#!/bin/bash

# Sourcing this file does not install anything or change shell options.
WORK_DIR=""
INSTALL_DIR=""
NAME=""
CMD=""
STAGED_FILES=()

log() {
  if [[ -t 1 && -z ${NO_COLOR+x} ]]; then
    printf '\033[32m>>\033[0m %s\n' "$*"
  else
    printf '>> %s\n' "$*"
  fi
}

die() {
  printf 'Error: %s\n' "$*" >&2
  exit 1
}

require_commands() {
  local cmd
  for cmd in "$@"; do
    command -v "$cmd" >/dev/null 2>&1 || die "Required command not found: $cmd"
  done
}

cleanup() {
  local status=$?
  if [[ -n $WORK_DIR ]]; then rm -rf -- "$WORK_DIR"; fi
  if ((${#STAGED_FILES[@]})); then rm -f -- "${STAGED_FILES[@]}"; fi
  return "$status"
}

_init() {
  local kind=$1 default=$2 max_args=0
  shift 2
  if [[ $kind == binary ]]; then max_args=2
  elif [[ -n $default ]]; then max_args=1
  fi

  if [[ $# == 1 && $1 == --help ]]; then
    printf '%s\nUsage: %s' "$NAME" "${0##*/}"
    if ((max_args)); then printf ' [version]'; fi
    if [[ $kind == binary ]]; then printf ' [install-dir]'; fi
    printf '\n'
    if ((max_args)); then
      printf 'Version: %s (default: %s)\n' "${VERSION_USAGE:-release version or latest}" "$default"
    fi
    if [[ $kind == binary ]]; then
      printf 'Directory: %s\nUse "" for the default version with a custom directory.\n' "${DEFAULT_INSTALL_DIR:-$HOME/.local/bin}"
    else
      printf 'Uses a tool-managed or system location; no install-directory argument.\n'
    fi
    printf 'Supports Ubuntu/Debian on x86_64 and ARM64 where upstream provides builds.\n'
    printf '%s\n' "${INSTALL_NOTES:-Re-running installs the selected version again.}"
    exit 0
  fi

  (($# <= max_args)) || die "Too many arguments. See ${0##*/} --help"
  VERSION=${1:-$default}
  if [[ -n $VERSION && ! $VERSION =~ ^[[:alnum:]][[:alnum:]._+/@%-]*$ ]]; then
    die "Invalid version argument: $VERSION. See ${0##*/} --help"
  fi
  if [[ $kind == binary ]]; then
    require_commands realpath
    INSTALL_DIR=$(realpath -m -- "${2:-${DEFAULT_INSTALL_DIR:-$HOME/.local/bin}}")
  fi

  [[ $(uname -s) == Linux ]] || die "Only Linux (including WSL) is supported"
  case $(uname -m) in
    x86_64) ARCH=amd64 ;;
    aarch64 | arm64) ARCH=arm64 ;;
    *) die "Unsupported architecture: $(uname -m)" ;;
  esac
  read_distribution
  case $DISTRO in
    ubuntu | debian) ;;
    *) die "Only Ubuntu and Debian are supported (found $DISTRO)" ;;
  esac
  trap cleanup EXIT
  trap 'exit 130' INT
  trap 'exit 143' TERM
}

init_binary() { _init binary "$@"; }
init_system() { _init system "$@"; }

read_distribution() {
  local NAME VERSION ID VERSION_ID VERSION_CODENAME
  # shellcheck source=/dev/null
  source /etc/os-release
  DISTRO=${ID:-unknown}
  DISTRO_VERSION=${VERSION_ID:-}
  export DISTRO_CODENAME=${VERSION_CODENAME:-}
}

asset_arch() {
  local value
  if [[ $ARCH == amd64 ]]; then value=$1; else value=${2:-}; fi
  [[ -n $value ]] || die "$NAME does not provide a supported $ARCH build for this installer"
  printf '%s\n' "$value"
}

fetch() {
  local url=$1
  shift
  require_commands curl
  [[ $url == https://* ]] || die "Only HTTPS downloads are supported: $url"
  curl --fail --silent --show-error --location --proto '=https' --proto-redir '=https' \
    --connect-timeout 15 --max-time 300 --retry 2 "$@" "$url" ||
    die "Download failed: $url"
}

download() {
  # curl can truncate its own output file when retrying a partial download.
  fetch "$1" --output "$2"
  [[ -s $2 ]] || die "Empty download: $1"
}

github_version() {
  local repo=$1 version=$2 prefix=${3-v} tag
  if [[ $version == latest ]]; then
    require_commands jq
    tag=$(fetch "https://api.github.com/repos/$repo/releases/latest" |
      jq -er '.tag_name | select(type == "string" and length > 0)') ||
      die "Cannot resolve latest release of $repo"
    [[ $tag == "$prefix"* ]] || die "Unexpected release tag for $repo: $tag"
    version=$tag
  fi
  version=${version#"$prefix"}
  [[ $version =~ ^[[:alnum:]][[:alnum:]._+-]*$ ]] || die "Invalid release version for $repo: $version"
  printf '%s\n' "$version"
}

github_latest_matching() {
  require_commands jq
  local page=1 releases tag
  while :; do
    releases=$(fetch "https://api.github.com/repos/$1/releases?per_page=100&page=$page")
    tag=$(jq -er --arg prefix "$2" \
      'if type != "array" then error("Expected release array") else
      [.[] | select(.draft == false and .prerelease == false) |
      .tag_name | select(startswith($prefix))][0] // "" end' <<< "$releases") ||
      die "Invalid releases response for $1"
    if [[ -n $tag ]]; then printf '%s\n' "$tag"; return; fi
    [[ $(jq length <<< "$releases") == 100 ]] || break
    page=$((page + 1))
  done
  die "No matching stable release found for $1 with prefix $2"
}

github_asset() {
  require_commands jq
  local tag=${2//\//%2F}
  fetch "https://api.github.com/repos/$1/releases/tags/$tag" |
    jq -er --arg first "$3" --arg second "${4:-$3}" \
      '[.assets[] | select(.name == $first or .name == $second)] |
      if length == 1 then .[0].browser_download_url else error("Expected exactly one matching asset") end' ||
    die "Cannot resolve the requested $ARCH release asset for $1 ($2)"
}

pre_run() {
  WORK_DIR=$(mktemp -d)
  log "Installing $NAME${VERSION:+ ($VERSION)}"
  if [[ -n $INSTALL_DIR ]]; then log "Target: $INSTALL_DIR"; fi
}

unpack() {
  local archive=$1
  case $archive in
    *.zip)
      require_commands unzip
      unzip -q -o "$archive" -d "$WORK_DIR"
      ;;
    *.tar.gz | *.tgz | *.tar.xz | *.tar.zst)
      require_commands tar
      case $archive in
        *.xz) require_commands xz ;;
        *.zst) require_commands zstd ;;
      esac
      tar --extract --file "$archive" --directory "$WORK_DIR" --no-same-owner
      ;;
    *) die "Unsupported archive format: $archive" ;;
  esac
}

install_binary() {
  local source=$1 name=${2:-$CMD} directory=${3:-$INSTALL_DIR} staged
  [[ -f $source && ! -L $source ]] || die "Expected binary missing or not a regular file: $source"
  mkdir -p -- "$directory"
  staged=$(mktemp "$directory/.${name}.XXXXXX")
  STAGED_FILES+=("$staged")
  install -m 0755 -- "$source" "$staged"
  mv -fT -- "$staged" "$directory/$name"
}

install_link() {
  local target=$1 link=$2 staged
  mkdir -p -- "$(dirname -- "$link")"
  staged=$(mktemp "$(dirname -- "$link")/.link.XXXXXX")
  STAGED_FILES+=("$staged")
  rm -- "$staged"
  ln -s -- "$target" "$staged"
  mv -fT -- "$staged" "$link"
}

as_root() {
  if ((EUID == 0)); then
    "$@"
  else
    require_commands sudo
    sudo -- "$@"
  fi
}

post_run() {
  local target=${INSTALLED_CMD:-${INSTALL_DIR:+$INSTALL_DIR/}$CMD} output
  if (($# == 0)); then set -- --version; fi
  [[ $target == */* ]] || target=$(command -v "$target") || die "Installed command not found: $CMD"
  [[ -x $target ]] || die "Installed command is not executable: $target"
  if ! output=$("$target" "$@" 2>&1); then
    printf '%s\n' "$output" >&2
    die "Version check failed for $target"
  fi
  log "Installed: $target"
  printf '%s\n' "$output"
  if [[ -n $INSTALL_DIR ]]; then
    case :$PATH: in
      *:"$INSTALL_DIR":*) ;;
      *) printf "Add to your shell profile: export PATH=%q:\"\$PATH\"\n" "$INSTALL_DIR" ;;
    esac
    local found
    found=$(command -v "$CMD" || true)
    if [[ -n $found && $found != "$target" ]]; then
      log "Note: PATH currently selects $found instead"
    fi
  fi
}

apt_install() {
  require_commands apt-get dpkg
  [[ $(dpkg --print-architecture) == "$ARCH" ]] || die "Host and apt architectures differ"
  as_root apt-get update -qq
  as_root apt-get install -y "$@"
}

install_apt_source() {
  local source=$1 target=$2 file staged
  [[ $target == *.sources ]] || die "Expected a .sources destination: $target"
  local legacy=${target%.sources}.list
  for file in "$target" "$legacy"; do
    if [[ -e $file || -L $file ]]; then
      [[ -f $file && ! -L $file ]] || die "Refusing to replace non-regular repository configuration: $file"
    fi
  done
  for file in "$target" "$legacy"; do
    if [[ -f $file ]]; then
      if [[ $file == "$target" ]] && cmp -s -- "$source" "$target"; then continue; fi
      as_root cp --backup=numbered --preserve=mode,timestamps -- "$file" "$file.bak" ||
        die "Could not back up repository configuration: $file"
      log "Backed up repository configuration: $file.bak"
    fi
  done
  staged=$(as_root mktemp "${target}.XXXXXX") || die "Could not stage repository configuration: $target"
  if ! as_root install -m 0644 -- "$source" "$staged" || ! as_root mv -fT -- "$staged" "$target"; then
    as_root rm -f -- "$staged"
    die "Could not install repository configuration: $target"
  fi
  if [[ -f $legacy ]]; then
    as_root rm -- "$legacy" || die "Could not retire legacy repository configuration: $legacy"
    log "Replaced legacy repository configuration: $legacy"
  fi
}

add_apt_repo() {
  local name=$1 key_url=$2 uri=$3 suite=$4 component=${5:-main}
  [[ $name =~ ^[a-z0-9][a-z0-9-]*$ ]] || die "Invalid repository name: $name"
  require_commands gpg
  download "$key_url" "$WORK_DIR/$name.asc"
  gpg --batch --yes --dearmor --output "$WORK_DIR/$name.gpg" "$WORK_DIR/$name.asc"
  printf 'Types: deb\nURIs: %s\nSuites: %s\nComponents: %s\nArchitectures: %s\nSigned-By: /etc/apt/keyrings/%s.gpg\n' \
    "$uri" "$suite" "$component" "$ARCH" "$name" > "$WORK_DIR/$name.sources"
  as_root install -d -m 0755 /etc/apt/keyrings /etc/apt/sources.list.d
  as_root install -m 0644 "$WORK_DIR/$name.gpg" "/etc/apt/keyrings/$name.gpg"
  install_apt_source "$WORK_DIR/$name.sources" "/etc/apt/sources.list.d/$name.sources"
}

microsoft_repo() {
  require_commands dpkg
  [[ -n $DISTRO_VERSION ]] || die "Cannot determine distribution version"
  download "https://packages.microsoft.com/config/$DISTRO/$DISTRO_VERSION/packages-microsoft-prod.deb" \
    "$WORK_DIR/packages-microsoft-prod.deb"
  as_root dpkg -i "$WORK_DIR/packages-microsoft-prod.deb"
}

random_fruit() {
  local fruits=("🍎" "🍊" "🍋" "🍌" "🍉" "🍇" "🍓" "🍒" "🍑" "🍍" "🥝" "🍅" "🍆" "🥑" "🥦" "🥒" "🥬" "🥭" "🥔" "🥕" "🌽" "🌶" "🍎" "🌶️" "🫐" "🥥" "🍄")
  printf '%s\n' "${fruits[RANDOM % ${#fruits[@]}]}"
}

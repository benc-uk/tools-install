#!/bin/bash
set -euo pipefail

ROOT=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
export ROOT
for dependency in jq zip unzip zstd shellcheck script; do
  command -v "$dependency" >/dev/null || { printf 'Missing test dependency: %s\n' "$dependency" >&2; exit 1; }
done
TEST_DIR=$(mktemp -d)
trap 'rm -rf -- "$TEST_DIR"' EXIT
export TEST_DIR
mkdir -p "$TEST_DIR/mock" "$TEST_DIR/home" "$TEST_DIR/tmp"
export HOME="$TEST_DIR/home" TMPDIR="$TEST_DIR/tmp"
export PATH="$TEST_DIR/mock:$PATH"
export NO_COLOR=1
cp "$ROOT/tests/fixtures/curl" "$TEST_DIR/mock/curl"
cp "$ROOT/tests/fixtures/uname" "$TEST_DIR/mock/uname"
for cmd in sudo apt-get apt dpkg dpkg-query npm git wget zsh; do
  cp "$ROOT/tests/fixtures/deny" "$TEST_DIR/mock/$cmd"
done
chmod +x "$TEST_DIR/mock/"*
export MOCK_ARCH=x86_64 MOCK_FAILURE="" MOCK_TAG=v1.2.3
export MOCK_DOWNLOAD="" MOCK_MEMBER="" MOCK_FORMAT=raw

fail() { printf 'FAIL: %s\n' "$*" >&2; exit 1; }
assert_contains() { grep -F -- "$2" "$1" >/dev/null || fail "Missing '$2' in $1"; }
assert_clean() { [[ -z $(find "$TMPDIR" -mindepth 1 -print -quit) ]] || fail "Temporary files remain"; }
expect_failure() {
  if "$@" > "$TEST_DIR/output" 2>&1; then fail "Unexpected success: $*"; fi
  if grep -F '>> Installed:' "$TEST_DIR/output" >/dev/null; then fail "Failure printed success"; fi
}

cd "$TEST_DIR"
for script in "$ROOT"/[a-z]*.sh; do
  bash "$script" --help > "$TEST_DIR/help"
  assert_contains "$TEST_DIR/help" "Usage:"
  expect_failure bash "$script" --bogus
  expect_failure bash "$script" 1 2 3
done
[[ ! -e $TEST_DIR/requests ]] || fail "Help/invalid arguments performed network access"
[[ -z $(find "$HOME" -mindepth 1 -print -quit) ]] || fail "Help/invalid arguments changed HOME"

check_binary() {
  local script=$1 command=$2 version=$3 url=$4 member=$5 format=$6 arguments=$7
  local companion=${8:-}
  export MOCK_DOWNLOAD=$url MOCK_MEMBER=$member MOCK_FORMAT=$format
  bash "$ROOT/$script.sh" "$version" "$TEST_DIR/custom bin" > "$TEST_DIR/output" 2> "$TEST_DIR/diagnostics"
  assert_contains "$TEST_DIR/requests" "$url"
  assert_contains "$TEST_DIR/output" "fixture $arguments"
  [[ -x "$TEST_DIR/custom bin/$command" ]] || fail "$script did not install an executable"
  if [[ -n $companion ]]; then
    [[ -x "$TEST_DIR/custom bin/$companion" ]] || fail "$script did not install $companion"
    assert_contains "$TEST_DIR/output" "Installed: $TEST_DIR/custom bin/$companion"
  fi
  assert_clean
}

for MOCK_ARCH in x86_64 aarch64; do
  export MOCK_ARCH
  arch=amd64 triple=x86_64 short=x64
  if [[ $MOCK_ARCH == aarch64 ]]; then arch=arm64; triple=aarch64; short=arm64; fi
  export MOCK_TAG=v1.2.3
  check_binary copilot copilot v1.2.3 "https://github.com/github/copilot-cli/releases/download/v1.2.3/copilot-linux-$short.tar.gz" copilot tar.gz --version
  check_binary copilot copilot 1.2.3 "$MOCK_DOWNLOAD" copilot tar.gz --version
  check_binary copilot copilot "" "$MOCK_DOWNLOAD" copilot tar.gz --version
  assert_contains "$TEST_DIR/output" "enter /login"
  check_binary yq yq v1.2.3 "https://github.com/mikefarah/yq/releases/download/v1.2.3/yq_linux_$arch" binary raw --version
  check_binary yq yq "" "$MOCK_DOWNLOAD" binary raw --version
  export MOCK_EXTRA_MEMBER=age/age-keygen
  check_binary age age v1.2.3 "https://github.com/FiloSottile/age/releases/download/v1.2.3/age-v1.2.3-linux-$arch.tar.gz" age/age tar.gz --version age-keygen
  check_binary age age "" "$MOCK_DOWNLOAD" age/age tar.gz --version age-keygen
  export MOCK_TAG=1.2.3 MOCK_EXTRA_MEMBER="uv-$triple-unknown-linux-gnu/uvx"
  check_binary uv uv 1.2.3 "https://github.com/astral-sh/uv/releases/download/1.2.3/uv-$triple-unknown-linux-gnu.tar.gz" "uv-$triple-unknown-linux-gnu/uv" tar.gz --version uvx
  check_binary uv uv "" "$MOCK_DOWNLOAD" "uv-$triple-unknown-linux-gnu/uv" tar.gz --version uvx
  unset MOCK_EXTRA_MEMBER
  check_binary bicep bicep v1.2.3 "https://github.com/Azure/bicep/releases/download/v1.2.3/bicep-linux-$short" binary raw --version
  check_binary helm helm 1.2.3 "https://get.helm.sh/helm-v1.2.3-linux-$arch.tar.gz" "linux-$arch/helm" tar.gz version
  check_binary terraform terraform 1.2.3 "https://releases.hashicorp.com/terraform/1.2.3/terraform_1.2.3_linux_$arch.zip" terraform zip --version
  check_binary kubectl kubectl 1.2.3 "https://dl.k8s.io/release/v1.2.3/bin/linux/$arch/kubectl" binary raw "version --client"
  check_binary kubectl kubectl v1.2.3 "$MOCK_DOWNLOAD" binary raw "version --client"
  check_binary linkerd linkerd stable-1.2.3 "https://github.com/linkerd/linkerd2/releases/download/stable-1.2.3/linkerd2-cli-stable-1.2.3-linux-$arch" binary raw "version --client"
  check_binary just just 1.2.3 "https://github.com/casey/just/releases/download/1.2.3/just-1.2.3-$triple-unknown-linux-musl.tar.gz" just tar.gz --version
  check_binary gh gh 1.2.3 "https://github.com/cli/cli/releases/download/v1.2.3/gh_1.2.3_linux_$arch.tar.gz" "gh_1.2.3_linux_$arch/bin/gh" tar.gz --version
  check_binary opa opa 1.2.3 "https://github.com/open-policy-agent/opa/releases/download/v1.2.3/opa_linux_$arch" binary raw version
  : > "$TEST_DIR/requests"
  export MOCK_FAILURE=api MOCK_TAG=v2.0.0
  check_binary edit edit "" "https://github.com/microsoft/edit/releases/download/v2.0.0/edit-2.0.0-$triple-linux-gnu.tar.gz" edit tar.gz --version
  assert_contains "$TEST_DIR/requests" "https://github.com/microsoft/edit/releases/latest"
  check_binary edit edit latest "$MOCK_DOWNLOAD" edit tar.gz --version
  check_binary edit edit 2.0.0 "$MOCK_DOWNLOAD" edit tar.gz --version
  check_binary edit edit v2.0.0 "$MOCK_DOWNLOAD" edit tar.gz --version
  check_binary edit edit 1.2.0 "https://github.com/microsoft/edit/releases/download/v1.2.0/edit-1.2.0-$triple-linux-gnu.tar.zst" edit tar.zst --version
  if grep -F 'https://api.github.com/' "$TEST_DIR/requests" >/dev/null; then fail "Edit used the GitHub API"; fi
  export MOCK_FAILURE="" MOCK_TAG=v1.2.3
  check_binary deno deno 1.2.3 "https://github.com/denoland/deno/releases/download/v1.2.3/deno-$triple-unknown-linux-gnu.zip" deno zip --version
  check_binary azd azd stable "https://azuresdkartifacts.z5.web.core.windows.net/azd/standalone/release/stable/azd-linux-$arch.tar.gz" "azd-linux-$arch" tar.gz version
  [[ -L "$TEST_DIR/custom bin/azd" ]] || fail "azd layout not preserved"
  check_binary sops sops 1.2.3 "https://github.com/getsops/sops/releases/download/v1.2.3/sops-v1.2.3.linux.$arch" binary raw --version
  act_arch=x86_64
  if [[ $arch == arm64 ]]; then act_arch=arm64; fi
  check_binary act act 1.2.3 "https://github.com/nektos/act/releases/download/v1.2.3/act_Linux_$act_arch.tar.gz" act tar.gz --version
  check_binary air air 1.2.3 "https://github.com/air-verse/air/releases/download/v1.2.3/air_1.2.3_linux_$arch" binary raw -v
  check_binary clusterctl clusterctl 1.2.3 "https://github.com/kubernetes-sigs/cluster-api/releases/download/v1.2.3/clusterctl-linux-$arch" binary raw version
  check_binary dapr dapr 1.2.3 "https://github.com/dapr/cli/releases/download/v1.2.3/dapr_linux_$arch.tar.gz" dapr tar.gz --version
  check_binary flux flux 1.2.3 "https://github.com/fluxcd/flux2/releases/download/v1.2.3/flux_1.2.3_linux_$arch.tar.gz" flux tar.gz --version
  check_binary golangci-lint golangci-lint 1.2.3 "https://github.com/golangci/golangci-lint/releases/download/v1.2.3/golangci-lint-1.2.3-linux-$arch.tar.gz" "golangci-lint-1.2.3-linux-$arch/golangci-lint" tar.gz --version
  check_binary k6 k6 1.2.3 "https://github.com/grafana/k6/releases/download/v1.2.3/k6-v1.2.3-linux-$arch.tar.gz" "k6-v1.2.3-linux-$arch/k6" tar.gz version
  check_binary k9s k9s 1.2.3 "https://github.com/derailed/k9s/releases/download/v1.2.3/k9s_Linux_$arch.tar.gz" k9s tar.gz version
  check_binary kind kind 1.2.3 "https://github.com/kubernetes-sigs/kind/releases/download/v1.2.3/kind-linux-$arch" binary raw --version
  check_binary nats nats-server 1.2.3 "https://github.com/nats-io/nats-server/releases/download/v1.2.3/nats-server-v1.2.3-linux-$arch.tar.gz" "nats-server-v1.2.3-linux-$arch/nats-server" tar.gz --version
  check_binary tflint tflint 1.2.3 "https://github.com/terraform-linters/tflint/releases/download/v1.2.3/tflint_linux_$arch.zip" tflint zip --version
  check_binary wasm-pack wasm-pack 1.2.3 "https://github.com/rustwasm/wasm-pack/releases/download/v1.2.3/wasm-pack-v1.2.3-$triple-unknown-linux-musl.tar.gz" "wasm-pack-v1.2.3-$triple-unknown-linux-musl/wasm-pack" tar.gz --version
  check_binary azcopy azcopy 10.1.2 "https://github.com/Azure/azure-storage-azcopy/releases/download/v10.1.2/azcopy_linux_${arch}_10.1.2.tar.gz" "azcopy_linux_${arch}_10.1.2/azcopy" tar.gz --version
  check_binary ngrok ngrok 2 "https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-$arch.zip" ngrok zip version
  hugo_asset=hugo_extended_1.2.3_Linux-64bit.tar.gz
  if [[ $arch == arm64 ]]; then hugo_asset=hugo_extended_1.2.3_linux-arm64.tar.gz; fi
  check_binary hugo hugo 1.2.3 "https://github.com/gohugoio/hugo/releases/download/v1.2.3/$hugo_asset" hugo tar.gz version
  bun_arch=x64
  if [[ $arch == arm64 ]]; then bun_arch=aarch64; fi
  export MOCK_TAG=bun-v1.2.3
  check_binary bun bun latest "https://github.com/oven-sh/bun/releases/download/bun-v1.2.3/bun-linux-$bun_arch.zip" "bun-linux-$bun_arch/bun" zip --version
done

export MOCK_ARCH=x86_64 MOCK_FORMAT=tar.gz
export MOCK_TAG=v2.0.0 MOCK_MEMBER=edit
export MOCK_DOWNLOAD=https://github.com/microsoft/edit/releases/download/v2.0.0/edit-2.0.0-x86_64-linux-gnu.tar.gz
printf 'previous installation\n' > "$TEST_DIR/custom bin/edit"
for MOCK_FAILURE in redirect http archive; do
  export MOCK_FAILURE
  expect_failure bash "$ROOT/edit.sh" latest "$TEST_DIR/custom bin"
  assert_contains "$TEST_DIR/custom bin/edit" "previous installation"
  assert_clean
done
export MOCK_FAILURE=http
expect_failure bash "$ROOT/edit.sh" 2.0.0 "$TEST_DIR/custom bin"
assert_contains "$TEST_DIR/output" "Download failed: $MOCK_DOWNLOAD"
assert_contains "$TEST_DIR/custom bin/edit" "previous installation"
assert_clean
export MOCK_FAILURE="" MOCK_TAG=v1.2.3
for tool in age uv; do
  if [[ $tool == age ]]; then
    export MOCK_DOWNLOAD=https://github.com/FiloSottile/age/releases/download/v1.2.3/age-v1.2.3-linux-amd64.tar.gz MOCK_MEMBER=age/age
    companion=age-keygen
  else
    export MOCK_DOWNLOAD=https://github.com/astral-sh/uv/releases/download/1.2.3/uv-x86_64-unknown-linux-gnu.tar.gz MOCK_MEMBER=uv-x86_64-unknown-linux-gnu/uv
    companion=uvx
  fi
  printf 'previous installation\n' > "$TEST_DIR/custom bin/$tool"
  printf 'previous companion\n' > "$TEST_DIR/custom bin/$companion"
  expect_failure bash "$ROOT/$tool.sh" 1.2.3 "$TEST_DIR/custom bin"
  assert_contains "$TEST_DIR/output" "Expected binary missing"
  assert_contains "$TEST_DIR/custom bin/$tool" "previous installation"
  assert_contains "$TEST_DIR/custom bin/$companion" "previous companion"
  assert_clean
done

export MOCK_ARCH=x86_64 MOCK_TAG=stable-1.2.3 MOCK_PAGINATE=yes
check_binary linkerd linkerd latest "https://github.com/linkerd/linkerd2/releases/download/stable-1.2.3/linkerd2-cli-stable-1.2.3-linux-amd64" binary raw "version --client"
assert_contains "$TEST_DIR/requests" "per_page=100&page=2"
unset MOCK_PAGINATE
export MOCK_TAG=v1.2.3
check_binary bicep bicep "" "https://github.com/Azure/bicep/releases/download/v1.2.3/bicep-linux-x64" binary raw --version
check_binary azbrowse azbrowse 1.2.3 "https://github.com/lawrencegripper/azbrowse/releases/download/v1.2.3/azbrowse_linux_amd64.tar.gz" azbrowse tar.gz version
check_binary devcontainer-cli devcontainer 1.2.3 "https://github.com/stuartleeks/devcontainer-cli/releases/download/v1.2.3/devcontainer-cli_linux_amd64.tar.gz" devcontainer tar.gz version

export MOCK_DOWNLOAD=https://github.com/ahmetb/kubectx/releases/download/v1.2.3/kubectx_v1.2.3_linux_x86_64.tar.gz
export MOCK_DOWNLOAD_ALT=https://github.com/ahmetb/kubectx/releases/download/v1.2.3/kubens_v1.2.3_linux_x86_64.tar.gz
export MOCK_MEMBER=kubectx MOCK_MEMBER_ALT=kubens MOCK_FORMAT=tar.gz
bash "$ROOT/kube-tools.sh" 1.2.3 "$TEST_DIR/custom bin" > "$TEST_DIR/output"
[[ -x "$TEST_DIR/custom bin/kubectx" && -x "$TEST_DIR/custom bin/kubens" ]] || fail "Missing Kubernetes helper"
printf 'previous installation\n' > "$TEST_DIR/custom bin/kubectx"
export MOCK_SECOND_FAILURE=yes
expect_failure bash "$ROOT/kube-tools.sh" 1.2.3 "$TEST_DIR/custom bin"
assert_contains "$TEST_DIR/custom bin/kubectx" "previous installation"
assert_clean
unset MOCK_DOWNLOAD_ALT MOCK_MEMBER_ALT MOCK_SECOND_FAILURE

# A same-named executable earlier on PATH must never be the version probe.
cp "$ROOT/tests/fixtures/deny" "$TEST_DIR/mock/bicep"
chmod +x "$TEST_DIR/mock/bicep"
check_binary bicep bicep 1.2.3 "https://github.com/Azure/bicep/releases/download/v1.2.3/bicep-linux-x64" binary raw --version
assert_contains "$TEST_DIR/diagnostics" "PATH currently selects"

printf 'previous installation\n' > "$TEST_DIR/custom bin/bicep"
export MOCK_FAILURE=http
expect_failure bash "$ROOT/bicep.sh" 1.2.3 "$TEST_DIR/custom bin"
assert_contains "$TEST_DIR/custom bin/bicep" "previous installation"
assert_contains "$TEST_DIR/output" "Download failed:"
assert_clean

export MOCK_FAILURE=json
expect_failure bash "$ROOT/bicep.sh"
assert_contains "$TEST_DIR/output" "Cannot resolve latest release"
export MOCK_FAILURE=archive MOCK_FORMAT=tar.gz MOCK_DOWNLOAD=https://get.helm.sh/helm-v1.2.3-linux-amd64.tar.gz
printf 'previous installation\n' > "$TEST_DIR/custom bin/helm"
expect_failure bash "$ROOT/helm.sh" 1.2.3 "$TEST_DIR/custom bin"
assert_contains "$TEST_DIR/custom bin/helm" "previous installation"
assert_clean

export MOCK_FAILURE="" MOCK_MEMBER=not-helm
expect_failure bash "$ROOT/helm.sh" 1.2.3 "$TEST_DIR/custom bin"
assert_contains "$TEST_DIR/custom bin/helm" "previous installation"
assert_clean

export MOCK_FAILURE=version MOCK_FORMAT=raw MOCK_DOWNLOAD=https://github.com/Azure/bicep/releases/download/v1.2.3/bicep-linux-x64
expect_failure bash "$ROOT/bicep.sh" 1.2.3 "$TEST_DIR/custom bin"
assert_contains "$TEST_DIR/output" "Version check failed"
assert_clean
export MOCK_FAILURE="" MOCK_ARCH=riscv64
expect_failure bash "$ROOT/bicep.sh" 1.2.3
assert_contains "$TEST_DIR/output" "Unsupported architecture"
export MOCK_ARCH=aarch64
for script in azbrowse devcontainer-cli; do
  expect_failure bash "$ROOT/$script.sh"
  assert_contains "$TEST_DIR/output" "does not provide a supported arm64"
done
export MOCK_OS=Darwin
expect_failure bash "$ROOT/bicep.sh" 1.2.3
assert_contains "$TEST_DIR/output" "Only Linux"
unset MOCK_OS

export MOCK_ARCH=x86_64 MOCK_FORMAT=raw MOCK_MEMBER=binary MOCK_DOWNLOAD=https://github.com/Azure/bicep/releases/download/v1.2.3/bicep-linux-x64
mkdir -p "$TEST_DIR/repo with spaces"
cp "$ROOT/_lib.sh" "$ROOT/bicep.sh" "$TEST_DIR/repo with spaces/"
bash "$TEST_DIR/repo with spaces/bicep.sh" 1.2.3 "./relative bin" > "$TEST_DIR/output"
[[ -x "$TEST_DIR/relative bin/bicep" ]] || fail "Relative destination not honoured"

printf 'unrelated\n' > "$TEST_DIR/unrelated"
rm "$TEST_DIR/custom bin/bicep"
ln -s "$TEST_DIR/unrelated" "$TEST_DIR/custom bin/bicep"
check_binary bicep bicep 1.2.3 "$MOCK_DOWNLOAD" binary raw --version
assert_contains "$TEST_DIR/unrelated" "unrelated"
[[ ! -L "$TEST_DIR/custom bin/bicep" ]] || fail "Wrote through destination symlink"

# shellcheck disable=SC2016
expect_failure bash -c 'source "$ROOT/_lib.sh"; PATH=/nonexistent; require_commands jq'
assert_contains "$TEST_DIR/output" "Required command not found: jq"
# shellcheck disable=SC2016
expect_failure bash -c 'source "$ROOT/_lib.sh"; NAME=Fixture; init_binary latest; pre_run; kill -TERM "$$"'
assert_clean
bash "$ROOT/tests/system.sh" > "$TEST_DIR/system-output"
bash "$ROOT/tests/output.sh"
bash "$ROOT/tests/apt-sources.sh" > "$TEST_DIR/apt-sources-output" 2>&1 || {
  cat "$TEST_DIR/apt-sources-output" >&2
  fail "Apt repository migration tests failed"
}
assert_clean

# Exported mocks are invoked by the child installer shell.
# shellcheck disable=SC2317,SC2329
(
  dpkg() { printf 'amd64\n'; }
  apt-get() { printf '%s\n' "$@" >> "$TEST_DIR/base-apt"; }
  dpkg-query() { printf '%s\n' "$@" >> "$TEST_DIR/base-query"; }
  sudo() {
    [[ ${1:-} == -- && ${2:-} == apt-get ]] || return 1
    shift 2
    apt-get "$@"
  }
  export -f dpkg apt-get dpkg-query sudo
  bash "$ROOT/base.sh" > "$TEST_DIR/output"
  grep -Fx htop "$TEST_DIR/base-apt" >/dev/null || fail "Base install did not request htop"
  grep -Fx htop "$TEST_DIR/base-query" >/dev/null || fail "Base install did not query htop"
  assert_clean
)

# shellcheck disable=SC2317,SC2329
(
  docker() { printf 'The existing Docker CLI must not be executed by the installer\n' >&2; return 1; }
  dpkg() {
    [[ $* == --print-architecture ]] || return 1
    printf 'amd64\n'
  }
  apt-get() {
    printf 'apt-get %s\n' "$*" >> "$TEST_DIR/podman-apt"
    [[ $* == 'update -qq' ]]
  }
  sudo() {
    [[ ${1:-} == -- && ${2:-} == apt-get ]] || return 1
    shift 2
    apt-get "$@"
  }
  export -f docker dpkg apt-get sudo
  expect_failure bash "$ROOT/podman.sh"
  assert_contains "$TEST_DIR/output" "WARNING: An existing docker command"
  assert_contains "$TEST_DIR/output" "Resolve any Docker package conflicts manually"
  grep -Fx 'apt-get install -y --no-remove podman podman-docker podman-compose uidmap' "$TEST_DIR/podman-apt" >/dev/null ||
    fail "Podman install must request the shim and Compose without allowing removals"
  assert_clean
)

for script in node dotnet functions jdk-ms ngrok; do
  expect_failure bash "$ROOT/$script.sh" unsupported-channel
done

bash "$ROOT/_list.sh" > "$TEST_DIR/index"
sed -n '/^## Script index$/,$p' "$ROOT/README.md" | tail -n +3 > "$TEST_DIR/readme-index"
diff -u "$TEST_DIR/index" "$TEST_DIR/readme-index"

if grep -nE 'source .*curl|curl.*\|.*(bash|sh)( |$)' "$ROOT"/[a-z]*.sh; then
  fail "Runtime library download or streamed installer remains"
fi
[[ ! -e "$HOME/.bashrc" && ! -e "$HOME/.zshrc" ]] || fail "Shell profile was modified"
printf 'All installer tests passed.\n'

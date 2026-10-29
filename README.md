# Tool and software installers

A semi-personal, curated collection of small Bash scripts for tools, SDKs and utilities.

The approach is deliberately opinionated: download official binaries where practical, use explicit apt setup for system packages, and keep each installer readable. This is not a package manager.

## Usage

Clone the repository and run the script you need:

```bash
git clone https://github.com/benc-uk/tools-install.git
cd tools-install
./helm.sh --help
./helm.sh
./helm.sh 3.9.1
./helm.sh "" ./mybin
./helm.sh 3.9.1 ./mybin
```

The usual interface is `./tool.sh [version] [install-dir]`. An omitted or empty version selects the default; ordinary binary installers resolve the latest upstream release. Rerunning installs the selected version again.

The usual destination is `$HOME/.local/bin`. Relative destinations are resolved against your working directory. You can run the scripts from outside the checkout, but keep them alongside [_lib.sh](./_lib.sh). Neither a remote library nor a central launcher is involved.

Use `--help` for each script's actual arguments and effects. Help does not access the network or install anything. Unsupported arguments are errors, not ignored options.

## Platforms and prerequisites

- Ubuntu and Debian, including WSL installations of those distributions.
- x86_64 and ARM64, where the requested upstream release provides a compatible build. No architecture emulation or fallback to a different release.
- Bash, core utilities, curl and a working CA certificate store.
- `jq` when JSON release discovery is needed. Most pinned direct downloads do not need it; metadata-based asset selection still does.
- `tar`, `unzip`, `xz` or `zstd`, depending on the release format. Git is needed to clone the repository; npm and package-management commands are needed only by scripts that use them.
- Tool runtime dependencies still apply. For example, Bicep requires the distribution's `libicu` runtime package.

Missing prerequisites are reported, not automatically bootstrapped. A system package or runtime dependency unavailable for your distro/version remains an error. Supporting a distribution does not guarantee every historical or latest upstream binary will run on every release of it.

Ordinary binary installers do not use sudo. System installers use root directly, or sudo when necessary. [mkcert.sh](./mkcert.sh) also installs `libnss3-tools` explicitly.

[base.sh](./base.sh) includes `ca-certificates`, `xz-utils`, `zstd` and `zip`, plus ripgrep (`rg`), fd (`fdfind`, from the Debian/Ubuntu `fd-find` package) and `htop`. It does not create an `fd` alias.

## Utility installers

- [yq.sh](./yq.sh) installs Mike Farah's Go-based YAML processor, not the unrelated Python package of the same name.
- [age.sh](./age.sh) installs `age` and `age-keygen` for file encryption. It does not install the optional bundled tools/plugins, generate keys or configure SOPS.
- [uv.sh](./uv.sh) installs `uv` and `uvx` for Python package and tool management. It does not install a Python interpreter or modify shell profiles.
- [copilot.sh](./copilot.sh) installs the standalone GitHub Copilot CLI from official release binaries, without Node.js, npm or the old `gh copilot` extension. Start `copilot` and enter `/login` yourself; using it requires a GitHub account with Copilot CLI access.
- [edit.sh](./edit.sh) resolves the latest release through GitHub's public release redirect, without GitHub API access or authentication. It downloads `.tar.gz` releases for v2 onward and `.tar.zst` for the supported v1 releases. Edit optionally uses ICU for Search and Replace.

These installers accept `[version] [install-dir]`, defaulting to the latest release and `$HOME/.local/bin`.

## Installation behaviour

- Downloads must succeed over HTTPS before extraction or execution.
- Archives are extracted into private temporary directories, not your working directory or final binary directory.
- Standalone executables are prepared on the destination filesystem and renamed into place. Failed downloads or extraction leave the previous executable untouched.
- Temporary files are cleaned up on success, failure and interruption.
- Version checks run the intended installed executable, not an older copy found on PATH. A failed version check is an error, not a successful installation.
- PATH guidance is printed when needed. The scripts do not edit shell profiles or change the login shell.
- Shared status messages use coloured emoji in terminals: a purple package for installation, a blue folder for the destination, green success, yellow warnings and red errors. Warnings and errors go to stderr.
- Redirected streams stay plain ASCII. Setting `NO_COLOR` (even to an empty value), or using `TERM=dumb`, disables both colour and emoji. Output from upstream tools and package managers is left unchanged.

**Downloaded binary checksums and signatures are not verified in this phase.** HTTPS and staging are not a guarantee of authenticity. Only run a checkout and upstream distributions you trust.

Individual binary replacement is not a transaction across multiple tools or apt operations. A version-check failure after replacement can leave the new executable installed. Go stages its complete SDK tree and retains a recoverable previous tree if replacement cannot complete; any retained backup is reported.

## Deliberate exceptions

| Scripts | Version and destination behaviour |
|---|---|
| [azcopy.sh](./azcopy.sh) | Defaults to major channel `10`; accepts exact `10.x.y` releases too |
| [azd.sh](./azd.sh) | Defaults to `stable`; supports `latest`, `daily` and exact versions. Preserves `~/.local/share/azd` with a link in the requested binary directory |
| [deno.sh](./deno.sh) | Preserves `~/.deno/bin` as its default destination |
| [golang.sh](./golang.sh) | Exact release or latest; replaces `/usr/local/go`, no destination argument |
| [rust.sh](./rust.sh) | Defaults to `stable`; accepts `beta`, `nightly` or an exact Rust version. Preserves `CARGO_HOME`/`RUSTUP_HOME`, no destination argument |
| [node.sh](./node.sh) | Major apt channel, default `26`, no destination argument |
| [dotnet.sh](./dotnet.sh) | Major.minor apt channel, default `10.0`; uses configured sources, no destination argument |
| [functions.sh](./functions.sh) | Major apt channel, default `4`, no destination argument |
| [jdk-ms.sh](./jdk-ms.sh) | JDK major apt channel, default `11`; package scripts may update Java alternatives |
| [azure-cli.sh](./azure-cli.sh), [docker.sh](./docker.sh), [podman.sh](./podman.sh), [powershell.sh](./powershell.sh) | Available apt packages; no version or destination arguments |
| [base.sh](./base.sh), [yarn.sh](./yarn.sh) | Curated setup, no version or destination arguments; see each script's help |
| [linkerd.sh](./linkerd.sh) | Retains the stable release series, never silently switches to edge |
| [ngrok.sh](./ngrok.sh) | Retains the legacy `2` distribution channel; no exact version selection |
| [azbrowse.sh](./azbrowse.sh), [devcontainer-cli.sh](./devcontainer-cli.sh) | Current upstream Linux assets are x86_64 only; ARM64 fails explicitly |

Exact release support depends on the assets that upstream still publishes. Remaining legacy tools retain their original identities: for example, [devcontainer-cli.sh](./devcontainer-cli.sh) remains the original `stuartleeks/devcontainer-cli` tool.

### System and bootstrap setup

NodeSource, Docker, Azure CLI and JDK package setup is explicit, using scoped signing keys rather than streamed setup scripts or `apt-key`. Microsoft package-feed configuration uses its official distro-specific `.deb`.

NodeSource, Docker and Azure CLI use deb822 `.sources` files, supported on both Ubuntu 24.04 and 26.04. Each installer manages only its named vendor files in `/etc/apt/sources.list.d/` (for example, `nodesource.sources` and `nodesource.list`). Existing differing configuration is copied to `.bak` before replacement; older backups are retained with numbered suffixes. The legacy `.list` is removed only after the new `.sources` is installed, avoiding duplicate entries under those names. Unchanged reruns do not create more backups.

Unrelated source files and existing signing keys at other paths are left alone. Symlinks and other non-regular source files are rejected for manual review. If the same repository was configured under a different filename, reconcile that separate entry manually. Package managers and their package scripts can still modify system configuration and services.

Docker group membership is a manual step: the script prints the command and does not grant root-equivalent group access automatically.

[podman.sh](./podman.sh) installs the distribution's `podman`, `podman-docker`, `podman-compose` and `uidmap` packages, with no external repository. The shim provides `/usr/bin/docker`; an existing `docker` command triggers a warning, including on reruns with the shim already installed. An earlier PATH entry may still select a different Docker CLI.

The installer passes `--no-remove` to apt: it will not automatically remove conflicting Docker packages. Resolve any package conflicts manually before retrying. It does not migrate Docker containers, images or configuration.

Use `podman-compose` for Compose projects. Newer Podman releases also expose `podman compose` (and `docker compose` through the shim), which delegates to an external provider. To explicitly select the installed provider, use `PODMAN_COMPOSE_PROVIDER=/usr/bin/podman-compose podman compose ...`. Older distro versions without that subcommand must use `podman-compose` directly.

Rootless operation requires subordinate UID/GID ranges in `/etc/subuid` and `/etc/subgid`; the script leaves these unchanged and prints guidance. It does not configure shell aliases or services. On WSL, use a WSL2 Linux distribution.

Rust deliberately delegates to the official **rustup-init executable**, downloaded completely before execution, with `--no-modify-path`. Maintaining our own toolchain manager would defeat the minimal approach. No active installer downloads and executes an upstream shell setup script.

## Maintaining the scripts

Agent guidance for creating, updating and maintaining installers is in [AGENTS.md](./AGENTS.md). Use a similar existing installer as a reference rather than a template. Keep tool-specific URL, architecture and archive rules in the installer; put genuinely repeated operations in [_lib.sh](./_lib.sh).

Use the shared `log`, `success`, `warn` and `die` helpers for consistent output. `error` reports an error without exiting, for cleanup paths that must finish before returning a failure. Do not embed colour escapes or emoji in individual installers.

Generate the index below with `./_list.sh`.

Run syntax, ShellCheck and offline regression tests:

```bash
bash tests/check.sh
```

Test dependencies are `shellcheck`, `jq`, `curl`, `tar`, `zip`, `unzip`, `xz`, `zstd` and `script` (from `bsdutils`). The tests use fixtures, deny unexpected external commands, and never install tools into your real home or system directories. They cover both architecture mappings, help, argument handling, downloads, archive formats, safe replacement, failure cleanup and real pseudo-terminal output.

To avoid installing test dependencies on your host, use the disposable Ubuntu image:

```bash
podman build -t localhost/tools-install-test -f tests/Containerfile .
podman run --rm --network none localhost/tools-install-test
```

`docker` can be used instead of `podman`. CI runs the offline checks on x86_64 and ARM64 Ubuntu runners. Mocked architecture selection is not proof that every upstream binary runs on that architecture. Live installer checks belong in disposable containers or VMs, not on a development workstation.

The personal [_backup.sh](./_backup.sh) helper is outside the supported installer checks. Checksum verification remains deferred.

## Script index

- [act.sh](./act.sh) - Nektos Act
- [age.sh](./age.sh) - age File Encryption
- [air.sh](./air.sh) - Air - Hot reloader for Go
- [azbrowse.sh](./azbrowse.sh) - Azure Browse
- [azcopy.sh](./azcopy.sh) - Azure Copy
- [azd.sh](./azd.sh) - Azure Dev CLI
- [azure-cli.sh](./azure-cli.sh) - Azure CLI
- [base.sh](./base.sh) - Various Linux Utilities
- [bicep.sh](./bicep.sh) - Azure Bicep
- [bun.sh](./bun.sh) - Bun.js
- [clusterctl.sh](./clusterctl.sh) - K8S Cluster API
- [copilot.sh](./copilot.sh) - GitHub Copilot CLI
- [dapr.sh](./dapr.sh) - Dapr CLI
- [deno.sh](./deno.sh) - Deno JavaScript Runtime
- [devcontainer-cli.sh](./devcontainer-cli.sh) - Dev Container CLI
- [docker.sh](./docker.sh) - Docker Engine & CLI
- [dotnet.sh](./dotnet.sh) - Dotnet SDK
- [edit.sh](./edit.sh) - Edit
- [flux.sh](./flux.sh) - FluxCD v2
- [functions.sh](./functions.sh) - Azure Functions Core Tools
- [gh.sh](./gh.sh) - GitHub CLI
- [golang.sh](./golang.sh) - Go Language
- [golangci-lint.sh](./golangci-lint.sh) - Golang CI Lint
- [helm.sh](./helm.sh) - Helm
- [hugo.sh](./hugo.sh) - Hugo Static Site Generator
- [jdk-ms.sh](./jdk-ms.sh) - Java JDK (OpenJDK Microsoft)
- [just.sh](./just.sh) - Just Command Runner
- [k6.sh](./k6.sh) - k6 Load Tester
- [k9s.sh](./k9s.sh) - k9s terminal UI for Kubernetes
- [kind.sh](./kind.sh) - Kind, run Kubernetes in Docker
- [kube-tools.sh](./kube-tools.sh) - kubectx & kubens
- [kubectl.sh](./kubectl.sh) - Kubectl
- [linkerd.sh](./linkerd.sh) - Linkerd Service Mesh
- [mkcert.sh](./mkcert.sh) - mkcert Cert Utility
- [nats.sh](./nats.sh) - NATS Server
- [ngrok.sh](./ngrok.sh) - ngrok
- [node.sh](./node.sh) - Node.js
- [opa.sh](./opa.sh) - Open Policy Agent
- [podman.sh](./podman.sh) - Podman Container Engine
- [powershell.sh](./powershell.sh) - PowerShell
- [rust.sh](./rust.sh) - Rust and Cargo
- [sops.sh](./sops.sh) - Sops
- [terraform.sh](./terraform.sh) - Terraform
- [tflint.sh](./tflint.sh) - Tflint Terraform Linter
- [uv.sh](./uv.sh) - uv Python Package Manager
- [wasm-pack.sh](./wasm-pack.sh) - WASM Pack
- [yarn.sh](./yarn.sh) - Yarn
- [yq.sh](./yq.sh) - yq (Mike Farah)

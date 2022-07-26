# 📦 Tool Installers 🛠🧰

This is a semi-personal, curated collection of setup scripts for tools, SDKs, dev kits and other things I might want on a new system or to install into a container.

💬 **NOTE!** These will only work on Ubuntu or Debian systems.

They are standalone bash scripts & can be run at any time, and re-running them will just install the latest version in place.  
Where possible the scripts pull binaries directly from the remote distribution source (mostly GitHub) or fall back to an 'official' remote setup script URL or failing that, use `apt`.

The default binary install location is `$HOME/.local/bin` if this isn't in your PATH, it really should be, it's [the official place for putting user executables](https://www.freedesktop.org/software/systemd/man/file-hierarchy.html#Home%20Directory)

The scripts accept two optional arguments version number (or tag) and install path. Running without arguments will try to find the latest version and install into `$HOME/.local/bin`

Some examples:

- `./helm.sh` Install latest version of Helm into the default location
- `./helm.sh 3.9.1` Install a specific older version of Helm into the default location
- `./helm.sh "" ./mybin` Install latest version of Helm into `./mybin` directory
- `./helm.sh 3.9.1 ./mybin` Install specific version of Helm into `./mybin` directory

Some scripts which install system wide components such as Docker or the Azure CLI do not accept a version or install location, as they use `apt`

## 📃 Script Index

- **act.sh** - Nektos Act
- **azbrowse.sh** - Azure Browse
- **azcopy.sh** - Azure Copy
- **azd.sh** - Azure Dev CLI
- **azure-cli.sh** - Azure CLI
- **base.sh** - Various Linux Utilities
- **bicep.sh** - Azure Bicep
- **bun.sh** - Bun.js
- **clusterctl.sh** - K8S Cluster API
- **dapr.sh** - Dapr CLI
- **deno.sh** - Deno JavaScript Runtime
- **devcontainer-cli.sh** - Dev Container CLI
- **docker.sh** - Docker Engine & CLI
- **dotnet.sh** - Dotnet SDK
- **flux.sh** - FluxCD v2
- **functions.sh** - Azure Functions Core Tools
- **gh.sh** - GitHub CLI
- **golang.sh** - Go Language
- **golangci-lint.sh** - Golang CI Lint
- **helm.sh** - Helm
- **hugo.sh** - Hugo Static Site Generator
- **jdk.sh** - Java JDK (Temurin)
- **k6.sh** - k6 Load Testing
- **k9s.sh** - k9s, a terminal based UI for Kubernetes
- **kind.sh** - Kind, run Kubernetes in Docker
- **kube-tools.sh** - kubectx & kubens
- **kubectl.sh** - Kubectl
- **kustomize.sh** - kustomize
- **linkerd.sh** - Linkerd Service Mesh
- **loophole.sh** - Loophole
- **mkcert.sh** - mkcert Cert Utility
- **nats.sh** - NATS Server
- **ngrok.sh** - ngrok
- **node-tools.sh** - Extra Node tools
- **node.sh** - Node.js
- **ohmyzsh.sh** - Oh My Zsh & Powerlevel10k
- **opa.sh** - Open Policy Agent
- **porter.sh** - Porter
- **powershell.sh** - PowerShell
- **rust.sh** - Rust and Cargo
- **sops.sh** - Mozilla Sops
- **terraform.sh** - Terraform
- **tflint.sh** - Tflint Terraform Linter
- **wasm-pack.sh** - WASM Pack
- **yarn.sh** - Yarn
# 📦 Tool Installers 🛠🧰

This is a collection of setup scripts for tools, SDKs, dev kits and other things I might want on a new system or to install into a container.

💬 **NOTE!** These will only work on Ubuntu or Debian systems.

They are standalone & can be run at any time, and re-running them will just install the latest version in place. Where possible I install via apt, or from an 'official' remote setup script URL.  
Where binaries are downloaded and un-tarred directly, they will be placed in `$HOME/.local/bin`

Any scripts which fetch binaries directly will accept a version parameter, if not supplied the latest will be located and installed.

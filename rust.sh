#!/bin/bash 
set -e

CMD=rustc
NAME="Rust and Cargo"

curl https://sh.rustup.rs -sSf | sh -s -- --no-modify-path

export PATH="$PATH:$HOME/.cargo/bin"
echo -e "\n\e[31m»»» 📢 \e[32mNote! '\$HOME/.cargo/bin' was temporarily added to your PATH"
echo -e "\e[31m»»» 📢 \e[32mAmend your shell startup scripts to make this change permanent"
echo -e "\e[34m»»» 💾 \e[32mInstalled to: \e[33m$(which $CMD)"
echo -e "\e[34m»»» 💡 \e[32mVersion details: \e[39m$($CMD --version)"
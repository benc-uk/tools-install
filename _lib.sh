#!/bin/bash

# All scripts should source this file

get_latest_release() {
  if [ $# -lt 2 ]; then PREFIX="v"; else PREFIX=$2; fi

  curl --silent "https://api.github.com/repos/$1/releases/latest" |
  grep '"tag_name":' | sed -E "s/.*\"$PREFIX([^\"]+)\".*/\1/"
}

pre_run() {
  echo -e "\e[34m»»» 📦 \e[32mInstalling \e[33m$NAME \e[35mv$VERSION\e[0m ..."
  if [ -z "$INSTALL_DIR" ]; then return; fi

  echo -e "\e[34m»»» 📂 \e[32mTarget directory for binary: \e[35m$INSTALL_DIR"

  if [[ :$PATH: == *:"$INSTALL_DIR":* ]] ; then
    echo -e "\e[34m»»» ✅ \e[32mPATH is good"
  else
    echo -e "\e[34m»»» 💥 \e[31mInstall directory in not in PATH. Temporarily adding it!"
    echo -e "\e[34m»»» 📢 \e[31mNOTE! Amend your shell startup scripts to make this change permanent:\n\t\e[37mexport PATH=\$PATH:$INSTALL_DIR"
    export PATH="$PATH:$INSTALL_DIR"
  fi

  mkdir -p "$INSTALL_DIR"
}

post_run() {
  VERFLAG=${1:-"--version"}
  # shellcheck disable=all
  echo -e "\n\e[34m»»» 💾 \e[32mInstalled to: \e[33m$(which $CMD)"
  # shellcheck disable=all
  echo -e "\e[34m»»» 💡 \e[32mVersion details: \e[39m$($CMD $VERFLAG)"
}

apt_version() {
  apt-cache policy "$1" | grep Candidate: | cut -b 14-99
}

random_fruit() {
  fruits=("🍎" "🍊" "🍋" "🍌" "🍉" "🍇" "🍓" "🍒" "🍑" "🍍" "🥝" "🍅" "🍆" "🥑" "🥦" "🥒" "🥬" "🥭" "🥔" "🥕" "🌽" "🌶" "🍎" "🌶️" "🫐" "🥥" "🍄")
  echo "${fruits[$((RANDOM % ${#fruits[@]}))]}"
}
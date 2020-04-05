start () {
  echo -e "\e[34m»»» 🚀 \e[32mInstalling \e[33m'$1'\e[32m ... \e[39m"
}

end() {
  echo -e "\n\e[34m»»» 💾 \e[32mInstalled to: \e[33m`which $1`"
  echo -e "\e[34m»»» 💡 \e[32mVersion details: \n\e[39m`$1 $2`"
}

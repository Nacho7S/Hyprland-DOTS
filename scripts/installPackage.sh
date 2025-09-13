#!/usr/bin/env bash

source ./scripts/functions.sh

update_system(){
  yay -Syyu
}

install_game_package(){
  echo "Installing game packages..."
  yay -S lutris steam-native-runtime wine
}

install_recomended_package(){
  echo "Installing recommendation packages..."
  yay -S fastfetch fcitx5-mozc fcitx5-configtool fcitx5-gtk easyeffects mpv dolphin foot cpupower hyprcursor 
}

install_momoisay(){
  git clone https://github.com/Mon4sm/momoisay.git /tmp/momosay
  cd /tmp/momosay
  bash ./install/linux.sh
  cd $base
}



main() {
  # update_system
  
  if ask_confirmation "Do you want to install game packages (Lutris, Steam, wine)?"; then
    install_game_package
  else
    echo "Skipping game packages installation."
  fi
  
  echo ""
  install_recomended_package
  install_momoisay
}

main
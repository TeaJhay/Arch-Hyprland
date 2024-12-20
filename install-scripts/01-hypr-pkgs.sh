#!/bin/bash
# 💫 https://github.com/JaKooLit 💫 #
# Hyprland Packages #

# edit your packages desired here. 
# WARNING! If you remove packages here, dotfiles may not work properly.
# and also, ensure that packages are present in AUR and official Arch Repo

# add packages wanted here
# #$ means I am moving these to flatpak. Switching over to QT/KDE based setup wtih flatpak used when reasonable
Extra=(
  solaar
  vulkan-radeon
  lib32-vulkan-radeon
  bitwarden
  cifs-utils
  brave-bin
  heroic-games-launcher-bin
  hyprgui
  obs-studio
  spicetify-cli
  spicetify-marketplace-bin
  steam
  steamtinkerlaunch
  thunar-shares-plugin
  timeshift
  wlrobs-hg
  lutris
  handbrake
  modrinth-app
  gparted
  #gvfs-afc
  #gvfs-smb
  #gvfs-wsdd
  flatpak
  kwallet
  kwalletmanager
  kwallet-pam
  clipboard-sync
  qpwgraph
)

Flat=(
  io.github.Soundux
  com.spotify.Client
  dev.vencord.Vesktop
  org.audacityteam.Audacity
  org.kde.krita
  org.mozilla.Thunderbird
  com.github.wwmm.easyeffects
  )

#Above are packages for my setup and below are packages for system and JaKooLit's config. Below shouldn't be touched to ensure sync works and system is up-to-date with all needed utilities 

hypr_package=( 
  #aylurs-gtk-shell
  cliphist
  curl 
  grim 
  gvfs 
  gvfs-mtp
  imagemagick
  inxi 
  jq
  kitty
  kvantum
  nano  
  network-manager-applet 
  pamixer 
  pwvucontrol
  pipewire-alsa 
  playerctl
  polkit-gnome
  python-requests
  python-pyquery
  #qt5ct
  #qt6ct
  qt6-svg
  rofi-wayland
  slurp 
  swappy 
  swaync 
  swww
  wallust 
  waybar
  wget
  wl-clipboard
  wlogout
  xdg-user-dirs
  xdg-utils 
  yad
)

# the following packages can be deleted. however, dotfiles may not work properly
hypr_package_2=(
  brightnessctl 
  btop
  cava
  eog
  fastfetch
  #gnome-system-monitor
  #mousepad 
  mpv
  mpv-mpris 
  nvtop
  nwg-look
  pacman-contrib
  #qalculate-gtk
  neovim
  yt-dlp
)

# List of packages to uninstall as it conflicts some packages
uninstall=(
  aylurs-gtk-shell
  dunst
  mako
  rofi
  wallust-git
)

## WARNING: DO NOT EDIT BEYOND THIS LINE IF YOU DON'T KNOW WHAT YOU ARE DOING! ##
# Determine the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Change the working directory to the parent directory of the script
PARENT_DIR="$SCRIPT_DIR/.."
cd "$PARENT_DIR" || exit 1

source "$(dirname "$(readlink -f "$0")")/Global_functions.sh"

# Set the name of the log file to include the current date and time
LOG="Install-Logs/install-$(date +%d-%H%M%S)_hypr-pkgs.log"

# uninstalling conflicting packages
# Initialize a variable to track overall errors
overall_failed=0

printf "\n%s - Removing Mako, Dunst, and rofi as they conflict with swaync and rofi-wayland \n" "${NOTE}"
for PKG in "${uninstall[@]}"; do
  uninstall_package "$PKG" 2>&1 | tee -a "$LOG"
  if [ $? -ne 0 ]; then
    # Track if any uninstallation failed
    overall_failed=1
  fi
done

if [ $overall_failed -ne 0 ]; then
  echo -e "${ERROR} Some packages failed to uninstall. Please check the log."
fi


# Installation of main components
printf "\n%s - Installing hyprland packages.... \n" "${NOTE}"

for PKG1 in "${hypr_package[@]}" "${hypr_package_2[@]}" "${Extra[@]}"; do
  install_package "$PKG1" 2>&1 | tee -a "$LOG"
  if [ $? -ne 0 ]; then
    echo -e "\e[1A\e[K${ERROR} - $PKG1 Package installation failed, Please check the installation logs"
    exit 1
  fi
done

for PKG2 in "${Flat[@]}"; do
  # Install the Flatpak package from the flathub repo
  flatpak install -y flathub "$PKG2" 2>&1 | tee -a "$LOG"
  
  # Check if the installation failed
  if [ $? -ne 0 ]; then
    echo -e "\e[1A\e[K${ERROR} - $PKG2 package installation failed. Please check the installation logs."
    exit 1
  fi
done


clear


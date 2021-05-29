#!/usr/bin/sh

if [[ "$USER" != "ari"  ]];
then
    exit -1
fi

echo "[?] Are you sure you want to update the dotfiles?"
read -p "[-----] press enter to continue [-----]"

rm -rfv dotfiles

mkdir -p dotfiles
mkdir -p dotfiles/core_scripts
mkdir -p dotfiles/RCs
mkdir -p dotfiles/suckless/dwm
mkdir -p dotfiles/editors/vim
mkdir -p dotfiles/suckless/st
mkdir -p dotfiles/config
mkdir -p dotfiles/config/fish
mkdir -p dotfiles/core
mkdir -p dotfiles/sessions
mkdir -p dotfiles/bin

from=(
    "/home/ari/.bash_git"
    "/home/ari/.bashrc"
    "/home/ari/.dwm"
    "/home/ari/.vim"
    "/home/ari/.vimrc"
    "/home/ari/.xinitrc"
    "/home/ari/suckless/dwm-6.2"
    "/home/ari/suckless/st"
    "/home/ari/.config/alacritty"
    "/home/ari/.config/fish/fish_variables"
    "/home/ari/.config/htop"
    "/home/ari/.config/i3"
    "/home/ari/.config/i3blocks"
    "/home/ari/.config/ksnip"
    "/home/ari/.config/lsd"
    "/home/ari/.config/mpv"
    "/home/ari/.config/picom"
    "/home/ari/.config/polybar"
    "/home/ari/.config/qutebrowser"
    "/home/ari/.config/rofi"
    "/home/ari/.config/scripts"
    "/home/ari/.config/Thunar"
    "/etc/default/grub"
    "/etc/fish"
    "/etc/lightdm/lightdm.conf"
    "/etc/paru.conf"
    "/etc/xdg/reflector/reflector.conf"
    "/usr/bin/pfetch"
    "/var/lib/NetworkManager/NetworkManager-intern.conf"
    "/etc/modprobe.d/blacklist.conf"
    "/usr/share/xsessions/dwm.desktop"
    "/usr/share/xsessions/dwm.png"
    "/home/ari/ari/coding/resources_/dotfiles-cleaned/arch"
    "/home/ari/ari/coding/resources_/dotfiles-cleaned/scripts"
    "/home/ari/ari/coding/resources_/dotfiles-cleaned/patch_fish"
    "/etc/nanorc"
)
to=(
    "dotfiles/core_scripts/bash_git"
    "dotfiles/RCs/bashrc"
    "dotfiles/suckless/dwm/dwm"
    "dotfiles/editors/vim/vim"
    "dotfiles/editors/vim/vimrc"
    "dotfiles/core_scripts/xinitrc"
    "dotfiles/suckless/dwm/dwm-6.2"
    "dotfiles/suckless/st"
    "dotfiles/config/alacritty"
    "dotfiles/config/fish/fish_variables"
    "dotfiles/config/htop"
    "dotfiles/config/i3"
    "dotfiles/config/i3blocks"
    "dotfiles/config/ksnip"
    "dotfiles/config/lsd"
    "dotfiles/config/mpv"
    "dotfiles/config/picom"
    "dotfiles/config/polybar"
    "dotfiles/config/qutebrowser"
    "dotfiles/config/rofi"
    "dotfiles/config/scripts"
    "dotfiles/config/Thunar"
    "dotfiles/core/grub"
    "dotfiles/config/fish/fish"
    "dotfiles/core/lightdm.conf"
    "dotfiles/core/paru.conf"
    "dotfiles/core/reflector.conf"
    "dotfiles/bin/pfetch"
    "dotfiles/core/NetworkManager-intern.conf"
    "dotfiles/core/blacklist.conf"
    "dotfiles/sessions"
    "dotfiles/sessions"
    "dotfiles/arch"
    "dotfiles/scripts"
    "dotfiles/fish_patch"
    "dotfiles/RCs/nanorc"
)

for i in "${!from[@]}";
do
    cp -rfv ${from[$i]} ${to[$i]}
done

rm -rfv dotfiles/editors/vim/vim/undodir


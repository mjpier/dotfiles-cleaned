#!/usr/bin/sh
# colours: https://github.com/slomkowski/bash-full-of-colors/blob/master/bashrc.sh


# Reset
Reset='\e[0m'           # Text Reset

# Regular Colours
Black='\e[0;30m'        # Black
Red='\e[0;31m'          # Red
Green='\e[0;32m'        # Green
Yellow='\e[0;33m'       # Yellow
Blue='\e[0;34m'         # Blue
Purple='\e[0;35m'       # Purple
Cyan='\e[0;36m'         # Cyan
White='\e[0;37m'        # White

# Bold
BBlack='\e[1;30m'       # Black
BRed='\e[1;31m'         # Red
BGreen='\e[1;32m'       # Green
BYellow='\e[1;33m'      # Yellow
BBlue='\e[1;34m'        # Blue
BPurple='\e[1;35m'      # Purple
BCyan='\e[1;36m'        # Cyan
BWhite='\e[1;37m'       # White

# High Intensity
IBlack='\e[0;90m'       # Black
IRed='\e[0;91m'         # Red
IGreen='\e[0;92m'       # Green
IYellow='\e[0;93m'      # Yellow
IBlue='\e[0;94m'        # Blue
IPurple='\e[0;95m'      # Purple
ICyan='\e[0;96m'        # Cyan
IWhite='\e[0;97m'       # White


echo -e "${IGreen}[!] Loading...${Reset}"
if [[ "$USER" == "root" ]];
then
    echo -e "${BRed}[-] Do not run me as root!${Reset}"
    exit -1
fi


# config
sud_cmd="sudo"          # Run a command as root
pkg_man="paru"          # Package manager, I'd usggest using an aur helper
pkg_ins="-S --needed"   # Install a package (as argv)
pkg_rem="-R"            # Remove a package  (as argv)
pkg_ign="--ignore"      # ignore a package  (as argv)


echo -en "\n"
echo -e "${IGreen}[!] Config review for ${USER} ($HOME)${Reset}"
echo -e "${IWhite}Superuser do      : ${sud_cmd} ${IBlack}<cmd>${Reset}"
echo -e "${IWhite}Package manager   : ${pkg_man}"
echo -e "\t${IBlack}╰ Install   : ${pkg_man} ${pkg_ins} <pkg>${Reset}"
echo -e "\t${IBlack}╰ Uninstall : ${pkg_man} ${pkg_rem} <pkg>${Reset}"
echo -e "\t${IBlack}╰ Ignore    : ${pkg_man} ${pkg_ins} <pkg> ${pkg_ign} \"<pkg_1>,<pkg_2>\"${Reset}"

echo -en "\n"
echo -e "${Blue}[?] Is this correct?${Reset}"
echo -en "${IWhite}(${Green}y${IWhite}/${Red}N${IWhite})> ${Reset}"
read -p "" confirm_config

if [[ "${confirm_config,,}" != "y" ]];
then
    echo -e "${Red}Exiting...${Reset}"
    exit -1
fi


# functions
function install_software() {
    pks_base="cmake curl feh fish fuse git make man-db nano nerd-fonts-hack python3 python-pip rsync ttf-font-awesome vim visual-studio-code-bin siji-git wget xclip"
    pks_i3="i3-gaps i3blocks"
    pks_apps="discord bpython ksnip libreoffice-fresh mpv pfetch telegram-desktop-bin thunar tor-browser firefox"
    pks_extra="alacritty bat bc gruvbox-dark-gtk gruvbox-material-icon-theme-git youtube-dl htop i3lock-color lxappearance rofi xautolock"
    pks_disp="lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings picom xorg"

    echo -e "${IGreen}[!] Installing base packages${Reset}"
    echo -e "${IBlack}[*] ${pks_base}${Reset}"
    $pkg_man $pkg_ins $pks_base
    echo -e "\n"

    echo -e "${IGreen}[!] Installing display packages${Reset}"
    echo -e "${IBlack}[*] ${pks_disp}${Reset}"
    $pkg_man $pkg_ins $pks_disp
    echo -e "\n"

    echo -e "${Blue}[?] Do you want to install i3 on your system?${Reset}"
    echo -en "${IWhite}(${Green}y${IWhite}/${Red}N${IWhite})> ${Reset}"
    read -p "" i3_install
    if [[ "${i3_install,,}" == "y" ]];
    then
        echo -e "${IGreen}[!] Installing i3 packages${Reset}"
        echo -e "${IBlack}[*] ${pks_i3}${Reset}"
        $pkg_man $pkg_ins $pks_i3
    fi
    echo -e "\n"

    echo -e "${IGreen}[!] Installing extra packages${Reset}"
    echo -e "${IBlack}[*] ${pks_extra}${Reset}"
    echo -e "${Blue}[?] What packages to exclude? (seperate by \",\")${Reset}"
    echo -en "${Green}>>> ${Reset}"
    read -p "" pkg_exl
    pkg_exl=$(echo -n $pkg_exl | sed "s/ //g")
    $pkg_man $pkg_ins $pks_extra $pkg_ign "$pkg_exl"
    echo -en "\n"

    echo -e "${IGreen}[!] Installing extra apps${Reset}"
    echo -e "${IBlack}[*] ${pks_apps}${Reset}"
    echo -e "${Blue}[?] What packages to exclude? (seperate by \",\")${Reset}"
    echo -en "${Green}>>> ${Reset}"
    read -p "" pkg_exl_app
    pkg_exl_app=$(echo -n $pkg_exl_app | sed "s/ //g")
    $pkg_man $pkg_ins $pks_apps $pkg_ign "$pkg_exl_app"
    echo -en "\n"
    sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
               https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    git clone https://github.com/oh-my-fish/oh-my-fish
    cd oh-my-fish
    chmod +x bin/install
    bin/install
    cd ..
    cd dotfiles/suckless/dwm/dwm-6.2
    $sud_cmd make clean install
    cd ../../st/st
    $sud_cmd make clean install
    cd ../../../../
    rm -rfv oh-my-fish
}

function enable_services() {
    svcs=(
        "systemd-networkd"
        "alsa-restore"
        "reflector.timer"
        "fstrim.timer"
    )

    for svc in "${svcs[@]}";
    do
        echo -e "${Blue}[?] Do you want to enable $svc?${Reset}"
        echo -en "${IWhite}(${Green}y${IWhite}/${Red}N${IWhite})> ${Reset}"
        read -p "" enable_svc
        
        if [[ "${enable_svc,,}" == "y" ]];
        then
            $sud_cmd systemct enable $svc
        fi
    done
    echo -e "${IGreen}[!] Enabling wifi${Reset}"
    $sud_cmd wifi on || true
}

function install_dotfiles() {
    from=(
        "dotfiles/core/reflector.conf"
        "dotfiles/core/paru.conf"
        "dotfiles/core/lightdm.conf"
    )
    to=(
        "/etc/xdg/reflector/reflector.conf"
        "/etc/paru.conf"
        "/etc/lightdm/lightdm.conf"
    )
    chmod +x $HOME/.config/scripts/*

    for i in "${!from[@]}";
    do
        cp -rfv ${from[$i]} ${to[$i]}
    done
    cp -rfv dotfiles/config/* $HOME/.config


    echo -e "${Blue}[?] Do you want to overwrite your GRUB config with mine?${Reset}"
    echo -en "${IWhite}(${Green}y${IWhite}/${Red}N${IWhite})> ${Reset}"
    read -p "" grub_over
    if [[ "${grub_over,,}" == "y" ]];
    then
        $sud_cmd cp -rfv dotfiles/core/grub /etc/default/grub
        $sud_cmd grub-mkconfig -o /boot/grub/grub.cfg
    fi

    echo -e "${Blue}[?] Do you want to overwrite your blacklisted modules with mine?${Reset}"
    echo -en "${IWhite}(${Green}y${IWhite}/${Red}N${IWhite})> ${Reset}"
    read -p "" blacklist_over
    if [[ "${blacklist_over,,}" == "y" ]];
    then
        $sud_cmd cp -rfv dotfiles/core/blacklist.conf /etc/modprobe.d/blacklist.conf
    fi

    echo -e "${Blue}[?] Do you want to overwrite your mkinitcpio config with mine?${Reset}"
    echo -en "${IWhite}(${Green}y${IWhite}/${Red}N${IWhite})> ${Reset}"
    read -p "" cpio_over
    if [[ "${cpio_over,,}" == "y" ]];
    then
        $sud_cmd cp -rfv dotfiles/core/mkinitcpio.conf /etc/mkinitcpio.conf
        $sud_cmd mkinitcpio -p linux
    fi


    from_1=(
        "dotfiles/editors/vim/vim"
        "dotfiles/editors/vim/vimrc"
        "dotfiles/RCs/bashrc"
        "dotfiles/suckless/dwm/dwm"
    )
    to_1=(
        "$HOME/.vim"
        "$HOME/.vimrc"
        "$HOME/.bashrc"
        "$HOME/.dwm"
    )

    for i_1 in "${!from_1[@]}";
    do
        cp -rfv ${from_1[$i_1]} ${to_1[$i_1]}
    done

    $sud_cmd cp -rfv dotfiles/bin/pfetch /usr/bin/pfetch
    $sud_cmd cp -rfv dotfiles/sessions/* /usr/share/xsessions
    $sud_cmd cp -rfv dotfiles/RCs/nanorc /etc/nanorc
    cp -rfv dotfiles/core_scripts/bash_git $HOME/.bash_git
    cp -rfv dotfiles/core_scripts/xinitrc $HOME/.xinitrc
    
    $sud_cmd chown root:root $HOME/.xinitrc
    $sud_cmd chmod +x $HOME/.xinitrc
    
    chmod +x $HOME/.bash_git
    chmod +x $HOME/.dwm/autostart.sh
    chmod +x $HOME/.dwm/dwm-bar/*
    chmod +x $HOME/.config/mpv/scripts/*
    $sud_cmd chmod +x /usr/bin/pfetch
}

function options() {
    echo -e "${IRed}Pick either 1, 2, 3 or 4${Reset}"
}

function main() {
    while true;
    do
        echo -en "\n"
        echo -e "${Yellow}1. Install software${Reset}"
        echo -e "${Yellow}2. Enable Services${Reset}"
        echo -e "${Yellow}3. Install dotfiles${Reset}"
        echo -e "${Yellow}4. Exit${Reset}"

        echo -en "${IYellow}>>> ${Reset}"
        read -p "" chs

        case "${chs}" in
            1) install_software  ;;
            2) enable_services   ;;
            3) install_dotfiles  ;;
            4) break             ;;
            *) options           ;;
        esac
    done
}


# main
main


#!/usr/bin/sh
# Yes, no colours, I made this descision because of compatibility and readability reasons.


echo "[*] loading..."
if [[ "$USER" == "root" ]];
then
    echo "[-] Do not run me as root"
    exit -1
fi


sudo_cmd="sudo"                     # Run a command as root
package_man="paru"                  # Your package manager, I'd suggest using an AUR helper
package_man_install="-S --needed"   # Flags to pass to install a package using your package manager
                                    # Base packages you want in your system
base_packages="cmake curl feh fish fuse git make man-db nano nerd-fonts-hack python3 python-pip rsync ttf-font-awesome vim siji-git wget"
                                    # i3 packages you want
i3_packages="i3-gaps i3blocks python-i3ipc"
                                    # apps
apps_packages="discord bpython ksnip libreoffice-fresh mpv kotatogram-desktop-bin pfetch thunar tor-browser firefox visual-studio-code-bin"
                                    # extra packages you want
extra_packages="alacritty bat bc gruvbox-dark-gtk gruvbox-material-icon-theme-git youtube-dl htop i3lock-color lxappearance rofi xautolock"
                                    # display manager, server, etc.
display_packages="lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings picom xorg xorg-xinit"

# Variables you don't need to edit
back=$(pwd)

echo "[*] Checking configuration for $USER"
echo -e "\tRun command as root :  $sudo_cmd <command>"
echo -e "\tPackage manager     :  $package_man"
echo -e "\tInstall a package   :  $package_man $package_man_install <package(s)>"

echo "[?] Confirm config, Is this correct?"
read -p "[y/N]$ " confirm_config
if [[ "${confirm_config,,}" != "y" ]];
then
    echo "[-] Exiting..."
    exit -1
fi


function install_software() {
    echo -en "\n"
    echo "[*] Installing base packages"
    $package_man $package_man_install $base_packages

    echo -en "\n"
    echo "[*] Installing i3 packages"
    echo "[?] Do you want i3 on your system?"
    read -p "[y/N]$ " i3_confirm
    if [[ "${i3_confirm,,}" == "y" ]];
    then
        $package_man $package_man_install $i3_packages
    fi

    echo -en "\n"
    echo "[*] Installing extra apps"
    $package_man $package_man_install $apps_packages

    echo -en "\n"
    echo "[*] Installing extra packages"
    $package_man $package_man_install $extra_packages

    echo -en "\n"
    echo "[*] Installing display packages"
    $package_man $package_man_install $display_packages
}

function compile_software() {
    function install_st() {
        cd dotfiles/suckless/st/st
        $sudo_cmd make clean install
        cd $back
    }

    function install_dwm() {
        cd dotfiles/suckless/dwm/dwm-6.2
        $sudo_cmd make clean install
        cd $back
    }
    
    function install_dmenu() {
        cd dotfiles/suckless/dmenu/dmenu-5.0
        $sudo_cmd make clean install
        cd $back
    }

    function install_oh_my_fish() {
        git clone https://github.com/oh-my-fish/oh-my-fish
        cd oh-my-fish
        bin/install
        cd $back
        rm -rf oh-my-fish
    }

    function install_vimplug() {
        curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
                https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    }

    suckless_utils=(
        "st"
        "dwm"
        "dmenu"
        "oh_my_fish"
        "vimplug"
    )

    for s_util in "${suckless_utils[@]}";
    do
        echo -en "\n"
        echo "[?] Do you want to install $s_util?"
        read -p "[y/N]$ " install_s_util

        if [[ "${install_s_util,,}" == "y" ]];
        then
            eval "install_$s_util"
        fi
    done
}

function enable_services_() {
    services=(
        "systemd-networkd"
        "alsa-restore"
        "reflector.timer"
        "fstrim.timer"
        "tlp"
        "lightdm"
    )

    for serv in "${services[@]}";
    do
        echo "[?] Do you want to enable $serv?"
        read -p "[y/N]$ " svc_enable
        
        if [[ "${svc_enable,,}" == "y" ]];
        then
            $sudo_cmd systemctl enable $svc || true
        fi
        echo -en "\n"
    done
    $sudo_cmd wifi on || true
}

function install_dotfiles() {
    from=(
        "dotfiles/bin/pfetch"
        "dotfiles/config"
        "dotfiles/core/blacklist.conf"
        "dotfiles/core/grub"
        "dotfiles/core/hosts"
        "dotfiles/core/mkinitcpio.conf"
        "dotfiles/core/pacman.conf"
        "dotfiles/core/paru.conf"
        "dotfiles/core/reflector.conf"
        "dotfiles/core_scripts/bash_git"
        "dotfiles/core_scripts/xinitrc"
        "dotfiles/editors/vim/vimrc"
        "dotfiles/editors/vim"
        "dotfiles/sessions/dwm.desktop"
        "dotfiles/sessions/dwm.png"
        "dotfiles/RCs/bashrc"
        "dotfiles/RCs/nanorc"
        "dotfiles/config/fish/fish"
        "dotfiles/config/fish/fish/functions"
    )
    to=(
        "/usr/bin/pfetch"
        "$HOME/.config"
        "/etc/modprobe.d/blacklist.conf"
        "/etc/default/grub"
        "/etc/hosts"
        "/etc/mkinitcpio.conf"
        "/etc/pacman.conf"
        "/etc/paru.conf"
        "/etc/xdg/reflector/reflector.conf"
        "$HOME/.bash_git"
        "$HOME/.xinitrc"
        "$HOME/.vimrc"
        "$HOME/.vim"
        "/usr/share/xsessions/dwm.desktop"
        "/usr/share/xsessions/dwm.png"
        "$HOME/.bashrc"
        "/etc/nanorc"
        "/etc/fish"
        "$HOME/.config/fish/functions"
    )

    for i in "${!from[@]}";
    do
        echo "[?] put ${from[$i]} -> ${to[$i]}?"
        read -p "[Y/n]$ " copy_dot

        if [ "${copy_dot,,}" == "y" ] || [ ! "${copy_dot}" ];
        then
            cp -rfv ${from[$i]} ${to[$i]}
        fi
    done
}

function all_options_____() {
    echo "Pick 1, 2, 3, 4 or 5"
}


function main() {
    while true;
    do
        echo -en "\n"
        echo "1. Install the needed software"
        echo "2. Compile needed software from source"
        echo "3. Enable needed services"
        echo "4. Install the dotfiles"
        echo "5. Exit"

        read -p ">>> " choice
        case "${choice}" in
            1) install_software     ;;
            2) compile_software     ;;
            3) enable_services_     ;;
            4) install_dotfiles     ;;
            5) break                ;;
            *) all_options_____     ;;
        esac
    done
}


main
echo "[@] The program has finished"


#!/usr/bin/sh

if [ "$EUID" -ne 0  ];
then
    echo "Run me as root"
    exit -1
fi

sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
git clone https://github.com/oh-my-fish/oh-my-fish
cd oh-my-fish
chmod +x bin/install
bin/install
cd ..
rm -rfv oh-my-fish
cp -rfv dotfiles/config $HOME/.config


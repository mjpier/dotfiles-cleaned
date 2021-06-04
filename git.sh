#!/usr/bin/sh

if [[ ! "$1" ]];
then
    echo "$0 <commit message>"
    exit -1
fi

echo "commiting with the message \"$1\""
if [[ ! -d .git  ]];
then
    git init
    git add .
    git commit -m "$0"
    https://github.com/TruncatedDinosour/dotfiles-cleaned.git
    git push -u origin master
    exit
fi

git add .
git commit -m "$1"
git push


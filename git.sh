#!/usr/bin/sh

if [[ ! "$1" ]];
then
    echo "$0 <commit message>"
    exit -1
fi

echo "commiting with the message \"$1\""
git add .
git commit -m "$1"
git push


#!/bin/bash

mkdir -p ~/.vim/bundle
cd ~/.vim/bundle

while read line;  do
    dir="$(basename "$line")"

    if [ ! -d "$dir" ]; then
        git clone --depth 1 --recursive "$line"
    fi
done < ~/.vim-conf/bundle.txt

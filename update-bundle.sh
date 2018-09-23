#!/bin/bash

cd ~/.vim/bundle

while read line;  do
    dir="$(basename "$line")"

    if [ ! -d "$dir" ]; then
        git clone --depth 1 "$line"
    fi
done < ~/.vim-conf/bundle.txt

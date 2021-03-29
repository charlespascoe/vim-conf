#!/bin/bash

directories=$(find ~/.vim-conf/ -maxdepth 1 -mindepth 1 -type d ! -name '.*' ! -name 'patches' | xargs basename)

mkdir -p ~/.vim/

for dir in $directories; do
    if [ ! -e ~/.vim/$dir ]; then
        ln -s $HOME/.vim-conf/"$dir" ~/.vim/"$dir"
    fi
done

if [ ! -f ~/.vimrc ]; then
    echo "source ~/.vim-conf/vimrc" >> ~/.vimrc
fi

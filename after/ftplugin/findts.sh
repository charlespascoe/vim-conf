#!/bin/bash

DIR=`pwd`
PREFIX=$1

while [[ "$DIR" != "/" ]]; do
    if [ ! -f "$DIR/tsconfig.json" ]; then
        DIR=`dirname "$DIR"`
        continue
    fi

    if [ -d "$DIR/src" ]; then
        MODULES="$(find "$DIR/src" -regex '.*\.tsx?$' -printf '%P\n' | sed -E 's/\.tsx?$//' | sed -E 's/\/index$//')"
        compgen -W "$MODULES" -- "$PREFIX"
    fi

    if [ -d "$DIR/node_modules" ]; then
        MODULES="$(find "$DIR/node_modules" -mindepth 1 -maxdepth 1 -type d -printf '%P\n')"
        compgen -W "$MODULES" -- "$PREFIX"
    fi


    break
done

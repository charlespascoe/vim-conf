#!/bin/bash

DIR=`pwd`
PREFIX=$1

while [[ "$DIR" != "/" ]]; do
    if [ ! -d "$DIR/.git" ]; then
        DIR=`dirname "$DIR"`
        continue
    fi

    if [ -d "$DIR/src" ]; then
        MODULES="$(find "$DIR/src" -regex '.*\.tsx?$' -printf '%P\n' | sed -E 's/\.tsx?$//' | sed -E 's/\/index$//')"
        compgen -W "$MODULES" -- "$PREFIX"
    fi

    break
done

#!/bin/bash

# TODO: Don't change BN_HOME if it's already set
export BN_HOME="$HOME/bulletnotes"

function __bn_complete() {
    COMPREPLY=()

    if [ -z "$BN_HOME" ] || [ ! -d "$BN_HOME" ]; then
        return
    fi

    if [ "$COMP_CWORD" -eq 1 ]; then
        COMPREPLY=( $(compgen -W 'clone inbox journal newproj vs' -- "${COMP_WORDS[COMP_CWORD]}") )
        return
    fi

    local projects="$(find "$BN_HOME" -maxdepth 1 -mindepth 1 -type d -printf '%f ')"

    case "${COMP_WORDS[1]}" in
        inbox|journal|vs)
            if [ "$COMP_CWORD" -eq 2 ]; then
                COMPREPLY=( $(compgen -W "$projects" -- "${COMP_WORDS[COMP_CWORD]}") )
            fi
            ;;
    esac
}

complete -F __bn_complete bn

export PATH="$PATH:$HOME/.vim-conf/bin"

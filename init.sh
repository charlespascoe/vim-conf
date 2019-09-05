#!/bin/bash

# TODO: Don't change BN_HOME if it's already set
export BN_HOME="$HOME/bulletnotes"

function __bn_complete() {
    COMPREPLY=()

    if [ -z "$BN_HOME" ] || [ ! -d "$BN_HOME" ]; then
        return
    fi

    if [ "$COMP_CWORD" -eq 1 ]; then
        COMPREPLY=( $(compgen -W 'clone fvs inbox journal ls newproj vs' -- "${COMP_WORDS[COMP_CWORD]}") )
        return
    fi

    local projects="$(find "$BN_HOME" -maxdepth 1 -mindepth 1 -type d -printf '%f ')"

    case "${COMP_WORDS[1]}" in
        fvs|inbox|journal|vs)
            if [ "$COMP_CWORD" -eq 2 ]; then
                COMPREPLY=( $(compgen -W "$projects" -- "${COMP_WORDS[COMP_CWORD]}") )
            fi
            ;;

        clone)
            touch "$BN_HOME/remotes_cache"
            remotes="$(xargs -a "$BN_HOME/remotes_cache" echo -n)"

            COMPREPLY=( $(compgen -W "$remotes" -- "${COMP_WORDS[COMP_CWORD]}") )

            ;;


        ls)
            COMPREPLY=( $(compgen -W "remote" -- "${COMP_WORDS[COMP_CWORD]}") )

            ;;
    esac
}

complete -F __bn_complete bn

export PATH="$PATH:$HOME/.vim-conf/bin"

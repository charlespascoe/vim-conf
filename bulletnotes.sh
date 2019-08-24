#!/bin/bash

export BN_HOME="$HOME/bulletnotes"

function bn() {
    if [ -z "$BN_HOME" ] || [ ! -d "$BN_HOME" ]; then
        echo "BN_HOME not set or not a directory"
        return 1
    fi

    if [ "$#" -eq 0 ]; then
        echo "Usage: bn COMMAND"
        return 1
    fi


    case $1 in
        inbox)
            if [ "$#" -lt 2 ] || [ "$#" -gt 3 ]; then
                echo "Usage: bn inbox PROJECT [TITLE]"
                return 1
            fi

            local proj="$2"

            if [ ! -d "$BN_HOME/$proj" ]; then
                echo "Project not found: $proj"
                return 1
            fi

            bash -c "export BN_PROJ=1 && cd '$BN_HOME/$proj' && vim -c 'Inbox $3'"
            ;;
        vs)
            if [ "$#" -ne 2 ]; then
                echo "Usage: bn vs PROJECT"
                return 1
            fi

            local proj="$2"

            if [ ! -d "$BN_HOME/$proj" ]; then
                echo "Project not found: $proj"
                return 1
            fi

            bash -c "export BN_PROJ=1 && cd '$BN_HOME/$proj' && source ~/.bash_aliases && vs"
            ;;

        newproj)
            if [ "$#" -ne 2 ]; then
                echo  "Usage: bn newproj PROJECT"
                return 1
            fi

            local proj="$2"

            if [ -d "$BN_HOME/$proj" ]; then
                echo "Project '$proj' already exists"
                return 1
            fi

            local confirm

            read -p "Are you sure you want to create the project $proj? " confirm

            if [ "$confirm" != 'y' ]; then
                return
            fi

            mkdir "$BN_HOME/$proj"

            pushd "$BN_HOME/$proj"

            git init

            mkdir inbox archive ref future

            touch .bnproj

            git add .bnproj

            git commit -m 'Initial Commit'

            hub create -p "bulletnotes-$proj"

            git push -u origin master

            popd

            ;;

        *)

            echo "Unknown command: $1"
            return 1
            ;;
    esac

}


function __bn_complete() {
    COMPREPLY=()

    if [ -z "$BN_HOME" ] || [ ! -d "$BN_HOME" ]; then
        return
    fi

    if [ "$COMP_CWORD" -eq 1 ]; then
        COMPREPLY=( $(compgen -W 'inbox newproj vs' -- "${COMP_WORDS[COMP_CWORD]}") )
        return
    fi

    local projects="$(find "$BN_HOME" -maxdepth 1 -mindepth 1 -type d -printf '%f ')"

    case "${COMP_WORDS[1]}" in
        inbox)
            if [ "$COMP_CWORD" -eq 2 ]; then
                COMPREPLY=( $(compgen -W "$projects" -- "${COMP_WORDS[COMP_CWORD]}") )
            fi
            ;;

        vs)
            if [ "$COMP_CWORD" -eq 2 ]; then
                COMPREPLY=( $(compgen -W "$projects" -- "${COMP_WORDS[COMP_CWORD]}") )
            fi
            ;;
    esac
}

complete -F __bn_complete bn

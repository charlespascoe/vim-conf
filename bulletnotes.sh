#!/bin/bash


function bn() {
    if [ -z "$BN_HOME" ] || [ ! -d "$BN_HOME" ]; then
        echo "BN_HOME not set or not a directory"
        return 1
    fi

    if [ "$#" -eq 0 ]; then
        echo "Usage: bn <command>"
        return 1
    fi


    case $1 in
        inbox)
            if [ "$#" -lt 2 ]; then
                echo "Usage: bn inbox <project> [title]"
                return 1
            fi

            local proj="$2"

            if [ ! -d "$BN_HOME/$proj" ]; then
                echo "Project not found: $proj"
                return 1
            fi

            bash -c "BN_PROJ=1 && cd '$BN_HOME/$proj' && vim -c 'Inbox $3'"
            ;;
        vs)
            if [ "$#" -lt 2 ]; then
                echo "Usage: bn go <project>"
                return 1
            fi

            local proj="$2"

            if [ ! -d "$BN_HOME/$proj" ]; then
                echo "Project not found: $proj"
                return 1
            fi

            bash -c "BN_PROJ=1 && cd '$BN_HOME/$proj' && source ~/.bash_aliases && vs"
            ;;

        *)

            echo "Unknown command: $1"
            return 1
            ;;
    esac

}

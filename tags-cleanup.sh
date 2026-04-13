#!/usr/bin/env zsh

gsed -E -i '/^anonymous(Object|Function)[0-9a-f]/d' $1

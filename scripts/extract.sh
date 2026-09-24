#!/bin/sh

file="$1"

case "$file" in
    *.tar.gz|*.tgz)
        tar -xzf "$file"
        ;;
    *.tar.bz2|*.tbz2)
        tar -xjf "$file"
        ;;
    *.tar.xz|*.txz)
        tar -xJf "$file"
        ;;
    *.tar)
        tar -xf "$file"
        ;;
    *.zip)
        unzip "$file"
        ;;
    *.gz)
        gunzip "$file"
        ;;
    *.xz)
        xz -d "$file"
        ;;
    *)
        exit 1
        ;;
esac


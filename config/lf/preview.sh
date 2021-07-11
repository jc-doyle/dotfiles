#!/bin/sh

case "$1" in
    *.tar*) tar tf "$1";;
    *.zip) unzip -l "$1";;
    *.rar) unrar l "$1";;
    *.7z) 7z l "$1";;
    *.pdf) pdftotext "$1" -;;
    *.jpg) chafa -c 240 --fill -block --symbols -geometric "$1";;
    *) bat --color=always --theme=base16 --style="plain" "$1";;
esac

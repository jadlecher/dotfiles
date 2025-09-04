#!/bin/bash -e
case $1 in
light | dark)
  value=prefer-$1
  echo setting gsettings preferred color scheme to \'"$value"\'
  gsettings set org.gnome.desktop.interface color-scheme "$value"
  for program in nvim kitty mako hypr qutebrowser; do
    ~/.config/$program/scripts/set-theme.sh
  done
  makoctl reload
  exit 0
  ;;
*)
  echo 'Unknown theme "'"$1"'"'
  exit 1
  ;;
esac

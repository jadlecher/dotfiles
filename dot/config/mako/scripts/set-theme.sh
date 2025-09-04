#!/bin/bash -e
theme=$(gsettings get org.gnome.desktop.interface color-scheme | grep -oE "light|dark")
case $theme in
light | dark)
  config_dir=~/.config/mako
  cat $config_dir/templates/common.conf >$config_dir/config
  echo "" >>$config_dir/config
  cat $config_dir/templates/"${theme}".conf >>$config_dir/config
  ;;
*)
  echo "could not determine current theme"
  exit 1
  ;;
esac

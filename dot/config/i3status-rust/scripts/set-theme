#!/bin/bash -e
theme=$(gsettings get org.gnome.desktop.interface color-scheme | grep -oE "light|dark")
case $theme in
light)
  theme="ctp-latte"
  ;;
dark)
  theme="ctp-mocha"
  ;;
*)
  echo "could not determine current theme"
  exit 1
  ;;
esac
conf_dir=~/.config/i3status-rust
file=config.toml
sed 's/${THEME}/'$theme'/' $conf_dir/template/$file >$conf_dir/$file

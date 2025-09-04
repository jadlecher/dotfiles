#!/bin/bash -e
theme=$(gsettings get org.gnome.desktop.interface color-scheme | grep -oE "light|dark")
case $theme in
dark)
  blacklist=light
  ;;
light)
  blacklist=dark
  ;;
*)
  echo "could not determine current theme"
  exit 1
  ;;
esac
# read current theme
conf_dir=$HOME/.config/sway
file=$conf_dir/conf-enabled/theme
[[ -f $file ]] && current_theme=$(<$file)
# change theme if necessary
if [[ "$theme" != "$current_theme" ]]; then
  # clear enabled configs
  rm -f $conf_dir/conf-enabled/*.conf
  # copy all configs except ones matching the opposite theme
  find $conf_dir/conf-available -name '*.conf' -and -not -name "*-${blacklist}.conf" \
    -exec ln -s {} $conf_dir/conf-enabled/ \;
  # record new theme
  echo $theme >$conf_dir/conf-enabled/theme
  # reload sway
  swaymsg reload >/dev/null
fi

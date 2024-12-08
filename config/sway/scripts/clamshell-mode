#!/bin/sh -e
laptop_output="eDP-1"
output_count=$(swaymsg -t get_outputs | grep name | wc -l)
lid_state_file="/proc/acpi/button/lid/LID0/state"
read -r LS <"$lid_state_file"

enabled=$(swaymsg -t get_outputs | jq '.[] | select(.name=="'$laptop_output'") | .power') || false
enable=true
case "$LS" in
*open) ;;
*closed)
  # if lid closed and more than one output, disable laptop output
  if [ "$output_count" -gt 1 ]; then
    enable=false
  fi
  ;;
*)
  echo "Could not get lid state" >&2
  exit 1
  ;;
esac

if [ $enable != $enabled ]; then
  verb=Disabling
  if $enable; then verb=Enabling; fi
  notify-send "Clamshell Mode" "$verb laptop output"
  value=disable
  if $enable; then value=enable; fi
  swaymsg output $laptop_output $value
fi

#!/bin/bash -e

source_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
dry_run=false

usage() {
  echo "Usage: $0 [OPTIONS]"
  echo "Options:"
  echo " -h, --help      Display this help message"
  echo " -n, --dry-run   Print proposed changes only"
}
handle_options() {
  while [ $# -gt 0 ]; do
    case $1 in
      -h | --help)
        usage
        exit 0
        ;;
      -n | --dry-run)
        dry_run=true
        ;;
      *)
        echo "Invalid option: $1" >&2
        usage
        exit 1
        ;;
    esac
    shift
  done
}
install() {
  echo "Creating symbolic link to $1 in $2."
  if ! ${dry_run} ; then
    ln -sf "$1" "$2"
  fi
}
install_scripts() {
  target=${HOME}/.local/bin
  if [ ! -d "${target}" ]; then
      echo "${fallback_target} does not exist, creating it."
      mkdir "${target}"
  fi
  for script in $source_dir/scripts/*; do
      if [ -f "$script" ]; then
        source=$(readlink -f "${script}")
        install "${source}" "${target}"
      fi
  done
}
install_configs() {
  target=${XDG_CONFIG_DIR} # try the default config directory
  fallback_target=~/.config # alternative dir to use if the default directory does not exist
  if [ ! -d "${target}" ]; then
    echo "XDG_CONFIG_DIR is not defined. Using ${fallback_target} instead."
    target="${fallback_target}"
    if [ ! -d "${target}" ]; then
      echo "${fallback_target} does not exist, creating it."
      mkdir "${target}"
    fi
  fi
  for entry in $source_dir/config/*/; do
      if [ -d "$entry" ] ; then
        source=$(readlink -f "${entry}")
        install "${source}" "${target}"
      fi
  done
}

handle_options "$@"
if ${dry_run} ; then echo "Executing dry run." ; fi
install_scripts
install_configs

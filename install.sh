#!/bin/bash -e

source_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
target_dir=$HOME
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
install_entry() {
  echo "Creating symbolic link to $1 in $2"
  if ! ${dry_run}; then
    ln -sf "$1" "$2"
  fi
}
install_dir_entries() {
  source="$1"
  target="$2"
  if [ ! -d "$target" ]; then
    echo "$target does not exist, creating it"
    mkdir "$target"
  fi
  for entry in "$source"/*; do
    basename=$(basename "$entry")
    install_entry "$entry" "$target/${basename}"
  done
}

handle_options "$@"
if ${dry_run}; then echo "Executing dry run"; fi
install_dir_entries "$source_dir/dot/config" "$target_dir/.config"
install_dir_entries "$source_dir/dot/local/bin" "$target_dir/.local/bin"

#!/bin/bash -e
target_dir=${XDG_CONFIG_DIR} # try the default config directory
fallback_target_dir=~/.config # alternative dir to use if the default directory does not exist
if [ ! -d "${target_dir}" ]; then
	echo "XDG_CONFIG_DIR is not defined. Using ${fallback_target_dir} instead."
	target_dir="${fallback_target_dir}"
	if [ ! -d "${target_dir}" ]; then
		echo "${fallback_target_dir} does not exist, creating it."
		mkdir "${target_dir}"
	fi
fi
for entry in */; do
    if [ -d "$entry" ]; then
      source_dir=$(readlink -f "${entry}")
      echo "Creating symbolic link to configuration ${source_dir} in ${target_dir}."
      ln -sf  "${source_dir}" "${target_dir}"
    fi
done
echo "Done."

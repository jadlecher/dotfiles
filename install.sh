#!/bin/bash
config_dir=${XDG_CONFIG_DIR} # try the default config directory
fallback_config_dir=~/.config # alternative dir to use if the default directory does not exist
if [ ! -d "${config_dir}" ]; then
	echo "XDG_CONFIG_DIR is not defined. Using ${fallback_config_dir} instead."
	config_dir="${fallback_config_dir}"
	if [ ! -d "${config_dir}" ]; then
		echo "${fallback_config_dir} does not exist, creating it."
		mkdir "${config_dir}"
	fi
fi
nvim_config_dir=$(readlink -f ./nvim)
echo "Creating symbolic link to this configuration (${nvim_config_dir}) in ${config_dir}."
ln -sf  "${nvim_config_dir}" "${config_dir}" && echo "Done."

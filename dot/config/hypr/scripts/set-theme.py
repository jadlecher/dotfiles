#!/usr/bin/env python3
import argparse
import os
import re
import subprocess
from os import listdir
from os.path import isfile, join

import yaml

extension = ".conf"
themes = ["light", "dark"]


def get_system_theme():
    command = "gsettings get org.gnome.desktop.interface color-scheme"
    result = subprocess.run(command.split(" "), stdout=subprocess.PIPE, check=True)
    theme = result.stdout.decode("utf-8")
    theme = theme.strip()  # remove any whitespace surrounding output
    theme = theme.strip("'")  # remove quotes around output
    prefix = "prefer-"
    if not theme.startswith(prefix):
        raise ValueError("invalid system theme detected")
    theme = theme.removeprefix("prefer-")
    if theme in themes:
        return theme
    else:
        raise ValueError("invalid system theme detected")


def list_config_files(path: str):
    return [
        file
        for file in listdir(path)
        if file.endswith(extension) and isfile(join(path, file))
    ]


def get_opposite_theme(theme: str):
    return [x for x in themes if x != theme][0]


def filter_inapplicable_config_files(theme: str, files: list[str]):
    pattern = f"^.*-{get_opposite_theme(theme)}\\.conf$"
    return [file for file in files if not re.search(pattern, file, re.IGNORECASE)]


def sync_link(src: str, dest: str):
    src = os.path.abspath(src)
    dest = os.path.abspath(dest)
    exists = False
    if os.path.exists(dest):
        if os.path.islink(dest) and os.path.abspath(os.readlink(dest)) == src:
            exists = True
        else:
            os.remove(dest)
    if not exists:
        os.symlink(src, dest)


def sync_dir(input_dir: str, output_dir: str, files: list[str]):
    for file in files:
        src = os.path.join(input_dir, file)
        dest = os.path.join(output_dir, file)
        sync_link(src, dest)

    # remove stale links
    for file in listdir(output_dir):
        path = os.path.join(output_dir, file)
        if os.path.islink(path) and file.endswith(extension) and file not in files:
            os.remove(path)


def set_wallpaper(output: str, path: str):
    subprocess.run(["hyprctl", "hyprpaper", "reload", f"{output},{path}"], check=True)


def apply_wallpaper_config(theme: str, config: str):
    with open(config, "r") as file:
        for display, options in yaml.safe_load(file).items():
            if theme in options:
                wallpaper = options[theme]
                set_wallpaper(display, wallpaper)


parser = argparse.ArgumentParser(prog="set-theme")
parser.add_argument(
    "-i",
    "--input-dir",
    required=True,
    help="A directory containing the input configuration files",
)
parser.add_argument(
    "-o",
    "--output-dir",
    required=True,
    help="A directory containing the output configuration files",
)
parser.add_argument("-w", "--wallpaper-config", help="The wallpaper configuration file")
args = parser.parse_args()

theme = get_system_theme()
files = list_config_files(args.input_dir)
files = filter_inapplicable_config_files(theme, files)
input_dir = os.path.abspath(args.input_dir)
output_dir = os.path.abspath(args.output_dir)
sync_dir(input_dir, output_dir, files)

if args.wallpaper_config:
    apply_wallpaper_config(theme, args.wallpaper_config)

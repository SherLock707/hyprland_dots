#!/bin/bash

# Define the path to the swww cache directory
cache_dir="$HOME/.cache/swww/"

# Get a list of monitor outputs
monitor_outputs=($(ls "$cache_dir"))

# Loop through monitor outputs
for output in "${monitor_outputs[@]}"; do
    # Construct the full path to the cache file
    cache_file="$cache_dir$output"

    # Check if the cache file exists for the current monitor output
    if [ -f "$cache_file" ]; then
        # Get the wallpaper path from the cache file
        wallpaper_path=$(cat "$cache_file")

        # Copy the wallpaper to the location Rofi can access
        ln -sf "$wallpaper_path" "$HOME/.config/rofi/.current_wallpaper"
        convert "$wallpaper_path" -filter Gaussian -blur 0x8 $HOME/.config/rofi/.current_wallpaper_blur.png &

        break  # Exit the loop after processing the first found monitor output
    fi
done

# execute pywal
# wal -i $wallpaper_path

# execute pywal skipping tty and terminal
wal -i $wallpaper_path -s -t
# matugen --mode dark image $wallpaper_path

sed -i 's/1.0)/0.5)/g' ~/.cache/wal/colors-waybar-rgba.css

#Update icon colours
$HOME/.config/hypr/scripts/SetIconColor.sh

# more info regarding Pywal https://github.com/dylanaraps/pywal/wiki/Getting-Started
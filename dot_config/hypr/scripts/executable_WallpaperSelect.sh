#!/bin/bash
# # WALLPAPERS PATH
# DIR=$HOME/Pictures/wallpapers

# # Transition config
# FPS=60
# TYPE="wipe"
# DURATION=1
# SWWW_PARAMS="--transition-fps $FPS --transition-type $TYPE --transition-duration $DURATION"

# # Check if swaybg is running
# if pidof swaybg > /dev/null; then
#   pkill swaybg
# fi

# # Retrieve image files
# PICS=($(ls "${DIR}" | grep -E ".jpg$|.jpeg$|.png$|.gif$"))
# RANDOM_PIC="${PICS[$((RANDOM % ${#PICS[@]}))]}"
# RANDOM_PIC_NAME="${#PICS[@]}. random"

# # Rofi command
# rofi_command="rofi -dmenu -config ~/.config/rofi/config-wallpaper.rasi"
# # rofi_command="rofi -dmenu -config ~/.config/rofi/config-wallpaper_img.rasi"

# menu() {
#   for i in "${!PICS[@]}"; do
#     # Displaying .gif to indicate animated images
#     if [[ -z $(echo "${PICS[$i]}" | grep .gif$) ]]; then
#       # printf "$i. $(echo "${PICS[$i]}" | cut -d. -f1)\n"
#       echo -en "$i. ${PICS[$i]}\x00icon\x1f${DIR}/${PICS[$i]}\n"
#       # printf "$(echo "${PICS[$i]}" | cut -d. -f1)\x00icon\x1f${DIR}/${PICS[$i]}\n"
#     else
#       # printf "$i. ${PICS[$i]}\n"
#       echo -en "$i. $PICS[$i]\x00icon\x1f${DIR}/${PICS[$i]}\n"
#     fi
#   done

#   printf "$RANDOM_PIC_NAME"
#   # find "$HOME/Pictures/wallpapers/" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) -exec basename {} \; | sort | while read rfile
#   # do
#   #     echo -en "$rfile\x00icon\x1f$HOME/Pictures/wallpapers/${rfile}\n"
#   # done 
# }

# swww query || swww init

# main() {
#   choice=$(menu | ${rofi_command})

#   # No choice case
#   if [[ -z $choice ]]; then
#     exit 0
#   fi

#   # Random choice case
#   if [ "$choice" = "$RANDOM_PIC_NAME" ]; then
#     swww img "${DIR}/${RANDOM_PIC}" $SWWW_PARAMS
#     exit 0
#   fi

#   pic_index=$(echo "$choice" | cut -d. -f1)
#   swww img "${DIR}/${PICS[$pic_index]}" $SWWW_PARAMS
# }

# # Check if rofi is already running
# if pidof rofi > /dev/null; then
#   pkill rofi
#   exit 0
# fi

# main

# $HOME/.config/hypr/scripts/PywalSwww.sh &
# $HOME/.config/hypr/scripts/Refresh.sh

SCRIPTSDIR="$HOME/.config/hypr/scripts"

# WALLPAPERS PATH
wallDIR="$HOME/Pictures/wallpapers"

randWall="$HOME/.config/swaync/assets/random_wallpaper.png"

# Transition config
FPS=30
TYPE="wipe"
DURATION=1
BEZIER=".43,1.19,1,.4"
SWWW_PARAMS="--transition-fps $FPS --transition-type $TYPE --transition-duration $DURATION"

# Check if swaybg is running
if pidof swaybg > /dev/null; then
  pkill swaybg
fi

# Retrieve image files
PICS=($(ls "${wallDIR}" | grep -E ".jpg$|.jpeg$|.png$|.gif$"))
RANDOM_PIC="${PICS[$((RANDOM % ${#PICS[@]}))]}"
RANDOM_PIC_NAME="🎲 Random"

# Rofi command
rofi_command="rofi -show -dmenu -config ~/.config/rofi/config-wallpaper.rasi"


get_random_emoji_list() {
    emojis=("🚀" "🎉" "🍕" "🌺" "📚" "🎸" "🌟" "🚲" "🍦" "🎨" "🐾" "🍭" "🎈" "🌍"
            "🌸" "🍀" "🎂" "🎁" "🎊" "🍔" "🌼" "📖" "🎹" "🌠" "🚗" "🍨" "🖌️" "🐶" "🍬"
            "🍇" "🚁" "🎸" "🍟" "🌷" "📔" "🎷" "🚲" "🍨" "🎭" "🐱" "🍩" "🎀" "🌄"
            "🌅" "🍓" "🎤" "🍻" "🌸" "🚢" "🏰" "🎡" "🎮" "🍂" "🚁" "🚤" "🚂")
    shuf -e "${emojis[@]}" -n "1"
}

menu() {
  for i in "${!PICS[@]}"; do
    # Displaying .gif to indicate animated images
    if [[ -z $(echo "${PICS[$i]}" | grep .gif$) ]]; then
      printf "$(echo "${PICS[$i]}" | cut -d. -f1)\x00icon\x1f${wallDIR}/${PICS[$i]}\n"
    else
      printf "${PICS[$i]}\n"
    fi
  done

  printf "$RANDOM_PIC_NAME\x00icon\x1f/${randWall}\n"
}

swww query || swww init

main() {
  choice=$(menu | ${rofi_command})

  # No choice case
  if [[ -z $choice ]]; then
    exit 0
  fi

  # Random choice case
  if [ "$choice" = "$RANDOM_PIC_NAME" ]; then
    swww img "${wallDIR}/${RANDOM_PIC}" $SWWW_PARAMS
    exit 0
  fi

  # Find the index of the selected file
  pic_index=-1
  for i in "${!PICS[@]}"; do
    filename=$(basename "${PICS[$i]}")
    if [[ "$filename" == "$choice"* ]]; then
      pic_index=$i
      break
    fi
  done

  if [[ $pic_index -ne -1 ]]; then
    swww img "${wallDIR}/${PICS[$pic_index]}" $SWWW_PARAMS
  else
    echo "Image not found."
    exit 1
  fi
}

# Check if rofi is already running
if pidof rofi > /dev/null; then
  pkill rofi
  exit 0
fi

main

sleep 0.5
${SCRIPTSDIR}/PywalSwww.sh
sleep 0.2
${SCRIPTSDIR}/Refresh.sh

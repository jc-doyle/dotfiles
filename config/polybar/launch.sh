#!/bin/zsh
if pgrep -x "polybar"; then pkill -x "polybar"; fi

if type "xrandr"; then
  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
  MONITOR=$m polybar --reload workspace &
  MONITOR=$m polybar --reload wired-network &
  MONITOR=$m polybar --reload memory &
  MONITOR=$m polybar --reload timedate &
  done
else
  polybar --reload example &
fi


# if [[ $HOST = "box" ]]; then
#   polybar -q lyleft &
#   polybar -q lyright &
#   polybar -q trayleft &
#   polybar -q trayright &
#   polybar -q wsleft &
#   polybar -q wsright &
#   polybar -q music &
# elif [[ $HOST = "notebook" ]]; then
#   polybar -q music-laptop &
#   polybar -q wsleft-laptop &
#   polybar -q lyleft-laptop &
#   polybar -q time-laptop &
#   polybar -q date-laptop &
#   polybar -q battery-laptop &
# fi

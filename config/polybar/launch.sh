#!/bin/zsh

if pgrep -x "polybar"; then pkill -x "polybar"; fi

if [[ $HOST = "box" ]]; then
  polybar -q lyleft &
  polybar -q lyright &
  polybar -q trayleft &
  polybar -q trayright &
  polybar -q wsleft &
  polybar -q wsright &
  polybar -q music &
elif [[ $HOST = "notebook" ]]; then
  polybar -q music-laptop &
  polybar -q wsleft-laptop &
  polybar -q lyleft-laptop &
  polybar -q time-laptop &
  polybar -q date-laptop &
  polybar -q battery-laptop &
fi

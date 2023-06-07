#!/bin/zsh

pkill polybar

if [[ $HOST = "box" ]]; then
  polybar -q lyleft &
  polybar -q lyright &
  polybar -q trayleft &
  polybar -q trayright &
  polybar -q wsleft &
  polybar -q wsright &
  polybar -q music &
  polybar -q network &
elif [[ $HOST = "laptop" ]]; then
  polybar -q music-laptop &
  polybar -q wsleft-laptop &
  polybar -q lyleft-laptop &
  polybar -q time-laptop &
  polybar -q date-laptop &
  polybar -q battery-laptop &
fi

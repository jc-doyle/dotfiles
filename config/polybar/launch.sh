#!/bin/zsh

pkill polybar

if [[ $HOST = "box" ]]; then
  polybar -q wsleft	&
  polybar -q lyleft	&
  polybar -q wsright &
  polybar -q lyright &
  polybar -q trayleft &
  polybar -q trayright &
  polybar -q music &
elif [[ $HOST = "laptop" ]]; then
  polybar -q music-laptop &
  polybar -q wsleft-laptop &
  polybar -q lyleft-laptop &
  polybar -q time-laptop &
  polybar -q monitor-laptop &
  polybar -q battery-laptop &
fi

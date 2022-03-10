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
else
  polybar -q music &
  polybar -q wsleft &
  polybar -q traymobile &
fi

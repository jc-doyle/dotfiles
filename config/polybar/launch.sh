#!/bin/zsh

pkill polybar

if [[ $HOST = "box" ]]; then
  polybar -q music &
  polybar -q wsleft	&
  polybar -q lyleft	&
  polybar -q wsright &
  polybar -q lyright &
  polybar -q trayleft &
  polybar -q trayright &
else
  polybar -q music &
  polybar -q wsleft &
  polybar -q traymobile &
fi

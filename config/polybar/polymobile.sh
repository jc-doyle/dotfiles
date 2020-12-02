#!/bin/zsh

killall -q polybar

polybar -q music &
polybar -q wsmobile &
polybar -q traymobile &

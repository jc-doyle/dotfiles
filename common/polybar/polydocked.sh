#!/bin/zsh

killall -q polybar

while pgrep -u $UID -x polybar >/dev/null
do
    sleep 1
done

polybar -q music &
polybar -q wsdockedmain	&
polybar -q wsdockedright &
polybar -q traydockedmain &
polybar -q traydockedright &

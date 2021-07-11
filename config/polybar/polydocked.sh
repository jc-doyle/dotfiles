#!/bin/zsh

killall -q polybar

polybar -q music &
polybar -q wsdockedmain	&
polybar -q wsdockedright &
polybar -q traydockedmain &
polybar -q traydockedright &
polybar -q pomodoro &

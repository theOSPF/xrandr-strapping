#!/bin/bash
mons=($(xrandr | grep -aoP ".+?\s(?=connected)" | tr " " "\n"))
primary=$(xrandr | grep -aoP ".+?\s(?=connected primary)")
last_mon=$primary
#for mon in $mons
#do
#	if [ $mon != $primary ];
#		then
#			xrandr --output $mon --off
#			xrandr --output $mon --mode 1920x1080 --right-of $last_mon
#			last_mon=$mon
#	fi
#done

echo ${mons[1]}

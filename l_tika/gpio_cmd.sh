#!/bin/bash

TARGET_PIN=${1}

on() {
	echo "turn on"
	gpio -g write ${TARGET_PIN} 1
}
off() {
	echo "turn off"
	gpio -g write ${TARGET_PIN} 0
}

gpio -g mode ${TARGET_PIN} out

for i in {0..10}; do
	on
	sleep 0.1
	off
	sleep 0.1
done

gpio -g mode ${TARGET_PIN} in

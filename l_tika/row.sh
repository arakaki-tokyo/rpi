#!/bin/bash

GPIO_DIR=/sys/class/gpio
TARGET_DIRECTION=${GPIO_DIR}/gpio${1}/direction
TARGET_VALUE=${GPIO_DIR}/gpio${1}/value

on() {
	echo "turn on"
	echo 1 >${TARGET_VALUE}
}
off() {
	echo "turn off"
	echo 0 >${TARGET_VALUE}
}

echo ${1} >${GPIO_DIR}/export
echo out >${TARGET_DIRECTION}

for i in {0..10}; do
	on
	sleep 0.1
	off
	sleep 0.1
done

echo ${1} >${GPIO_DIR}/unexport

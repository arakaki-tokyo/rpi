#!/bin/bash

GPIO_DIR=/sys/class/gpio
TARGET_PIN=${1}
TARGET_DIRECTION=${GPIO_DIR}/gpio${TARGET_PIN}/direction
TARGET_VALUE=${GPIO_DIR}/gpio${TARGET_PIN}/value
SW_PIN=${2}
SW_DIRECTION=${GPIO_DIR}/gpio${SW_PIN}/direction
SW_VALUE=${GPIO_DIR}/gpio${SW_PIN}/value

preProc() {
	echo ${TARGET_PIN} >${GPIO_DIR}/export
	echo ${SW_PIN} >${GPIO_DIR}/export
	sleep 0.1
	sudo echo out >${TARGET_DIRECTION}
}
postProc() {
	echo ${TARGET_PIN} >${GPIO_DIR}/unexport
	echo ${SW_PIN} >${GPIO_DIR}/unexport
	exit
}
getSW() {
	return $(cat ${SW_VALUE})
}
tgrSW() {
	sw=$((sw ^ 1))
}
tgrTarget() {
	curTargetValue=$(cat ${TARGET_VALUE})
	echo $((curTargetValue ^ 1)) >${TARGET_VALUE}
}
main() {
	preProc
	trap "postProc" 2

	getSW
	sw=$?

	echo "sw is ${sw}"

	while true; do
		sleep 0.1
		getSW
		curSW=$?
		if [ ${sw} != ${curSW} ]; then
			tgrSW
			echo "sw is ${sw}"
			if [ ${sw} == 0 ]; then
				tgrTarget
			fi
		fi

	done
}

main

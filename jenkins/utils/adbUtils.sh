#!/bin/bash

# get emulator by UUID. Try to close it via adb. Try to kill the process if adb can not connect to it.
function adbCloseEmulator {
	echo "Closing emulator."
	adb -s emulator_$EMULATOR_PORT emu kill || true
	isProcessExists $EMULATOR_UUID && killProcessByString $EMULATOR_UUID
}

# create the AVD
function createAVD {
	android delete avd -n $AVD_NAME || true
	echo no | android -s create  avd -n $AVD_NAME -t "$ANDROID_TARGET" -c $SDCARD -f -b $ANDROID_ABI
}

# start the AVD
# This starts the emulator 
function startEmulator {
	echo "[EMULATOR] Starting emulator with avd $AVD_NAME and console port $EMULATOR_PORT"
	emulator -avd $AVD_NAME -port $EMULATOR_PORT -prop emu.uuid=$EMULATOR_UUID -no-boot-anim -noaudio  &
	EMULATOR_PID=$!
	#-no-window

	# This waits for emulator to start up
	echo  "[emulator-$EMULATOR_PORT] Waiting for emulator to boot completely"
	wait_for_boot_complete "getprop dev.bootcomplete" 1
	wait_for_boot_complete "getprop sys.boot_completed" 1
	wait_for_boot_complete "pm path android" package
}

# function to really, really check things are booted up
function wait_for_boot_complete {
	local boot_property=$1  
	local boot_property_test=$2
	echo "[emulator-$EMULATOR_PORT] Checking $boot_property..."
	local result=`adb -s emulator-$EMULATOR_PORT shell $boot_property 2>/dev/null | grep "$boot_property_test"`

	timeout=300 # 120 second maximum

	while [ -z $result ]; do
		let "timeout -= 1" # decrease timeout
		sleep 1
		echo "waiting for the emulator"
		result=`adb -s emulator-$EMULATOR_PORT shell $boot_property 2>/dev/null | grep "$boot_property_test"`
		if [ "$timeout" -eq 0 ]; then 
			echo "Timeout while waiting for the emulator"
			abortScript
		fi

		if [ "$timeout" -eq 180 ]; then
			res=`adb devices | grep "emulator-$EMULATOR_PORT" | wc -l`
			if [ "$res" -eq 0 ]; then
				echo "Trying to restart adb"
				adb kill-server
				adb devices
			fi
		fi
	done
	echo "[emulator-$EMULATOR_PORT] All boot properties succesful"
}
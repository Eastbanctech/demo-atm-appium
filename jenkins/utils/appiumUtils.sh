#!/bin/bash

function startAppiumServer {

	isProcessExists "node.*appium" && killProcessByString "node.*appium"

	if [ -z "$APPIUM_HOME" ]; then
		echo "APPIUM_HOME variable is not set."
		abortScript
	fi

	if [ ! -x "$APPIUM_HOME/appium" ]; then
		echo "$APPIUM_HOME/appium can not be executed."
		abortScript
	fi	

	$APPIUM_HOME/appium 1>&2 > $SCRIPT_DIR/appium.log &
	APPIUM_PID=$!
	echo Appum server started with PID = $APPIUM_PID.
	timeout=20
	while [ -z "$result" ]; do
		let "timeout -= 1" # decrease timeout
		sleep 1
		result=`cat $SCRIPT_DIR/appium.log | grep 'Appium REST http interface listener started'`
		if [ "$timeout" -eq 0 ]; then 
			echo "Appium can't start. Logs:"
			cat $SCRIPT_DIR/appium.log
			kill -9 $APPIUM_PID 
			abortScript
		fi
	done
	echo Appium loaded
}

function stopAppiumServer {
	echo "Stopping appium"
	kill -9 $APPIUM_PID 	
}
#!/bin/bash


# Copy the APK in and start application
function installApplicationAPK {

	echo "[emulator-$EMULATOR_PORT] Installing application"
	adb -s emulator-$EMULATOR_PORT install $APK_PATH
}


# Activating Application
function activateApplication {
	echo "[emulator-$EMULATOR_PORT] Getting out of home screen"
	adb -s emulator-$EMULATOR_PORT shell input keyevent 82
	adb -s emulator-$EMULATOR_PORT shell input keyevent 4

	echo "[emulator-$EMULATOR_PORT] Activating the app"
	adb -s emulator-$EMULATOR_PORT shell am start -a android.intent.action.MAIN -n $APK_PACKAGE/$APK_ACTiVITY
}
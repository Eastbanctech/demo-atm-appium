#!/bin/bash

function abortScript {
  echo "aborting all operations"
  if [ $APPIUM_PID ]; then
  	echo "Killing appium server"
  	kill -9 $APPIUM_PID
  fi
  if [ $EMULATOR_PID ]; then
  	echo "Killing emulator"
  	kill -9 $EMULATOR_PID
  fi  
  exit 1
}

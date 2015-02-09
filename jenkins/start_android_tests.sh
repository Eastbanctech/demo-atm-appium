#!/bin/bash
set -x

#define script directory
SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

#process arguments and environment variables
source $SCRIPT_DIR/init.sh
source $SCRIPT_DIR/android_config.ini

#include all the helper functions from the ./utils directory
for f in $SCRIPT_DIR/utils/*Utils.sh; do source $f; done

#if emulator running - kill it
isProcessExists $EMULATOR_UUID && killProcessByString $EMULATOR_UUID

startAppiumServer
createAVD
startEmulator
installApplicationAPK
activateApplication

runCucumberTests

adbCloseEmulator
stopAppiumServer

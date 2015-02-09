#!/bin/bash
set -x

#define script directory
SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

#process arguments and environment variables
source $SCRIPT_DIR/utils/init.sh
source $SCRIPT_DIR/ios_config.ini

#include all the helper functions from the ./utils directory
for f in $SCRIPT_DIR/utils/*Utils.sh; do source $f; done

startAppiumServer

runCucumberTests

stopAppiumServer

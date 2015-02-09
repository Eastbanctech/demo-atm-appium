#!/bin/bash

function runCucumberTests {

	cd "$SCRIPT_DIR/.."
	cucumber --version >/dev/null 2>&1 || { echo >&2 "Cucumber is required.  Aborting."; abortScript; }
	cucumber -p "$CUCUMBER_PROFILE"

}
#!/bin/bash

# Set current directory to the directory this script is in
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

../utils/submit_upgrade_proposal.sh "OpenFPL_backend" "1.6.0" "Update OpenFPL Backend Wasm" "https://github.com/jamesbeadle/OpenFPL" "Update backend logic to allow an assist to match with an own goal event, not just a goal event."

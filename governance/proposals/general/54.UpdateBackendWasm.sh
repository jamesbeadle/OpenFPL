#!/bin/bash

# Set current directory to the directory this script is in
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

../utils/submit_upgrade_proposal.sh "OpenFPL_backend" "0.8.0" "Update OpenFPL Backend Wasm" "https://github.com/jamesbeadle/OpenFPL/blob/master/src/OpenFPL_backend/main.mo" "Remove the beginOpenFPL() function. Reset data cache hash values and reset total manager count in manager composite."

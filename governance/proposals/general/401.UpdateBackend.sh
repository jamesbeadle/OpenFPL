#!/bin/bash

# Set current directory to the directory this script is in
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

../utils/submit_upgrade_proposal.sh "OpenFPL_backend" "1.3.9" "Update OpenFPL Backend Wasm" "https://github.com/jamesbeadle/OpenFPL" "Add check to clean teams for invalid teams to ensure value is under 300m, else clear team."

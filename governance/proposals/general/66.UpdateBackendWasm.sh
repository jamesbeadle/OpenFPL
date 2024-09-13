#!/bin/bash

# Set current directory to the directory this script is in
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

../utils/submit_upgrade_proposal.sh "OpenFPL_backend" "0.9.8" "Update OpenFPL Backend Wasm" "https://github.com/jamesbeadle/OpenFPL/blob/master/src/OpenFPL_backend/main.mo" "Update check for bonuses played in current week."

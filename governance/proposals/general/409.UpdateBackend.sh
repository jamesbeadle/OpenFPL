#!/bin/bash

# Set current directory to the directory this script is in
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

../utils/submit_upgrade_proposal.sh "OpenFPL_backend" "1.4.5" "Update OpenFPL Backend Wasm" "https://github.com/jamesbeadle/OpenFPL" "Update inter canister function definition for calculate gameweek call on manager canister as players no longer passed to function."

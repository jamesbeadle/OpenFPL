#!/bin/bash

# Set current directory to the directory this script is in
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

../utils/submit_upgrade_proposal.sh "OpenFPL_backend" "1.5.7" "Update OpenFPL Backend Wasm" "https://github.com/jamesbeadle/OpenFPL" "Fix manager canister searching for backend principal id instead of dto id."

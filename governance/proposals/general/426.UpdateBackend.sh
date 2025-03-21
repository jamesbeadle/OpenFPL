#!/bin/bash

# Set current directory to the directory this script is in
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

../utils/submit_upgrade_proposal.sh "OpenFPL_backend" "1.5.4" "Update OpenFPL Backend Wasm" "https://github.com/jamesbeadle/OpenFPL" "Add log statements to manager canister to ensure ordered snapshots are accurate."

#!/bin/bash

# Set current directory to the directory this script is in
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

../utils/submit_upgrade_proposal.sh "OpenFPL_backend" "1.3.6" "Update OpenFPL Backend Wasm" "https://github.com/jamesbeadle/OpenFPL" "Snapshot fantasy teams for gameweek 1 without updating the manager canister wasm."

#!/bin/bash

# Set current directory to the directory this script is in
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

../utils/submit_upgrade_proposal.sh "OpenFPL_backend" "1.3.3" "Update OpenFPL Backend Wasm" "https://github.com/jamesbeadle/OpenFPL" "Due to an error people were able to select players from relegated teams. This bug has been fixed but the manager canister requires a complete list of players to continue. This proposals adds this function solely for the manager canister to use."

#!/bin/bash

# Set current directory to the directory this script is in
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

../utils/submit_upgrade_proposal.sh "OpenFPL_backend" "1.5.1" "Update OpenFPL Backend Wasm" "https://github.com/jamesbeadle/OpenFPL" "Remove fixture data from players and fixtures in preparation for rerunning the fixture data submission passing in the candid file type."

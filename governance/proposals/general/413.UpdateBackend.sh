#!/bin/bash

# Set current directory to the directory this script is in
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

../utils/submit_upgrade_proposal.sh "OpenFPL_backend" "1.4.8" "Update OpenFPL Backend Wasm" "https://github.com/jamesbeadle/OpenFPL" "Add logging for fixture data proposal submisison and refactor manager snapshot functionality."

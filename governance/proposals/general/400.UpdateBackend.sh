#!/bin/bash

# Set current directory to the directory this script is in
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

../utils/submit_upgrade_proposal.sh "OpenFPL_backend" "1.3.8" "Update OpenFPL Backend Wasm" "https://github.com/jamesbeadle/OpenFPL" "Run clean teams function and snapshot to remove any players that were incorrectly included in the autofill but from relegated teams."

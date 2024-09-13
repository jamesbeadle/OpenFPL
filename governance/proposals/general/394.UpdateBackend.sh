#!/bin/bash

# Set current directory to the directory this script is in
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

../utils/submit_upgrade_proposal.sh "OpenFPL_backend" "1.3.2" "Update OpenFPL Backend Wasm" "https://github.com/jamesbeadle/OpenFPL/blob/master/src/OpenFPL_backend/composites/manager-composite.mo" "Trigger snapshotting in manager canister and add logging throughout to identify why different from local."

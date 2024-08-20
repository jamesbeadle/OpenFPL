#!/bin/bash

# Set current directory to the directory this script is in
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

../utils/submit_upgrade_proposal.sh "OpenFPL_backend" "1.3.7" "Update OpenFPL Backend Wasm" "https://github.com/jamesbeadle/OpenFPL" "Add detailed logging to identify why the live snapshotting is different to local snapshotting. We must confirm that the teams are snapshotted for GW1 before we move on."

#!/bin/bash

# Set current directory to the directory this script is in
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

../utils/submit_upgrade_proposal.sh "OpenFPL_backend" "1.5.2" "Update OpenFPL Backend Wasm" "https://github.com/jamesbeadle/OpenFPL" "Reset Man United v Fulham fixture id status to completed status from verified."

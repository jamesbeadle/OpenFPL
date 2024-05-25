#!/bin/bash

# Set current directory to the directory this script is in
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

./submit_upgrade_proposal.sh "OpenFPL_backend" "0.5.0" "Upgrade OpenFPL Backend to version 0.5.0" "https://github.com/jamesbeadle/OpenFPL/tree/master/src/OpenFPL_backend" "Add test debugs." 

#!/bin/bash

# Set current directory to the directory this script is in
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

../utils/submit_upgrade_proposal.sh "OpenFPL_frontend" "0.1.0" "Upgrade OpenFPL Frontend to version 0.1.0" "https://github.com/jamesbeadle/OpenFPL/tree/master/src/OpenFPL_frontend" "Add how to play to homepage and update environment variables." 

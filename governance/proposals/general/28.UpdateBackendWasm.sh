#!/bin/bash

# Set current directory to the directory this script is in
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

../utils/submit_upgrade_proposal.sh "OpenFPL_backend" "0.1.0" "Upgrade OpenFPL Backend to version 0.1.0" "https://github.com/jamesbeadle/OpenFPL/tree/master/src/OpenFPL_backend" "Set SNS Canister environment variables & add neuron controller generic function endpoints." 

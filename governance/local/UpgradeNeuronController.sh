#!/bin/bash

# Set current directory to the directory this script is in
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

./submit_upgrade_proposal.sh "neuron_controller" "1.1.0" "Upgrade Neuron Controller to v1.1.0" "https://github.com/jamesbeadle/OpenFPL/tree/master/src/neuron_controller" "Update neuron controller access control to check for OpenFPL_backend principal." 

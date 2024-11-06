#!/bin/bash

# Set current directory to the directory this script is in
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR
../../utils/submit_upgrade_proposal.sh "OpenFPL_backend" "2.5.1" "Update OpenFPL Backend Wasm" "https://github.com/jamesbeadle/OpenFPL" "Transfer 10,000 FPL to new OpenFPL backend canister for GW 9 prize distribution."


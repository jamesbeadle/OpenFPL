#!/bin/bash

# Set current directory to the directory this script is in
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR
../../utils/submit_upgrade_proposal.sh "OpenFPL_backend" "2.5.5" "Update OpenFPL Backend Wasm" "https://github.com/jamesbeadle/OpenFPL" "Transfer complete FPL to new OpenFPL backend canister for season prize distribution."


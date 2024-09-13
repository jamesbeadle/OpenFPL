#!/bin/bash

# Set current directory to the directory this script is in
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

../utils/submit_upgrade_proposal.sh "OpenFPL_backend" "1.1.8" "Update OpenFPL Backend Wasm" "https://nns.ic0.app/proposal/?u=gyito-zyaaa-aaaaq-aacpq-cai&proposal=381" "Handle inactive season in bonus validity check."

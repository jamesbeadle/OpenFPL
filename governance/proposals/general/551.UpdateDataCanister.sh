#!/bin/bash

# Set current directory to the directory this script is in
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR
../../utils/submit_upgrade_proposal.sh "data_canister" "0.0.1" "Update Football Data Canister Wasm" "https://github.com/jamesbeadle/football_god/blob/master/src/data_canister/main.mo" "Remove season and gameweek requirements from revaluation DTOs."


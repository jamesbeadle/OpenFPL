#!/bin/bash

# Set current directory to the directory this script is in
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

../deregister_canister_with_sns.sh bgpwv-eqaaa-aaaal-qb6eq-cai "Deregister OpenFPL_frontend as an SNS controlled canister." "https://github.com/jamesbeadle/OpenFPL/blob/master/src/OpenFPL_frontend" "Removal of the frontend canister."
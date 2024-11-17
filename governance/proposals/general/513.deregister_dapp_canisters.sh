#!/bin/bash

# Set current directory to the directory this script is in
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

../deregister_canister_with_sns.sh bboqb-jiaaa-aaaal-qb6ea-cai "Deregister OpenFPL_backend as an SNS controlled canister." "https://github.com/jamesbeadle/OpenFPL/blob/master/src/OpenFPL_backend/main.mo" "Removal of the backend canister."
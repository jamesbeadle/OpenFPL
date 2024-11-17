#!/bin/bash

# Set current directory to the directory this script is in
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

../deregister_canister_with_sns.sh hqfmc-cqaaa-aaaal-qitcq-cai "Deregister neuron_controller as an SNS controlled canister." "https://github.com/jamesbeadle/OpenFPL/blob/master/src/neuron_controller/actor.mo" "Removal of the neuron controller canister."
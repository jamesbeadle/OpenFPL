#!/bin/bash

# Set current directory to the directory this script is in
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

CANISTER=$1
TITLE=$2
URL=$3
SUMMARY=$4

echo "Deregister $CANISTER with SNS"

CANISTER_ID=$(dfx -qq canister --network $NETWORK id $CANISTER)

PROPOSAL="(record { title=\"$TITLE\"; url=\"$URL\"; summary=\"$SUMMARY\"; action=opt variant {DeregisterDappCanisters = record {canister_ids=vec {principal \"$CANISTER\"}; new_controllers=vec {principal \"4jijx-ekel7-4t2kx-32cyf-wzo3t-i4tas-qsq4k-ujnug-oxke7-o5aci-eae\"} }}})"

../utils/submit_proposal.sh "$PROPOSAL"
#!/bin/bash

# cd into folder containing this script
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

# Extract the args
FUNCTION_ID=$1
TITLE=$2
SUMMARY=$3
URL=$4
EVIDENCE_STRING=$5
BATCH_ID=$6
METHOD=$7



# Build the proposal candid
PAYLOAD=$(didc encode "(record{ batch_id = $BATCH_ID : nat; evidence = blob \"$(echo $EVIDENCE_STRING | sed 's/../\\&/g')\"; })")

echo $PAYLOAD
didc decode $PAYLOAD

PROPOSAL="(record { title=\"$TITLE\"; url=\"$URL\"; summary=\"$SUMMARY\"; action=opt variant 
    {ExecuteGenericNervousSystemFunction = record {function_id=($FUNCTION_ID:nat64); payload = blob \"$(echo $PAYLOAD | sed 's/../\\&/g')\"}}})"

echo "------"
echo $PROPOSAL

ENCODED_PROPOSAL="$(didc encode "$PROPOSAL")"

echo "------"
echo $ENCODED_PROPOSAL

didc decode "$ENCODED_PROPOSAL"
# Make the proposal


# Make the proposal
./submit_proposal.sh "$PROPOSAL"
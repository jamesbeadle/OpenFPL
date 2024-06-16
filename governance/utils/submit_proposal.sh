#!/bin/bash

# Set current directory to the directory this script is in
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

# Extract the proposal
PROPOSAL=$1
echo $PROPOSAL

dfx identity use ic_admin
OWNER_IDENTITY=$(dfx identity whoami)
PEM_FILE="$(readlink -f "$HOME/.config/dfx/identity/${OWNER_IDENTITY}/identity.pem")"
PROPOSER_NEURON_ID=015af64e3b155e7cbc45470a6c45e823e689b35fc2170facc7b967d4674236eb

# Make the proposal using quill
quill sns --canister-ids-file ./sns_canister_ids.json --pem-file $PEM_FILE make-proposal --proposal "$PROPOSAL" $PROPOSER_NEURON_ID > msg.json
quill send msg.json
rm -f msg.json
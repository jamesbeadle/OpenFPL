#!/bin/bash

# Set current directory to the directory this script is in
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

# Extract the proposal
PROPOSAL=$1
#echo $PROPOSAL



export PROPOSER_NEURON_ID=07cc5979857a5c037e2b980817bbd4dafea28675c0b57cf6f19c07795662e954
export NETWORK=local
export IDENTITY=default
export IC_URL=http://localhost:8080

OWNER_IDENTITY=$(dfx identity whoami)
export PEM_FILE="$(readlink -f "$HOME/.config/dfx/identity/${OWNER_IDENTITY}/identity.pem")"


# Make the proposal using quill

#echo $PROPOSAL


quill sns --canister-ids-file ./sns_canister_ids.json --pem-file $PEM_FILE make-proposal --proposal "$PROPOSAL" $PROPOSER_NEURON_ID > msg.json
quill send --insecure-local-dev-mode --yes msg.json
rm -f msg.json
#!/bin/bash

# Set current directory to the directory this script is in
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

# Extract the args
CANISTER_NAME=$1
VERSION=$2
TITLE=$3
URL=$4
SUMMARY=$5

# Get the target canister id
TARGET_CANISTER_ID=$(dfx -qq canister --network $NETWORK id $CANISTER_NAME)

# Build the WASM path
WASM_FILE=$CANISTER_NAME.wasm.gz
WASM_PATH=$WASM_FOLDER/$WASM_FILE

# Parse the version string
IFS='.' read -ra VERSION_PARTS <<< "$VERSION"
MAJOR=${VERSION_PARTS[0]}
MINOR=${VERSION_PARTS[1]}
BUILD=${VERSION_PARTS[2]}


export PROPOSER_NEURON_ID=9e0d0508dddf109a6cdb6f8d52246c43ebb558b3ae5b83f4ac207196d1773165
export NETWORK=local
export IDENTITY=default
export IC_URL=http://localhost:8080

export WASM_FOLDER="../wasms"

OWNER_IDENTITY=$(dfx identity whoami)
export PEM_FILE="$(readlink -f "$HOME/.config/dfx/identity/${OWNER_IDENTITY}/identity.pem")"

# Build the canister-upgrade-arg
UPGRADE_ARG="(record { wasm_version = record { major=$MAJOR:nat32; minor=$MINOR:nat32; patch=$BUILD:nat32 } })"
echo $WASM_PATH



# Make the proposal using quill
quill sns --canister-ids-file ./sns_canister_ids.json --pem-file $PEM_FILE make-upgrade-canister-proposal --canister-upgrade-arg "$UPGRADE_ARG" --title "$TITLE" --url "$URL" --summary "$SUMMARY" --target-canister-id $TARGET_CANISTER_ID --wasm-path $WASM_PATH $PROPOSER_NEURON_ID > msg.json
quill send --insecure-local-dev-mode msg.json
rm -f msg.json
echo $PROPOSER_NEURON_ID
#!/bin/bash
echo "here2"

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

NETWORK="ic"

# Get the target canister id
TARGET_CANISTER_ID=$(dfx -qq canister --network $NETWORK id $CANISTER_NAME)

WASM_FOLDER="../wasms"
echo "here3"
echo $WASM_FOLDER

# Build the WASM path
WASM_FILE=$CANISTER_NAME.wasm.gz
WASM_PATH=$WASM_FOLDER/$WASM_FILE

# Parse the version string
IFS='.' read -ra VERSION_PARTS <<< "$VERSION"
MAJOR=${VERSION_PARTS[0]}
MINOR=${VERSION_PARTS[1]}
BUILD=${VERSION_PARTS[2]}

# Build the canister-upgrade-arg
UPGRADE_ARG="(record { wasm_version = record { major=$MAJOR:nat32; minor=$MINOR:nat32; patch=$BUILD:nat32 } })"

dfx identity use ic_admin
OWNER_IDENTITY=$(dfx identity whoami)
PEM_FILE="$(readlink -f "$HOME/.config/dfx/identity/${OWNER_IDENTITY}/identity.pem")"
PROPOSER_NEURON_ID=d2ccf59abe1741c21c35da7e3863d5d14c97d9b82b36045f4a8d4c336864f6dc

# Make the proposal using quill
quill sns --canister-ids-file ./sns_canister_ids.json --pem-file $PEM_FILE make-upgrade-canister-proposal --canister-upgrade-arg "$UPGRADE_ARG" --title "$TITLE" --url "$URL" --summary "$SUMMARY" --target-canister-id $TARGET_CANISTER_ID --wasm-path $WASM_PATH $PROPOSER_NEURON_ID > msg.json
quill send msg.json
rm -f msg.json
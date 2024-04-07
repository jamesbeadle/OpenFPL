#!/bin/bash

SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

WASM_SRC=$1 # WASM_SRC is either empty, "latest", "local", "prod" the commit Id or the release version

if [[ -z $WASM_SRC ]] || [[ $WASM_SRC = "latest" ]]
then
  WASM_SRC=$(curl -s https://openfpl-canister-wasms.s3.amazonaws.com/latest)
fi

echo "Downloading wasms"

./download-canister-wasm.sh OpenFPL_backend $WASM_SRC || exit 1
./download-canister-wasm.sh internet_identity $WASM_SRC || exit 1
./download-canister-wasm.sh neuron_controller $WASM_SRC || exit 1

echo "Wasms downloaded"
#!/bin/bash

SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR/..

./scripts/generate-wasm.sh OpenFPL_backend
./scripts/generate-wasm.sh internet_identity
./scripts/generate-wasm.sh neuron_controller
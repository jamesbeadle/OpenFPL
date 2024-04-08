#!/bin/bash

# Pass in network name, IC url, identity name, Governance canisterId, Ledger canisterId, CMC canisterId, and test mode (true/false)
# eg './deploy.sh ic https://ic0.app/ openfpl rrkah-fqaaa-aaaaa-aaaaq-cai ryjl3-tyaaa-aaaaa-aaaba-cai rkp4c-7iaaa-aaaaa-aaaca-cai false'

NETWORK=$1
IC_URL=$2
IDENTITY=$3
WASM_SRC=$4 # WASM_SRC is either empty, "build", "latest", "local", "prod" the commit Id or the release version
NNS_ROOT_CANISTER_ID=$5
NNS_GOVERNANCE_CANISTER_ID=$6
NNS_INTERNET_IDENTITY_CANISTER_ID=$7
NNS_LEDGER_CANISTER_ID=$8
NNS_CMC_CANISTER_ID=$9
NNS_SNS_WASM_CANISTER_ID=${10}
NNS_INDEX_CANISTER_ID=${11}
TEST_MODE=${12}

SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR/..

dfx deploy --network local --identity $IDENTITY 

IDENTITY_CANISTER_ID=$(dfx canister --network $NETWORK id internet_identity)
NEURON_CONTROLLER_CANISTER_ID=$(dfx canister --network $NETWORK id neuron_controller)
OPENFPL_BACKEND_CANISTER_ID=$(dfx canister --network $NETWORK id OpenFPL_backend)



#!/bin/bash

# Deploys everything needed to test OpenFPL locally (OpenFPL and the NNS canisters)

IDENTITY=${1:-default}
WASM_SRC=${2:-latest} # WASM_SRC is either empty, "build", "latest", "local", "prod" the commit Id or the release version

SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR/..

# Create and install the NNS canisters
echo "installing extesion"
dfx extension install nns # --version 0.4.0 #>& /dev/null
echo "done"
dfx --identity $IDENTITY nns install

NNS_ROOT_CANISTER_ID=r7inp-6aaaa-aaaaa-aaabq-cai
NNS_GOVERNANCE_CANISTER_ID=rrkah-fqaaa-aaaaa-aaaaq-cai
NNS_INTERNET_IDENTITY_CANISTER_ID=qhbym-qaaaa-aaaaa-aaafq-cai
NNS_LEDGER_CANISTER_ID=ryjl3-tyaaa-aaaaa-aaaba-cai
NNS_CMC_CANISTER_ID=rkp4c-7iaaa-aaaaa-aaaca-cai
NNS_SNS_WASM_CANISTER_ID=qaa6y-5yaaa-aaaaa-aaafa-cai
NNS_INDEX_CANISTER_ID=qhbym-qaaaa-aaaaa-aaafq-cai

# Create the OpenFPL canisters
dfx --identity $IDENTITY canister create --no-wallet --with-cycles 100000000000000 OpenFPL_backend
dfx --identity $IDENTITY canister create --no-wallet --with-cycles 100000000000000 internet_identity

# Install the OpenFPL canisters
./scripts/deploy.sh local \
    http://127.0.0.1:8080/ \
    $IDENTITY \
    $WASM_SRC \
    $NNS_ROOT_CANISTER_ID \
    $NNS_GOVERNANCE_CANISTER_ID \
    $NNS_INTERNET_IDENTITY_CANISTER_ID \
    $NNS_LEDGER_CANISTER_ID \
    $NNS_CMC_CANISTER_ID \
    $NNS_SNS_WASM_CANISTER_ID \
    $NNS_INDEX_CANISTER_ID \
    true \

./scripts/deploy-test-ledger.sh $IDENTITY
./scripts/mint-test-tokens.sh "dccg7-xmaaa-aaaaa-qaamq-cai" $IDENTITY
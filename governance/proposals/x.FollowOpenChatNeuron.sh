
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR/..

TITLE="Set NNS neuron 2511989001097450386 to follow the OpenChat neuron ?????????."
SUMMARY="This will instruct the NeuronController canister to call 'manage_neuron' on the NNS governance canister, setting the follower of the OpenFPL neuron 2511989001097450386 to follow the OpenChat neuron ???????."
URL="https://dashboard.internetcomputer.org/neuron/2511989001097450386"
ARGS="(record { neuron_id = 2511989001097450386:nat64; command = variant { Follow = record { operation = opt variant { topic: ?; followees: [????]} } } })"
FUNCTION_ID=20000

# Submit the proposal

./utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
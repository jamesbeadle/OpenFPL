
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR/..

TITLE="Follow Dfinity's neuron ID 27."
SUMMARY="This will instruct the NeuronController canister to call 'manage_neuron' on the NNS governance canister, set the follower for neuron 2511989001097450386 to Dfinity neuron ID 27 (https://dashboard.internetcomputer.org/neuron/27)."
URL="https://dashboard.internetcomputer.org/neuron/2511989001097450386"
ARGS="(variant { Follow = record { topic = 0:int32; followees = vec { record { id = 27:nat64 } }}})"
FUNCTION_ID=20000

# Submit the proposal

./utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
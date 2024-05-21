
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR/..

TITLE="Increase the dissolve delay of NNS neuron 2511989001097450386 to 8 years."
SUMMARY="This will instruct the NeuronController canister to call 'manage_neuron' on the NNS governance canister, increasing the dissolve delay of neuron 2511989001097450386 to 8 years."
URL="https://dashboard.internetcomputer.org/neuron/2511989001097450386"
ARGS="(variant { Configure = record { operation = opt variant { IncreaseDissolveDelay = record { additional_dissolve_delay_seconds = 252_288_000 }}}})"
FUNCTION_ID=20000

# Submit the proposal

./utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
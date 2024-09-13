
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR/..

TITLE="Add Hotkey to Neuron."
SUMMARY="This will instruct the NeuronController canister to call 'manage_neuron' on the NNS governance canister, adding a hotkey for to the neuron to allow OpenFPL founder James Beadle to see information on it."
URL="https://dashboard.internetcomputer.org/neuron/2511989001097450386"

ARGS="(Configure { operation: variant{  }  } )"
FUNCTION_ID=20000

# Submit the proposal

./utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
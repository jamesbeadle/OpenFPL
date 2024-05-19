
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR/..

TITLE="2nd Attempt to Create DAO Controlled Neuron with 1 ICP"
SUMMARY="This proposal will attempt to create a DAO controlled neuron through calling the registered generic function CreateDAONeuron. 
This proposal is the same as the failed proposal 36, with the environment variables updated on the neuron controller."
URL="https://github.com/jamesbeadle/OpenFPL/tree/master/src/neuron_controller"
ARGS="()"
FUNCTION_ID=19000

# Submit the proposal

./utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
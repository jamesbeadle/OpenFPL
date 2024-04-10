
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR/..

TITLE="Create DAO Controlled Neuron with 1 ICP"
SUMMARY="This proposal will create a DAO controlled neuron through calling the registered generic function CreateDAONeuron"
URL="https://github.com/jamesbeadle/OpenFPL/tree/master/src/neuron_controller"
ARGS="(null)"
FUNCTION_ID=19000

# Submit the proposal

./utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
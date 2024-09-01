
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Test Player Proposal."
SUMMARY="This is a test player proposal."
URL="https://openfpl.xyz"

ARGS="( record { playerId=373:nat16; newClubId=1:nat16 } )"
FUNCTION_ID=8000

# Submit the proposal

./make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS" validateTransferPlayer
echo $PROPOSER_NEURON_ID

#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Transfer Emile Smith Rowe from Arsenal to Fulham."
SUMMARY="Transfer Emile Smith Rowe from Arsenal to Fulham."
URL="https://openfpl.xyz"

ARGS="( record { playerId=15:nat16; newClubId=10:nat16 } )"
FUNCTION_ID=8000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
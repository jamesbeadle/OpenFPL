
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Transfer Ryan Sessegnon to Fulham."
SUMMARY="Transfer Ryan Sessegnon to Fulham."
URL="https://openfpl.xyz"

ARGS="( record { playerId=503:nat16; newClubId=10:nat16 } )"
FUNCTION_ID=8000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
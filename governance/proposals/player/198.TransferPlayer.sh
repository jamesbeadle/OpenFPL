
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Transfer Arnaut Danjuma from Everton to Villarreal."
SUMMARY="Transfer Arnaut Danjuma from Everton to Villarreal."
URL="https://openfpl.xyz"

ARGS="( record { playerId=262:nat16; newClubId=0:nat16 } )"
FUNCTION_ID=8000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
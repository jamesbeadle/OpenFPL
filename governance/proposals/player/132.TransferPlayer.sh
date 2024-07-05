
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Transfer Ross Barkley from Luton to Aston Villa."
SUMMARY="Transfer Ross Barkley from Luton to Aston Villa."
URL="https://openfpl.xyz"

ARGS="( record { playerId=332:nat16; newClubId=2:nat16 } )"
FUNCTION_ID=8000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
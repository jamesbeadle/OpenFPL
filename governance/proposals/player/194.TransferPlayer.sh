
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Transfer Mason Holgate from Sheffield United to Everton."
SUMMARY="Transfer Mason Holgate from Sheffield United to Everton."
URL="https://openfpl.xyz"

ARGS="( record { playerId=470:nat16; newClubId=9:nat16 } )"
FUNCTION_ID=8000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
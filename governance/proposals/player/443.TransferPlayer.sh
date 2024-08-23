
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Transfer Cameron Archer from Aston Villa to Southampton."
SUMMARY="Transfer Cameron Archer from Aston Villa to Southampton."
URL="https://openfpl.xyz"

ARGS="( record { playerId=482:nat16; newClubId=23:nat16 } )"
FUNCTION_ID=8000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS" validateTransferPlayer
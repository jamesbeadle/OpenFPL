
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Transfer Neal Maupay from Brentford to Everton."
SUMMARY="Transfer Neal Maupay from Brentford to Everton."
URL="https://openfpl.xyz"

ARGS="( record { playerId=115:nat16; newClubId=9:nat16 } )"
FUNCTION_ID=8000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"

#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Transfer Ben Johnson from West Ham to Ipswich Town."
SUMMARY="Transfer Ben Johnson from West Ham to Ipswich Town."
URL="https://openfpl.xyz"

ARGS="( record { playerId=515:nat16; newClubId=22:nat16 } )"
FUNCTION_ID=8000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
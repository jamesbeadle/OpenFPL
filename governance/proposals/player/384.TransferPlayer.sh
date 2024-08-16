
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Transfer Dominic Solanke from Bournemouth United to Tottenham."
SUMMARY="Transfer Dominic Solanke from Bournemouth United to Tottenham."
URL="https://openfpl.xyz"

ARGS="( record { playerId=82:nat16; newClubId=18:nat16 } )"
FUNCTION_ID=8000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"

#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Transfer William Osula from Sheffield United to Newcastle."
SUMMARY="Transfer William Osula from Sheffield United to Newcastle."
URL="https://openfpl.xyz"

ARGS="( record { playerId=483:nat16; newClubId=15:nat16 } )"
FUNCTION_ID=8000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
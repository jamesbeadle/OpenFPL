
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Fix Carl Rushworth Transfer."
SUMMARY="Fix Carl Rushworth Transfer."
URL="https://openfpl.xyz"

ARGS="( record { playerId=676:nat16; newClubId=5:nat16 } )"
FUNCTION_ID=8000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
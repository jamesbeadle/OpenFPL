
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR/..

TITLE="Test Player Proposal."
SUMMARY="This is a test player proposal."
URL="https://openfpl.xyz"

ARGS="({ playerId=373:nat64 } )"
FUNCTION_ID=8000

# Submit the proposal

./utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
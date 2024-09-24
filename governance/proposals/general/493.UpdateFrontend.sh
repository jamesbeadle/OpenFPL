
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Update Frontend Canister."
SUMMARY="Update frontend V1.7.8 canister with evidence batch id 210."
URL="https://openfpl.xyz"

EVIDENCE_STRING=358bb9e06e5dc90b390cab42e4f6efbcc5f31cfb0d2e4fc5b3e2aef47f4cbd63
BATCH_ID=210
FUNCTION_ID=24000

# Submit the proposal

../../utils/make_custom_function_proposal_frontend.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$EVIDENCE_STRING" "$BATCH_ID" "commit_proposed_batch"
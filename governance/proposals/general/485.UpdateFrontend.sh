
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Update Frontend Canister."
SUMMARY="Update frontend V1.7.2 canister with evidence batch id 205."
URL="https://openfpl.xyz"

EVIDENCE_STRING=e3ed7cabdf62a6ed4dd10d6bceae7f73d10ea657537e4fcfae6791cab88a5463
BATCH_ID=206
FUNCTION_ID=24000

# Submit the proposal

../../utils/make_custom_function_proposal_frontend.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$EVIDENCE_STRING" "$BATCH_ID" "commit_proposed_batch"
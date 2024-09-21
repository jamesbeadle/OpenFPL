
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Update Frontend Canister."
SUMMARY="Update frontend V1.7.4 canister with evidence batch id 207."
URL="https://openfpl.xyz"

EVIDENCE_STRING=0d45e9cd14a44589d8e4cfe9e27828d1ac16c4080fa08ae6a3568e3b553895b8
BATCH_ID=207
FUNCTION_ID=24000

# Submit the proposal

../../utils/make_custom_function_proposal_frontend.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$EVIDENCE_STRING" "$BATCH_ID" "commit_proposed_batch"
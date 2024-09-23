
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Update Frontend Canister."
SUMMARY="Update frontend V1.7.6 canister with evidence batch id 208."
URL="https://openfpl.xyz"

EVIDENCE_STRING=b6945a70ea7811c61964e702182ee838c57452a4061aa49556026678f72ac7a9
BATCH_ID=208
FUNCTION_ID=24000

# Submit the proposal

../../utils/make_custom_function_proposal_frontend.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$EVIDENCE_STRING" "$BATCH_ID" "commit_proposed_batch"
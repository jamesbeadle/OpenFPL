
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Update Frontend Canister."
SUMMARY="Update frontend V1.7.2 canister with evidence batch id 205."
URL="https://openfpl.xyz"

EVIDENCE_STRING=9c3955d25c6fb1d28bff2f1f5df9d5b50f60d97e892caad03933e2622af4a797
BATCH_ID=205
FUNCTION_ID=24000

# Submit the proposal

../../utils/make_custom_function_proposal_frontend.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$EVIDENCE_STRING" "$BATCH_ID" "commit_proposed_batch"
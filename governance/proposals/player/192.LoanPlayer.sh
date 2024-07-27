
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Loan Luke Plange from Crystal Palace to HJK Helsinki until 1st January 2025."
SUMMARY="Loan Luke Plange from Crystal Palace to HJK Helsinki until 1st January 2025."
URL="https://openfpl.xyz"

ARGS="( record { playerId=240:nat16; loanClubId=0:nat16; loanEndDate=1735689600000000000:int } )"
FUNCTION_ID=9000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
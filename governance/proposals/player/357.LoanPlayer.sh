
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Loan Luke Harris from Fulham to Birmingham City until 30th June 2025."
SUMMARY="Loan Luke Harris from Fulham to Birmingham City until 30th June 2025."
URL="https://openfpl.xyz"

ARGS="( record { playerId=597:nat16; loanClubId=0:nat16; loanEndDate=1751241600000000000:int } )"
FUNCTION_ID=9000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"    
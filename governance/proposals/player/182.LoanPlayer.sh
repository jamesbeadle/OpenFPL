
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Loan Joe Whitworth from Crystal Palace to Exeter City until 1st July 2025."
SUMMARY="Loan Joe Whitworth from Crystal Palace to Exeter City until 1st July 2025."
URL="https://openfpl.xyz"

ARGS="( record { playerId=211:nat16; loanClubId=0:nat16; loanEndDate=1751328000000000000:int } )"
FUNCTION_ID=9000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
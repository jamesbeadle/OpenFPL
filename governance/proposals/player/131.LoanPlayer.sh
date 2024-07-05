
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Loan Ellery Balcombe from Brentford to St Mirren 31st July 2025."
SUMMARY="Loan Ellery Balcombe from Brentford to St Mirren 31st July 2025."
URL="https://openfpl.xyz"

ARGS="( record { playerId=91:nat16; loanClubId=0:nat16; loanEndDate=1753920000000000000:int } )"
FUNCTION_ID=9000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
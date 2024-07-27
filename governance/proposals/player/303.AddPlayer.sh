
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Ross Stewart to Southampton."
SUMMARY="Add Ross Stewart to Southampton (£16m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 23:nat16;
    position = variant { Forward };
    firstName = \"Ross\";
    lastName = \"Stewart\";
    shirtNumber = 11:nat8;
    valueQuarterMillions = 64:nat16;
    dateOfBirth =  837043200000000000:int;
    nationality = 186:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
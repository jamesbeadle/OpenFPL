
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Igor Thiago to Brentford."
SUMMARY="Add Igor Thiago to Brentford (£16m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 4:nat16;
    position = variant { Forward };
    firstName = \"Igor\";
    lastName = \"Thiago\";
    shirtNumber = 9:nat8;
    valueQuarterMillions = 64:nat16;
    dateOfBirth =  980467200000000000:int;
    nationality = 24:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
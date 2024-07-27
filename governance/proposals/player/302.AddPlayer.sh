
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Sékou Mara to Southampton."
SUMMARY="Add Sékou Mara to Southampton (£15m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 23:nat16;
    position = variant { Forward };
    firstName = \"Sékou\";
    lastName = \"Mara\";
    shirtNumber = 18:nat8;
    valueQuarterMillions = 60:nat16;
    dateOfBirth =  1027987200000000000:int;
    nationality = 61:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
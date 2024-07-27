
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Wanya Marçal to Leicester."
SUMMARY="Add Wanya Marçal to Leicester (£11m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 21:nat16;
    position = variant { Forward };
    firstName = \"Wanya\";
    lastName = \"Marçal\";
    shirtNumber = 40:nat8;
    valueQuarterMillions = 44:nat16;
    dateOfBirth =  1034985600000000000:int;
    nationality = 141:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
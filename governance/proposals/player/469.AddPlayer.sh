
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Kasey McAteer to Leicester."
SUMMARY="Add Kasey McAteer to Leicester (£10m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 21:nat16;
    position = variant { Midfielder };
    firstName = \"Kasey\";
    lastName = \"McAteer\";
    shirtNumber = 35:nat8;
    valueQuarterMillions = 40:nat16;
    dateOfBirth =  1006387200000000000:int;
    nationality = 81:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS" validateCreatePlayer
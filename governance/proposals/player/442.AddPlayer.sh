
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Ben Brereton to Southampton."
SUMMARY="Add Ben Brereton to Southampton (£14m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 23:nat16;
    position = variant { Forward };
    firstName = \"Ben\";
    lastName = \"Brereton\";
    shirtNumber = 17:nat8;
    valueQuarterMillions = 56:nat16;
    dateOfBirth =  924393600000000000:int;
    nationality = 35:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS" validateCreatePlayer
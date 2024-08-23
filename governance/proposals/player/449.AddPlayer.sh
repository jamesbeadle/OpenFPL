
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Crysencio Summerville to West Ham."
SUMMARY="Add Crysencio Summerville to West Ham (£16m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 19:nat16;
    position = variant { Forward };
    firstName = \"Crysencio\";
    lastName = \"Summerville\";
    shirtNumber = 7:nat8;
    valueQuarterMillions = 64:nat16;
    dateOfBirth =  1004400000000000000:int;
    nationality = 125:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS" validateCreatePlayer
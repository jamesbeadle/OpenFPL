
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Jack Harrison to Everton."
SUMMARY="Add Jack Harrison to Everton (£20m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 9:nat16;
    position = variant { Forward };
    firstName = \"Jack\";
    lastName = \"Harrison\";
    shirtNumber = 11:nat8;
    valueQuarterMillions = 80:nat16;
    dateOfBirth =  848448000000000000:int;
    nationality = 186:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
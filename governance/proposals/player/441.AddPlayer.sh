
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Tyler Dibling to Southampton."
SUMMARY="Add Tyler Dibling to Southampton (£9m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 23:nat16;
    position = variant { Midfielder };
    firstName = \"Tyler\";
    lastName = \"Dibling\";
    shirtNumber = 33:nat8;
    valueQuarterMillions = 36:nat16;
    dateOfBirth =  1140134400000000000:int;
    nationality = 186:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS" validateCreatePlayer
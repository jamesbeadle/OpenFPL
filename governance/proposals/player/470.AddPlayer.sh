
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Boubakary Soumaré to Leicester."
SUMMARY="Add Boubakary Soumaré to Leicester (£8m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 21:nat16;
    position = variant { Midfielder };
    firstName = \"Boubakary\";
    lastName = \"Soumaré\";
    shirtNumber = 24:nat8;
    valueQuarterMillions = 32:nat16;
    dateOfBirth =  920073600000000000:int;
    nationality = 61:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS" validateCreatePlayer
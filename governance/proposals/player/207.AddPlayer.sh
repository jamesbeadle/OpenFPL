
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Fábio Carvalho to Liverpool."
SUMMARY="Add Fábio Carvalho to Liverpool (£18m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 11:nat16;
    position = variant { Forward };
    firstName = \"Fábio\";
    lastName = \"Carvalho\";
    shirtNumber = 28:nat8;
    valueQuarterMillions = 72:nat16;
    dateOfBirth =  1030665600000000000:int;
    nationality = 141:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
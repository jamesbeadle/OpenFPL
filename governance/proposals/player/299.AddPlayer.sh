
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Samuel Edozie to Southampton."
SUMMARY="Add Samuel Edozie to Southampton (£14m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 23:nat16;
    position = variant { Midfielder };
    firstName = \"Samuel\";
    lastName = \"Edozie\";
    shirtNumber = 23:nat8;
    valueQuarterMillions = 56:nat16;
    dateOfBirth =  1043712000000000000:int;
    nationality = 186:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
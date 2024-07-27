
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Adam Armstrong to Southampton."
SUMMARY="Add Adam Armstrong to Southampton (£20m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 23:nat16;
    position = variant { Forward };
    firstName = \"Adam\";
    lastName = \"Armstrong\";
    shirtNumber = 9:nat8;
    valueQuarterMillions = 80:nat16;
    dateOfBirth =  855532800000000000:int;
    nationality = 186:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
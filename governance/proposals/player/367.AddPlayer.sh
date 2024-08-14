
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Toby Collyer to Manchester United."
SUMMARY="Add Toby Collyer to Manchester United (£7m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 14:nat16;
    position = variant { Midfielder };
    firstName = \"Toby\";
    lastName = \"Collyer\";
    shirtNumber = 43:nat8;
    valueQuarterMillions = 28:nat16;
    dateOfBirth =  1073088000000000000:int;
    nationality = 186:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
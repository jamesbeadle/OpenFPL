
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Jamie Vardy to Leicester."
SUMMARY="Add Jamie Vardy to Leicester (£20m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 21:nat16;
    position = variant { Forward };
    firstName = \"Jamie\";
    lastName = \"Vardy\";
    shirtNumber = 9:nat8;
    valueQuarterMillions = 80:nat16;
    dateOfBirth =  537321600000000000:int;
    nationality = 186:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
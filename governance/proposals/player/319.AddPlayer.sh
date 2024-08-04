
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Alex Paulsen to Bournemouth."
SUMMARY="Add Alex Paulsen to Bournemouth (£5.5m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 3:nat16;
    position = variant { Goalkeeper };
    firstName = \"Alex\";
    lastName = \"Paulsen\";
    shirtNumber = 0:nat8;
    valueQuarterMillions = 22:nat16;
    dateOfBirth =  1025740800000000000:int;
    nationality = 126:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
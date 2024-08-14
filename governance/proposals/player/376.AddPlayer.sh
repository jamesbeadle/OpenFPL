
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Jota Silva to Nottingham Forest."
SUMMARY="Add Jota Silva to Nottingham Forest (£7m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 16:nat16;
    position = variant { Forward };
    firstName = \"Jota\";
    lastName = \"Silva\";
    shirtNumber = 20:nat8;
    valueQuarterMillions = 28:nat16;
    dateOfBirth =  938736000000000000:int;
    nationality = 141:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
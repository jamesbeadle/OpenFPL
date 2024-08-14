
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Eric Da Silva Moreira to Nottingham Forest."
SUMMARY="Add Eric Da Silva Moreira to Nottingham Forest (£6m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 16:nat16;
    position = variant { Forward };
    firstName = \"Eric\";
    lastName = \"Da Silva Moreira\";
    shirtNumber = 17:nat8;
    valueQuarterMillions = 24:nat16;
    dateOfBirth =  1146614400000000000:int;
    nationality = 65:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
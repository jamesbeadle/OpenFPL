
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Daniel Podence to Wolves."
SUMMARY="Add Daniel Podence to Wolves (£15m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 20:nat16;
    position = variant { Forward };
    firstName = \"Daniel\";
    lastName = \"Podence\";
    shirtNumber = 10:nat8;
    valueQuarterMillions = 60:nat16;
    dateOfBirth =  814233600000000000:int;
    nationality = 141:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS" validateCreatePlayer
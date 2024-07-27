
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Samuel Iling-Junior to Aston Villa."
SUMMARY="Add Samuel Iling-Junior to Aston Villa (£15m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 2:nat16;
    position = variant { Midfielder };
    firstName = \"Samuel\";
    lastName = \"Iling-Junior\";
    shirtNumber = 0:nat8;
    valueQuarterMillions = 60:nat16;
    dateOfBirth =  1065225600000000000:int;
    nationality = 186:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
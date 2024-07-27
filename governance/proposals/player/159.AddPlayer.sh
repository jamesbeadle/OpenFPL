
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Daniel Jebbison to Bournemouth."
SUMMARY="Add Daniel Jebbison to Bournemouth (£15m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 3:nat16;
    position = variant { Forward };
    firstName = \"Daniel\";
    lastName = \"Jebbison\";
    shirtNumber = 0:nat8;
    valueQuarterMillions = 60:nat16;
    dateOfBirth =  1057881600000000000:int;
    nationality = 186:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
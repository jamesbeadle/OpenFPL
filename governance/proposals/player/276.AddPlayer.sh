
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Harry Winks to Leicester."
SUMMARY="Add Harry Winks to Leicester (£10m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 21:nat16;
    position = variant { Midfielder };
    firstName = \"Harry\";
    lastName = \"Winks\";
    shirtNumber = 8:nat8;
    valueQuarterMillions = 40:nat16;
    dateOfBirth =  823219200000000000:int;
    nationality = 186:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
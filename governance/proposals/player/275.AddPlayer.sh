
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Caleb Okoli to Leicester."
SUMMARY="Add Caleb Okoli to Leicester (£8.5m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 21:nat16;
    position = variant { Defender };
    firstName = \"Caleb\";
    lastName = \"Okoli\";
    shirtNumber = 0:nat8;
    valueQuarterMillions = 34:nat16;
    dateOfBirth =  994982400000000000:int;
    nationality = 83:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
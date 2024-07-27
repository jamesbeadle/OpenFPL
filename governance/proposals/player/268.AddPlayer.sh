
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Wout Faes to Leicester."
SUMMARY="Add Wout Faes to Leicester (£8.5m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 21:nat16;
    position = variant { Defender };
    firstName = \"Wout\";
    lastName = \"Faes\";
    shirtNumber = 3:nat8;
    valueQuarterMillions = 34:nat16;
    dateOfBirth =  891561600000000000:int;
    nationality = 17:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
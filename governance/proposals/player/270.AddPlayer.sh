
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Victor Kristiansen to Leicester."
SUMMARY="Add Victor Kristiansen to Leicester (£8.5m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 21:nat16;
    position = variant { Defender };
    firstName = \"Victor\";
    lastName = \"Kristiansen\";
    shirtNumber = 16:nat8;
    valueQuarterMillions = 34:nat16;
    dateOfBirth =  1039996800000000000:int;
    nationality = 47:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"

#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Kieran Tierney to Arsenal."
SUMMARY="Add Kieran Tierney to Arsenal (£10m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 1:nat16;
    position = variant { Defender };
    firstName = \"Kieran\";
    lastName = \"Tierney\";
    shirtNumber = 3:nat8;
    valueQuarterMillions = 60:nat16;
    dateOfBirth =  865468800000000000:int;
    nationality = 186:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
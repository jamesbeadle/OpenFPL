
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Yerson Mosquera to Wolves."
SUMMARY="Add Yerson Mosquera to Wolves (£14m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 20:nat16;
    position = variant { Defender };
    firstName = \"Yerson\";
    lastName = \"Mosquera\";
    shirtNumber = 14:nat8;
    valueQuarterMillions = 56:nat16;
    dateOfBirth =  988761600000000000:int;
    nationality = 37:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS" validateCreatePlayer
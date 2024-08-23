
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Jean-Clair Todibo to West Ham."
SUMMARY="Add Jean-Clair Todibo to West Ham (£10m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 19:nat16;
    position = variant { Defender };
    firstName = \"Jean-Clair\";
    lastName = \"Todibo\";
    shirtNumber = 25:nat8;
    valueQuarterMillions = 40:nat16;
    dateOfBirth =  946512000000000000:int;
    nationality = 61:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS" validateCreatePlayer
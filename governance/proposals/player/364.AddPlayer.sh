
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Noussair Mazraoui to Manchester United."
SUMMARY="Add Noussair Mazraoui to Manchester United (£16m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 14:nat16;
    position = variant { Defender };
    firstName = \"Noussair\";
    lastName = \"Mazraoui\";
    shirtNumber = 3:nat8;
    valueQuarterMillions = 64:nat16;
    dateOfBirth =  879465600000000000:int;
    nationality = 119:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
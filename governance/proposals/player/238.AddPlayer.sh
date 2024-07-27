
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Pedro Lima to Wolves."
SUMMARY="Add Pedro Lima to Wolves (£7.5m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 20:nat16;
    position = variant { Defender };
    firstName = \"Pedro\";
    lastName = \"Lima\";
    shirtNumber = 37:nat8;
    valueQuarterMillions = 30:nat16;
    dateOfBirth =  1151712000000000000:int;
    nationality = 24:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
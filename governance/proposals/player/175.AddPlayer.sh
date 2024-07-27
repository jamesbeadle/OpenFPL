
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Amario Cozier-Duberry to Brighton."
SUMMARY="Add Amario Cozier-Duberry to Brighton (£10m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 5:nat16;
    position = variant { Forward };
    firstName = \"Amario\";
    lastName = \"Cozier-Duberry\";
    shirtNumber = 0:nat8;
    valueQuarterMillions = 40:nat16;
    dateOfBirth =  1117324800000000000:int;
    nationality = 186:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
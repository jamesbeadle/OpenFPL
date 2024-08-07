
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Update position for Amario Cozier-Duberry (Brighton) from Forward to Midfielder."
SUMMARY="Update position for Amario Cozier-Duberry (Brighton) from Forward to Midfielder."
URL="https://openfpl.xyz"

ARGS="( record { 
    playerId = 580:nat16;
    position = variant { Midfielder };
    firstName = \"Amario\";
    lastName = \"Cozier-Duberry\";
    shirtNumber = 0:nat8;
    dateOfBirth =  1117324800000000000:int;
    nationality = 186:nat16;
} )"
FUNCTION_ID=12000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
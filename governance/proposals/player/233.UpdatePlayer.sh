
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Update position for Brennan Johnson (Tottenham) from Midfielder to Forward."
SUMMARY="Update position for Brennan Johnson (Tottenham) from Midfielder to Forward."
URL="https://openfpl.xyz"

ARGS="( record { 
    playerId = 505:nat16;
    position = variant { Forward };
    firstName = \"Brennan\";
    lastName = \"Johnson\";
    shirtNumber = 20:nat8;
    dateOfBirth =  990576000000000000:int;
    nationality = 186:nat16;
} )"
FUNCTION_ID=12000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
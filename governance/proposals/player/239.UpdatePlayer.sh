
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Update position for Hwang Hee-chan (Wolves) from Midfielder to Forward."
SUMMARY="Update position for Hwang Hee-chan (Wolves) from Midfielder to Forward."
URL="https://openfpl.xyz"

ARGS="( record { 
    playerId = 554:nat16;
    position = variant { Forward };
    firstName = \"Hee-chan\";
    lastName = \"Hwang\";
    shirtNumber = 11:nat8;
    dateOfBirth =  822614400000000000:int;
    nationality = 91:nat16;
} )"
FUNCTION_ID=12000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
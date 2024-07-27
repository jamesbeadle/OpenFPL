
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Update position for Amad Diallo (Man United) from Midfielder to Forward."
SUMMARY="Update position for Amad Diallo (Man United) from Midfielder to Forward."
URL="https://openfpl.xyz"

ARGS="( record { 
    playerId = 392:nat16;
    position = variant { Forward };
    firstName = \"Amad\";
    lastName = \"Diallo\";
    shirtNumber = 16:nat8;
    dateOfBirth =  1026345600000000000:int;
    nationality = 42:nat16;
} )"
FUNCTION_ID=12000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
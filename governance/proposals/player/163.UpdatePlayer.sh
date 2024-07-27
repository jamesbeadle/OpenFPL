
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Update position for Yoane Wissa (Brentford) from Midfielder to Forward."
SUMMARY="Update position for Yoane Wissa (Brentford) from Midfielder to Forward."
URL="https://openfpl.xyz"

ARGS="( record { 
    playerId = 106:nat16;
    position = variant { Forward };
    firstName = \"Yoane\";
    lastName = \"Wissa\";
    shirtNumber = 11:nat8;
    dateOfBirth =  841708800000000000:int;
    nationality = 76:nat16;
} )"
FUNCTION_ID=12000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
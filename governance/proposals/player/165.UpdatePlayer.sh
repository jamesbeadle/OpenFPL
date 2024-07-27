
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Update position for Yunus Konak (Brentford) from Defender to Forward."
SUMMARY="Update position for Yunus Konak (Brentford) from Defender to Forward."
URL="https://openfpl.xyz"

ARGS="( record { 
    playerId = 572:nat16;
    position = variant { Forward };
    firstName = \"Yunus\";
    lastName = \"Konak\";
    shirtNumber = 0:nat8;
    dateOfBirth =  1136851200000000000:int;
    nationality = 180:nat16;
} )"
FUNCTION_ID=12000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
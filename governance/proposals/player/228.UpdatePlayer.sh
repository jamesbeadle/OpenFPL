
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Update position for Radu Drăgușin (Tottenham) from Midfielder to Defender."
SUMMARY="Update position for Radu Drăgușin (Tottenham) from Midfielder to Defender."
URL="https://openfpl.xyz"

ARGS="( record { 
    playerId = 496:nat16;
    position = variant { Defender };
    firstName = \"Radu\";
    lastName = \"Drăgușin\";
    shirtNumber = 6:nat8;
    dateOfBirth =  1012694400000000000:int;
    nationality = 143:nat16;
} )"
FUNCTION_ID=12000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
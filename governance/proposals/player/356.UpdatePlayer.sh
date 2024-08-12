
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Update position for Ryan Sessegnon (Fulham) from Midfielder to Defender."
SUMMARY="Update position for Ryan Sessegnon (Fulham) from Midfielder to Defender."
URL="https://openfpl.xyz"

ARGS="( record { 
    playerId = 503:nat16;
    position = variant { Defender };
    firstName = \"Ryan\";
    lastName = \"Sessegnon\";
    shirtNumber = 0:nat8;
    dateOfBirth =  958608000000000000:int;
    nationality = 186:nat16;
} )"
FUNCTION_ID=12000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
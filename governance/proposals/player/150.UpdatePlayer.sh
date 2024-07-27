
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Update Lino Sousa surname."
SUMMARY="Update Lino Sousa surname."
URL="https://openfpl.xyz"

ARGS="( record { 
    playerId = 564:nat16;
    position = variant { Defender };
    firstName = \"Lino\";
    lastName = \"Sousa\";
    shirtNumber = 0:nat8;
    dateOfBirth =  1106092800000000000:int;
    nationality = 141:nat16;
} )"
FUNCTION_ID=12000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"

#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Seán	Grehan to Crystal Palace."
SUMMARY="Add Seán Grehan to Crystal Palace (£9m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 8:nat16;
    position = variant { Defender };
    firstName = \"Seán\";
    lastName = \"Grehan\";
    shirtNumber = 42:nat8;
    valueQuarterMillions = 36:nat16;
    dateOfBirth =  1073520000000000000:int;
    nationality = 81:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
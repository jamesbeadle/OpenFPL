
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Carl Rushworth to Brighton."
SUMMARY="Add Carl Rushworth to Arsenal (£9m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 1:nat16;
    position = variant { Goalkeeper };
    firstName = \"Carl\";
    lastName = \"Rushworth\";
    shirtNumber = 0:nat8;
    valueQuarterMillions = 36:nat16;
    dateOfBirth =  994032000000000000:int;
    nationality = 186:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
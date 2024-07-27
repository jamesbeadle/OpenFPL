
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Odeluga Offiah to Brighton."
SUMMARY="Add Odeluga Offiah to Brighton (£6m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 5:nat16;
    position = variant { Defender };
    firstName = \"Odeluga\";
    lastName = \"Offiah\";
    shirtNumber = 42:nat8;
    valueQuarterMillions = 24:nat16;
    dateOfBirth =  1035590400000000000:int;
    nationality = 186:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
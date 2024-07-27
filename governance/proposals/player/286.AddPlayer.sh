
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add James Bree to Southampton."
SUMMARY="Add James Bree to Southampton (£9m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 23:nat16;
    position = variant { Defender };
    firstName = \"James\";
    lastName = \"Bree\";
    shirtNumber = 14:nat8;
    valueQuarterMillions = 36:nat16;
    dateOfBirth =  881798400000000000:int;
    nationality = 186:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"

#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Djed Spence to Tottenham Hotspur."
SUMMARY="Add Djed Spence to Tottenham Hotspur (£8m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 18:nat16;
    position = variant { Defender };
    firstName = \"Djed\";
    lastName = \"Spence\";
    shirtNumber = 24:nat8;
    valueQuarterMillions = 32:nat16;
    dateOfBirth =  965779200000000000:int;
    nationality = 186:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
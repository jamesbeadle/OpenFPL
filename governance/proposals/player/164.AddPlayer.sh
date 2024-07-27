
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Yunus Konak to Brentford."
SUMMARY="Add Yunus Konak to Brentford (£8m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 4:nat16;
    position = variant { Defender };
    firstName = \"Yunus\";
    lastName = \"Konak\";
    shirtNumber = 0:nat8;
    valueQuarterMillions = 32:nat16;
    dateOfBirth =  1136851200000000000:int;
    nationality = 180:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
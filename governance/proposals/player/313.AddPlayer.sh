
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Leny Yoro to Man United."
SUMMARY="Add Leny Yoro to Man United (£8.5m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 14:nat16;
    position = variant { Defender };
    firstName = \"Leny\";
    lastName = \"Yoro\";
    shirtNumber = 15:nat8;
    valueQuarterMillions = 34:nat16;
    dateOfBirth =  1131840000000000000:int;
    nationality = 61:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
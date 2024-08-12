
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Jorge Cuenca to Fulham."
SUMMARY="Add Jorge Cuenca to Fulham (£8m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 10:nat16;
    position = variant { Defender };
    firstName = \"Jorge\";
    lastName = \"Cuenca\";
    shirtNumber = 0:nat8;
    valueQuarterMillions = 32:nat16;
    dateOfBirth =  942796800000000000:int;
    nationality = 164:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
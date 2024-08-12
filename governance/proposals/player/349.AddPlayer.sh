
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Jake O'Brien to Everton."
SUMMARY="Add Jake O'Brien to Everton (£6.5m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 9:nat16;
    position = variant { Defender };
    firstName = \"Jake\";
    lastName = \"O'Brien\";
    shirtNumber = 0:nat8;
    valueQuarterMillions = 26:nat16;
    dateOfBirth =  989884800000000000:int;
    nationality = 81:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
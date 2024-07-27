
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Joshua Zirkzee to Man Man United."
SUMMARY="Add Joshua Zirkzee to Man Man United (£20m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 14:nat16;
    position = variant { Forward };
    firstName = \"Joshua\";
    lastName = \"Zirkzee\";
    shirtNumber = 0:nat8;
    valueQuarterMillions = 80:nat16;
    dateOfBirth =  990489600000000000:int;
    nationality = 125:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
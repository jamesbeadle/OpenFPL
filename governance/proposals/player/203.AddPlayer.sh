
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Luke Harris to Fulham."
SUMMARY="Add Luke Harris to Fulham (£8m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 10:nat16;
    position = variant { Midfielder };
    firstName = \"Luke\";
    lastName = \"Harris\";
    shirtNumber = 38:nat8;
    valueQuarterMillions = 32:nat16;
    dateOfBirth =  1109894400000000000:int;
    nationality = 186:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
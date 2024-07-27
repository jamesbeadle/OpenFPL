
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Flynn Downes to Southampton."
SUMMARY="Add Flynn Downes to Southampton (£13m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 23:nat16;
    position = variant { Midfielder };
    firstName = \"Flynn\";
    lastName = \"Downes\";
    shirtNumber = 4:nat8;
    valueQuarterMillions = 52:nat16;
    dateOfBirth =  916790400000000000:int;
    nationality = 186:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
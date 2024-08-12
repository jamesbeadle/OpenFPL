
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Ismaïla Sarr to Crystal Palace."
SUMMARY="Add Ismaïla Sarr to Crystal Palace (£16m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 8:nat16;
    position = variant { Midfielder };
    firstName = \"Ismaïla\";
    lastName = \"Sarr\";
    shirtNumber = 7:nat8;
    valueQuarterMillions = 64:nat16;
    dateOfBirth =  919900800000000000:int;
    nationality = 153:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
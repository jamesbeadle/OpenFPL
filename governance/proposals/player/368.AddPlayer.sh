
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Ethan Wheatley to Manchester United."
SUMMARY="Add Ethan Wheatley to Manchester United (£7m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 14:nat16;
    position = variant { Forward };
    firstName = \"Ethan\";
    lastName = \"Wheatley\";
    shirtNumber = 36:nat8;
    valueQuarterMillions = 28:nat16;
    dateOfBirth =  1137715200000000000:int;
    nationality = 186:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
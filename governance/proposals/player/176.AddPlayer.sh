
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Yankuba Minteh to Brighton."
SUMMARY="Add Yankuba Minteh to Brighton (£15m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 5:nat16;
    position = variant { Forward };
    firstName = \"Yankuba\";
    lastName = \"Minteh\";
    shirtNumber = 0:nat8;
    valueQuarterMillions = 60:nat16;
    dateOfBirth =  1090454400000000000:int;
    nationality = 63:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
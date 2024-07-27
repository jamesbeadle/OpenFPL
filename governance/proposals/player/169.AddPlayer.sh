
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Mahmoud Dahoud to Brighton."
SUMMARY="Add Mahmoud Dahoud to Brighton (£10m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 5:nat16;
    position = variant { Midfielder };
    firstName = \"Mahmoud\";
    lastName = \"Dahoud\";
    shirtNumber = 8:nat8;
    valueQuarterMillions = 40:nat16;
    dateOfBirth =  1035590400000000000:int;
    nationality = 65:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
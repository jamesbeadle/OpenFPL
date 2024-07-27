
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Deniz Undav to Brighton."
SUMMARY="Add Deniz Undav to Brighton (£20m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 5:nat16;
    position = variant { Forward };
    firstName = \"Deniz\";
    lastName = \"Undav\";
    shirtNumber = 21:nat8;
    valueQuarterMillions = 80:nat16;
    dateOfBirth =  837734400000000000:int;
    nationality = 65:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
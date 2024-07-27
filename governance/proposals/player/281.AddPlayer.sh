
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Stephy Mavididi to Leicester."
SUMMARY="Add Stephy Mavididi to Leicester (£18m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 21:nat16;
    position = variant { Forward };
    firstName = \"Stephy\";
    lastName = \"Mavididi\";
    shirtNumber = 10:nat8;
    valueQuarterMillions = 72:nat16;
    dateOfBirth =  896572800000000000:int;
    nationality = 186:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
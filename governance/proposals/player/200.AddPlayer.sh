
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Iliman Ndiaye to Everton."
SUMMARY="Add Iliman Ndiaye to Everton (£18m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 9:nat16;
    position = variant { Forward };
    firstName = \"Iliman\";
    lastName = \"Ndiaye\";
    shirtNumber = 0:nat8;
    valueQuarterMillions = 72:nat16;
    dateOfBirth =  952300800000000000:int;
    nationality = 153:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
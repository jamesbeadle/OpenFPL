
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Mads Hermansen to Leicester."
SUMMARY="Add Mads Hermansen to Leicester (£7.5m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 21:nat16;
    position = variant { Goalkeeper };
    firstName = \"Mads\";
    lastName = \"Hermansen\";
    shirtNumber = 30:nat8;
    valueQuarterMillions = 30:nat16;
    dateOfBirth =  963273600000000000:int;
    nationality = 47:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
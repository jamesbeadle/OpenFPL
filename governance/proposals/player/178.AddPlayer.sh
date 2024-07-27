
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Armando Broja to Chelsea."
SUMMARY="Add Armando Broja to Chelsea (£15m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 7:nat16;
    position = variant { Forward };
    firstName = \"Armando\";
    lastName = \"Broja\";
    shirtNumber = 19:nat8;
    valueQuarterMillions = 60:nat16;
    dateOfBirth =  1000080000000000000:int;
    nationality = 2:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
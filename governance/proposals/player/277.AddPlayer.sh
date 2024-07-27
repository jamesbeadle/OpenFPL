
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Hamza Choudhury to Leicester."
SUMMARY="Add Hamza Choudhury to Leicester (£9.5m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 21:nat16;
    position = variant { Midfielder };
    firstName = \"Hamza\";
    lastName = \"Choudhury\";
    shirtNumber = 17:nat8;
    valueQuarterMillions = 38:nat16;
    dateOfBirth =  875664000000000000:int;
    nationality = 186:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
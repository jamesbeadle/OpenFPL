
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Leander Dendoncker to Aston Villa."
SUMMARY="Add Leander Dendoncker to Aston Villa (£17m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 2:nat16;
    position = variant { Midfielder };
    firstName = \"Leander\";
    lastName = \"Dendoncker\";
    shirtNumber = 32:nat8;
    valueQuarterMillions = 68:nat16;
    dateOfBirth =  797904000000000000:int;
    nationality = 17:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
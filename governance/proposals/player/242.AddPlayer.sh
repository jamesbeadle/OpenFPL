
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Rodrigo Gomes to Wolves."
SUMMARY="Add Rodrigo Gomes to Wolves (£12m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 20:nat16;
    position = variant { Forward };
    firstName = \"Rodrigo\";
    lastName = \"Gomes\";
    shirtNumber = 19:nat8;
    valueQuarterMillions = 48:nat16;
    dateOfBirth =  1057536000000000000:int;
    nationality = 141:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
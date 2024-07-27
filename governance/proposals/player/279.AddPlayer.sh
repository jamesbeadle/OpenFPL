
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Abdul Fatawu to Leicester."
SUMMARY="Add Abdul Fatawu to Leicester (£12m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 21:nat16;
    position = variant { Forward };
    firstName = \"Abdul\";
    lastName = \"Fatawu\";
    shirtNumber = 7:nat8;
    valueQuarterMillions = 48:nat16;
    dateOfBirth =  1078704000000000000:int;
    nationality = 66:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"

#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Omari Hutchinson to Ipswich."
SUMMARY="Add Omari Hutchinson to Ipswich (£16m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 22:nat16;
    position = variant { Forward };
    firstName = \"Omari\";
    lastName = \"Hutchinson\";
    shirtNumber = 20:nat8;
    valueQuarterMillions = 64:nat16;
    dateOfBirth =  1067472000000000000:int;
    nationality = 84:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
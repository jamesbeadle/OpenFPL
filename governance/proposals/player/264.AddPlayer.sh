
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Liam Delap to Ipswich."
SUMMARY="Add Liam Delap to Ipswich (£16m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 22:nat16;
    position = variant { Forward };
    firstName = \"Liam\";
    lastName = \"Delap\";
    shirtNumber = 0:nat8;
    valueQuarterMillions = 64:nat16;
    dateOfBirth =  1044662400000000000:int;
    nationality = 186:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
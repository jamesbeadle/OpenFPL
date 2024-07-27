
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Cameron Humphreys to Ipswich."
SUMMARY="Add Cameron Humphreys to Ipswich (£9.5m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 22:nat16;
    position = variant { Midfielder };
    firstName = \"Cameron\";
    lastName = \"Humphreys\";
    shirtNumber = 30:nat8;
    valueQuarterMillions = 38:nat16;
    dateOfBirth =  1067472000000000000:int;
    nationality = 186:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"

#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Massimo Luongo to Ipswich."
SUMMARY="Add Massimo Luongo to Ipswich (£10m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 22:nat16;
    position = variant { Midfielder };
    firstName = \"Massimo\";
    lastName = \"Luongo\";
    shirtNumber = 25:nat8;
    valueQuarterMillions = 40:nat16;
    dateOfBirth =  717379200000000000:int;
    nationality = 9:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
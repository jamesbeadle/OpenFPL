
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Sam Morsy to Ipswich."
SUMMARY="Add Sam Morsy to Ipswich (£10m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 22:nat16;
    position = variant { Midfielder };
    firstName = \"Sam\";
    lastName = \"Morsy\";
    shirtNumber = 5:nat8;
    valueQuarterMillions = 40:nat16;
    dateOfBirth =  684460800000000000:int;
    nationality = 52:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
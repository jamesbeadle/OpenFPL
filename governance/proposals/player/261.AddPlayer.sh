
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Ali Al-Hamadi to Ipswich."
SUMMARY="Add Ali Al-Hamadi to Ipswich (£16m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 22:nat16;
    position = variant { Forward };
    firstName = \"Ali\";
    lastName = \"Al-Hamadi\";
    shirtNumber = 16:nat8;
    valueQuarterMillions = 64:nat16;
    dateOfBirth =  1014940800000000000:int;
    nationality = 80:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
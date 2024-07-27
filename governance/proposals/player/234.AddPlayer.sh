
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Dane Scarlett to Tottenham Hotspur."
SUMMARY="Add Dane Scarlett to Tottenham Hotspur (£12m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 18:nat16;
    position = variant { Forward };
    firstName = \"Dane\";
    lastName = \"Scarlett\";
    shirtNumber = 44:nat8;
    valueQuarterMillions = 48:nat16;
    dateOfBirth =  1080086400000000000:int;
    nationality = 186:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
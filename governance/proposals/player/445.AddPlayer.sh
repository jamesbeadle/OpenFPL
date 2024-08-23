
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Julián Araujo to Bournemouth."
SUMMARY="Add Julián Araujo to Bournemouth (£8m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 3:nat16;
    position = variant { Defender };
    firstName = \"Julián\";
    lastName = \"Araujo\";
    shirtNumber = 28:nat8;
    valueQuarterMillions = 32:nat16;
    dateOfBirth =  997660800000000000:int;
    nationality = 113:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS" validateCreatePlayer
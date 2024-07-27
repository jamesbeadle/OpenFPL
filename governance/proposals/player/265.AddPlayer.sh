
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Danny Ward to Leicester."
SUMMARY="Add Danny Ward to Leicester (£8m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 21:nat16;
    position = variant { Goalkeeper };
    firstName = \"Danny\";
    lastName = \"Ward\";
    shirtNumber = 1:nat8;
    valueQuarterMillions = 32:nat16;
    dateOfBirth =  740707200000000000:int;
    nationality = 186:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
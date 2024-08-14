
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Carlos Miguel to Nottingham Forest."
SUMMARY="Add Carlos Miguel to Nottingham Forest (£5m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 16:nat16;
    position = variant { Goalkeeper };
    firstName = \"Carlos\";
    lastName = \"Miguel\";
    shirtNumber = 33:nat8;
    valueQuarterMillions = 20:nat16;
    dateOfBirth =  907891200000000000:int;
    nationality = 24:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
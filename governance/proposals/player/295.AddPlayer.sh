
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Sam Amo-Ameyaw to Southampton."
SUMMARY="Add Sam Amo-Ameyaw to Southampton (£10m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 23:nat16;
    position = variant { Midfielder };
    firstName = \"Sam\";
    lastName = \"Amo-Ameyaw\";
    shirtNumber = 27:nat8;
    valueQuarterMillions = 40:nat16;
    dateOfBirth =  1153180800000000000:int;
    nationality = 66:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
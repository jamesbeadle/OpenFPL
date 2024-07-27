
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Dele Alli to Everton."
SUMMARY="Add Dele Alli to Everton (£18m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 9:nat16;
    position = variant { Midfielder };
    firstName = \"Dele\";
    lastName = \"Alli\";
    shirtNumber = 20:nat8;
    valueQuarterMillions = 72:nat16;
    dateOfBirth =  829180800000000000:int;
    nationality = 186:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"

#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Jesper Lindstrøm to Everton."
SUMMARY="Add Jesper Lindstrøm to Everton (£19m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 9:nat16;
    position = variant { Forward };
    firstName = \"Jesper\";
    lastName = \"Lindstrøm\";
    shirtNumber = 0:nat8;
    valueQuarterMillions = 76:nat16;
    dateOfBirth =  951782400000000000:int;
    nationality = 47:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
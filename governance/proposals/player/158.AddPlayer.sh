
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Enes Ünal to Bournemouth."
SUMMARY="Add Enes Ünal to Bournemouth (£18m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 3:nat16;
    position = variant { Forward };
    firstName = \"Enes\";
    lastName = \"Ünal\";
    shirtNumber = 26:nat8;
    valueQuarterMillions = 72:nat16;
    dateOfBirth =  863222400000000000:int;
    nationality = 180:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
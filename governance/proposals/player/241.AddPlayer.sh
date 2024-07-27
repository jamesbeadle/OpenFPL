
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Jørgen Strand Larsen to Wolves."
SUMMARY="Add Jørgen Strand Larsen to Wolves (£15m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 20:nat16;
    position = variant { Forward };
    firstName = \"Jørgen\";
    lastName = \"Strand Larsen\";
    shirtNumber = 9:nat8;
    valueQuarterMillions = 60:nat16;
    dateOfBirth =  949795200000000000:int;
    nationality = 131:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
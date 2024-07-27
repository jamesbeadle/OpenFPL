
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Yukinari Sugawara to Southampton."
SUMMARY="Add Yukinari Sugawara to Southampton (£9m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 23:nat16;
    position = variant { Defender };
    firstName = \"Yukinari\";
    lastName = \"Sugawara\";
    shirtNumber = 0:nat8;
    valueQuarterMillions = 36:nat16;
    dateOfBirth =  962150400000000000:int;
    nationality = 85:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
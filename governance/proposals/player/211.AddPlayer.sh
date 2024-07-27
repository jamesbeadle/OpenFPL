
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Savinho to Man City."
SUMMARY="Add Savinho to Man City (£12m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 13:nat16;
    position = variant { Midfielder };
    firstName = \"\";
    lastName = \"Savinho\";
    shirtNumber = 26:nat8;
    valueQuarterMillions = 48:nat16;
    dateOfBirth =  1081555200000000000:int;
    nationality = 24:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
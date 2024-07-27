
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Jeremy Sarmiento to Brighton."
SUMMARY="Add Jeremy Sarmiento to Brighton (£12m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 5:nat16;
    position = variant { Midfielder };
    firstName = \"Jeremy\";
    lastName = \"Sarmiento\";
    shirtNumber = 19:nat8;
    valueQuarterMillions = 48:nat16;
    dateOfBirth =  1024185600000000000:int;
    nationality = 51:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
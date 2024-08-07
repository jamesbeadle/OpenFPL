
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Andrew Moran to Brighton."
SUMMARY="Add Andrew Moran to Brighton (£7.5m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 5:nat16;
    position = variant { Midfielder };
    firstName = \"Andrew\";
    lastName = \"Moran\";
    shirtNumber = 0:nat8;
    valueQuarterMillions = 30:nat16;
    dateOfBirth =  1066176000000000000:int;
    nationality = 81:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
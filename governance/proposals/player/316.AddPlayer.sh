
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Yasin Ayari to Brighton."
SUMMARY="Add Yasin Ayari to Brighton (£7.5m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 5:nat16;
    position = variant { Midfielder };
    firstName = \"Yasin\";
    lastName = \"Ayari\";
    shirtNumber = 0:nat8;
    valueQuarterMillions = 30:nat16;
    dateOfBirth =  1065398400000000000:int;
    nationality = 168:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
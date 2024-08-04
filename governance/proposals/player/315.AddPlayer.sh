
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Malick Yalcouyé to Brighton."
SUMMARY="Add Malick Yalcouyé to Brighton (£6.5m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 5:nat16;
    position = variant { Midfielder };
    firstName = \"Malick\";
    lastName = \"Yalcouyé\";
    shirtNumber = 0:nat8;
    valueQuarterMillions = 26:nat16;
    dateOfBirth =  1132272000000000000:int;
    nationality = 108:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"

#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Guido Rodríguez to West Ham."
SUMMARY="Add Guido Rodríguez to West Ham (£15m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 19:nat16;
    position = variant { Midfielder };
    firstName = \"Guido\";
    lastName = \"Rodríguez\";
    shirtNumber = 24:nat8;
    valueQuarterMillions = 60:nat16;
    dateOfBirth =  766108800000000000:int;
    nationality = 7:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS" validateCreatePlayer
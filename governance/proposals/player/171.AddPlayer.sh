
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Cameron Peupion to Brighton."
SUMMARY="Add Cameron Peupion to Brighton (£10m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 5:nat16;
    position = variant { Midfielder };
    firstName = \"Cameron\";
    lastName = \"Peupion\";
    shirtNumber = 44:nat8;
    valueQuarterMillions = 40:nat16;
    dateOfBirth =  1032739200000000000:int;
    nationality = 9:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
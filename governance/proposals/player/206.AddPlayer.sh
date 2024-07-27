
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Marcelo Pitaluga to Liverpool."
SUMMARY="Add Marcelo Pitaluga to Liverpool (£8m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 11:nat16;
    position = variant { Goalkeeper };
    firstName = \"Marcelo\";
    lastName = \"Pitaluga\";
    shirtNumber = 45:nat8;
    valueQuarterMillions = 32:nat16;
    dateOfBirth =  1040342400000000000:int;
    nationality = 24:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
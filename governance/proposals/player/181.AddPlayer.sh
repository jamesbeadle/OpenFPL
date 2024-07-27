
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add David Fofana to Chelsea."
SUMMARY="Add David Fofana to Chelsea (£13m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 7:nat16;
    position = variant { Forward };
    firstName = \"David\";
    lastName = \"Fofana\";
    shirtNumber = 0:nat8;
    valueQuarterMillions = 52:nat16;
    dateOfBirth =  1040515200000000000:int;
    nationality = 42:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
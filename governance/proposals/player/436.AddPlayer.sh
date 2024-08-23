
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Chiquinho to Wolves."
SUMMARY="Add Chiquinho to Wolves (£15m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 20:nat16;
    position = variant { Forward };
    firstName = \"\";
    lastName = \"Chiquinho\";
    shirtNumber = 23:nat8;
    valueQuarterMillions = 60:nat16;
    dateOfBirth =  949708800000000000:int;
    nationality = 141:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS" validateCreatePlayer
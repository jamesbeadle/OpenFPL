
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Tyrique George to Chelsea."
SUMMARY="Add Tyrique George to Chelsea (£8m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 7:nat16;
    position = variant { Forward };
    firstName = \"Tyrique\";
    lastName = \"George\";
    shirtNumber = 32:nat8;
    valueQuarterMillions = 32:nat16;
    dateOfBirth =  1139011200000000000:int;
    nationality = 186:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
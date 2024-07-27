
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Kaden Rodney to Crystal Palace."
SUMMARY="Add Kaden Rodney to Crystal Palace (£8m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 8:nat16;
    position = variant { Midfielder };
    firstName = \"Kaden\";
    lastName = \"Rodney\";
    shirtNumber = 51:nat8;
    valueQuarterMillions = 32:nat16;
    dateOfBirth =  1097107200000000000:int;
    nationality = 186:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
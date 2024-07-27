
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Malcom Ebiowei to Crystal Palace."
SUMMARY="Add Malcom Ebiowei to Crystal Palace (£12m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 8:nat16;
    position = variant { Midfielder };
    firstName = \"Malcom\";
    lastName = \"Ebiowei\";
    shirtNumber = 23:nat8;
    valueQuarterMillions = 48:nat16;
    dateOfBirth =  1062633600000000000:int;
    nationality = 186:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
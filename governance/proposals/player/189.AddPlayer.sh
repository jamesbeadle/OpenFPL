
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Killian Phillips to Crystal Palace."
SUMMARY="Add Killian Phillips to Crystal Palace (£11m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 8:nat16;
    position = variant { Midfielder };
    firstName = \"Killian\";
    lastName = \"Phillips\";
    shirtNumber = 34:nat8;
    valueQuarterMillions = 44:nat16;
    dateOfBirth =  1017446400000000000:int;
    nationality = 81:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"

#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Max Kilman to West Ham."
SUMMARY="Add Max Kilman to West Ham (£11m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 19:nat16;
    position = variant { Defender };
    firstName = \"Max\";
    lastName = \"Kilman\";
    shirtNumber = 26:nat8;
    valueQuarterMillions = 44:nat16;
    dateOfBirth =  864345600000000000:int;
    nationality = 186:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"

#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Luke Thomas to Leicester."
SUMMARY="Add Luke Thomas to Leicester (£8m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 21:nat16;
    position = variant { Defender };
    firstName = \"Luke\";
    lastName = \"Thomas\";
    shirtNumber = 33:nat8;
    valueQuarterMillions = 32:nat16;
    dateOfBirth =  992131200000000000:int;
    nationality = 186:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
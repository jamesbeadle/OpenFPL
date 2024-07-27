
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Kim Ji-soo to Bournemouth."
SUMMARY="Add Kim Ji-soo to Bournemouth (£10m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 4:nat16;
    position = variant { Defender };
    firstName = \"Ji-soo\";
    lastName = \"Kim\";
    shirtNumber = 36:nat8;
    valueQuarterMillions = 40:nat16;
    dateOfBirth =  1103846400000000000:int;
    nationality = 91:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
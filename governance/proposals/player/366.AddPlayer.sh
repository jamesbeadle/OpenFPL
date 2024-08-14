
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Harry Amass to Manchester United."
SUMMARY="Add Harry Amass to Manchester United (£6.5m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 14:nat16;
    position = variant { Defender };
    firstName = \"Harry\";
    lastName = \"Amass\";
    shirtNumber = 41:nat8;
    valueQuarterMillions = 26:nat16;
    dateOfBirth =  1174003200000000000:int;
    nationality = 186:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
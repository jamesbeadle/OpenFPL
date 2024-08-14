
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Nikola Milenković to Nottingham Forest."
SUMMARY="Add Nikola Milenković to Nottingham Forest (£7.5m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 16:nat16;
    position = variant { Defender };
    firstName = \"Nikola\";
    lastName = \"Milenković\";
    shirtNumber = 31:nat8;
    valueQuarterMillions = 30:nat16;
    dateOfBirth =  876614400000000000:int;
    nationality = 154:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
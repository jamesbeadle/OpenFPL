
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Ian Maatsen to Aston Villa."
SUMMARY="Add Ian Maatsen to Aston Villa (£10m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 2:nat16;
    position = variant { Defender };
    firstName = \"Ian\";
    lastName = \"Maatsen\";
    shirtNumber = 0:nat8;
    valueQuarterMillions = 40:nat16;
    dateOfBirth =  895104000000000000:int;
    nationality = 125:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
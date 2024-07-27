
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Kosta Nedeljković to Aston Villa."
SUMMARY="Add Kosta Nedeljković to Aston Villa (£10m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 2:nat16;
    position = variant { Defender };
    firstName = \"Kosta\";
    lastName = \"Nedeljković\";
    shirtNumber = 0:nat8;
    valueQuarterMillions = 20:nat16;
    dateOfBirth =  1134691200000000000:int;
    nationality = 154:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
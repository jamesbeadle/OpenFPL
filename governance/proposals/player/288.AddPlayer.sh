
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Taylor Harwood-Bellis to Southampton."
SUMMARY="Add Taylor Harwood-Bellis to Southampton (£8m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 23:nat16;
    position = variant { Defender };
    firstName = \"Taylor\";
    lastName = \"Harwood-Bellis\";
    shirtNumber = 6:nat8;
    valueQuarterMillions = 34:nat16;
    dateOfBirth =  1012348800000000000:int;
    nationality = 186:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
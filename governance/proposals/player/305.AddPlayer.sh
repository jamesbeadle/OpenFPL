
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Riccardo Calafiori to Arsenal."
SUMMARY="Add Riccardo Calafiori to Arsenal (£14m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 1:nat16;
    position = variant { Defender };
    firstName = \"Riccardo\";
    lastName = \"Calafiori\";
    shirtNumber = 33:nat8;
    valueQuarterMillions = 56:nat16;
    dateOfBirth =  1021766400000000000:int;
    nationality = 83:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
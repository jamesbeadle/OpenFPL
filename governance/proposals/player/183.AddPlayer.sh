
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Chadi Riad to Crystal Palace."
SUMMARY="Add Chadi Riad to Crystal Palace (£9m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 8:nat16;
    position = variant { Defender };
    firstName = \"Chadi\";
    lastName = \"Riad\";
    shirtNumber = 0:nat8;
    valueQuarterMillions = 36:nat16;
    dateOfBirth =  1055808000000000000:int;
    nationality = 119:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
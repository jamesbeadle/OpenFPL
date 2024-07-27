
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Marc Guiu to Chelsea."
SUMMARY="Add Marc Guiu to Chelsea (£12m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 7:nat16;
    position = variant { Forward };
    firstName = \"Marc\";
    lastName = \"Guiu\";
    shirtNumber = 38:nat8;
    valueQuarterMillions = 48:nat16;
    dateOfBirth =  1136332800000000000:int;
    nationality = 164:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
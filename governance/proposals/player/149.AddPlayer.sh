
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Lino Sousa to Aston Villa."
SUMMARY="Add Lino Sousa to Aston Villa (£5m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 2:nat16;
    position = variant { Defender };
    firstName = \"Lino\";
    lastName = \"\";
    shirtNumber = 0:nat8;
    valueQuarterMillions = 20:nat16;
    dateOfBirth =  1106092800000000000:int;
    nationality = 141:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
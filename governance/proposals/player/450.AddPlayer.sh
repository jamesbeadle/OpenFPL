
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Niclas Füllkrug to West Ham."
SUMMARY="Add Niclas Füllkrug to West Ham (£20m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 19:nat16;
    position = variant { Forward };
    firstName = \"Niclas\";
    lastName = \"Füllkrug\";
    shirtNumber = 11:nat8;
    valueQuarterMillions = 80:nat16;
    dateOfBirth =  729216000000000000:int;
    nationality = 65:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS" validateCreatePlayer
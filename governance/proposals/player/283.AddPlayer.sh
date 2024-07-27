
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Joe Lumley to Southampton."
SUMMARY="Add Joe Lumley to Southampton (£7m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 23:nat16;
    position = variant { Goalkeeper };
    firstName = \"Joe\";
    lastName = \"Lumley\";
    shirtNumber = 13:nat8;
    valueQuarterMillions = 28:nat16;
    dateOfBirth =  792806400000000000:int;
    nationality = 186:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
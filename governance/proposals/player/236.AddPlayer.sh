
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Lucas Bergvall to Tottenham Hotspur."
SUMMARY="Add Lucas Bergvall to Tottenham Hotspur (£13m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 18:nat16;
    position = variant { Midfielder };
    firstName = \"Lucas\";
    lastName = \"Bergvall\";
    shirtNumber = 15:nat8;
    valueQuarterMillions = 52:nat16;
    dateOfBirth =  1138838400000000000:int;
    nationality = 168:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
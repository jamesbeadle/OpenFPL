
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Joe Aribo to Southampton."
SUMMARY="Add Joe Aribo to Southampton (£15m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 23:nat16;
    position = variant { Midfielder };
    firstName = \"Joe\";
    lastName = \"Aribo\";
    shirtNumber = 7:nat8;
    valueQuarterMillions = 60:nat16;
    dateOfBirth =  837907200000000000:int;
    nationality = 129:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
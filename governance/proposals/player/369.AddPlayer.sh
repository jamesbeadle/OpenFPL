
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Joe White to Newcastle United."
SUMMARY="Add Joe White to Newcastle United (£8m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 15:nat16;
    position = variant { Midfielder };
    firstName = \"Joe\";
    lastName = \"White\";
    shirtNumber = 40:nat8;
    valueQuarterMillions = 32:nat16;
    dateOfBirth =  1033430400000000000:int;
    nationality = 186:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"

#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add John Ruddy to Newcastle United."
SUMMARY="Add John Ruddy to Newcastle United (£8m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 15:nat16;
    position = variant { Goalkeeper };
    firstName = \"John\";
    lastName = \"Ruddy\";
    shirtNumber = 0:nat8;
    valueQuarterMillions = 32:nat16;
    dateOfBirth =  530496000000000000:int;
    nationality = 186:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
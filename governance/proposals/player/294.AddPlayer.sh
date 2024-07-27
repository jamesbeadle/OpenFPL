
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Nathan Wood to Southampton."
SUMMARY="Add Nathan Wood to Southampton (£8m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 23:nat16;
    position = variant { Defender };
    firstName = \"Nathan\";
    lastName = \"Wood\";
    shirtNumber = 0:nat8;
    valueQuarterMillions = 32:nat16;
    dateOfBirth =  1022803200000000000:int;
    nationality = 186:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"

#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add George Hirst to Ipswich."
SUMMARY="Add George Hirst to Ipswich (£15m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 22:nat16;
    position = variant { Forward };
    firstName = \"George\";
    lastName = \"Hirst\";
    shirtNumber = 27:nat8;
    valueQuarterMillions = 60:nat16;
    dateOfBirth =  919036800000000000:int;
    nationality = 186:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
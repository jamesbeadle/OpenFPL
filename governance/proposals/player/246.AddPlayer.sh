
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Harry Clarke to Ipswich."
SUMMARY="Add Harry Clarke to Ipswich (£8.5m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 22:nat16;
    position = variant { Defender };
    firstName = \"Harry\";
    lastName = \"Clarke\";
    shirtNumber = 2:nat8;
    valueQuarterMillions = 34:nat16;
    dateOfBirth =  983491200000000000:int;
    nationality = 186:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
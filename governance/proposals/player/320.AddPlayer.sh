
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Dean Huijsen to Bournemouth."
SUMMARY="Add Dean Huijsen to Bournemouth (£7m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 3:nat16;
    position = variant { Defender };
    firstName = \"Dean\";
    lastName = \"Huijsen\";
    shirtNumber = 2:nat8;
    valueQuarterMillions = 28:nat16;
    dateOfBirth =  1113436800000000000:int;
    nationality = 164:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
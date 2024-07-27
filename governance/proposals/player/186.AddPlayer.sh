
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Daichi Kamada to Crystal Palace."
SUMMARY="Add Daichi Kamada to Crystal Palace (£17m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 8:nat16;
    position = variant { Midfielder };
    firstName = \"Daichi\";
    lastName = \"Kamada\";
    shirtNumber = 0:nat8;
    valueQuarterMillions = 68:nat16;
    dateOfBirth =  839203200000000000:int;
    nationality = 85:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
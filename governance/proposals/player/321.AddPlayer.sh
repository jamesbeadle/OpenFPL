
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add David Brooks to Bournemouth."
SUMMARY="Add David Brooks to Bournemouth (£17.5m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 3:nat16;
    position = variant { Midfielder };
    firstName = \"David\";
    lastName = \"Brooks\";
    shirtNumber = 7:nat8;
    valueQuarterMillions = 70:nat16;
    dateOfBirth =  868320000000000000:int;
    nationality = 186:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
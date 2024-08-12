
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Kiernan Dewsbury-Hall to Chelsea."
SUMMARY="Add Kiernan Dewsbury-Hall to Chelsea (£18m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 7:nat16;
    position = variant { Midfielder };
    firstName = \"Kiernan\";
    lastName = \"Dewsbury-Hall\";
    shirtNumber = 22:nat8;
    valueQuarterMillions = 72:nat16;
    dateOfBirth =  905040000000000000:int;
    nationality = 186:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
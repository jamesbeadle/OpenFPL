
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Filip Jörgensen to Chelsea."
SUMMARY="Add Filip Jörgensen to Chelsea (£8m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 7:nat16;
    position = variant { Goalkeeper };
    firstName = \"Filip\";
    lastName = \"Jörgensen\";
    shirtNumber = 12:nat8;
    valueQuarterMillions = 32:nat16;
    dateOfBirth =  1018915200000000000:int;
    nationality = 47:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
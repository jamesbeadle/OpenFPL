
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Jack Taylor to Ipswich."
SUMMARY="Add Jack Taylor to Ipswich (£12m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 22:nat16;
    position = variant { Midfielder };
    firstName = \"Jack\";
    lastName = \"Taylor\";
    shirtNumber = 14:nat8;
    valueQuarterMillions = 48:nat16;
    dateOfBirth =  898560000000000000:int;
    nationality = 81:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
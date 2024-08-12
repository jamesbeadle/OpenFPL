
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Renato Veiga to Chelsea."
SUMMARY="Add Renato Veiga to Chelsea (£12m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 7:nat16;
    position = variant { Midfielder };
    firstName = \"Renato\";
    lastName = \"Veiga\";
    shirtNumber = 40:nat8;
    valueQuarterMillions = 48:nat16;
    dateOfBirth =  1059436800000000000:int;
    nationality = 141:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
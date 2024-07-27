
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Arijanet Muric to Ipswich."
SUMMARY="Add Arijanet Muric to Ipswich (£7m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 22:nat16;
    position = variant { Goalkeeper };
    firstName = \"Arijanet\";
    lastName = \"Muric\";
    shirtNumber = 0:nat8;
    valueQuarterMillions = 28:nat16;
    dateOfBirth =  910396800000000000:int;
    nationality = 169:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
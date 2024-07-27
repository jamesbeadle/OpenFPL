
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Luke Woolfenden to Ipswich."
SUMMARY="Add Luke Woolfenden to Ipswich (£8.5m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 22:nat16;
    position = variant { Defender };
    firstName = \"Luke\";
    lastName = \"Woolfenden\";
    shirtNumber = 6:nat8;
    valueQuarterMillions = 34:nat16;
    dateOfBirth =  908928000000000000:int;
    nationality = 186:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
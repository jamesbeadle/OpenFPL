
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Matthijs De Ligt to Manchester United."
SUMMARY="Add Matthijs De Ligt to Manchester United (£18m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 14:nat16;
    position = variant { Defender };
    firstName = \"Matthijs\";
    lastName = \"De Ligt\";
    shirtNumber = 4:nat8;
    valueQuarterMillions = 72:nat16;
    dateOfBirth =  934416000000000000:int;
    nationality = 125:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
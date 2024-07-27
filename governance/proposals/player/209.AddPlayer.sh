
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Josh Wilson-Esbrand to Man City."
SUMMARY="Add Josh Wilson-Esbrand to Man City (£8m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 13:nat16;
    position = variant { Defender };
    firstName = \"Josh\";
    lastName = \"Wilson-Esbrand\";
    shirtNumber = 97:nat8;
    valueQuarterMillions = 32:nat16;
    dateOfBirth =  1040860800000000000:int;
    nationality = 186:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
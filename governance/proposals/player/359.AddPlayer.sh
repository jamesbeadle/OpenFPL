
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Wilfred Ndidi to Leicester City."
SUMMARY="Add Wilfred Ndidi to Leicester City (£8m)."
URL="https://openfpl.xyz"

ARGS="( record { 
    clubId = 21:nat16;
    position = variant { Midfielder };
    firstName = \"Wilfred\";
    lastName = \"Ndidi\";
    shirtNumber = 25:nat8;
    valueQuarterMillions = 32:nat16;
    dateOfBirth =  850694400000000000:int;
    nationality = 129:nat16;
} )"
FUNCTION_ID=22000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
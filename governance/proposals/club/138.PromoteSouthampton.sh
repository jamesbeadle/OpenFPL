
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Promote Southampton to the Premier League."
SUMMARY="Promote Southampton to the Premier League."
URL="https://openfpl.xyz"

ARGS="( record { 
    

    name = \"Southampton\";
    friendlyName = \"Southampton\";
    primaryColourHex = \"#c00e1a\";
    secondaryColourHex = \"#FFFFFF\";
    thirdColourHex = \"#000000\";
    abbreviatedName = \"SOT\";
    shirtType = variant { Striped };

 } )"
FUNCTION_ID=23000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"
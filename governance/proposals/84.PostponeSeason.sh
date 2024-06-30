#!/bin/bash

# Set current directory to the directory this script is in
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

PROPOSAL="(
    record {  
        title = \"Motion to Postpone Season\";  
        url = \"https://app.icpswap.com/\";  
        summary = \"
        Unfortunately without funding it is not possible to develop, promote and manage OpenFPL for the 2024/25 season.
        Waterway Labs (https://waterwaylabs.xyz) proposes postponing the first season until 2025/26 to give the team time to raise funds through OpenBook and GolfPad.
        \";
        action = opt variant {  
        Motion = record {  
            motion_text = \"
            Unfortunately without funding it is not possible to develop, promote and manage OpenFPL for the 2024/25 season.
            aterway Labs (https://waterwaylabs.xyz) proposes postponing the first season until 2025/26 to give the team time to raise funds through OpenBook and GolfPad.
        \";  
            
        }  
    };  
    })"

../utils/submit_proposal.sh "$PROPOSAL"

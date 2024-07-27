#!/bin/bash

# Set current directory to the directory this script is in
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

PROPOSAL="(
    record {  
        title = \"Motion to add protections against bots.\";  
        url = \"https://github.com/jamesbeadle/openfpl/\";  
        summary = \"
            Motion to add checks through correct image identification on save team.
            This will be required every 3 months for a user making changes to their team weekly.
            For users with longer gaps in their team selection or other patterns of behaviour we identify, 
            the correct image check verification may be required. 
            This solution will be 100% on chain with a canister added containing the challenge images.
        \";
        action = opt variant {  
        Motion = record {  
        
            motion_text = \"
            Motion to add checks through correct image identification on save team.
            This will be required every 3 months for a user making changes to their team weekly.
            For users with longer gaps in their team selection or other patterns of behaviour we identify, 
            the correct image check verification may be required. 
            This solution will be 100% on chain with a canister added containing the challenge images.
        \";  
            
        }  
    };  
    })"

../utils/submit_proposal.sh "$PROPOSAL"

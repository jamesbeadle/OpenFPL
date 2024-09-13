#!/bin/bash

# Set current directory to the directory this script is in
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

PROPOSAL="(
    record {  
        title = \"Motion to Adjust the minting of rewards\";  
        url = \"https://github.com/jamesbeadle/OpenFPL\";  
        summary = \"
            Adjust the logic for minting rewards for the 2024/25 season to ensure inflation is controlled in the best way possible.
        \";
        action = opt variant {  
        Motion = record {  
        
            motion_text = \"
            The tokenomics of OpenFPL are balanced through protecting the DAO, rewarding users and controlling inflation. 
            The Waterway Labs team believe it is prudent to adjust how we obtain the 1.875m FPL for the first season due to the nature of the 3 factors we are balancing.
            For at least the next 2 years, an attack to gain control of the DAO isn't possible with 3 key token holders. 
            The rewards for proposals are great and we have a lot of proposals coming. Active participation will make our product even more valuable so I have no intention of adjusting the reward rate.
            Therefore to control inflation, we proposal the 1.875m FPL is taken from the treasury in the first season, reducing the FPL balance from 50m FPL to 48.125m FPL.
            Our plan remains to use the profit from the platform's various revenue streams to buy back FPL from exchanges (this will be done randomly to prevent front running).
            We will then decide on the amount to burn based on how close the total supply is to the starting 100m FPL tokens.
            We aim for this to reduce price volatility.
        \";  
            
        }  
    };  
    })"

../utils/submit_proposal.sh "$PROPOSAL"

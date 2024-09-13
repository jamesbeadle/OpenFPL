#!/bin/bash

# Set current directory to the directory this script is in
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

PROPOSAL="(
    record {  
        title = \"Motion to extend OpenFPL multi-canister architecture for additional clubs, leagues and players.\";  
        url = \"https://github.com/jamesbeadle/openfpl/\";  
        summary = \"
            Motion to extend OpenFPL multi-canister architecture to capture data for every professional league, club and player in the world. 
            This will involve the addition of a dedicated league and competitions canister, a clubs canister and an extension to the data structure in the player canister. 
            Transfer Kings will have a dependency on the OpenFPL dataset, ensuring it is owned by the DAO. A Transfer Kings agency will only be purchasable using FPL.
        \";
        action = opt variant {  
        Motion = record {  
            motion_text = \"
            Motion to extend OpenFPL multi-canister architecture to capture data for every professional league, club and player in the world. 
            This will involve the addition of a dedicated league and competitions canister, a clubs canister and an extension to the data structure in the player canister. 
            Transfer Kings will have a dependency on the OpenFPL dataset, ensuring it is owned by the DAO. A Transfer Kings agency will only be purchasable using FPL.
        \";  
            
        }  
    };  
    })"

../utils/submit_proposal.sh "$PROPOSAL"

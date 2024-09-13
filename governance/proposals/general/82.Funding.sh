#!/bin/bash

# Set current directory to the directory this script is in
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

PROPOSAL="(
    record {  
        title = \"Motion to Rethink Staking Treasury\";  
        url = \"https://app.icpswap.com/\";  
        summary = \"
        The developer who wrote our neuron controller code expressed concerns after we last spoke which has made me rethink staking the treasury.
        With staking the treasury being undocumented & unsupported and by dfinity, also the rewards may be potentially at risk of change in the future, I won't be pursuing it anymore as it feels high risk. 
        I propose we reallocate funds as follows:
            - Fund Waterway Labs 20% of the treasury (13,820 ICP).
                - This will fund the 2024/25 promotional tour of UK stadiums, Youtube Channel & Podcast.
                - This will allow for the full time employment of DayDrinkr and the continued employment of Kelly to work on OpenFPL.
            - Reserve 10% (5,121) of the remaining ~51K ICP to create an additional liquidity pool on ICP Swap to ensure the smooth trading of the FPL token in future.            
        \";
        action = opt variant {  
        Motion = record {  
        
            motion_text = \"
            The developer who wrote our neuron controller code expressed concerns after we last spoke which has made me rethink staking the treasury.
            With staking the treasury being undocumented & unsupported and by dfinity, also the rewards may be potentially at risk of change in the future, I won't be pursuing it anymore as it feels high risk. 
            I propose we reallocate funds as follows:
                - Fund Waterway Labs 20% of the treasury (13,820 ICP).
                    - This will fund the 2024/25 promotional tour of UK stadiums, Youtube Channel & Podcast.
                    - This will allow for the full time employment of DayDrinkr and the continued employment of Kelly to work on OpenFPL.
                - Reserve 10% (5,121) of the remaining ~51K ICP to create an additional liquidity pool on ICP Swap to ensure the smooth trading of the FPL token in future.
        \";  
            
        }  
    };  
    })"

../utils/submit_proposal.sh "$PROPOSAL"

#!/bin/bash

# Set current directory to the directory this script is in
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

# Call the function to configure the neuron that has just been created

echo "Transfer to ICP Swap"

PROPOSAL="(
    record {  
        title = \"Transfer 8,100 ICP to FPL/ICP pool on ICPSwap\";  
        url = \"https://nns.ic0.app/proposal/?u=gyito-zyaaa-aaaaq-aacpq-cai&proposal=25\";  
        summary = \"
            This is the first of 2 proposals which add liquidity to the FPL/ICP pool on ICPSwap.
            
            https://info.icpswap.com/swap/pool/details/yco2w-2iaaa-aaaag-qjqoa-cai

            See this motion proposal for full details.
            https://nns.ic0.app/proposal/?u=gyito-zyaaa-aaaaq-aacpq-cai&proposal=25
        \";
        action = opt variant {  
            TransferSnsTreasuryFunds = record {
               from_treasury=1:int32; 
               amount_e8s=810000000000:nat64; 
               to_principal=opt principal \"yco2w-2iaaa-aaaag-qjqoa-cai\"; 
               to_subaccount=opt record { subaccount=vec { 10: nat8; 0: nat8; 0: nat8; 0: nat8; 0: nat8; 2: nat8; 0: nat8; 0: nat8; 160: nat8; 1: nat8; 1: nat8; 0: nat8; 0: nat8; 0: nat8; 0: nat8; 0: nat8; 0: nat8; 0: nat8; 0: nat8; 0: nat8; 0: nat8; 0: nat8; 0: nat8; 0: nat8; 0: nat8; 0: nat8; 0: nat8; 0: nat8; 0: nat8; 0: nat8; 0: nat8; 0: nat8 }}; 
               memo=null;
            }
        };  
    })"

./submit_proposal.sh "$PROPOSAL"

#On completion use OpenFPL Backend to obtain neuron id

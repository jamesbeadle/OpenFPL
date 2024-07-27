#!/bin/bash

# Set current directory to the directory this script is in
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

# Call the function to configure the neuron that has just been created

echo "Transfer to ICP Swap"

PROPOSAL="(
    record {  
        title = \"Transfer 1,875,000 FPL from treasury to FPL prize pool.\";  
        url = \"https://nns.ic0.app/proposal/?u=gyito-zyaaa-aaaaq-aacpq-cai&proposal=25\";  
        summary = \"
            This proposal will transfer 1,875,000 FPL to the OpenFPL backend canister bboqb-jiaaa-aaaal-qb6ea-cai for the 2024/25 season prize pool.
        \";
        action = opt variant {  
            TransferSnsTreasuryFunds = record {
               from_treasury=2:int32; 
               amount_e8s=187500000000000:nat64; 
               to_principal=opt principal \"bboqb-jiaaa-aaaal-qb6ea-cai\"; 
               to_subaccount=opt record { subaccount=vec { 10: nat8; 0: nat8; 0: nat8; 0: nat8; 0: nat8; 2: nat8; 0: nat8; 0: nat8; 160: nat8; 1: nat8; 1: nat8; 0: nat8; 0: nat8; 0: nat8; 0: nat8; 0: nat8; 0: nat8; 0: nat8; 0: nat8; 0: nat8; 0: nat8; 0: nat8; 0: nat8; 0: nat8; 0: nat8; 0: nat8; 0: nat8; 0: nat8; 0: nat8; 0: nat8; 0: nat8; 0: nat8 }}; 
               memo=null;
            }  
        };  
    })"

../utils/submit_proposal.sh "$PROPOSAL"

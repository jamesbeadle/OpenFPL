#!/bin/bash

# Set current directory to the directory this script is in
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

# Call the function to configure the neuron that has just been created

echo "Transfer to fund neuron"

PROPOSAL="(
    record {  
        title = \"Transfer an initial 2,500 ICP to the DAO controlled neuron\";  
        url = \"https://dashboard.internetcomputer.org/neuron/2511989001097450386\";  
        summary = \"
            This proposal will transfer 2,500 ICP to the DAO controlled neuron 2511989001097450386 to enable to DAO to test spawning maturity interest.
        \";
        action = opt variant {  
            TransferSnsTreasuryFunds = record {
                from_treasury=1:int32; 
                amount_e8s=250000000000:nat64; 
                to_principal=opt principal \"???\"; 
                to_subaccount = null;
                memo=null;   
            }
        };  
    })"

../utils/submit_proposal.sh "$PROPOSAL"

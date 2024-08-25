#!/bin/bash

# Set current directory to the directory this script is in
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

# Call the function to configure the neuron that has just been created

echo "Transfer funds Waterway Labs"

PROPOSAL="(
    record {  
        title = \"Transfer 10,000 ICP to Waterway Labs\";  
        url = \"https://nuance.xyz/jamesbeadle/11014-434go-diaaa-aaaaf-qakwq-cai/openfpl-update\";  
        summary = \"
            Waterway Labs is the UK limited company (Reg: 15281491) setup by OpenFPL founder James Beadle. 
            
            https://waterwaylabs.xyz 
            
            Please read the following nuance article for details about the request:
            https://nuance.xyz/jamesbeadle/11014-434go-diaaa-aaaaf-qakwq-cai/openfpl-update

            James

        \";
        action = opt variant {  
            TransferSnsTreasuryFunds = record {
                from_treasury=1:int32; 
                amount_e8s=1000000000000:nat64; 
                to_principal=opt principal \"agy5w-dlcen-pkrgo-pgfrz-3eqf2-xfwvr-qcvwn-nlhyu-77fsb-wgc37-nqe\"; 
                to_subaccount = null;
                memo=null;   
            }
        };  
    })"

../utils/submit_proposal.sh "$PROPOSAL"

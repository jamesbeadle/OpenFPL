#!/bin/bash

# Set current directory to the directory this script is in
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

# Call the function to configure the neuron that has just been created

echo "Transfer to fund ICPFA"

PROPOSAL="(
    record {  
        title = \"Transfer 4,064 ICP to ICPFA\";  
        url = \"https://nns.ic0.app/proposal/?u=gyito-zyaaa-aaaaq-aacpq-cai&proposal=25\";  
        summary = \"
            This proposal will transfer 4,064 ICP to James Beadle to setup the ICPFA. 
            
            This money will be used for equipment, promotion, marketing and merchandising purposes.
            
            James will setup:
            - The OpenFPL YouTube channel documenting various IRL promotional events.
            - The OpenFPL main podcast, running weekly discussing upcoming fixtures with fans.
            - Stocking the ICPFA store with the initial 'classic' range of Premier League football shirts.
            - Online marketing campaigns on all major social media platforms.
            
            Each area's required future funding is secured through the maturity interest earned through staking 80% on the treasury. 
        \";
        action = opt variant {  
            TransferSnsTreasuryFunds = record {
                from_treasury=1:int32; 
                amount_e8s=406400000000:nat64; 
                to_principal=opt principal \"agy5w-dlcen-pkrgo-pgfrz-3eqf2-xfwvr-qcvwn-nlhyu-77fsb-wgc37-nqe\"; 
                to_subaccount = null;
                memo=null;   
            }
        };  
    })"

../utils/submit_proposal.sh "$PROPOSAL"

#On completion use OpenFPL Backend to obtain neuron id

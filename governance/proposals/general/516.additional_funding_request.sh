#!/bin/bash

# Set current directory to the directory this script is in
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

# Call the function to configure the neuron that has just been created

echo "Transfer funds Waterway Labs"

PROPOSAL="(
    record {  
        title = \"Transfer 5,000 ICP to Waterway Labs\";  
        url = \"https://waterwaylabs.xyz\";  
        summary = \"

            As we move into a crucial stage of the project I want to ensure my company is not financially exposed with the potential price volatility. 

            Today, I have made an offer to employ an Aberdeen University AI MSc graduate with Motoko experience to join our team. 

            This hire will accelerate the development of our existing products, with our new hire (John) taking on the day to day backend programming responsibilities. 
            
            John also allows us to utilise our valuable football dataset through training AI models to:
            - assist people pick teams based on their prior selections
            - raise proposals to populate football data 
            - generate more accurate odds for the upcoming gambling site

            Over the next few weeks I will also incur charges from our management agency in Alderney along with a requirement to setup a bank account with £25K within it, 
            this money will be utilised by our company over the coming years as our UK operation is moved to Alderney. 

        \";
        action = opt variant {  
            TransferSnsTreasuryFunds = record {
                from_treasury=1:int32; 
                amount_e8s=500000000000:nat64; 
                to_principal=opt principal \"agy5w-dlcen-pkrgo-pgfrz-3eqf2-xfwvr-qcvwn-nlhyu-77fsb-wgc37-nqe\"; 
                to_subaccount = null;
                memo=null;   
            }
        };  
    })"

../../utils/submit_proposal.sh "$PROPOSAL"

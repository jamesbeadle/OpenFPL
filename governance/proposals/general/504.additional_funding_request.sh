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
        url = \"https://waterwaylabs.xyz\";  
        summary = \"

            This funding request reflects the additional expenditure incurred by Waterway Labs in relation to work building the OpenFPL ecosystem.
            We have begun the process to obtain a gambling license to implement fixed odds betting using the FPL token, 
            this has involved acquiring the services of a financial consultancy company with expertise in this field. 
            The company has a 100% success rate with getting licenses for clients and aim to have our license by March 2025. 
            So far the process has been successful, with myself accepted by a corporate service provider in Alderney, and our company is being restructured accordingly. 

            Over the past few months we have faced a lot of delays due to technical issues with the IC, 
            to overcome these problems we will face a noticable increase in cycles cost. 
            We are working on calculations for this but we feel it is a priority to launch whilst pressuring dfinity to fix the underlying cause of the cost increase. 

            We have always had a carrying cost for promotion with staff and expenses related to events that didn't materialise due to the app not being live. 
            These costs will continue as promotion begins.
            
            Whilst we have been waiting on DFINITY we have been working on refactoring the OpenFPL backend into a dedicated data canister, 
            with the ability to handle a multi-league system in preparation for 
            
             dataset into a multi-league

            Data Manager 
            
            Sponsorhip
            
             we are about to launch   Thilly and another developer


            we have always been setup to promote at anytime but refrained from beginning promotion whilst there have been technical problems.
            To overcome 

            to overcome these problems our cycles costs have increased

            carrying cosst for promotion, we have been setup and ready to go for months 
            
            Waterway Labs is the UK limited company (Reg: 15281491) setup by OpenFPL founder, James Beadle. 
            
             
            
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

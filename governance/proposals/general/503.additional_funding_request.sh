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
            with the ability to handle a multi-league system in preparation for handling world wide fixed odds betting. This work is now complete and can be found here:

            https://github.com/jamesbeadle/OpenFPL

            We have hired a new developer, Thilly, who has already built the OpenWSL frontend. 
            We will be incurring additional designer costs as we need to have FootballGod redesigned to fit the new gambling features. 
            We then plan to release gambling site linked to our data, whilst restricting every IP address until our licenses in each jurisdication become available.
            We also need to hire another developer to assist with the backend, to obtain the licenses we have certain requirements along with assisting with IC related technical issues.
            
            We would also like to hire a data manager to help manage our data entry and validation pipelines as this grows for the data used by the FootballGod gambling site.   

            We have a lot of content being prepared from podcast videos to challenge reels but no outlet to produce the professional quality we require. 
            We have therefore begun hiring freelancers to help produce this but as more products come online we feel we can justify hiring a full time person for this work.

            We have also signed a 3 year sponsorhip agreement for a women's team, this will be an ongoing cost, 
            something we'd ideally make proportional to the expected increasing amount raised to be our official sponsor. 
            This sponsorship campaign compliments our movement into women's football nicely, more information can be found here:

            https://nuance.xyz/openfpl/11316-434go-diaaa-aaaaf-qakwq-cai/openfpl-womens-ambassador-fund-

            We aim to release OpenFPL and OpenWSL together from Monday 7th October, barring any additional problems with the IC. 
            We continue to develop additional products that will result in tokens for OpenFPL neuron holders, 
            significant progress has been made with OpenBook, GolfPad & OpenBeats. 

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

../../utils/submit_proposal.sh "$PROPOSAL"

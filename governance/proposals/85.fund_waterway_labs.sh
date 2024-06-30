#!/bin/bash

# Set current directory to the directory this script is in
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

# Call the function to configure the neuron that has just been created

echo "Transfer to fund Waterway Labs"

PROPOSAL="(
    record {  
        title = \"Transfer 13,820 ICP to Waterway Labs\";  
        url = \"https://nns.ic0.app/proposal/?u=gyito-zyaaa-aaaaq-aacpq-cai&proposal=25\";  
        summary = \"
            Waterway Labs is the UK limited company (Reg: 15281491) setup by OpenFPL founder James Beadle. 
            
            https://waterwaylabs.xyz 
            
            We believe time is running out to make a decision about who will do all the work required to make OpenFPL a success. We propose funding Waterway Labs to do the following work and get the season started for 2024/25:

            - Complete the private leagues feature so the DAO can start earning revenue.
            - Stock the ICPFA shop with shirts so the DAO can start earning revenue.
            - Prepare proposals to mint rewards ready for 2024/25 prizes.
            - Manage all data for the 2024/25 season.
            - Employ a community manager for the 2024/25 season.
            - Build Android and iOS apps.
            - Promote the app on all major social media platforms as we tour the UK giving $FPL as prizes.
            - Add in new proposal for bulk upload of never before promoted teams to save us entering every player for new teams with functionality to cross reference against players that may have moved to that team that already exist in OpenFPL.
            - Add token withdrawal code.
            - Build unit tests.
            - Add in UI improvements
            - Fix tied position text error.
            - Refactor and improve efficiency of the leaderboard calculation.
            - Add in checks to protect against bot farms etc.

            As the Euro 2024 group stage completes, transfers of Premier League players will begin.

            Funding from OpenFPL would mean it would be our primary focus and staked FPL holders would be rewarded accordingly with new Waterway Labs projects.

            There is now a potential implementation to stake a DAOs treasury, we will do the required testing on this but it could take longer than the start of the season.

            We know the amount of work required to develop, manage and run OpenFPL and we hope we can begin the season in August 2024.

            James

        \";
        action = opt variant {  
            TransferSnsTreasuryFunds = record {
                from_treasury=1:int32; 
                amount_e8s=1382000000000:nat64; 
                to_principal=opt principal \"agy5w-dlcen-pkrgo-pgfrz-3eqf2-xfwvr-qcvwn-nlhyu-77fsb-wgc37-nqe\"; 
                to_subaccount = null;
                memo=null;   
            }
        };  
    })"

../utils/submit_proposal.sh "$PROPOSAL"

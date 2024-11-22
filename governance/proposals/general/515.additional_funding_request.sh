#!/bin/bash

# Set current directory to the directory this script is in
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

# Call the function to configure the neuron that has just been created

echo "Transfer funds Waterway Labs"

PROPOSAL="(
    record {  
        title = \"Transfer 7,500 ICP to Waterway Labs\";  
        url = \"https://waterwaylabs.xyz\";  
        summary = \"

            This funding request is for the on going expenditure incurred by Waterway Labs in relation to work building the OpenFPL ecosystem.
            
            Promotion for OpenFPL has been held up by time bottlenecks, I currently don't have time to execute the promotional plan and need to hire more people to help me from development, content creation and promotion. 
            Kelly has also had to pivot roles to data management as we pursue the gambling license however we have been planning events, we've recently purchased a van to store our OpenFPL promotional target equipment 
            and are hoping to have more time now the gamlbing license requirements are easing. 

            We have purchased kit's for the Epsom & Ewell Colts women's teams and a promotional campaign around the real world good Web3 can do (especially in women's football) will begin in the coming weeks as these OpenChat & OpenFPL branded kits are delivered to the club.
            
            The process for obtaining our gambling license is underway. The current phase requires a financial and code audit, hence our team's recent focus on preparing the code for the betting site and refactoring the backend's of all our apps ready for these checks. 
            We now have a multi-app (FootballGod, OpenFPL, OpenWSL) ecosystem that is controlled through new tooling built out on the waterwaylabs.xyz wesbite.

            This tooling can be explained along with a lot of the stuff we are working on in this nuance article here:

            https://nuance.xyz/jamesbeadle/11632-434go-diaaa-aaaaf-qakwq-cai/waterway-labs

            FootballGod is now the home of our betting functionality along with the governance data functionality. 
            Governance proposals now span multiple leagues, enabling betting markets to be offered for any league in the world in which data has been brought up to date. 

            Designs for the FootballGod UI are nearly complete, with previews being released online by our designer. 

            https://x.com/DfinityDesigner/status/1859642756001571196

            We have put together the perfect one-click bet building platform based on existing market leading betting platforms, allowing users to easily build and place bets using their FPL.
            We aim to have a beta live for the start of 2025, allowing beta test users to gamble with fake FPL tokens until we receive our license.
           
            We will be signing up for an X gold account to increase the promotion of our growing football ecosystem.

            I am keen to bring on another Motoko developer to go with Thilly developing our Svelte frontends. 
            However with any new hire, there is a period of training required for our niche tech stack. 
            When Thilly is fully trained (again, requires a lot of my time), I will bring on a new developer.
            Thilly has been hard at work across our frontends, nearly completing the GolfPad UI.

            The Waterway Labs site is nearly finished, it now contains a contact section in which you can reach out to us directly if you have any questions along with emailing the team - hello@waterwaylabs.xyz
                      
            James
        \";
        action = opt variant {  
            TransferSnsTreasuryFunds = record {
                from_treasury=1:int32; 
                amount_e8s=750000000000:nat64; 
                to_principal=opt principal \"agy5w-dlcen-pkrgo-pgfrz-3eqf2-xfwvr-qcvwn-nlhyu-77fsb-wgc37-nqe\"; 
                to_subaccount = null;
                memo=null;   
            }
        };  
    })"

../../utils/submit_proposal.sh "$PROPOSAL"

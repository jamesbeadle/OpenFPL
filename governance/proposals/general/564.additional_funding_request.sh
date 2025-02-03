#!/bin/bash

# Set current directory to the directory this script is in
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

# Call the function to configure the neuron that has just been created

echo "Transfer funds Waterway Labs"

PROPOSAL="(
    record {  
        title = \"Transfer 4,000 ICP to Waterway Labs\";  
        url = \"https://waterwaylabs.xyz\";  
        summary = \"
            Waterway Labs continues to fund the obtaining of our gambling license through the hiring of Louie Connaris, an award video editor.
            
            An example of work produced by Louie would be our proof of work video to obtain the license:

            https://next.frame.io/share/3116f3f2-cd87-42c0-9c6f-5b91aad4421b/view/bbf1000a-d403-4e3b-b832-4ddf522abe21

            Louie is also working on marketing content for our upcoming 1M FPL, gameweek 29-38 competition.

            We have decided to create a seperate standalone betting site, showing a clear definition between governance of the OpenFPL ecosytem data and our AI Betting features.
            
            FootballGod will be the brain of our ecosystem, allowing users to earn FPL through managing our multileague dataset for applications like fantasy football (OpenFPL / OpenWSL) and betting (JeffBets).

            Our betting site, Jeff Bets, will be centered around our new betting features, deliverable through conversing with Jeff, our betting AI Agent.

            Our betting agent, 'Jeff', will be used within JeffBets to streamline the process of users placing bets through this new conversational AI medium but he will also bring a new approach to betting, something we find very exciting.
            'Jeff' will introduce new betting approaches using pattern-based strategies, opting for Jeff to place bets on your behalf if predefined rules are met based on in-game data.  
            This new process adds a new level of excitement to betting, with users having different bets becoming active automatically based on in game events. 
            It also ensures users never a miss a bet they would normally make, with 'Jeff' placing a bet in the background automatically after giving him a betting rule. 

            Our tagline for Jeff is:

            'JeffBets - so you don't have to'

            JeffBets has been designed by DfinityDesigner, completing the core applications to our football ecosystem. With these 3 applications, we have the required levers to pull on the ensure a non-inflationary token supply, targeting 100m FPL.

            Content around how OpenFPL, FootballGod and JeffBets will be use to manage the FPL token supply is being produced, enabling investors to be fully informed of the opportunity we see.
            
            Our new betting site github can be found here:
            https://github.com/jamesbeadle/jeffbets
           
            The football data canister that drives our ecosystem has now been handed back to the DAO, with users able to raise proposals through the footballgod player explorer:
            footballgod.xyz/players

            Videos will follow to instruct and promote participation in this process.

            Due to market volatility, increasing expenditure as we grow and the important time the company finds itself proving itself as a going concern to obtain our gambling license, further funding requests will follow.
             
        \";
        action = opt variant {  
            TransferSnsTreasuryFunds = record {
                from_treasury=1:int32; 
                amount_e8s=400000000000:nat64; 
                to_principal=opt principal \"agy5w-dlcen-pkrgo-pgfrz-3eqf2-xfwvr-qcvwn-nlhyu-77fsb-wgc37-nqe\"; 
                to_subaccount = null;
                memo=null;   
            }
        };  
    })"

../../utils/submit_proposal.sh "$PROPOSAL"

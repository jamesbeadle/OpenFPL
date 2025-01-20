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
            Waterway Labs will be incorporated in Alderney within the few weeks, a key step in obtaining the gambling license that will enable us to offer fixed odds betting through our FootballGod platform using FPL as a utility token. 

            The betting site code is being finalised, with the site live on footballgod.xyz. You can also follow the github here:

            https://github.com/jamesbeadle/football_god
           
            We are in the process of selecting and evaluating KYC providers for our license requirements, this coupled with the existing footballgod betting features will be used to produce a 90 second walkthrough final product video.
            This video will be used by our prospective business representatives in Alderney to justify the going concern of Waterway Labs by showcasing our first of many products.
            
            We recently expanded our team to include John Nixon, an graduate with a masters in Artificial Intelligence to assist with developing next level FPL features. 
            The first major project John is undertaking is working on developing the world's first fixed odds betting agent. 

            Our betting agent, 'Jeff', will be used to streamline the process of users placing bets through this new conversational AI medium but he will also bring a new approach to betting, something we find very exciting.
            'Jeff' will introduce new betting approaches using pattern-based strategies, opting for Jeff to place bets on your behalf if predefined rules are met based on in-game data.  
            This new process adds a new level of excitement to betting, with users having different bets becoming active automatically based on in game events. 
            It also ensures users never a miss a bet they would normally make, with 'Jeff' placing a bet in the background automatically after giving him a betting rule. 

            We are committed to creating high-quality, on-brand promotional content. To do this we will be hiring a video editor, Louie, to assist in bringing together our mountain of production content into a coherant series of episodes around our FPL ecosystem.

            Our first production will be centred around staking FPL to revalue players, engaging real life Premier League clubs to vote on football player valuations through the SNS. 
            We aim to produce a ‘first-of-its-kind’, fan driven valuation of Premier League players, featuring metrics on fan participation, emphasising the power of the OpenFPL DAO. 
            
            As part of this, we will transfer the FootballGod data_canister back to the DAO. We plan to do this in the coming days as we film promotional activity, marking the beginning of a continual stream of OpenFPL proposals.
            
            Waterway Labs will also begin using Instagram heavily going forwards due to owning the clean 'OpenFPL' handle along with their announced advanced creator ecosystem features.

            We have been quoted $20,000 by X for the clean OpenFPL handle but feel our budget is better spent on promoting on platforms like Instagram due to the ease in which we can produce entertaining football related video content. 
            Obviously we would like the handle and have raised a grant proposal with DFINITY on the DAOs behalf but it may have to wait until enough revenue comes in from our other activities.

            Updates can be found through the OpenFPL X page here:

            https://x.com/openfpl_dao/status/1881423070285746259?s=46&t=lxdtEPBGF1MOnFWhOuSKeg 
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

#!/bin/bash

# Set current directory to the directory this script is in
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

PROPOSAL="(
    record {  
        title = \"Motion to adjust season prize pool.\";  
        url = \"https://github.com/jamesbeadle/openfpl/\";  
        summary = \"
            Motion to adjust the season prize pool amount from 30% of the total FPL to be won in the first season to 15%. 
            The 15% will be added to the monthly club leaderboard prize pool, 
            incentivizing people to sign up throughout the season whether or not they miss the opening gameweeks.
        \";
        action = opt variant {  
        Motion = record {  
            motion_text = \"
            Motion to adjust the season prize pool amount from 30% of the total FPL to be won in the first season to 15%. 
            The 15% will be added to the monthly club leaderboard prize pool, 
            incentivizing people to sign up throughout the season whether or not they miss the opening gameweeks.
        \";  
        }  
    };  
})"

../utils/submit_proposal.sh "$PROPOSAL"

#!/bin/bash

# Set current directory to the directory this script is in
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

PROPOSAL="(
    record {  
        title = \"Motion to introduce fantasy Womens Super League Football along side OpenFPL.\";  
        url = \"https://github.com/jamesbeadle/openfpl/\";  
        summary = \"
            Nigel Reilly has been working with Waterway Labs MD Zoe Duffy to introduce women's fantasy football to ICP. 
            The first step of this process is to fulfil the OpenChat sponsorship agreement through sponsoring Epsom & Ewell Women FC.
            This will lead to usable philanthropic content for OpenChat, OpenFPL and the general ICP ecosystem to use. 
            Women's football is also a rapidly growing market that does not have a deserved women's fantasy football game, 
            in doing this OpenFPL hope to drive more people to engage with women's football. 
            Over the past week, the Waterway Labs team has extended the application code to handle a multi-lteague environment, allowing OpenFPL to run alongside OpenWSL.
            This multi-league architecture is required in preparation to offer gambling markets for each league in the world.
            To ensure things are equal, we propose to increase the total prize pool by 250K FPL to 2 million FPL. 
            This will then be split equally between the men and the women's game.
            A article will be released shortly with content and further information through the OpenFPL X account. 
            This proposal was created under a new neuron created by Nigel for the interest of women's football, neuron ID 61d4d2cddcabf9b2c9a5c3b44e6a338365aefdff8a78739fc6b316c8d03a0ad1.
        \";
        action = opt variant {  
        Motion = record {  
            motion_text = \"
            Nigel Reilly has been working with Waterway Labs MD Zoe Duffy to introduce women's fantasy football to ICP. 
            The first step of this process is to fulfil the OpenChat sponsorship agreement through sponsoring Epsom & Ewell Women FC.
            This will lead to usable philanthropic content for OpenChat, OpenFPL and the general ICP ecosystem to use. 
            Women's football is also a rapidly growing market that does not have a deserved women's fantasy football game, 
            in doing this OpenFPL hope to drive more people to engage with women's football. 
            Over the past week, the Waterway Labs team has extended the application code to handle a multi-lteague environment, allowing OpenFPL to run alongside OpenWSL.
            This multi-league architecture is required in preparation to offer gambling markets for each league in the world.
            To ensure things are equal, we propose to increase the total prize pool by 250K FPL to 2 million FPL. 
            This will then be split equally between the men and the women's game.
            A article will be released shortly with content and further information through the OpenFPL X account. 
            This proposal was created under a new neuron created by Nigel for the interest of women's football, neuron ID 61d4d2cddcabf9b2c9a5c3b44e6a338365aefdff8a78739fc6b316c8d03a0ad1.
        \";  
        }  
    };  
})"

../../utils/submit_proposal.sh "$PROPOSAL"

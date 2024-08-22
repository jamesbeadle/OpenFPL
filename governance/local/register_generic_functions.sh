#!/bin/bash

# Set current directory to the directory this script is in
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

#Register generic proposal functions

echo "Register Generic Proposal Function 5 with SNS"

PROPOSAL="(
    record {
        title = \"Create SubmitFixtureData Callback Function\";          
        url = \"https://github.com/jamesbeadle/OpenFPL/blob/master/src/OpenFPL_backend/main.mo\";        
        summary = \"Proposal to create the endpoint for adding the callback function for submitting Premier League match fixture data.\";
        action = opt variant {
            AddGenericNervousSystemFunction = record {
                id = 3000 : nat64;
                name = \"Add SubmitFixtureData Callback Function\";
                description = opt \"Proposal to create the endpoint for adding the callback function for submitting Premier League match fixture data.\";
                function_type = opt variant { 
                    GenericNervousSystemFunction = record { 
                        validator_canister_id = opt principal \"bd3sg-teaaa-aaaaa-qaaba-cai\"; 
                        target_canister_id = opt principal \"bd3sg-teaaa-aaaaa-qaaba-cai\"; 
                        validator_method_name = opt \"validateSubmitFixtureData\";                         
                        target_method_name = opt \"executeSubmitFixtureData\";
                    } 
                };
            }
        };
    }
)"

./submit_proposal.sh "$PROPOSAL"
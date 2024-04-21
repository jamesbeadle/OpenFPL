#!/bin/bash

# Set current directory to the directory this script is in
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR


PROPOSAL="(
    record {
        title = \"Create AddNewToken Callback Function\";          
        url = \"https://github.com/jamesbeadle/OpenFPL/blob/master/src/OpenFPL_backend/main.mo\";        
        summary = \"Proposal to create the endpoint for adding the callback function to add a new ICRC-1 token for use as a currency within the private leagues feature.\";
        action = opt variant {
            AddGenericNervousSystemFunction = record {
                id = 19000 : nat64;
                name = \"Add AddNewToken Callback Function.\";
                description = opt \"Proposal to create the endpoint for adding the callback function to add a new ICRC-1 token for use as a currency within the private leagues feature.\";
                function_type = opt variant { 
                    GenericNervousSystemFunction = record { 
                        validator_canister_id = opt principal \"bboqb-jiaaa-aaaal-qb6ea-cai\"; 
                        target_canister_id = opt principal \"bboqb-jiaaa-aaaal-qb6ea-cai\"; 
                        validator_method_name = opt \"validateAddNewToken\";                         
                        target_method_name = opt \"executeAddNewToken\";
                    } 
                };
            }
        };
    }
)"

../utils/submit_proposal.sh "$PROPOSAL"
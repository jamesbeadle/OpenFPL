

# Set current directory to the directory this script is in
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

PROPOSAL="(
    record {
        title = \"Create CreatePlayer Callback Function\";          
        url = \"https://github.com/jamesbeadle/OpenFPL/blob/master/src/OpenFPL_backend/main.mo\";        
        summary = \"Proposal to create the endpoint for adding the callback function to create a new player.\";
        action = opt variant {
            AddGenericNervousSystemFunction = record {
                id = 22000 : nat64;
                name = \"Add CreatePlayer Callback Function\";
                description = opt \"Proposal to create the endpoint for adding the callback function to create a new player.\";
                function_type = opt variant { 
                    GenericNervousSystemFunction = record { 
                        validator_canister_id = opt principal \"bboqb-jiaaa-aaaal-qb6ea-cai\"; 
                        target_canister_id = opt principal \"bboqb-jiaaa-aaaal-qb6ea-cai\"; 
                        validator_method_name = opt \"validateCreatePlayer\";                         
                        target_method_name = opt \"executeCreatePlayer\";
                    } 
                };
            }
        };
    }
)"

../utils/submit_proposal.sh "$PROPOSAL"

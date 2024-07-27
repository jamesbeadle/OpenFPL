

# Set current directory to the directory this script is in
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

PROPOSAL="(
    record {
        title = \"Create PromoteNewClub Callback Function\";          
        url = \"https://github.com/jamesbeadle/OpenFPL/blob/master/src/OpenFPL_backend/main.mo\";        
        summary = \"Proposal to create the endpoint for adding the callback function to add a promoted championship team.\";
        action = opt variant {
            AddGenericNervousSystemFunction = record {
                id = 23000 : nat64;
                name = \"Promote New Club\";
                description = opt \"Add Promoted Championship Team.\";
                function_type = opt variant { 
                    GenericNervousSystemFunction = record { 
                        validator_canister_id = opt principal \"bd3sg-teaaa-aaaaa-qaaba-cai\"; 
                        target_canister_id = opt principal \"bd3sg-teaaa-aaaaa-qaaba-cai\"; 
                        validator_method_name = opt \"validatePromoteNewClub\";                         
                        target_method_name = opt \"executePromoteNewClub\";
                    } 
                };
            }
        };
    }
)"

./submit_proposal.sh "$PROPOSAL"
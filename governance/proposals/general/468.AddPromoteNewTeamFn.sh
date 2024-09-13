

# Set current directory to the directory this script is in
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

PROPOSAL="(
    record {
        title = \"Create Generic SNS Function to commit proposed frontend changes.\";          
        url = \"https://github.com/jamesbeadle/OpenFPL/blob/master/src/OpenFPL_frontend\";        
        summary = \"Proposal to Create Generic SNS Function to commit proposed frontend changes.\";
        action = opt variant {
            AddGenericNervousSystemFunction = record {
                id = 24000 : nat64;
                name = \"Commit Frontend Canister Update\";
                description = opt \"Commit updated frontend canister with computed evidence.\";
                function_type = opt variant { 
                    GenericNervousSystemFunction = record { 
                        validator_canister_id = opt principal \"bgpwv-eqaaa-aaaal-qb6eq-cai\"; 
                        target_canister_id = opt principal \"bgpwv-eqaaa-aaaal-qb6eq-cai\"; 
                        validator_method_name = opt \"validate_commit_proposed_batch\";                         
                        target_method_name = opt \"commit_proposed_batch\";
                    } 
                };
            }
        };
    }
)"

../utils/submit_proposal.sh "$PROPOSAL"

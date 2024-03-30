
#!/bin/bash

# Set current directory to the directory this script is in
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

# Call the function to configure the neuron that has just been created

echo "Configure DAO Controlled Neuron"

PROPOSAL="(
    record {
        title = \"Configure DAO Controlled Neuron\";          
        url = \"https://github.com/jamesbeadle/OpenFPL/blob/master/src/OpenFPL_backend/main.mo\";        
        summary = \"Proposal to configure the DAO controlled neuron with balance of 1 ICP.\";
        action = opt variant {
            ExecuteGenericNervousSystemFunction = record {
                function_id = 20000:nat64;
                payload = vec {}
            }
        };
    }
)"

../utils/submit_proposal.sh "$PROPOSAL"
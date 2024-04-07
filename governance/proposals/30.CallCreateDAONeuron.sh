#!/bin/bash

# Set current directory to the directory this script is in
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

echo "Create DAO Neuron"

PROPOSAL="(
    record {  
        title = \"Create DAO Controlled Neuron with 1 ICP\";  
        url = \"https://openfpl.xyz/whitepaper/\";  
        summary = \"This proposal will create a DAO controlled neuron through calling the registered generic function CreateDAONeuron\";
        action = opt variant {  
            ExecuteGenericNervousSystemFunction = record {  
                function_id=19000;
                payload=null;
            }  
        };  
    })"

../utils/submit_proposal.sh "$PROPOSAL"

#On completion use OpenFPL Backend to obtain neuron id
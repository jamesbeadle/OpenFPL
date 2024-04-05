#!/bin/bash

# Set current directory to the directory this script is in
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

# Call the function to configure the neuron that has just been created

echo "Stake NNS Neuron"
export $WASM_PATH="/home/user/new_wasm.wasm"

PROPOSAL="(
    record {  
        title = \"Update Backend Wasm V1.\";  
        url = \"https://app.icpswap.com/\";  
        summary = \"
            We (the OpenFPL team) propose to add liquidity to the FPL/ICP pool on ICPSwap.
            Following this motion proposal we will submit 2 additional proposals to transfer 8,100 ICP and 1,000,000 FPL respectively to the FPL/ICP Swap canister owned by ICPSwap (yco2w-2iaaa-aaaag-qjqoa-cai).
            The destination account for both of these transfers will be the same (but on 2 different ledgers) and is as follows:
            
            Principal yco2w-2iaaa-aaaag-qjqoa-cai
            SubAccount:
            [10, 0, 0, 0, 0, 2, 0, 0, 160, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 , 0, 0, 0, 0, 0, 0, 0] (this is the Subaccount generated from the OpenFPL governance canister Id, detjl-sqaaa-aaaaq-aacqa-cai)

            Liquidity funds are controlled by OpenFPL governance canister.
            
            @ICPSwap will tweet to verify that these details are correct.
            
            If these proposals pass, ICPSwap will then add the funds to the liquidity pool. Half of the funds transferred will provide liquidity in the
            full range and the other half will provide liquidity in the range of 0.001 ICP to 0.03 ICP per FPL.
            
            Subsequent proposals can be made to add more liquidity or to adjust the ranges if the price of FPL moves significantly.
        \";
        action = opt variant {  
        Motion = record {  
        
            motion_text = \"
            We (the OpenFPL team) propose to add liquidity to the FPL/ICP pool on ICPSwap.
            Following this motion proposal we will submit 2 additional proposals to transfer 8,100 ICP and 1,000,000 FPL respectively to the FPL/ICP Swap canister owned by ICPSwap (yco2w-2iaaa-aaaag-qjqoa-cai).
            The destination account for both of these transfers will be the same (but on 2 different ledgers) and is as follows:
            
            Principal yco2w-2iaaa-aaaag-qjqoa-cai
            SubAccount:
            [10, 0, 0, 0, 0, 2, 0, 0, 160, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 , 0, 0, 0, 0, 0, 0, 0] (this is the Subaccount generated from the OpenFPL governance canister Id, detjl-sqaaa-aaaaq-aacqa-cai)

            Liquidity funds are controlled by OpenFPL governance canister.
            
            @ICPSwap will tweet to verify that these details are correct.
            
            If these proposals pass, ICPSwap will then add the funds to the liquidity pool. Half of the funds transferred will provide liquidity in the
            full range and the other half will provide liquidity in the range of 0.001 ICP to 0.03 ICP per FPL.
            
            Subsequent proposals can be made to add more liquidity or to adjust the ranges if the price of FPL moves significantly.
        \";  
            
        }  
    };  
    })"

../utils/submit_proposal.sh "$PROPOSAL"

#On completion use OpenFPL Backend to obtain neuron id


quill sns make-upgrade-canister-proposal --target-canister-id "4ijyc-kiaaa-aaaaf-aaaja-cai" --wasm-path $WASM_PATH $PROPOSAL_NEURON_ID > message.json
quill send message.json
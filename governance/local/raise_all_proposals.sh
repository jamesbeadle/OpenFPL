
export PROPOSER_NEURON_ID=07cc5979857a5c037e2b980817bbd4dafea28675c0b57cf6f19c07795662e954
export NETWORK=local
export IDENTITY=default
export IC_URL=http://localhost:8080

export WASM_FOLDER="../wasms"

dfx canister call neuron_controller init
dfx identity use ic_admin
OWNER_IDENTITY=$(dfx identity whoami)
export PEM_FILE="$(readlink -f "$HOME/.config/dfx/identity/${OWNER_IDENTITY}/identity.pem")"


./governance/local/UpgradeBackend.sh
#./governance/local/99.TestPlayerProposal.sh


# ./governance/local/23.update_token_image.sh
#./governance/local/removefns.sh
#./governance/local/1-21.register_generic_functions.sh

# ./governance/local/31.RegisterNewToken.sh

#dfx identity use default
#dfx canister update-settings neuron_controller --add-controller b77ix-eeaaa-aaaaa-qaada-cai
#dfx identity use ic_admin
# ./governance/local/register_canister_with_sns.sh br5f7-7uaaa-aaaaa-qaaca-cai "Register neuron_controller as an SNS controlled canister." "https://github.com/jamesbeadle/OpenFPL/blob/master/src/neuron_controller/actor.mo" "This canister is responsible for controlling the DAO's first neuron."

# ./governance/local/26.ICPSwapTransferICP.sh
# ./governance/local/27.ICPSwapTransferFPL.sh

# #Add New token generic callback function
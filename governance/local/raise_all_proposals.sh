
export PROPOSER_NEURON_ID=b4630d2345187c03a80e19fd43d9384c194d598fefd54acb298a6421a484c0e1
export NETWORK=local
export IDENTITY=default
export IC_URL=http://localhost:8080

export WASM_FOLDER="../wasms"

dfx identity use default
OWNER_IDENTITY=$(dfx identity whoami)
export PEM_FILE="$(readlink -f "$HOME/.config/dfx/identity/${OWNER_IDENTITY}/identity.pem")"


#./governance/local/register_add_player.sh
#./governance/local/UpgradeBackend.sh

#./governance/local/417.AddFixtureData_1.sh
#./governance/local/138.PromoteSouthampton.sh
#./governance/local/142.Add2024Fixtures.sh
#./governance/local/99.TestPlayerProposal.sh


 ./governance/local/23.update_token_image.sh
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
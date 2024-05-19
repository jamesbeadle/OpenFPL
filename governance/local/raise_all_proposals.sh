
export PROPOSER_NEURON_ID=f5da8b3e3653bf452f4c1f8a3267d15a5bb2b64c3c4a85217df0341eab69a947
export NETWORK=local
export IDENTITY=default
export IC_URL=http://localhost:8080

export WASM_FOLDER="../wasms"

dfx canister call neuron_controller init
dfx identity use ic_admin
OWNER_IDENTITY=$(dfx identity whoami)
export PEM_FILE="$(readlink -f "$HOME/.config/dfx/identity/${OWNER_IDENTITY}/identity.pem")"

./governance/local/CallCreateDAONeuron.sh
exit 1

#Raise all live proposals
./governance/local/23.update_token_image.sh

#Add all generic functions
 ./governance/local/1-21.register_generic_functions.sh
Neuron already created
# #Add SNS root as a controller to neuron controller canister
dfx identity use default
 dfx canister update-settings neuron_controller --add-controller b77ix-eeaaa-aaaaa-qaada-cai
dfx identity use ic_admin

# #Register neuron controller canister
 ./governance/local/register_canister_with_sns.sh br5f7-7uaaa-aaaaa-qaaca-cai "Register neuron_controller as an SNS controlled canister." "https://github.com/jamesbeadle/OpenFPL/blob/master/src/neuron_controller/actor.mo" "This canister is responsible for controlling the DAO's first neuron."

# #Transfer treasury funds x 2
 ./governance/local/26.ICPSwapTransferICP.sh
 ./governance/local/27.ICPSwapTransferFPL.sh

# #Add New token generic callback function
 ./governance/local/31.RegisterNewToken.sh
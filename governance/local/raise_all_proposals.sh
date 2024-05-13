
#Raise all live proposals
./governance/local/23.update_token_image.sh

#Add all generic functions
./governance/local/1-21.register_generic_functions.sh

#Add SNS root as a controller to neuron controller canister
dfx canister update-settings neuron_controller --add-controller by6od-j4aaa-aaaaa-qaadq-cai

#Register neuron controller canister
./governance/local/register_canister_with_sns.sh br5f7-7uaaa-aaaaa-qaaca-cai "Register neuron_controller as an SNS controlled canister." "https://github.com/jamesbeadle/OpenFPL/blob/master/src/neuron_controller/actor.mo" "This canister is responsible for controlling the DAO's first neuron."

#Transfer treasury funds x 2
./governance/local/26.ICPSwapTransferICP.sh
./governance/local/27.ICPSwapTransferFPL.sh

#Add New token generic callback function
./governance/local/31.RegisterNewToken.sh

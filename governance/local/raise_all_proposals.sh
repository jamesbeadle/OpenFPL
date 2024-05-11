
#Raise all live proposals
./governance/proposals/23.update_token_image.sh

#Add all generic functions
./governance/proposals/1-21.register_generic_functions.sh

#Add SNS root as a controller to neuron controller canister
dfx canister update-settings neuron_controller --add-controller b77ix-eeaaa-aaaaa-qaada-cai

#Register neuron controller canister
./governance/proposals/register_canister_with_sns.sh br5f7-7uaaa-aaaaa-qaaca-cai "Register neuron_controller as an SNS controlled canister." "https://github.com/jamesbeadle/OpenFPL/blob/master/src/neuron_controller/actor.mo" "This canister is responsible for controlling the DAO's first neuron."

#Transfer treasury funds x 2
./governance/proposals/26.ICPSwapTransferICP.sh
./governance/proposals/26.ICPSwapTransferFPL.sh

#Add New token generic callback function
./governance/proposals/31.RegisterNewToken.sh

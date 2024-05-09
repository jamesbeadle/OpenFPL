
#Raise all live proposals

#Add all generic functions
../proposals/1-21.register_generic_functions.sh

#Register neuron controller canister
../proposals/register_canister_with_sns.sh br5f7-7uaaa-aaaaa-qaaca-cai "Register neuron_controller as an SNS controlled canister." "https://github.com/jamesbeadle/OpenFPL/blob/master/src/neuron_controller/actor.mo" "This canister is responsible for controlling the DAO's first neuron."

#Transfer treasury funds x 2
../proposals/26.ICPSwapTransferICP.sh
../proposals/26.ICPSwapTransferFPL.sh

#Add New token generic callback function
../proposals/31.RegisterNewToken.sh

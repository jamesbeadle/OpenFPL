
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

../register_canister_with_sns.sh 52fzd-2aaaa-aaaal-qmzsa-cai "Register Football Data Canister as an SNS controlled canister." "https://github.com/jamesbeadle/football_god/blob/master/src/data_canister/main.mo" "This canister holds the FPL governance dataset used for all our applications including OpenFPL, FootballGod and JeffBets."
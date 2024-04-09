IDENTITY=${1:-default}

SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR/..

PRINCIPAL=$(dfx --identity $IDENTITY identity get-principal)

./scripts/download-nns-canister-wasm.sh icrc_ledger ic-icrc1-ledger
dfx --identity $IDENTITY canister create --no-wallet --with-cycles 100000000000000 test_ledger
dfx --identity $IDENTITY canister install test_ledger --wasm ./wasms/icrc_ledger.wasm.gz --argument "(variant { Init = record {
    minting_account = record { owner = principal \"$PRINCIPAL\" };
    transfer_fee = 10000:nat64;
    decimals = 8:nat8;
    token_symbol = \"TEST\";
    token_name = \"Test\";
    metadata = vec { };
    initial_balances = vec {};
    archive_options = record {
        num_blocks_to_archive = 1000:nat64;
        trigger_threshold = 1000:nat64;
        controller_id = principal \"$PRINCIPAL\";
    };
}})"

LEDGER_CANISTER_ID=$(dfx canister id test_ledger)

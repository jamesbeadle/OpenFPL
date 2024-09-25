set -euo pipefail

cd -- "$(dirname -- "${BASH_SOURCE[0]}")"

export SNS_CONFIGURATION_FILE_PATH="${1:-sns_init.yaml}"

. ./constants.sh normal

export CURRENT_DX_IDENT="$(dfx identity whoami)"

dfx identity use default

sns propose \
    --network "${NETWORK}" \
    --test-neuron-proposer \
    "${SNS_CONFIGURATION_FILE_PATH}"

dfx canister --network "${NETWORK}" \
    call nns-sns-wasm list_deployed_snses '(record {})' \
    | idl2json \
    > sns-wasm-list_deployed_snses-response.json
NUM_SNS_INSTANCES=$(jq '.instances | length' sns-wasm-list_deployed_snses-response.json)

# Need to flatten the JSON to make it compatible with quill
jq '.instances[-1] | .[] |= .[0]' \
    sns-wasm-list_deployed_snses-response.json \
        > sns_canister_ids.json

# Switch back to the previous identity
dfx identity use "${CURRENT_DX_IDENT}"
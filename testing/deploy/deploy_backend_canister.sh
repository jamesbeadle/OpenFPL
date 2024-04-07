
#!/usr/bin/env bash

set -euo pipefail

cd -- "$(dirname -- "${BASH_SOURCE[0]}")"

. ./constants.sh normal

export NAME="OpenFPL_backend"
export WASM_FILE_NAME="${NAME}.wasm"
export WASM_LOCATION="../../.dfx/${DX_NETWORK}/canisters/${NAME}"
export WASM="${WASM_LOCATION}/OpenFPL_backend.wasm"

if [ -f "./sns_canister_ids.json" ]
then
    ./deploy_dapp.sh "OpenFPL_backend" "${WASM}" "(opt record {sns_governance = opt principal\"${SNS_GOVERNANCE_CANISTER_ID}\";})"
else
    ./deploy_dapp.sh "OpenFPL_backend" "${WASM}" "(opt record {sns_governance = null;})"
fi

#!/usr/bin/env bash

set -euo pipefail

cd -- "$(dirname -- "${BASH_SOURCE[0]}")"

. ./constants.sh normal

if [ -f "./sns_canister_ids.json" ]
then
    ./upgrade_dapp.sh "OpenFPL_frontend" "" "(opt record {sns_governance = opt principal\"${SNS_GOVERNANCE_CANISTER_ID}\";})"
    ./upgrade_dapp.sh "OpenFPL_backend" "" "(opt record {sns_governance = opt principal\"${SNS_GOVERNANCE_CANISTER_ID}\";})"
else
    ./upgrade_dapp.sh "OpenFPL_frontend" "" "(opt record {sns_governance = null;})"
    ./upgrade_dapp.sh "OpenFPL_backend" "" "(opt record {sns_governance = null;})"
fi
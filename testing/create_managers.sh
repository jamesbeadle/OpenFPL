#!/usr/bin/env bash

set -euo pipefail

cd -- "$(dirname -- "${BASH_SOURCE[0]}")"


export NUM_MANAGERS="${1:-100}"

for (( c=0; c<${NUM_MANAGERS}; c++ ))
do
  export ID="$(printf "%03d" ${c})"
  export NEW_DX_IDENT="participant-${ID}"
  dfx identity new --storage-mode=plaintext "${NEW_DX_IDENT}" 2>/dev/null || true
  dfx identity use "${NEW_DX_IDENT}"

  dfx canister --network "${NETWORK}" \
    call saveFantasyTeam '(record {})' \
    | idl2json \
    > save_fantasy_team_response.json
  
  #in case you need pem file
  export PEM_FILE="$(readlink -f ~/.config/dfx/identity/${NEW_DX_IDENT}/identity.pem)"  
done

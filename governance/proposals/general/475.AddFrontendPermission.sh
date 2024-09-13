
#!/bin/bash
echo begin

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Update Frontend Canister Permissions."
SUMMARY="Update the frontend canister permissions, adding commit permissions for the governance canister."
URL="https://openfpl.xyz"

CANISTER_NAME=OpenFPL_frontend
NETWORK="ic"

# Get the target canister id
TARGET_CANISTER_ID=$(dfx -qq canister --network $NETWORK id $CANISTER_NAME)

dfx identity use ic_admin
OWNER_IDENTITY=$(dfx identity whoami)
PEM_FILE="$(readlink -f "$HOME/.config/dfx/identity/${OWNER_IDENTITY}/identity.pem")"
PROPOSER_NEURON_ID=d2ccf59abe1741c21c35da7e3863d5d14c97d9b82b36045f4a8d4c336864f6dc

UPGRADE_ARG="(opt variant {
  Upgrade = record {
    set_permissions = opt record {
      prepare = vec {
        principal \"detjl-sqaaa-aaaaq-aacqa-cai\";
        principal \"4jijx-ekel7-4t2kx-32cyf-wzo3t-i4tas-qsq4k-ujnug-oxke7-o5aci-eae\"
      };
      commit = vec { principal \"detjl-sqaaa-aaaaq-aacqa-cai\"}; 
      manage_permissions = vec { principal \"detjl-sqaaa-aaaaq-aacqa-cai\"}
    }
  }
})"

echo UPGRADE_ARG
# Make the proposal using quill
quill sns --canister-ids-file ../../utils/sns_canister_ids.json --pem-file $PEM_FILE make-upgrade-canister-proposal  --title "$TITLE" --url "$URL" --summary "$SUMMARY"  $PROPOSER_NEURON_ID  --target-canister-id $TARGET_CANISTER_ID --wasm-path '../../../.dfx/ic/canisters/OpenFPL_frontend/assetstorage.wasm.gz' --canister-upgrade-arg "$UPGRADE_ARG" > msg.json
quill send msg.json
rm -f msg.json


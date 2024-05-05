# OpenFPL

## Summary

OpenFPL is a decentralised fantasy football application built on the Internet Computer blockchain using Motoko, Svelte, TypeScript & Tailwind CSS.

## Features

- Unique Gameplay: A wide range of gameplay rules mirroring the varying elements of the football gameplay.
- Fully Decentralised: Built to run as a DAO using the IC's Service Nervous System (SNS).
- Consensus Data: Runs fully on-chain using "consensus data" to take ownership of Premier League football data.
- Private Leagues: Build your own customised community & rewards structure and play among your friends.

## Prerequisites

These steps assume that you already run IC projects within a local development environment, ensuring you have the experience to test this application.

More information about the Internet Computer blockchain can be found at https://internetcomputer.org.

## Install SNS

To run OpenFPL you will need to setup a local version of the NNS containing the FPL utility token with users after the SNS sale.

To get to this state follow these steps:

1. Clone OpenFPL & the sns testing repo into your linux root directory:

```bash
git clone https://github.com/jamesbeadle/OpenFPL.git
```

```bash
git clone https://github.com/dfinity/sns-testing.git
```

2. Load the sns-testing solution in VSCode and run the following command:

```bash
./install.sh
```

2. In a separate linux terminal, from the sns-testing directory, run the following command:

```bash
./setup_locally.sh
```

Overwrite any existing canisters if the terminal asks by using the 'y' key.

Make note of the deployed SNS governance canister id from the sns_canister_ids.json file.

3. In the sns-testing solution VSCode terminal run the following command to set the ICP/XDR exchange rate:

```bash
./set-icp-xdr-rate.sh 10000
```

4. Load the OpenFPL solution in VSCode and deploy the application using the following command:

```dfx deploy --network=local

```

Make note of the frontend and backend canister ids.

5. Withing the OpenFPL repository, update the frontend and backend canister ids listed as DAO controlled canisters within sns_init.yaml.

6. Deploy the SNS from the sns-testing repository by running the following commands:

```
 SNS_GOVERNANCE_CANISTER_ID="<INSERT DEPLOYED SNS GOVERNANCE CANISTER ID>"
NUM_PARTICIPANTS=100
ICP_PER_PARTICIPANT=10000
./let_nns_control_dapp.sh
./propose_sns.sh
./participate_sns_swap.sh $NUM_PARTICIPANTS $ICP_PER_PARTICIPANT
```

7. You can then access the NNS containing OpenFPL from the following link:

http://qsgjb-riaaa-aaaaa-aaaga-cai.localhost:8080/

Create a new test user and make a note of their principal id.

8. Mint FPL tokens for your users by running the following command:

dfx canister call "${SNS_GOVERNANCE_CANISTER_ID}" mint_tokens "(record{recipient=opt record{owner=opt principal \"${PRINCIPAL}\"};amount_e8s=opt 1_0000_000_000_000_000:opt nat64})" --network "$NETWORK"

Now stake the tokens and when raising propsals with this user they will pass immediately.

9. Run dfx identity get-principal to get the principal of the current dfx user. Add this user as a hotkey to your initially created user.

10. Run the create SNS setup files script

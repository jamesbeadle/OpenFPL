# OpenFPL

## Summary

OpenFPL is a decentralised fantasy football application built on the Internet Computer blockchain using Motoko, Svelte, TypeScript & Tailwind CSS.

## Features

- Unique Gameplay: A wide range of gameplay rules mirroring the varying elements of football gameplay.
- Fully Decentralised: Built to run as a DAO using the IC's Service Nervous System (SNS).
- Consensus Data: Runs fully on-chain using "consensus data" to take ownership of Premier League football data.
- Private Leagues: Build your own customised community & rewards structure and play among your friends.

## Prerequisites

These steps assume that you already run IC projects within a local development environment, ensuring you have the experience to test this application.

More information about the Internet Computer blockchain can be found at https://internetcomputer.org.

## Setup Locally

To run OpenFPL you will need to setup a local version of the NNS containing the FPL utility token with users after the SNS sale.

To get to this state follow these steps:

1. Clone OpenFPL & the sns-testing repo into your linux root directory:

```bash
git clone https://github.com/jamesbeadle/OpenFPL.git
```

```bash
git clone https://github.com/dfinity/sns-testing.git
```

2. Load a linux terminal window, navigate to the sns-testing directory and run the following commands:

```bash
./install.sh
```

```bash
./cleanup.sh
```

3. Load a second linux terminal, navigate to the OpenFPL director and run:

```bash
./run_local_setup.sh
```

4. Within the first sns-testing linex terminal, run the following command:

```bash
./setup_locally.sh
```

Overwrite any existing canisters if the terminal asks by using the 'y' key.

Make note of the deployed SNS governance canister id from the sns_canister_ids.json file.

3. In the same sns-testing linux terminal, run the following command:

```bash
./set-icp-xdr-rate.sh 10000
```

4. Load the OpenFPL solution in VSCode and deploy the application using the following command:

```bash
dfx deps pull
dfx deps init
dfx deps deploy
dfx deploy --network=local
```

Make note of the frontend and backend canister ids.

5. Within the OpenFPL repository, update the frontend and backend canister ids listed as DAO controlled canisters within sns_init.yaml.

6. Deploy the SNS from the sns-testing repository by running the following commands, replacing the SNS governance canister id:

```bash
SNS_GOVERNANCE_CANISTER_ID="<INSERT DEPLOYED SNS GOVERNANCE CANISTER ID>"
NUM_PARTICIPANTS=100
ICP_PER_PARTICIPANT=10000
./let_nns_control_dapp.sh
./propose_sns.sh
./participate_sns_swap.sh $NUM_PARTICIPANTS $ICP_PER_PARTICIPANT
```

7. You can then access the NNS containing OpenFPL from http://qsgjb-riaaa-aaaaa-aaaga-cai.localhost:8080/.

8. Create a new test user in the local NNS and make a note of their principal id.

9. Mint FPL tokens for your users by running the following command:

```bash
dfx canister call "${SNS_GOVERNANCE_CANISTER_ID}" mint_tokens "(record{recipient=opt record{owner=opt principal \"${PRINCIPAL}\"};amount_e8s=opt 1_0000_000_000_000_000:opt nat64})" --network "$NETWORK"
```

10. Stake the tokens so when you raise a proposal it will pass immediately.

11. Make a note of the identity of your current dfx user by running:

```bash
dfx identity get-principal
```

12. Add the dfx user principal as a hotkey to your local NNS user's OpenFPL neuron.

13. Within the OpenFPL VS Code terminal, run the following command:

```bash
./run_local_setup.sh
```

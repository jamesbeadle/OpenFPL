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

4. Within the first sns-testing linux terminal, run the following command:

```bash
./setup_locally.sh
```

Overwrite any existing canisters if the terminal asks by using the 'y' key.

5. In the same sns-testing linux terminal, run the following command:

```bash
./set-icp-xdr-rate.sh 10000
```

6. Load the OpenFPL solution in VSCode and deploy the application using the following command:

```bash
dfx deploy --network=local
```

Make note of the frontend, backend and neuron controller canister ids.

7. Within the OpenFPL repository, update the frontend and backend canister ids listed as DAO controlled canisters within sns_init.yaml.

8. Make a copy of the sns_init.yaml in the OpenFPL root directory into the sns-testing root directory.

9. Deploy the SNS from the sns-testing repository by running the following commands:

```bash
NUM_PARTICIPANTS=100
ICP_PER_PARTICIPANT=10000
./let_nns_control_dapp.sh
./propose_sns.sh
./participate_sns_swap.sh $NUM_PARTICIPANTS $ICP_PER_PARTICIPANT
```

10. Make note of the deployed SNS governance canister id from the sns_canister_ids.json file. It will be the value for key "governance_canister_id". Then run the following command within the sns-testing terminal, replacing the canister id with your deployed governance canister id:

```bash
NETWORK=local
SNS_GOVERNANCE_CANISTER_ID="a3shf-5eaaa-aaaaa-qaafa-cai"
```

11. You can then access the NNS containing OpenFPL from http://qsgjb-riaaa-aaaaa-aaaga-cai.localhost:8080/.

12. Create a new test user in the local NNS and make a note of their principal id. Set the principal id, updating the value to your local user's principal id:


```bash
PRINCIPAL="2syo2-cf2ig-ptf4n-75gqo-gq657-7nwon-qoik3-2ttyo-njnnf-ys33z-qqe"
```

13. Mint FPL tokens for your users by running the following command:

```bash
dfx canister call "${SNS_GOVERNANCE_CANISTER_ID}" mint_tokens "(record{recipient=opt record{owner=opt principal \"${PRINCIPAL}\"};amount_e8s=opt 1_0000_000_000_000_000:opt nat64})" --network "$NETWORK"
```
14. Stake the tokens so when you raise a proposal it will pass immediately.

15. Make a note of the identity of your current dfx user by running:

```bash
dfx identity get-principal
```

16. Add the dfx user principal as a hotkey to your local NNS user's OpenFPL neuron.

17. Add the neuron id to the command below and run it inside the OpenFPL VS Code terminal:


```bash

export PROPOSER_NEURON_ID=18f84f58433627de8c490ed739371ed40e1c185587b272591525a3027b9e50cc
export NETWORK=local
export IDENTITY=default
export IC_URL=http://localhost:8080

export PEM_FILE=../../../.config/dfx/identity/default/identity.pem
export WASM_FOLDER="../wasms"

```
18. Within the ./governance/local/raise_all_proposals.sh update the neuron controller canister id.

19. Within the OpenFPL VS Solution, from the root director, run the following command to raise all proposals existing in the live DAO:

```bash
./governance/local/raise_all_proposals.sh
```

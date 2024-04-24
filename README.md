# OpenFPL

## Summary

OpenFPL is a decentralised fantasy football application built on the Internet Computer blockchain using Svelte, TypeScript & Motoko.

## Features

- Unique Gameplay: A wide range of gameplay rules mirroring the varying elements of the football gameplay.
- Fully Decentralised: Built to run as a DAO using the IC's Service Nervous System (SNS).
- Consensus Data: Runs fully on-chain using "consensus data" to take ownership of Premier League football data.

## Prerequisites

These steps assume that you already run IC projects within a local development environment, ensuring you have the experience to test this application.

More information about the Internet Computer blockchain can be found at https://internetcomputer.org.

## Install SNS

To run OpenFPL you will need to setup a local version of the NNS containing the FPL utility token with users after the SNS sale. To get to this state follow these steps:

1. Clone the sns testing repo into your linux root directory:

```bash
git clone https://github.com/dfinity/sns-testing.git
```
2. Clone the OpenFPL repository:

```bash
git clone https://github.com/jamesbeadle/OpenFPL.git
```
SNS_TESTING_INSTANCE=$(
   docker run -p 8000:8000 -p 8080:8080 -v "`pwd`":/dapp -d ghcr.io/dfinity/sns-testing:main dfx start --clean
)
while ! docker logs $SNS_TESTING_INSTANCE 2>&1 | grep -m 1 'Dashboard:'
do
   echo "Awaiting local replica ..."
   sleep 3
done

docker exec -it $SNS_TESTING_INSTANCE bash setup_locally.sh

docker kill $SNS_TESTING_INSTANCE

docker exec -it $SNS_TESTING_INSTANCE bash

./cleanup.sh  # from Bash

SNS_TESTING_INSTANCE=$(
   docker run -p 8000:8000 -p 8080:8080 -v "`pwd`":/dapp -d ghcr.io/dfinity/sns-testing:main dfx start --clean
)
while ! docker logs $SNS_TESTING_INSTANCE 2>&1 | grep -m 1 'Dashboard:'
do
   echo "Awaiting local replica ..."
   sleep 3
done



3. Navigate to the  directory:

```bash
cd OpenFPL
```

If using npm:

```bash
npm install
```

If using yarn:

```bash
yarn install
```

3. Deploy the application:

```bash
dfx deploy --network=local
```

2. Within the CanisterIds.mo file, update MAIN_CANISTER_LOCAL_ID to your deployed OpenFPL_backend canister.

3. Redeploy the OpenFPL_backend file with the updated canister.

4. Fabricate some cycles for the main backend canister:

```bash
dfx ledger fabricate-cycles --canister OpenFPL_backend
```

5. Load the OpenFPL_backend canister init() function through the backend candid interface.

6. Test the current state of the live app by connecting with your internet identity and updating your profile information.

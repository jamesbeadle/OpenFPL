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

## Installation

1. Clone the repository:

```bash
git clone https://github.com/jamesbeadle/OpenFPL.git
```
2. Navigate to the directory:
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
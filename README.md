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
cd OpenFPL
# If using npm
npm install

# If using yarn
yarn install
```

Running the Application
To run the application, follow these steps:

```bash
Run dfx deploy to deploy the Main canister and frontend canister.
Within the CanisterIds.mo file update the local canister ids to the deployed canister ids.
Within the Environment.mo ensure that you have set your network to local.
Redeploy the application with the updated canister id and environment files.
dfx ledger fabricate-cycles --canister OpenFPL_backend
Within the admin dashboard call the init function to create the initial set of Premier League teams.
Test creating a user through the profile section
Copy code
# Command to start the application
npm start
Seed the system with fixtures via the "Add Initial Fixtures" proposal type. A csv of fixtures can be found within the testing folder of this repository.
```




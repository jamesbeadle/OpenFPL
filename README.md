OpenFPL is a decentralised fantasy football application built on the Internet Computer blockchain using Svelte, TypeScript & Motoko.

Getting Started
Follow these steps to setup OpenFPL on your local machine for development and testing purposes.

Prerequisites
These steps assume that you already run IC projects within a local development environment, ensuring you have the experience to test this application.

More information about the Internet Computer blockchain can be found at https://internetcomputer.org.

Testing
Clone the repo and install dependencies using npm install.

Create the token canister using the CrateTokenCanister.txt script.

Run dfx deploy to deploy the Main canister and frontend canister.

Within the CanisterIds.mo file update the local canister ids to the deployed canister ids.

Within the Environment.mo ensure that you have set your network to local.

Redeploy the application with the updated canister id and environment files.

Fabricate enough cycles to ensure you can test the application
dfx ledger fabricate-cycles --canister OpenFPL_backend

Update Admin Principal
For testing purposes you will need to update the admin principal to give you access to the admin dashboard. Here you can initialise system. You can find your principal in the profile section accessible via the navbar.

Within the admin dashboard call the init function to create the initial set of Premier League teams.

Seed the system with fixtures via the "Add Initial Fixtures" proposal type. A csv of fixtures can be found within the testing folder of this repository.

You can now create a user through either picking a fantasy team and saving it, or going to the profile section and updating any of the default profile information.

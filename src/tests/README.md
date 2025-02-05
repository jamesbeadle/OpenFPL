# Running Tests

This guide outlines the steps to install dependencies, deploy the backend, generate required files, and run tests for the project.

## Prerequisites

Ensure you have the following installed:

- [DFX](https://internetcomputer.org/docs/current/developer-docs/getting-started/quickstart) (Dfinity SDK)
- [Node.js and npm](https://nodejs.org/)

## Installation

First, install the required npm packages:

```sh
npm install
```

## Starting the Local Replica

Before deploying the backend, start the local replica with a clean state:

```sh
dfx start --clean
```

## Deploying the Backend

Deploy the backend canister to the local replica:

```sh
dfx deploy OpenFPL_backend
```

## Generating Canister Bindings

Run the following command to generate necessary bindings:

```sh
dfx generate OpenFPL_backend
```

## Running Tests

Finally, execute the test suite:

```sh
npm test
```

This will run the test scripts configured in your project.

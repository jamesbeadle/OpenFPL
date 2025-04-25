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

---

### Updated README

1. **Make sure you have Homebrew installed.**

   - Instructions: [https://brew.sh/](https://brew.sh/)
   - Use Homebrew to install (or upgrade to the latest available versions) `bash`, `coreutils` (needed for tools like `sha256sum`), `jq`, and `yq`:

   ```bash
    brew install bash coreutils jq yq
   ```

2. **Install Rosetta (for Apple Silicon users) by running:**

   ```bash
   softwareupdate --install-rosetta
   ```

   **Also, make sure you have Rust installed, including the `wasm32-unknown-unknown` target.**

   - Instructions: [https://www.rust-lang.org/tools/install](https://www.rust-lang.org/tools/install)
   - Add `wasm32-unknown-unknown` to your active toolchain by running:
     ```bash
     rustup target add wasm32-unknown-unknown
     ```

3. **Ensure the newly installed tools are added to your `PATH`:**

   ```bash
   echo 'export PATH="$PATH:/opt/homebrew/bin/:/usr/local/opt/coreutils/libexec/gnubin"' >> "${HOME}/.bashrc"
   ```

   Above, we rely on `.bashrc` as the main commands from this repository are to be executed via **Bash**.

---

### **To run OpenFPL, you will need to set up a local version of the NNS containing the FPL utility token with users after the SNS sale.**

**Follow these steps:**

4. **Clone OpenFPL & the sns-testing repo into your Linux root directory:**

   ```bash
   git clone https://github.com/jamesbeadle/OpenFPL.git
   git clone https://github.com/dfinity/sns-testing.git
   ```

5. **Open the sns-testing directory and run the install script:**

   ```bash
   cd sns-testing
   bash install.sh
   ```

6. **Start a local replica (this will keep running in the current console; press ⌘+C to stop):**

   ```bash
   DX_NET_JSON="${HOME}/.config/dfx/networks.json"
   mkdir -p "$(dirname "${DX_NET_JSON}")"
   cp "$DX_NET_JSON" "${DX_NET_JSON}.tmp" 2>/dev/null  # Save original config if present
   echo '{
      "local": {
         "bind": "0.0.0.0:8080",
         "type": "ephemeral",
         "replica": {
            "subnet_type": "system",
            "port": 8000
         }
      }
   }' > "${DX_NET_JSON}"
   ./bin/dfx start --clean
   mv "${DX_NET_JSON}.tmp" "$DX_NET_JSON" 2>/dev/null  # Restore original config if present
   ```

   While running these instructions for the first time, you may need to hit the "Allow" button to authorize the system to execute the binaries shipped with sns-testing (e.g., `./bin/dfx`).

   **This should print the dashboard URL:**

   ```
   Dashboard: http://localhost:8000/_/dashboard
   ```

7. **Open another terminal and run the setup script for sns-testing:**

   ```bash
   ./setup_locally.sh  # from Bash
   ```

   After this step, you can also access the **NNS frontend dapp** from the browser.

**If prompted, overwrite any existing canisters by pressing the 'y' key.**

8.  **In the same sns-testing terminal, run the following command to set the ICP/XDR rate:**

```bash
./set-icp-xdr-rate.sh 10000
```

9. **Load the OpenFPL solution in VSCode and deploy the application with:**

   ```bash
    dfx deploy --network=local
    dfx canister install OpenFPL_frontend —network=local
    dfx canister install OpenFPL_backend —network=local
   ```

   **Make note of the frontend, backend, and neuron controller canister IDs.**

10. **Update the frontend and backend canister IDs listed as DAO-controlled canisters within `sns_init.yaml` in the OpenFPL repository.**

11. **Copy the `sns_init.yaml` file from the OpenFPL root directory into the sns-testing root directory.**

12. **Deploy the SNS from the sns-testing repository by running these commands:**

```bash
NUM_PARTICIPANTS=10
ICP_PER_PARTICIPANT=100000
./let_nns_control_dapp.sh
./propose_sns.sh
./participate_sns_swap.sh $NUM_PARTICIPANTS $ICP_PER_PARTICIPANT
```

13. **Make note of the deployed SNS governance canister ID from the `sns_canister_ids.json` file. It will be the value for the key `governance_canister_id`. Then run the following command in the sns-testing terminal, replacing the canister ID with your deployed governance canister ID:**

```bash
NETWORK=local
SNS_GOVERNANCE_CANISTER_ID="a3shf-5eaaa-aaaaa-qaafa-cai"
```

14. **You can then access the NNS containing OpenFPL from:**

```
http://qsgjb-riaaa-aaaaa-aaaga-cai.localhost:8080/
```

15. **Create a new test user in the local NNS and note their principal ID. Set the principal ID by updating the value to your local user’s principal ID:**

```bash
PRINCIPAL="2syo2-cf2ig-ptf4n-75gqo-gq657-7nwon-qoik3-2ttyo-njnnf-ys33z-qqe"
```

16. **Mint FPL tokens for your users by running this command:**

```bash
dfx canister call "${SNS_GOVERNANCE_CANISTER_ID}" mint_tokens "(record{recipient=opt record{owner=opt principal \"${PRINCIPAL}\"};amount_e8s=opt 2_000_000_000_000_000:opt nat64})" --network "$NETWORK"
```

17. **Stake the tokens so when you raise a proposal, it will pass immediately.**

18. **Make note of the identity of your current dfx user by running:**

```bash
dfx identity get-principal
```

19. **Add the dfx user principal as a hotkey to your local NNS user’s OpenFPL neuron.**

20. **Add the neuron ID to the following command and run it inside the OpenFPL VS Code terminal:**

```bash
export PROPOSER_NEURON_ID=18f84f58433627de8c490ed739371ed40e1c185587b272591525a3027b9e50cc
export NETWORK=local
export IDENTITY=default
export IC_URL=http://localhost:8080
export PEM_FILE=../../../.config/dfx/identity/default/identity.pem
export WASM_FOLDER="../wasms"
```

21. **Update the neuron controller canister ID in `./governance/local/raise_all_proposals.sh`.**

22. **From the OpenFPL root directory, raise all proposals in the live DAO by running:**

```bash
./governance/local/raise_all_proposals.sh
```

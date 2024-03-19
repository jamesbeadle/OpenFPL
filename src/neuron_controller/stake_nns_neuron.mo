import Result "mo:base/Result";
import Blob "mo:base/Blob";
import Bool "mo:base/Bool";
import HashMap "mo:base/HashMap";
import Random "mo:base/Random";
import Array "mo:base/Array";
import SHA256 "mo:sha256/SHA256";

/*
use crate::guards::caller_is_governance_principal;
use crate::{read_state, RuntimeState};
use candid::Principal;
use canister_api_macros::proposal;
use canister_tracing_macros::trace;
use icrc_ledger_types::icrc1::account::Account;
use icrc_ledger_types::icrc1::transfer::TransferArg;
use ledger_utils::compute_neuron_staking_subaccount_bytes;
use neuron_controller_canister::stake_nns_neuron::{Response::*, *};
use nns_governance_canister::types::manage_neuron::claim_or_refresh::{By, MemoAndController};
use nns_governance_canister::types::manage_neuron::{ClaimOrRefresh, Command};
use nns_governance_canister::types::{manage_neuron_response, ManageNeuron};
use tracing::{error, info};
use types::CanisterId;
use utils::canister::get_random_seed;
#[proposal(guard = "caller_is_governance_principal")]
#[trace]
*/

module {
     
    
    type CanisterId = Principal;
    type PrepareResult = {
        nns_governance_canister_id: CanisterId;
        nns_ledger_canister_id: CanisterId;
        principal: Principal;
    };
    type Cycles = Nat;
    type BlockIndex = Nat64;
    type Args = {
        block_index: BlockIndex;
        canister_id: CanisterId;
    };
    type NotifyError = {
        #Refunded : {
            reason: Text;
            block_index: ?BlockIndex;
        };
        #InvalidTransaction : (Text);
        #TransactionTooOld : (BlockIndex);
        #Processing;
        #Other : {
            error_code: Nat64;
            error_message: Text;
        };
    };
    
    type Hash = Blob;
    type Response = Result.Result<Cycles, NotifyError>;
    type TimestampNanos = Nat64;
    type TimestampMillis = Nat64;

    type Environment = {
        now_nanos: shared () -> async TimestampNanos;
        caller: shared () -> async Principal;
        canister_id: shared () -> async Principal;
        cycles_balance: shared () -> async Cycles;
        rng: shared {seed: Nat} -> async Nat;
        arg_data_raw: shared () -> async Blob;
        now: shared () -> async TimestampMillis;
        entropy: shared () -> async Hash;
    };
    type Timestamped<T> = {
        value: T;
        timestamp: TimestampMillis;
    };
    type Milliseconds = Nat64;
    type Document = {
        fields: Blob;
        age: ?Milliseconds;
    };
    
    type Cryptocurrency = {
        #InternetComputer;
        #FPL;
        #CKBTC;
        #CKETH;
        #CHAT;
        #Other: (Text);
    };

    type PrizeData = {
        token: Cryptocurrency;
        ledger_canister_id: CanisterId;
        prizes: Blob;
        end_date: TimestampMillis;
    };

    type Data = {
        user_index_canister_id: CanisterId;
        admins: HashMap.HashMap<Principal, ()>;
        avatar: Timestamped<?Document>;
        test_mode: Bool;
        username: Text;
        prize_data: ?PrizeData;
        mean_time_between_prizes: TimestampMillis;
        prizes_sent: Blob;
        groups: HashMap.HashMap<CanisterId, ()>;
        started: Bool;
        rng_seed: Blob;
    };


    type RuntimeState = {
        env: Environment;
        data: Data;
    };

    public func stake_nns_neuron(_args: Args): async Response {
        let random_bytes = await Random.blob();
        let array = Blob.toArray(random_bytes);
        let first8Bytes = Array.subArray(array, 0, 8);
        
        let nonce: Nat64 = from_be_bytes(first8Bytes.try_into().unwrap());
        let subaccount = compute_neuron_staking_subaccount_bytes(principal, nonce);

        try {
        
            await ledger.transfer({
                memo = Some(nonce.into());
                from_subaccount = None;
                to = Account.accountIdentifier(nns_governance_canister_id, Some(subaccount));
                amount = 100_000_000u32.into();
                fee = Some(10_000u32.into());
                created_at_time = ?{ timestamp_nanos = Nat64.fromNat(Int.abs(Time.now())) };
            });

            #ok();

        } catch (error) {
            #err("Error transferring ICP")
        };

        try {
            let manage_neuron_response = await nns_governance_canister_c2c_client.manage_neuron(
                nns_governance_canister_id,
                {
                    id = None;
                    neuron_id_or_subaccount = None;
                    command = {
                        by = {
                            controller = principal;
                            memo = nonce;
                        };
                    }
                },
            );

            switch(manage_neuron_response){
                case (null) {
                    #err("Error staking neuron");
                };
                case (?response){
                    let neuron_id = response.refreshed_neuron_id.unwrap().id;
                    #ok("Neuron staked: ", neuron_id);
                }
            };
        } catch (error) {
            #err("Error staking neuron");
        };
    };

    func from_be_bytes() : Nat64 {
        let nonce: Nat64 = 7306897292049529674;
        let buf = Buffer.Buffer<Nat8>(0);

        NatX.encodeNat64(buffer, nonce, #msb)

        Buffer.toArray(buffer);

    };

    func computeNeuronStakingSubaccountBytes(controller: Principal, nonce: Nat64): Blob {
        let domain: Blob = Text.encodeUtf8("neuron-stake");
        let domainLength: Blob = Nat8Array.fromArray([0x0c]);
    
        let hasher = Sha.sha256();
        hasher.update(domainLength);
        hasher.update(domain);
        hasher.update(Principal.toBlob(controller));
        hasher.update(Binary.BigEndian.fromNat64(nonce));
        return hasher.digest();
    };

    func prepare(state: ?RuntimeState) : PrepareResult {
        let result: PrepareResult = {
            nns_governance_canister_id = state.data.nns_governance_canister_id;
            nns_ledger_canister_id = state.data.nns_ledger_canister_id;
            principal = state.data.get_principal();
        }
    };
}
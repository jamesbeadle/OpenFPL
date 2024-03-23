import Result "mo:base/Result";
import Blob "mo:base/Blob";
import Bool "mo:base/Bool";
import HashMap "mo:base/HashMap";
import Random "mo:base/Random";
import Account "../OpenFPL_backend/lib/Account";
import Text "mo:base/Text";
import Principal "mo:base/Principal";
import Nat64 "mo:base/Nat64";
import Int "mo:base/Int";
import Time "mo:base/Time";
import SHA256 "./SHA256";
import Binary "Binary";
import Ledger "Ledger";
import NNSGovernance "NNSGovernance";
import Environment "../OpenFPL_backend/Environment";

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

actor Self {
    private let ledger : Ledger.Interface = actor (Ledger.CANISTER_ID);
    private let nns_governance : NNSGovernance.Interface = actor (NNSGovernance.CANISTER_ID);
    private stable var neuronId: Nat64 = 0;
    
    public func stake_nns_neuron(principal: Principal): async Response {
        let random_bytes = await Random.blob();
        let array = Blob.toArray(random_bytes);

        let nonce: Nat64 = Binary.BigEndian.toNat64(array);
        let subaccount = computeNeuronStakingSubaccountBytes(principal, nonce);

        try {
            let _ = await ledger.transfer({
                memo = nonce;
                from_subaccount = null;
                to = Account.accountIdentifier(Principal.fromText(Environment.NNS_GOVERNANCE_CANISTER_ID), subaccount);
                amount = {e8s = 100_000_000};
                fee = { e8s = 10_000 };
                created_at_time = ?{ timestamp_nanos = Nat64.fromNat(Int.abs(Time.now())) };
            });

        } catch (error) {
            return #err(#InvalidTransaction "Error transferring neuron funds");
        };

        try {

            let manage_neuron_response = await nns_governance.manage_neuron(
                {
                    id = null;
                    command = ? #ClaimOrRefresh {
                        by: ?NNSGovernance.By = ? #MemoAndController {
                            controller = ?principal;
                            memo = nonce;
                        };
                    };
                    neuron_id_or_subaccount = null;
                }
            );

            switch(manage_neuron_response.command){
                case (null) {
                    #err(#InvalidTransaction "Error staking neuron");
                };
                case (?response) {
                    switch(response){
                        case (#ClaimOrRefresh(crResponse)) {
                            switch(crResponse.refreshed_neuron_id){
                                case null{
                                    #err(#InvalidTransaction "Error staking neuron");
                                };
                                case (?returnedNeuronId){
                                    neuronId := returnedNeuronId.id;
                                }
                            };
                        };
                        case _{
                            #err(#InvalidTransaction "Error staking neuron");
                        };
                    };
                }
            };
        } catch (error) {
            #err(#InvalidTransaction "Error staking neuron");
        };
    };

    public shared query func getNeuronId() : async Nat64 {
        return neuronId;
    };

    func computeNeuronStakingSubaccountBytes(controller: Principal, nonce: Nat64): Blob {
        let domain: Blob = Text.encodeUtf8("neuron-stake");
        let domainLength: Blob = Blob.fromArray([0x0c]);
    
        let hasher = SHA256.New();
        hasher.write(Blob.toArray(domainLength));
        hasher.write(Blob.toArray(domain));
        hasher.write(Blob.toArray(Principal.toBlob(controller)));
        hasher.write(Binary.BigEndian.fromNat64(nonce));
        return Blob.fromArray(hasher.sum([]));
    };
}
import Result "mo:base/Result";
import HashMap "mo:base/HashMap";
import Trie "mo:base/Trie";
module _Types {
        
    public type CanisterId = Principal;
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
    public type Response = Result.Result<Cycles, NotifyError>;
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
    
    public type EcdsaCurve = { #secp256k1 };
    public type EcdsaKeyId = { name : Text; curve : EcdsaCurve };
    
    public type CanisterEcdsaRequest = {
        envelope_content: EnvelopeContent;
        request_url: Text;
        public_key: Blob;
        key_id: EcdsaKeyId;
        this_canister_id: CanisterId;
    };

    type Label = Trie.Trie<Blob,Blob>;
    
    public type EnvelopeContent = {
        #Call : {
            nonce : ?Blob;
            ingress_expiry : Nat64;
            sender : Principal;
            canister_id : Principal;
            method_name : Text;
            arg : Blob;
        };
        #ReadState : {
            ingress_expiry : Nat64;
            sender : Principal;
            paths : [[Label]];
        };
        #Query : {
            ingress_expiry : Nat64;
            sender : Principal;
            canister_id : Principal;
            method_name : Text;
            arg : Blob;
            nonce : ?Blob;
        };
    };

    public type Error = {
        #ECSDAError;
    };
}
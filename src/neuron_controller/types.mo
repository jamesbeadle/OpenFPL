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

    

    public type Envelope = {
        content: EnvelopeContent;
        sender_pubkey: ?Blob;
        sender_sig: ?Blob;
    };
    
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


    //neuron types
    
        
    public type NeuronId = { id: Nat64 };
        
    public type Spawn = { percentage_to_spawn: ?Nat32; new_controller: ?Principal; nonce: ?Nat64 };

    public type Follow = { topic: Int32; followees: [NeuronId] };

    public type ClaimOrRefresh = { by: ?By };

    public type Configure = { operation: ?Operation };

    public type StakeMaturity = { percentage_to_stake: ?Nat32 };

    public type Disburse = { to_account: ?AccountIdentifier; amount: ?Amount };

    public type By = { #NeuronIdOrSubaccount; #MemoAndController: ClaimOrRefreshNeuronFromAccount; #Memo: Nat64 };

    public type Amount = { e8s: Nat64 };

    public type AccountIdentifier = { hash: [Nat8] };

    public type ClaimOrRefreshNeuronFromAccount = { controller: ?Principal; memo: Nat64 };

    public type SetDissolveTimestamp = { dissolve_timestamp_seconds: Nat64 };

    public type IncreaseDissolveDelay = { additional_dissolve_delay_seconds: Nat32 };

    public type ChangeAutoStakeMaturity = { requested_setting_for_auto_stake_maturity: Bool };

    public type GovernanceError = { error_message: Text; error_type: Int32 };

    public type SpawnResponse = { created_neuron_id: ?NeuronId };

    public type ClaimOrRefreshResponse = { refreshed_neuron_id: ?NeuronId };

    public type StakeMaturityResponse = { maturity_e8s: Nat64; stake_maturity_e8s: Nat64 };

    public type DisburseResponse = { transfer_block_height: Nat64 };
            
    public type Command = {
        #Spawn: Spawn;
        #Follow: Follow;
        #ClaimOrRefresh: ClaimOrRefresh;
        #Configure: Configure;
        #StakeMaturity: StakeMaturityResponse;
        #Disburse: Disburse;
    };
    
    public type ManageNeuron = { id: ?NeuronId; command: ?Command; neuron_id_or_subaccount: ?NeuronIdOrSubaccount };
    
    public type Operation = {
        #StopDissolving;
        #StartDissolving;
        #ChangeAutoStakeMaturity: ChangeAutoStakeMaturity;
        #IncreaseDissolveDelay: IncreaseDissolveDelay;
        #SetDissolveTimestamp: SetDissolveTimestamp;
    };

    public type NeuronIdOrSubaccount = { #Subaccount : [Nat8]; #NeuronId : NeuronId };
}
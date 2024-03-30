import Loopback "mo:http-loopback";
import { Identity } "mo:tecdsa";
import { Ledger } "mo:utilities";
import Result "mo:base/Result";
import State "state";

module {

  public type Identity = Identity.Identity;

  public type InitParams = State.InitParams;

  public type AsyncReturn<T> = State.AsyncReturn<T>;

  public type HttpAgent = Loopback.Agent.Agent;

  public type HttpClient = Loopback.Client.Client;

  public type HttpClientError = Loopback.Client.Error;

  public type AccountId = Ledger.AccountIdentifier;

  public type Tokens = Ledger.Tokens;

  public type Address = Ledger.Address;

  public type LedgerArgs = Ledger.Interface.TransferArgs;

  public type TransferResult = Ledger.Interface.TransferResult;

  public type LedgerResponse = { #ok : TransferResult; #err: Loopback.Client.Error };

  public let { Http } = Loopback;

  public type Command = {
    #Spawn: Spawn;
    #Follow: Follow;
    #ClaimOrRefresh: ClaimOrRefresh;
    #Configure: Configure;
    #StakeMaturity: StakeMaturityResponse;
    #Disburse: Disburse;
  };

  public type CommandResponse = {
    #Error: GovernanceError;
    #Spawn: SpawnResponse;
    #Follow: ();
    #ClaimOrRefresh: ClaimOrRefreshResponse;
    #Configure: ();
    #StakeMaturity: StakeMaturityResponse;
    #Disburse: DisburseResponse;
  };
  
  public type Operation = {
    #StopDissolving;
    #StartDissolving;
    #ChangeAutoStakeMaturity: ChangeAutoStakeMaturity;
    #IncreaseDissolveDelay: IncreaseDissolveDelay;
    #SetDissolveTimestamp: SetDissolveTimestamp;
  };

  public type NeuronResponse = { #ok : ManageNeuronResponse; #err: Loopback.Client.Error };

  public type State = State.State;

  public type NeuronId = { id: Nat64 };

  public type Agent = Loopback.Agent;

  public type NeuronIdOrSubaccount = { #Subaccount : [Nat8]; #NeuronId : NeuronId };

  public type Client = object { manage_neuron: (ManageNeuron) -> async* Response };

  public type Service = actor { manage_neuron: (ManageNeuron) -> async ManageNeuronResponse };

  public type ManageNeuron = { id: ?NeuronId; command: ?Command; neuron_id_or_subaccount: ?NeuronIdOrSubaccount };

  public type ManageNeuronResponse = { command: ?CommandResponse };

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

  public type BlockIndex = Nat64;
  
  public type DisburseResponse = { transfer_block_height: Nat64 };

  public type Response = Result.Result<Nat, NotifyError>;

  public type NotifyError = {
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

};
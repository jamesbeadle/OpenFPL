import State "state";

module {

  public type State = State.State;
  
  public type Status = ?((Principal, Nat), Status);

  public type StatusResponse = { status : Status };

  public type StatusRequest = { status : Status };

  public type TransferRequest = { max_cycles : Nat; status : Status };

  public type ChangeRequest = { args : [ChangeRequestArg] };

  public type Return<T> = { response: T; trapped: [Text] };

  public type ReturnStatus = Return<StatusResponse>;

  public type ReturnAmount = Return<Nat>;

  public type ChangeRequestArg = {
    #AddAdmin : Principal;
    #RemoveAdmin: Principal;
    #AddClient : Principal;
    #RemoveClient : Principal;
  };

  public type Cycles = object {
    accept : <system>() -> Nat;
    balance : () -> Nat;
    release : Nat -> ();
    reserve : Nat -> Bool;
    set_canister_id : Principal -> ();
    status : StatusRequest -> async* ReturnStatus;
    transfer : TransferRequest -> async* ReturnAmount;
    change : ChangeRequest -> async* Return<()>;
  };

  public type Interface = actor {
    cycles_accept : () -> async Nat;
    cycles_request_balance : query () -> async Nat;
    cycles_request_status : query StatusRequest -> async ReturnStatus;
    cycles_request_transfer : TransferRequest -> async ReturnAmount;
    cycles_request_change : ChangeRequest -> async Return<()>;
  };

};
import { fromText = principalFromText } "mo:base/Principal";

module { 

  public type Predecessors = { #null_ };

  public type State = {
    var canister_id: Principal;
    var server : ?Principal;
    var clients : [Principal];
    var admins : [Principal];
    var minimum_balance : Nat;
    var reserved : Nat
  }; 

  public type InitParams = {
    subaccount : Nat;
    minimum_balance : Nat;
    server : ?Principal;
    clients : [Principal];
    admins : [Principal];
    self : Principal;
  };

  public func init(params: InitParams): State = {
    var reserved = 0;
    var subaccount = null;
    var canister_id = principalFromText("aaaaa-aa");
    var minimum_balance = params.minimum_balance;
    var server = params.server;
    var clients = params.clients;
    var admins = params.admins;
  };

}
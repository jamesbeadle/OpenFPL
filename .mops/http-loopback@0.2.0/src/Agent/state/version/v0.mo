import { Nonce } "mo:utilities";

module { 

  public type Predecessors = { #null_ };
  
  public type State = {
    var read_attempts: Nat;
    var ingress_expiry : Nat;
    var nonce : Nonce.State;
  };

  public type InitParams = { ingress_expiry : Nat };

  public func init(params: InitParams) : State = {
    var read_attempts = 1;
    var ingress_expiry = params.ingress_expiry;
    var nonce = Nonce.State.init()
  }

}
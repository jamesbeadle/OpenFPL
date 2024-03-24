import { Fees; Nonce; Cycles } "mo:utilities";

module { 

  public type Predecessors = { #null_ };

  public type InitParams = {
    nonce: Nonce.State;
    fees: Fees.State;
    domain: Text;
    path: Text;
  };
  
  public type State = {
    var path: Text;
    var domain: Text;
    var nonce: Nonce.State;
    var fees: Fees.State;
  }; 

  public func init(params: InitParams): State = {
    var path = params.path;
    var domain = params.domain;
    var nonce = params.nonce;
    var fees = params.fees;
  };

}
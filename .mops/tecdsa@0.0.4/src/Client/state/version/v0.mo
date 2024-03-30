import { Fees } = "mo:utilities";

module { 

  public type Predecessors = { #null_ };

  public type State = { var canister_id: Text; var fees: Fees.State };

  public type InitParams = { canister_id : Text; fees : Fees.State };

  public func init(params: InitParams): State = {
    var canister_id = params.canister_id;
    var fees = params.fees;
  };

}
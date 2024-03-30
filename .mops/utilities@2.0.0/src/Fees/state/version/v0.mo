import { fromIter; thash } "mo:map/Map";
import MT "mo:map/Map/types";

module { 

  public type Predecessors = { #null_ };

  public type State = {var fees : MT.Map<Text, Nat64>}; 

  public type InitParams = { fees: [(Text, Nat64)] };

  public func init(params: InitParams): State = {var fees = fromIter<Text, Nat64>(params.fees.vals(), thash) };

}
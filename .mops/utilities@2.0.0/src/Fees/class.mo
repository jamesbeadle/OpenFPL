import { put = mapPut; get = mapGet; thash } "mo:map/Map";
import State "state";

module {

  public type Fee = Nat64;

  public type Return = { #ok: Nat64; #err: Error };

  public type Error = { #fee_not_defined: Text };

  public class Fees(state_: State.State) = {

    let state = State.unwrap( state_ );

    public func set(k: Text, v: Fee) = ignore mapPut<Text, Fee>(state.fees, thash, k, v);

    public func get(k: Text): Return {
      switch( mapGet<Text, Fee>(state.fees, thash, k) ){
        case null #err( #fee_not_defined(k) );
        case( ?fee ) #ok( fee );
      }
    };

    public func multiply(k: Text, n: Nat64): Return {
      switch( mapGet<Text, Fee>(state.fees, thash, k) ){
        case null #err( #fee_not_defined(k) );
        case( ?fee ) #ok( fee * n );
      }
    };

  };

}
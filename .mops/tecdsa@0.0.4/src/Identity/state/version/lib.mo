import { trap } "mo:base/Debug";
import Current "v0";
import T "../../types";

module {

  public type State = Current.State;

  public type InitParams = Current.InitParams;

  public type Version = Current.Predecessors or { #v0 : Current.State };

  public func init(params: InitParams): async* T.AsyncReturn<(T.SeedPhrase, Version)> {
    switch( await* Current.init( params ) ){
      case( #ok(sp, vstate) ) #ok(sp, #v0(vstate));
      case( #err msg ) #err(msg);
    }
  };

  public func unwrap(ver: Version): Current.State {
    let #v0 state = ver else { trap("State.Version.unwrap(): version mismatch; please run Version.migrate_from()") };
    state
  };

  public func migrate_from(version : Version): Version = switch version {
    case( #null_ ) { trap("failed state migration"); #null_ };
    case( _ ) version
  };

}
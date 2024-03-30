import { trap } "mo:base/Debug";
import Current "v0";

module {

  public type State = Current.State;

  public type InitParams = Current.InitParams;

  public type Version = Current.Predecessors or { #v0 : Current.State };

  public func init(params: InitParams): Version = #v0( Current.init( params ) );

  public func unwrap(ver: Version): Current.State {
    let #v0 state = ver else { trap("State.Version.unwrap(): version mismatch; please run Version.migrate_from()") };
    state
  };

  public func migrate_from(version : Version): Version = switch version {
    case( #null_ ) { trap("failed state migration"); #null_ };
    case( _ ) version
  };

}
import Version "version";

module {

  public type Version = Version.Version;

  public type InitParams = Version.InitParams;

  public type State = { var version : Version };

  public func empty(): State = { var version = #null_ };

  public func load(state: State, params: InitParams) : () {
    state.version := Version.init( params )
  };

  public func init(params : Version.InitParams): State = {
    var version = Version.init( params )
  };

  public func unwrap(state: State): Version.State {
    state.version := Version.migrate_from( state.version );
    Version.unwrap( state.version )
  };

}
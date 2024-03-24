import ECDSA "mo:tecdsa";
import S "state";
import T "types";

module {

  public class Runtime(state: T.State) = {

    public func init(p : Principal): async* T.AsyncReturn<()> {
      if ( state.initialized == false ) await* S.init(state, p)
      else #ok
    };

    public func identity(): T.Identity {
      ECDSA.Identity.Identity(
        state.ecdsa_identity,
        ECDSA.Client.Client(
          state.ecdsa_client
        )
      )
    };

    public func service(transformFn: Loopback.Http.TransformFunction): Service.Service {
      Service.Service(
        Loopback.Agent.Agent(
          state.loopback_agent,
          Loopback.Client.Client(
            state.loopback_client,
            transformFn
          ),
          ECDSA.Identity.Identity(
            state.ecdsa_identity,
            ECDSA.Client.Client(
              state.ecdsa_client
        ))),
        state.self_id
      )
    };

  };


}
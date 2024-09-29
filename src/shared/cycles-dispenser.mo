import Buffer "mo:base/Buffer";
import Management "../shared/utils/Management";
import Nat "mo:base/Nat";
import Time "mo:base/Time";
import T "../shared/types";
import Utilities "../shared/utils/utilities";
import NetworkEnvironmentVariables "network_environment_variables";

module {

  public class CyclesDispenser() {

    private var topups : [T.CanisterTopup] = [];

    private var recordSystemEvent : ?((eventLog: T.EventLogEntry) -> ()) = null;

    public func setRecordSystemEventFunction(
      _recordSystemEvent : ((eventLog: T.EventLogEntry) -> ()),
    ) {
      recordSystemEvent := ?_recordSystemEvent;
    };

    public func getStableTopups() : [T.CanisterTopup] {
      return topups;
    };

    public func setStableTopups(stable_topups : [T.CanisterTopup]) {
      topups := stable_topups;
    };

    public func requestCanisterTopup(canisterPrincipal : Text, cycles: Nat) : async () {
      let canister_actor = actor (canisterPrincipal) : actor { };
      let IC : Management.Management = actor (NetworkEnvironmentVariables.Default);
      let _ = await Utilities.topup_canister_(canister_actor, IC, cycles);
      recordCanisterTopup(canisterPrincipal, cycles);
    };

    private func recordCanisterTopup(canisterId: T.CanisterId, cyclesAmount: Nat){

      let topup: T.CanisterTopup = {
        canisterId = canisterId;
        cyclesAmount = cyclesAmount;
        topupTime = Time.now();
      };

      let topupBuffer = Buffer.fromArray<T.CanisterTopup>(topups);
      topupBuffer.add(topup);

      topups := Buffer.toArray(topupBuffer);

      switch(recordSystemEvent){
        case null{};
        case (?function){
          function({
            eventDetail = "Canister " # canisterId # " was topped up with " # Nat.toText(cyclesAmount) # " cycles."; 
            eventId = 0;
            eventTime = Time.now();
            eventTitle = "Canister Topup";
            eventType = #CanisterTopup;
          });
        }
      }
      
    };
  };
};

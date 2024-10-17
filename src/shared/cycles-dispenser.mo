import Buffer "mo:base/Buffer";
import Management "../shared/utils/Management";
import Nat "mo:base/Nat";
import Time "mo:base/Time";
import Base "../shared/types/base_types";
import Utilities "../shared/utils/utilities";
import NetworkEnvironmentVariables "network_environment_variables";

module {

  public class CyclesDispenser() {

    private var topups : [Base.CanisterTopup] = [];

    private var recordSystemEvent : ?((eventLog: Base.EventLogEntry) -> ()) = null;

    public func setRecordSystemEventFunction(
      _recordSystemEvent : ((eventLog: Base.EventLogEntry) -> ()),
    ) {
      recordSystemEvent := ?_recordSystemEvent;
    };

    public func getStableTopups() : [Base.CanisterTopup] {
      return topups;
    };

    public func setStableTopups(stable_topups : [Base.CanisterTopup]) {
      topups := stable_topups;
    };

    public func requestCanisterTopup(canisterPrincipal : Text, cycles: Nat) : async () {
      let canister_actor = actor (canisterPrincipal) : actor { };
      let IC : Management.Management = actor (NetworkEnvironmentVariables.Default);
      let _ = await Utilities.topup_canister_(canister_actor, IC, cycles);
      recordCanisterTopup(canisterPrincipal, cycles);
    };

    private func recordCanisterTopup(canisterId: Base.CanisterId, cyclesAmount: Nat){

      let topup: Base.CanisterTopup = {
        canisterId = canisterId;
        cyclesAmount = cyclesAmount;
        topupTime = Time.now();
      };

      let topupBuffer = Buffer.fromArray<Base.CanisterTopup>(topups);
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

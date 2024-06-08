import Time "mo:base/Time";
import Buffer "mo:base/Buffer";
import Nat "mo:base/Nat";
import Iter "mo:base/Iter";
import Principal "mo:base/Principal";
import Environment "utils/Environment";
import T "types";
import Root "sns-wrappers/root";
import Utilities "utils/utilities";
import Management "modules/Management";

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

    public func checkDynamicCanisterCycles(dynamicCanisterIds: [T.CanisterId]) : async (){
      
      for(canisterId in Iter.fromArray(dynamicCanisterIds)){
        
        let dynamic_canister = actor (canisterId) : actor {
          getCyclesBalanace : () -> async Nat;
        };

        let cyclesBalance = await dynamic_canister.getCyclesBalanace();

        if (cyclesBalance < 10_000_000_000_000) {
          await requestCanisterTopup(canisterId, 10_000_000_000_000);
        };
      };
    };

    public func checkSNSCanisterCycles() : async (){
      let root_canister = actor (Environment.SNS_ROOT_CANISTER_ID) : actor {
        get_sns_canisters_summary : (request: Root.GetSnsCanistersSummaryRequest) -> async Root.GetSnsCanistersSummaryResponse;
      };

      let summary = await root_canister.get_sns_canisters_summary({update_canister_list = ?false});
      
      for(canister in Iter.fromArray(summary.archives)){
        switch(canister.canister_id){
          case (null) {};
          case (?foundCanisterId){
            let status = canister.status;
            switch(status){
              case (null){};
              case (?foundStatus){
                if (foundStatus.cycles < 10_000_000_000_000) {
                  await requestCanisterTopup(Principal.toText(foundCanisterId), 10_000_000_000_000);
                };
              }
            };
          };
        };
      };

      for(canister in Iter.fromArray(summary.dapps)){
        switch(canister.canister_id){
          case (null) {};
          case (?foundCanisterId){
            let status = canister.status;
            switch(status){
              case (null){};
              case (?foundStatus){
                if (foundStatus.cycles < 10_000_000_000_000) {
                  await requestCanisterTopup(Principal.toText(foundCanisterId), 10_000_000_000_000);
                };
              }
            };
          };
        };
      };
      
      switch(summary.governance){
        case (null){ };
        case (?canister){
           switch(canister.canister_id){
              case (null) {};
              case (?foundCanisterId){
                let status = canister.status;
                switch(status){
                  case (null){};
                  case (?foundStatus){
                    if (foundStatus.cycles < 10_000_000_000_000) {
                      await requestCanisterTopup(Principal.toText(foundCanisterId), 10_000_000_000_000);
                    };
                  }
                };
              };
            };
        };
      };
      
      switch(summary.index){
        case (null){ };
        case (?canister){
           switch(canister.canister_id){
              case (null) {};
              case (?foundCanisterId){
                let status = canister.status;
                switch(status){
                  case (null){};
                  case (?foundStatus){
                    if (foundStatus.cycles < 10_000_000_000_000) {
                      await requestCanisterTopup(Principal.toText(foundCanisterId), 10_000_000_000_000);
                    };
                  }
                };
              };
            };

        };
      };
      
      switch(summary.ledger){
        case (null){ };
        case (?canister){
           switch(canister.canister_id){
              case (null) {};
              case (?foundCanisterId){
                let status = canister.status;
                switch(status){
                  case (null){};
                  case (?foundStatus){
                    if (foundStatus.cycles < 10_000_000_000_000) {
                      await requestCanisterTopup(Principal.toText(foundCanisterId), 10_000_000_000_000);
                    };
                  }
                };
              };
            };

        };
      };
      
      switch(summary.root){
        case (null){ };
        case (?canister){
           switch(canister.canister_id){
              case (null) {};
              case (?foundCanisterId){
                let status = canister.status;
                switch(status){
                  case (null){};
                  case (?foundStatus){
                    if (foundStatus.cycles < 10_000_000_000_000) {
                      await requestCanisterTopup(Principal.toText(foundCanisterId), 10_000_000_000_000);
                    };
                  }
                };
              };
            };

        };
      };
      
      switch(summary.swap){
        case (null){ };
        case (?canister){
           switch(canister.canister_id){
              case (null) {};
              case (?foundCanisterId){
                let status = canister.status;
                switch(status){
                  case (null){};
                  case (?foundStatus){
                    if (foundStatus.cycles < 10_000_000_000_000) {
                      await requestCanisterTopup(Principal.toText(foundCanisterId), 10_000_000_000_000);
                    };
                  }
                };
              };
            };

        };
      };
    };

    public func requestCanisterTopup(canisterPrincipal : Text, cycles: Nat) : async () {
      let canister_actor = actor (canisterPrincipal) : actor { };
      let IC : Management.Management = actor (Environment.Default);
      let _ = await Utilities.topup_canister_(canister_actor, ?Principal.fromText(Environment.BACKEND_CANISTER_ID), IC, cycles);
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

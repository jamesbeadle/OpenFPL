import Cycles "mo:base/ExperimentalCycles";
import List "mo:base/List";
import Timer "mo:base/Timer";
import Iter "mo:base/Iter";
import Utilities "utilities";
import CanisterIds "CanisterIds";

module {

  public class CanisterWatcher() {

    let canisterIds: List.List<Text> = List.fromArray<Text>([CanisterIds.MAIN_CANISTER_ID]);
    let canisterCheckInterval = Utilities.getHour() * 24;
    let canisterCheckTimerId: ?Timer.TimerId = null;

    public func setAndWatchCanister(canisterId: Text) : async (){
      if(canisterCheckTimerId != null){
        //TODO:cancel current timer
      };
      //TODO:Chcek canister balances now
      await checkCanisterCycles();
      //TODO:Check canister balances in timer duration
    };

    public func checkCanisterCycles() : async () {

      for(canisterId in Iter.fromList(canisterIds)){
        let canister_actor = actor (canisterId) : actor {
          checkCanisterCycles : () -> ();
        };
        canister_actor.checkCanisterCycles();
      };
    };

  };
};

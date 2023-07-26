import T "types";
import List "mo:base/List";
import HashMap "mo:base/HashMap";
import Utilities "utilities";

module {
    public class Governance(){

        private var fixtureDataSubmissions: HashMap.HashMap<Nat16, List.List<T.PlayerEventData>> = HashMap.HashMap<Nat16, List.List<T.PlayerEventData>>(22, Utilities.eqNat16, Utilities.hashNat16);

        public shared func getGameweekPlayerEventData(gameweek: Nat8, fixtureId: Nat32) : async List.List<T.PlayerEventData> {

            //IMPLEMENT

            return List.nil();
        };

        public shared func getRevaluedPlayers() : async [T.Player] {

            //IMPLEMENT

            //RESET PLAYERS VOTES

            //NOTE THE SUCCESSFUL PLAYER VALUATION VOTES

            return [];
        };

    }
}

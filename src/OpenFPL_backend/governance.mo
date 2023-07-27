import T "types";
import List "mo:base/List";
import HashMap "mo:base/HashMap";
import Utilities "utilities";
import Iter "mo:base/Iter";

module {
    public class Governance(){

        private var fixtureDataSubmissions: HashMap.HashMap<Nat16, List.List<T.PlayerEventData>> = HashMap.HashMap<Nat16, List.List<T.PlayerEventData>>(22, Utilities.eqNat16, Utilities.hashNat16);
        
        public func setData(stable_fixture_data_submissions: [(Nat16, List.List<T.PlayerEventData>)]){
            fixtureDataSubmissions := HashMap.fromIter<Nat16, List.List<T.PlayerEventData>>(
                stable_fixture_data_submissions.vals(), stable_fixture_data_submissions.size(), Utilities.eqNat16, Utilities.hashNat16);
        };
        
        public func getFixtureDataSubmissions() : [(Nat16, List.List<T.PlayerEventData>)] {
            return Iter.toArray(fixtureDataSubmissions.entries());
        };

        public func getGameweekPlayerEventData(gameweek: Nat8, fixtureId: Nat32) : async List.List<T.PlayerEventData> {

            //IMPLEMENT

            return List.nil();
        };

        public func getRevaluedPlayers() : async [T.Player] {

            //IMPLEMENT

            //RESET PLAYERS VOTES

            //NOTE THE SUCCESSFUL PLAYER VALUATION VOTES

            return [];
        };

    }
}

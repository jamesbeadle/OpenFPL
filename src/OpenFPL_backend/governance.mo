import T "types";
import List "mo:base/List";
import HashMap "mo:base/HashMap";
import Utilities "utilities";
import Iter "mo:base/Iter";
import Principal "mo:base/Principal";
import Array "mo:base/Array";

module {
    public class Governance(){

        let admins : [Text] = [
            //JB Local
            "eqlhf-ppkq7-roa5i-4wu6r-jumy3-g2xrc-vfdd5-wtoeu-n7xre-vsktn-lqe"
            //JB Live
            //"ld6pc-7sgvt-fs7gg-fvsih-gspgy-34ikk-wrwl6-ixrkc-k54er-7ivom-wae"
        ];

        private var draftFixtureDataSubmissions: HashMap.HashMap<Nat16, List.List<T.PlayerEventData>> = HashMap.HashMap<Nat16, List.List<T.PlayerEventData>>(22, Utilities.eqNat16, Utilities.hashNat16);
        private var fixtureDataSubmissions: HashMap.HashMap<Nat16, List.List<T.PlayerEventData>> = HashMap.HashMap<Nat16, List.List<T.PlayerEventData>>(22, Utilities.eqNat16, Utilities.hashNat16);
        
        public func setData(stable_fixture_data_submissions: [(Nat16, List.List<T.PlayerEventData>)], stable__draft_fixture_data_submissions: [(Nat16, List.List<T.PlayerEventData>)]){
            
            draftFixtureDataSubmissions := HashMap.fromIter<Nat16, List.List<T.PlayerEventData>>(
                stable__draft_fixture_data_submissions.vals(), stable__draft_fixture_data_submissions.size(), Utilities.eqNat16, Utilities.hashNat16);
            
            fixtureDataSubmissions := HashMap.fromIter<Nat16, List.List<T.PlayerEventData>>(
                stable_fixture_data_submissions.vals(), stable_fixture_data_submissions.size(), Utilities.eqNat16, Utilities.hashNat16);
        };
        
        public func getFixtureDataSubmissions() : [(Nat16, List.List<T.PlayerEventData>)] {
            return Iter.toArray(fixtureDataSubmissions.entries());
        };
        
        public func getDraftFixtureDataSubmissions() : [(Nat16, List.List<T.PlayerEventData>)] {
            return Iter.toArray(draftFixtureDataSubmissions.entries());
        };

        public func submitDraftData(principalId: Text, fixtureId: Nat16, playerEventData: [T.PlayerEventData]) : (){
            let userVotingPower = getVotingPower(principalId);

            //this will submit the draft data and then add it to the list with their voting power

            //need a structure that handles this

            //on submission recalculate the current accepted draft data to be shown to the site

            //have an array of consensus draft data

        };

        public func getVotingPower(principalId: Text) : Nat64 {
            switch (Array.find<Text>(admins, func (admin) { admin == principalId })) {
            case null { return 0; };
            case _ { return 1_000_000; };
            };
        };

        public func getGameweekPlayerEventData(gameweek: Nat8, fixtureId: Nat32) : async List.List<T.PlayerEventData> {

            //so you could have lots of variations of consensus data
                //need a way to use the most weighted to be in the final array

            //Based on the data that has been added and the voting power of the user the 

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

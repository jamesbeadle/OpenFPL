import T "types";
import List "mo:base/List";
import HashMap "mo:base/HashMap";
import Utilities "utilities";
import Iter "mo:base/Iter";
import Principal "mo:base/Principal";
import Array "mo:base/Array";
import Buffer "mo:base/Buffer";

module {
    public class Governance(){


        let admins : [Text] = [
            //JB Local
            "eqlhf-ppkq7-roa5i-4wu6r-jumy3-g2xrc-vfdd5-wtoeu-n7xre-vsktn-lqe"
            //JB Live
            //"ld6pc-7sgvt-fs7gg-fvsih-gspgy-34ikk-wrwl6-ixrkc-k54er-7ivom-wae"
        ];

        private var draftFixtureDataSubmissions: HashMap.HashMap<T.FixtureId, T.DataSubmission> = 
            HashMap.HashMap<T.FixtureId, T.DataSubmission>(22, Utilities.eqNat32, Utilities.hashNat32);
        private var fixtureDataSubmissions: HashMap.HashMap<T.FixtureId, T.DataSubmission> = 
            HashMap.HashMap<T.FixtureId, T.DataSubmission>(22, Utilities.eqNat32, Utilities.hashNat32);
        private var playerRevaluationSubmissions: HashMap.HashMap<T.SeasonId, HashMap.HashMap<T.GameweekNumber, HashMap.HashMap<T.PlayerId, List.List<T.PlayerValuationSubmission>>>> = 
            HashMap.HashMap<T.SeasonId, HashMap.HashMap<T.GameweekNumber, HashMap.HashMap<T.PlayerId, List.List<T.PlayerValuationSubmission>>>> (20, Utilities.eqNat16, Utilities.hashNat16);
        private var proposals: [T.Proposal] = [];


        public func setData(
            stable_fixture_data_submissions: [(T.FixtureId, T.DataSubmission)], 
            stable__draft_fixture_data_submissions: [(T.FixtureId, T.DataSubmission)],
            stable_player_revaluation_submissions: [(T.SeasonId, (T.GameweekNumber, (T.PlayerId, List.List<T.PlayerValuationSubmission>)))],
            stable_proposals: [T.Proposal]) {

            // Type definitions
            type InnerMapType = HashMap.HashMap<T.PlayerId, List.List<T.PlayerValuationSubmission>>;
            type MidMapType = HashMap.HashMap<T.GameweekNumber, InnerMapType>;
            type OuterMapType = HashMap.HashMap<T.SeasonId, MidMapType>;

            // Iterators
            let draftFixtureIterator = Iter.fromArray(stable__draft_fixture_data_submissions);
            let fixtureDataIterator = Iter.fromArray(stable_fixture_data_submissions);

            draftFixtureDataSubmissions := HashMap.fromIter<T.FixtureId, T.DataSubmission>(
                draftFixtureIterator,
                Iter.size(draftFixtureIterator),
                Utilities.eqNat32, 
                Utilities.hashNat32
            );

            fixtureDataSubmissions := HashMap.fromIter<T.FixtureId, T.DataSubmission>(
                fixtureDataIterator,
                Iter.size(fixtureDataIterator),
                Utilities.eqNat32, 
                Utilities.hashNat32
            );
            
            var outerMap: OuterMapType = HashMap.HashMap<T.SeasonId, MidMapType>(Iter.size(Iter.fromArray(stable_player_revaluation_submissions)), Utilities.eqNat16, Utilities.hashNat16);
            for ((seasonId, (gameweek, data)) in Iter.fromArray(stable_player_revaluation_submissions)) {
                let (playerId, submissions) = data;

                let innerMap: InnerMapType = HashMap.HashMap<T.PlayerId, List.List<T.PlayerValuationSubmission>>(1, Utilities.eqNat16, Utilities.hashNat16);
                innerMap.put(playerId, submissions);
                
                let midMap: MidMapType = HashMap.HashMap<T.GameweekNumber, InnerMapType>(1, Utilities.eqNat8, Utilities.hashNat8);
                midMap.put(gameweek, innerMap);
                
                outerMap.put(seasonId, midMap);
            };

            playerRevaluationSubmissions := outerMap;

            proposals := stable_proposals;
        };
        
        public func getFixtureDataSubmissions() : [(T.FixtureId, T.DataSubmission)] {
            return Iter.toArray(fixtureDataSubmissions.entries());
        };
        
        public func getDraftFixtureDataSubmissions() : [(T.FixtureId, T.DataSubmission)] {
            return Iter.toArray(draftFixtureDataSubmissions.entries());
        };


        public func getPlayerRevaluationSubmissions() : [(T.SeasonId, (T.GameweekNumber, (T.PlayerId, List.List<T.PlayerValuationSubmission>)))] {
            var results: [(T.SeasonId, (T.GameweekNumber, (T.PlayerId, List.List<T.PlayerValuationSubmission>)))] = [];
            var resultsBuffer = Buffer.fromArray<(T.SeasonId, (T.GameweekNumber, (T.PlayerId, List.List<T.PlayerValuationSubmission>)))>(results);

            // Iterate over the outer map (seasons)
            for ((seasonId, midMap) in playerRevaluationSubmissions.entries()) {
                
                // Iterate over the mid map (gameweeks)
                for ((gameweek, innerMap) in midMap.entries()) {
                    
                    // Iterate over the inner map (player submissions)
                    for ((playerId, submissions) in innerMap.entries()) {
                        
                        let entry: (T.SeasonId, (T.GameweekNumber, (T.PlayerId, List.List<T.PlayerValuationSubmission>))) = (seasonId, (gameweek, (playerId, submissions)));
                        resultsBuffer.add(entry);
                    }
                }
            };

            results := Buffer.toArray(resultsBuffer);
            return results;
        };

        public func getProposals() : [T.Proposal]{
            return proposals;
        };




        public func submitDraftPlayerEventData(principalId: Text, fixtureId: Nat16, playerEventData: [T.PlayerEventData]) : (){
            let userVotingPower = getVotingPower(principalId);

            //this will submit the draft data and then add it to the list with their voting power


            //on submission recalculate the current accepted draft data to be shown to the site

            //have an array of consensus draft data

        };

        public func submitPlayerEventData(principalId: Text, fixtureId: Nat16, playerEventData: [T.PlayerEventData]) : (){
            let userVotingPower = getVotingPower(principalId);

            //this will submit the data and then add it to the list with their voting power


            //on submission recalculate the current accepted data to be shown to the site

            //have an array of consensus data

        };

        public func submitPlayerRevaluation() : (){
            //IMPLEMENT
        };

        public func voteOnProposal() : (){
            //IMPLEMENT
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

        public func getVotingPower(principalId: Text) : Nat64 {
            switch (Array.find<Text>(admins, func (admin) { admin == principalId })) {
            case null { return 0; };
            case _ { return 1_000_000; };
            };
        };

    }
}

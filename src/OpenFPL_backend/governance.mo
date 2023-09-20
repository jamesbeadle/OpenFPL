import T "types";
import List "mo:base/List";
import HashMap "mo:base/HashMap";
import Utilities "utilities";
import Iter "mo:base/Iter";
import Principal "mo:base/Principal";
import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import Time "mo:base/Time";
import Int64 "mo:base/Int64";
import Nat64 "mo:base/Nat64";
import TrieMap "mo:base/TrieMap";
import Nat "mo:base/Nat";
import Hash "mo:base/Hash";
import Int "mo:base/Int";
import Timer "mo:base/Timer";
import Debug "mo:base/Debug";
import SNSGovernance "Ledger";

module {
    public class Governance(
        transferPlayer: (proposalPayload: T.TransferPlayerPayload) -> async (),
        loanPlayer: (proposalPayload: T.LoanPlayerPayload) -> async (),
        recallPlayer: (proposalPayload: T.RecallPlayerPayload) -> async (),
        createPlayer: (proposalPayload: T.CreatePlayerPayload) -> async (),
        updatePlayer: (proposalPayload: T.UpdatePlayerPayload) -> async (),
        setPlayerInjury: (proposalPayload: T.SetPlayerInjuryPayload) -> async (),
        retirePlayer: (proposalPayload: T.RetirePlayerPayload) -> async (),
        unretirePlayer: (proposalPayload: T.UnretirePlayerPayload) -> async (),
        promoteTeam: (proposalPayload: T.PromoteTeamPayload) -> async (),
        relegateTeam: (proposalPayload: T.RelegateTeamPayload) -> async (),
        updateTeam: (proposalPayload: T.UpdateTeamPayload) -> async ()){

        private let oneHour = 1_000_000_000 * 60 * 60;
        private let governanceCanister  : SNSGovernance.Interface = actor(SNSGovernance.CANISTER_ID);

        //really all of these could be extracted from the governance canister and probably should:

        /*
        private var fixtureDataSubmissions: HashMap.HashMap<T.FixtureId, List.List<T.DataSubmission>> = 
            HashMap.HashMap<T.FixtureId, List.List<T.DataSubmission>>(22, Utilities.eqNat32, Utilities.hashNat32);
        private var playerRevaluationSubmissions: HashMap.HashMap<T.SeasonId, HashMap.HashMap<T.GameweekNumber, HashMap.HashMap<T.PlayerId, List.List<T.PlayerValuationSubmission>>>> = 
            HashMap.HashMap<T.SeasonId, HashMap.HashMap<T.GameweekNumber, HashMap.HashMap<T.PlayerId, List.List<T.PlayerValuationSubmission>>>> (20, Utilities.eqNat16, Utilities.hashNat16);
        private var consensusFixtureData: HashMap.HashMap<T.FixtureId, T.ConsensusData> = HashMap.HashMap<T.FixtureId, T.ConsensusData>(22, Utilities.eqNat32, Utilities.hashNat32);
        */

        private var addInitialFixtures : ?((T.AddInitialFixturesPayload) -> async ()) = null;
        private var rescheduleFixture : ?((T.RescheduleFixturePayload) -> async ()) = null;
        private var setAndBackupTimer : ?((duration: Timer.Duration, callbackName: Text, fixtureId: T.FixtureId) -> async ()) = null;
        private var finaliseFixture : ?((seasonId: T.SeasonId, gameweekNumber: T.GameweekNumber, fixtureId: T.FixtureId) -> async ()) = null;

        //system parameters - I guess I need to check whether I can set these times based on proposal type as some proposals should take longer than 12 hours
        /*
        private var EventData_VotePeriod: Int = oneHour * 12;
        private var Proposal_VotePeriod: Int = oneHour * 12;
        private var EventData_VoteThreshold: Nat64 = 100_000;
        private var Revaluation_VoteThreshold: Nat64 = 1_000_000;
        private var Proposal_VoteThreshold: Nat64 = 1_000_000;
        private var Max_Votes_Per_User: Nat64 = 100_000;
        private var Proposal_Submission_e8_Fee: Nat64 = 10_000;

        
        //system parameter function setters
        public func getEventDataVotePeriod() : Int{
            return EventData_VotePeriod;
        };

        public func setEventDataVotePeriod(newValue: Int){
            EventData_VotePeriod := newValue;
        };
        
        public func getEventDataVoteThreshold() : Nat64{
            return EventData_VoteThreshold;
        };

        public func setEventDataVoteThreshold(newValue: Nat64){
            EventData_VoteThreshold := newValue;
        };
        
        public func getRevaluationVoteThreshold() : Nat64{
            return Revaluation_VoteThreshold;
        };

        public func setRevaluationVoteThreshold(newValue: Nat64){
            Revaluation_VoteThreshold := newValue;
        };
        
        public func getProposalVoteThreshold() : Nat64{
            return Proposal_VoteThreshold;
        };

        public func setProposalVoteThreshold(newValue: Nat64){
            Proposal_VoteThreshold := newValue;
        };
        
        public func getMaxVotesPerUser() : Nat64{
            return Max_Votes_Per_User;
        };

        public func setMaxVotesPerUser(newValue: Nat64){
            Max_Votes_Per_User := newValue;
        };
        
        public func getProposalSubmissione8Fee() : Nat64{
            return Proposal_Submission_e8_Fee;
        };

        public func setProposalSubmissione8Fee(newValue: Nat64){
            Proposal_Submission_e8_Fee := newValue;
        };
        */

        public func setFixtureFunctions(_addInitialFixtures: (proposalPayload: T.AddInitialFixturesPayload) -> async (), _rescheduleFixture: (proposalPayload: T.RescheduleFixturePayload) -> async ()) {
            addInitialFixtures := ?_addInitialFixtures;
            rescheduleFixture := ?_rescheduleFixture;
        };

        /* Need to get from governance canister
        public func getVotingPower(principalId: Text) : Nat64 {
            switch (Array.find<Text>(admins, func (admin) { admin == principalId })) {
                case null { return 0; };
                case _ { 
                    var dummyVP = Nat64.fromNat(1_000_000);
                    if(dummyVP > Max_Votes_Per_User){
                        dummyVP := Max_Votes_Per_User;
                    };
                    return dummyVP; 
                };
            };
        };
        */
        
        /*
        public func getFixtureDataSubmissions() : [(T.FixtureId, List.List<T.DataSubmission>)] {
            return Iter.toArray(fixtureDataSubmissions.entries());
        };
        
        public func getConsensusFixtureData() : [(T.FixtureId, T.ConsensusData)] {
            return Iter.toArray(consensusFixtureData.entries());
        };
        */

        /*
        public func getPlayerRevaluationSubmissions() : [(T.SeasonId, (T.GameweekNumber, (T.PlayerId, List.List<T.PlayerValuationSubmission>)))] {
            var results: [(T.SeasonId, (T.GameweekNumber, (T.PlayerId, List.List<T.PlayerValuationSubmission>)))] = [];
            var resultsBuffer = Buffer.fromArray<(T.SeasonId, (T.GameweekNumber, (T.PlayerId, List.List<T.PlayerValuationSubmission>)))>(results);

            for ((seasonId, midMap) in playerRevaluationSubmissions.entries()) {        
                for ((gameweek, innerMap) in midMap.entries()) {
                    for ((playerId, submissions) in innerMap.entries()) {
                        let entry: (T.SeasonId, (T.GameweekNumber, (T.PlayerId, List.List<T.PlayerValuationSubmission>))) = (seasonId, (gameweek, (playerId, submissions)));
                        resultsBuffer.add(entry);
                    }
                }
            };

            results := Buffer.toArray(resultsBuffer);
            return results;
        };
        */

        /* This will be replaced with the governance function to add the data via a proposal
        public func submitPlayerEventData(principalId: Text, fixtureId: T.FixtureId, allPlayerEventData: [T.PlayerEventData]) : async () {
            
            let existingSubmissionsForFixture = fixtureDataSubmissions.get(fixtureId);
            switch (existingSubmissionsForFixture) {
                case (?submissions) {
                    for (submission in Iter.fromList(submissions)) {
                        if (submission.proposer == principalId) {
                            return;
                        };
                    }
                };
                case null {};
            };
            
            let userVotingPower: Nat64 = getVotingPower(principalId);
            let currentTime = Time.now();
        
            let votes: T.PlayerValuationVote = {
                principalId = Principal.fromText(principalId);
                votes = {amount_e8s = userVotingPower};
            };

            let newSubmission: T.DataSubmission = {
                fixtureId = fixtureId;
                proposer = principalId;
                timestamp = currentTime;
                events = List.fromArray(allPlayerEventData);
                votes_yes = List.fromArray<T.PlayerValuationVote>([votes]);
                votes_no = List.nil<T.PlayerValuationVote>();
            };

            let updatedSubmissions = switch (existingSubmissionsForFixture) {
                case (null) {
                    List.fromArray([newSubmission])
                };
                case (?currentSubmissions) {
                    List.push(newSubmission, currentSubmissions)
                }
            };

            fixtureDataSubmissions.put(fixtureId, updatedSubmissions);
            let newConsensus = recalculateConsensus(fixtureId);
            consensusFixtureData.put(fixtureId, newConsensus);
            
            let consensusAchieved = newConsensus.totalVotes.amount_e8s >= EventData_VoteThreshold;
       
            if(consensusAchieved){
                switch(finaliseFixture){
                    case (null) {};
                    case (?foundFunction){
                        await foundFunction(0, 0, fixtureId);
                    };
                }
            };
        };
        */

        /* Consensus should be calculated from the governance canister
        private func recalculateConsensus(fixtureId: T.FixtureId) : T.ConsensusData {
            let foundSubmissions = fixtureDataSubmissions.get(fixtureId);
        
            switch(foundSubmissions){
                case (null) {
                    
                    return {
                        fixtureId = 0;
                        events = List.nil();
                        totalVotes = {amount_e8s = 0};
                    };
                };
                case (?submissions){

                    var maxVotesSubmission: ?T.DataSubmission = null;
                    var maxVotes: Int = 0;

                    List.iterate(submissions, func (submission: T.DataSubmission) {
                        let totalVotesYes = List.foldLeft<T.PlayerValuationVote, Int>(submission.votes_yes, 0, func (acc: Int, vote: T.PlayerValuationVote) {
                            acc + Int64.toInt(Int64.fromNat64(vote.votes.amount_e8s));
                        });

                        let totalVotesNo = List.foldLeft<T.PlayerValuationVote, Int>(submission.votes_no, 0, func (acc: Int, vote: T.PlayerValuationVote) {
                            acc + Int64.toInt(Int64.fromNat64(vote.votes.amount_e8s));
                        });

                        let currentTotalVotes = totalVotesYes - totalVotesNo;

                        if (currentTotalVotes > maxVotes) {
                            maxVotes := currentTotalVotes;
                            maxVotesSubmission := ?submission;
                        }
                    });

                    let (weightedEvents, totalVotesYes, totalVotesNo) = switch (maxVotesSubmission) {
                        case (null) {
                            ([], { amount_e8s = 0 }, { amount_e8s = 0 })
                        };
                        case (?submissionWithMaxVotes) {
                            let events = List.toArray(submissionWithMaxVotes.events);

                            let votesYes = List.foldLeft<T.PlayerValuationVote, Int>(submissionWithMaxVotes.votes_yes, 0, func (acc: Int, vote: T.PlayerValuationVote) {
                                acc + Int64.toInt(Int64.fromNat64(vote.votes.amount_e8s));
                            });

                            let votesNo = List.foldLeft<T.PlayerValuationVote, Int>(submissionWithMaxVotes.votes_no, 0, func (acc: Int, vote: T.PlayerValuationVote) {
                                acc + Int64.toInt(Int64.fromNat64(vote.votes.amount_e8s));
                            });

                            (events, { amount_e8s = votesYes }, { amount_e8s = votesNo })
                        };
                    };

                    let totalVotesDifference = totalVotesYes.amount_e8s - totalVotesNo.amount_e8s;
                    let totalVotes: T.Tokens = { amount_e8s = Int64.toNat64(Int64.fromInt(totalVotesDifference)) };

                    return {
                        fixtureId = fixtureId;
                        events = List.fromArray(weightedEvents);
                        totalVotes = totalVotes;
                    };
                };
            };

        };
        */

        /* Needs to be done via proposal
        public func submitPlayerRevaluations(principalId: Text, seasonId: T.SeasonId, gameweek: T.GameweekNumber, revaluations: [T.PlayerValuationSubmission]) : () {
            let userVotingPower: Nat64 = getVotingPower(principalId);

            switch (playerRevaluationSubmissions.get(seasonId)) {
                case (null) {
                    let innerMap = HashMap.HashMap<T.PlayerId, List.List<T.PlayerValuationSubmission>>(10, Utilities.eqNat16, Utilities.hashNat16);
                    for (revaluation in Iter.fromArray(revaluations)) {
                        innerMap.put(revaluation.playerId, List.push(revaluation, List.nil<T.PlayerValuationSubmission>()));
                    };

                    let midMap = HashMap.HashMap<T.GameweekNumber, HashMap.HashMap<T.PlayerId, List.List<T.PlayerValuationSubmission>>>(10, Utilities.eqNat8, Utilities.hashNat8);
                    midMap.put(gameweek, innerMap);

                    playerRevaluationSubmissions.put(seasonId, midMap);
                };
                case (?midMap) {
                    switch (midMap.get(gameweek)) {
                        case (null) {
                            let innerMap = HashMap.HashMap<T.PlayerId, List.List<T.PlayerValuationSubmission>>(10, Utilities.eqNat16, Utilities.hashNat16);
                            for (revaluation in Iter.fromArray(revaluations)) {
                                innerMap.put(revaluation.playerId, List.push(revaluation, List.nil<T.PlayerValuationSubmission>()));
                            };

                            midMap.put(gameweek, innerMap);
                        };
                        case (?innerMap) {
                            for (revaluation in Iter.fromArray(revaluations)) {
                                switch (innerMap.get(revaluation.playerId)) {
                                    case (null) {
                                        innerMap.put(revaluation.playerId, List.push(revaluation, List.nil<T.PlayerValuationSubmission>()));
                                    };
                                    case (?existingRevaluations) {
                                        innerMap.put(revaluation.playerId, List.push(revaluation, existingRevaluations));
                                    };
                                }
                            }
                        };
                    }
                };
            }
        };
        */

        /* Will be set on successful execution of a proposal
        public func getConsensusPlayerEventData(gameweek: Nat8, fixtureId: Nat32) : async List.List<T.PlayerEventData> {
            let consensusDataOption = consensusFixtureData.get(fixtureId);
            
            switch (consensusDataOption) {
                case (null) { 
                    return List.nil();
                };
                case (?consensusData) {
                    return consensusData.events ; 
                };
            };
        };
        */

        /* Need to get the players to be revalued from the governance canister
        public func getRevaluedPlayers(seasonId: Nat16, gameweek: Nat8) : async List.List<T.RevaluedPlayer> {
            var revaluedPlayers: List.List<T.RevaluedPlayer> = List.nil<T.RevaluedPlayer>();

            let seasonData = playerRevaluationSubmissions.get(seasonId);
            switch (seasonData) {
                case (null) { return List.nil<T.RevaluedPlayer>(); };
                case (?seasonData) {
                    let gameweekData = seasonData.get(gameweek);
                    switch (gameweekData) {
                        case (null) { return List.nil<T.RevaluedPlayer>(); };
                        case (?gameweekData) {
                            
                            for ((_, submissions) in gameweekData.entries()) {
                                
                                let totalVotesUp = List.foldLeft<T.PlayerValuationSubmission, Nat64>(submissions, 0, func(acc: Nat64, x: T.PlayerValuationSubmission): Nat64 {
                                    return acc + List.foldLeft<T.PlayerValuationVote, Nat64>(x.votes_up, 0, func(innerAcc: Nat64, vote: T.PlayerValuationVote): Nat64 {
                                        return innerAcc + vote.votes.amount_e8s;
                                    });
                                });

                                let totalVotesDown = List.foldLeft<T.PlayerValuationSubmission, Nat64>(submissions, 0, func(acc: Nat64, x: T.PlayerValuationSubmission): Nat64 {
                                    return acc + List.foldLeft<T.PlayerValuationVote, Nat64>(x.votes_down, 0, func(innerAcc: Nat64, vote: T.PlayerValuationVote): Nat64 {
                                        return innerAcc + vote.votes.amount_e8s;
                                    });
                                });


                                switch (submissions) {
                                    case (null) {  };
                                    case (?(firstSubmission, _)) {
                                        if (totalVotesUp > Revaluation_VoteThreshold) {
                                            revaluedPlayers := List.append<T.RevaluedPlayer>(revaluedPlayers, List.make<T.RevaluedPlayer>({
                                                playerId = firstSubmission.playerId;
                                                direction = #Increase;
                                            }));
                                        } else if (totalVotesDown > Revaluation_VoteThreshold) {
                                            revaluedPlayers := List.append<T.RevaluedPlayer>(revaluedPlayers, List.make<T.RevaluedPlayer>({
                                                playerId = firstSubmission.playerId;
                                                direction = #Decrease;
                                            }));
                                        }
                                    };
                                };
                            }
                        };
                    };
                };
            };
            return revaluedPlayers;
        };
        */
        /* Add individual execution events instead of this
        private func updateSystemParameters(proposalPayload: T.UpdateSystemParametersPayload) : async () {
            switch (proposalPayload.flag) {
                case (#EventData_VotePeriod) {
                    switch (proposalPayload.event_data_voting_period) {
                        case (null) {  };
                        case (?value) {
                            EventData_VotePeriod := value;
                        };
                    };
                };
                case (#EventData_VoteThreshold) {
                    switch (proposalPayload.event_data_vote_threshold) {
                        case (null) {  };
                        case (?value) {
                            EventData_VoteThreshold := value;
                        };
                    };
                };
                case (#Revaluation_VoteThreshold) {
                    switch (proposalPayload.revalution_vote_threshold) {
                        case (null) {  };
                        case (?value) {
                            Revaluation_VoteThreshold := value;
                        };
                    };
                };
                case (#Proposal_VoteThreshold) {
                    switch (proposalPayload.proposal_vote_threshold) {
                        case (null) {  };
                        case (?value) {
                            Proposal_VoteThreshold := value;
                        };
                    };
                };
                case (#Max_Votes_Per_User) {
                    switch (proposalPayload.max_votes_per_user) {
                        case (null) {  };
                        case (?value) {
                            Max_Votes_Per_User := value;
                        };
                    };
                };
                case (#Proposal_Submission_e8_Fee) {
                    switch (proposalPayload.proposal_submission_e8_fee) {
                        case (null) {  };
                        case (?value) {
                            Proposal_Submission_e8_Fee := value;
                        };
                    };
                };
            };
        };
        */
    
        public func setTimerBackupFunction(_setAndBackupTimer: (duration: Timer.Duration, callbackName: Text, fixtureId: T.FixtureId) -> async ()) {
            setAndBackupTimer := ?_setAndBackupTimer;
        };
    
        public func setFinaliseFixtureFunction(_finaliseFixture: (seasonId: T.SeasonId, gameweekNumber: T.GameweekNumber, fixtureId: T.FixtureId) -> async ()) {
            finaliseFixture := ?_finaliseFixture;
        };

/* Remove as no longer storing this data
        public func resetConsensusData (data: [(T.FixtureId, T.ConsensusData)]) : (){
            consensusFixtureData := HashMap.fromIter<T.FixtureId, T.ConsensusData>(
                data.vals(),
                data.size(),
                Utilities.eqNat32, 
                Utilities.hashNat32
            );
        };
*/
        

    }
}

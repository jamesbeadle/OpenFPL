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
        
        /*
        ////USE FOR LOCAL DEV
        let admins : [Text] = [
            "6sbwi-mq6zw-jcwiq-urs3i-2abjy-o7p3o-n33vj-ecw43-vsd2w-4poay-iqe"
        ];
        */

        //Live
        let admins : [Text] = [
            "opyzn-r7zln-jwgvb-tx75c-ncekh-xhvje-epcj7-saonq-z732m-zi4mm-qae"
        ];
        private var fixtureDataSubmissions: HashMap.HashMap<T.FixtureId, List.List<T.DataSubmission>> = 
            HashMap.HashMap<T.FixtureId, List.List<T.DataSubmission>>(22, Utilities.eqNat32, Utilities.hashNat32);
        private var playerRevaluationSubmissions: HashMap.HashMap<T.SeasonId, HashMap.HashMap<T.GameweekNumber, HashMap.HashMap<T.PlayerId, List.List<T.PlayerValuationSubmission>>>> = 
            HashMap.HashMap<T.SeasonId, HashMap.HashMap<T.GameweekNumber, HashMap.HashMap<T.PlayerId, List.List<T.PlayerValuationSubmission>>>> (20, Utilities.eqNat16, Utilities.hashNat16);
        private var proposals: List.List<T.Proposal> = List.nil<T.Proposal>();
        private var consensusFixtureData: HashMap.HashMap<T.FixtureId, T.ConsensusData> = HashMap.HashMap<T.FixtureId, T.ConsensusData>(22, Utilities.eqNat32, Utilities.hashNat32);
        
        private var addInitialFixtures : ?((T.AddInitialFixturesPayload) -> async ()) = null;
        private var rescheduleFixture : ?((T.RescheduleFixturePayload) -> async ()) = null;

        //system parameters
        private var EventData_VotePeriod: Int = oneHour * 12;
        private var Proposal_VotePeriod: Int = oneHour * 12;
        private var EventData_VoteThreshold: Nat64 = 100_000;
        private var Revaluation_VoteThreshold: Nat64 = 1_000_000;
        private var Proposal_VoteThreshold: Nat64 = 1_000_000;
        private var Max_Votes_Per_User: Nat64 = 100_000;
        private var Proposal_Submission_e8_Fee: Nat64 = 10_000;

        private var setAndBackupTimer : ?((duration: Timer.Duration, callbackName: Text, fixtureId: T.FixtureId) -> async ()) = null;
        private var finaliseFixture : ?((seasonId: T.SeasonId, gameweekNumber: T.GameweekNumber, fixtureId: T.FixtureId) -> async ()) = null;
    
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

        public func setFixtureFunctions(_addInitialFixtures: (proposalPayload: T.AddInitialFixturesPayload) -> async (), _rescheduleFixture: (proposalPayload: T.RescheduleFixturePayload) -> async ()) {
            addInitialFixtures := ?_addInitialFixtures;
            rescheduleFixture := ?_rescheduleFixture;
        };

        public func setData(
            stable_fixture_data_submissions: [(T.FixtureId, List.List<T.DataSubmission>)], 
            stable_player_revaluation_submissions: [(T.SeasonId, (T.GameweekNumber, (T.PlayerId, List.List<T.PlayerValuationSubmission>)))],
            stable_proposals: [T.Proposal],
            stable_consensus_fixture_data: [(T.FixtureId, T.ConsensusData)]) {

            // Type definitions
            type InnerMapType = HashMap.HashMap<T.PlayerId, List.List<T.PlayerValuationSubmission>>;
            type MidMapType = HashMap.HashMap<T.GameweekNumber, InnerMapType>;
            type OuterMapType = HashMap.HashMap<T.SeasonId, MidMapType>;

            // Iterators
            let fixtureDataIterator = Iter.fromArray(stable_fixture_data_submissions);

            fixtureDataSubmissions := HashMap.fromIter<T.FixtureId, List.List<T.DataSubmission>>(
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

            proposals := List.fromArray(stable_proposals);

            consensusFixtureData := HashMap.fromIter<T.FixtureId, T.ConsensusData>(
                stable_consensus_fixture_data.vals(),
                stable_consensus_fixture_data.size(),
                Utilities.eqNat32, 
                Utilities.hashNat32
            );
        };

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
        
        public func getFixtureDataSubmissions() : [(T.FixtureId, List.List<T.DataSubmission>)] {
            return Iter.toArray(fixtureDataSubmissions.entries());
        };
        
        public func getConsensusFixtureData() : [(T.FixtureId, T.ConsensusData)] {
            return Iter.toArray(consensusFixtureData.entries());
        };

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

        public func getProposals() : [T.Proposal]{
            return List.toArray(proposals);
        };

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

        public func voteOnProposal(principalId: Text, proposalId: T.ProposalId, voteChoice: T.VoteChoice) : () {
            let userVotingPower: Nat64 = getVotingPower(principalId);
            
            let proposalOpt: ?T.Proposal = findProposalById(proposalId);

            switch (proposalOpt) {
                case (null) { };
                case (?proposal) {
                    if (not hasUserVoted(Principal.fromText(principalId), proposal)) {
                        castVote(Principal.fromText(principalId), proposal, voteChoice, userVotingPower);
                    };
                };
            }
        };

        private func findProposalById(proposalId: T.ProposalId) : ?T.Proposal {
            var current: List.List<T.Proposal> = proposals;
            while (switch current {
                case null { false };
                case (?((head, tail))) {
                    if (head.id == proposalId) { true } else {
                        current := tail;
                        false
                    }
                }
            }) {};
            switch current {
                case null { return null; };
                case (?((head, _))) { return ?head; };
            }
        };

        private func hasUserVoted(principal: Principal, proposal: T.Proposal) : Bool {
            let hasVotedYes = Array.find<T.PlayerValuationVote>(List.toArray(proposal.votes_yes), func (vote: T.PlayerValuationVote) : Bool {
                return vote.principalId == principal;
            }) != null;

            let hasVotedNo = Array.find<T.PlayerValuationVote>(List.toArray(proposal.votes_no), func (vote: T.PlayerValuationVote) : Bool {
                return vote.principalId == principal;
            }) != null;

            return hasVotedYes or hasVotedNo;
        };

        private func castVote(principal: Principal, proposal: T.Proposal, voteChoice: T.VoteChoice, votingPower: Nat64) : () {
            let userVote: T.PlayerValuationVote = {
                principalId = principal;
                votes = { amount_e8s = votingPower };
            };

            let updatedProposal: T.Proposal = {
                id = proposal.id;
                votes_no = switch (voteChoice) {
                    case (#Yes) { proposal.votes_no };
                    case (#No) { List.append(?(userVote, null), proposal.votes_no) };
                };
                votes_yes = switch (voteChoice) {
                    case (#Yes) { List.append(?(userVote, null), proposal.votes_yes) };
                    case (#No) { proposal.votes_yes };
                };
                voters = List.append(?(principal, null), proposal.voters);
                state = proposal.state;
                timestamp = proposal.timestamp;
                proposer = proposal.proposer;
                payload = proposal.payload;
                proposalType = proposal.proposalType;
                data = proposal.data;
            };

            func replaceInList(current: List.List<T.Proposal>, found: Bool) : (List.List<T.Proposal>, Bool) {
                switch current {
                    case null {
                        return (null, found);
                    };
                    case (?((head, tail))) {
                        if (head.id == proposal.id and not found) {
                            let (newTail, _) = replaceInList(tail, true);
                            return (?(updatedProposal, newTail), true);
                        } else {
                            let (newTail, wasReplaced) = replaceInList(tail, found);
                            return (?(head, newTail), wasReplaced);
                        };
                    };
                };
            };

            let (newProposals, _) = replaceInList(proposals, false);
            proposals := newProposals;
        };

        public func submitProposal(proposer: Principal, payload: T.ProposalPayload, proposalType: T.ProposalType, data: T.PayloadData) : async Nat {
            let newId = List.size<T.Proposal>(proposals) + 1;

            let newProposal: T.Proposal = {
                id = newId;
                votes_no = List.nil<T.PlayerValuationVote>();
                voters = List.nil<Principal>();
                state = #open;
                timestamp = Time.now();
                proposer = proposer;
                votes_yes = List.nil<T.PlayerValuationVote>();
                payload = payload;
                proposalType = proposalType;
                data = data;
            };

            proposals := List.append(?(newProposal, null), proposals);

            let proposalTimerDuration : Timer.Duration = #nanoseconds (Int.abs((Time.now() + Proposal_VotePeriod) - Time.now()));
            switch(setAndBackupTimer) {
                case (null) { };
                case (?actualFunction) {
                    await actualFunction(proposalTimerDuration, "proposalExpired", 0);
                };
            };
            
            return newId;
        };


        public func proposalExpired() : async () {
            
            var updatedProposals = List.nil<T.Proposal>();
            
            for (proposal in Iter.fromList<T.Proposal>(proposals)) {
                if (Time.now() - proposal.timestamp > Proposal_VotePeriod) {
                    let yesVotes = Nat64.fromNat(List.size<T.PlayerValuationVote>(proposal.votes_yes));
                    let noVotes = Nat64.fromNat(List.size<T.PlayerValuationVote>(proposal.votes_no));
                    
                    if (yesVotes > noVotes and yesVotes > Proposal_VoteThreshold) {
                        await executeProposal(proposal);
                        updatedProposals := List.append(?(proposal, null), updatedProposals);
                    } else {
                        let updatedProposal: T.Proposal = {
                            id = proposal.id;
                            votes_no = proposal.votes_no;
                            voters = proposal.voters;
                            state = #rejected;
                            timestamp = proposal.timestamp;
                            proposer = proposal.proposer;
                            votes_yes = proposal.votes_yes;
                            payload = proposal.payload;
                            proposalType = proposal.proposalType;
                            data = proposal.data;
                        };
                        updatedProposals := List.append(?(updatedProposal, null), updatedProposals);
                    }
                } else {
                    updatedProposals := List.append(?(proposal, null), updatedProposals);
                }
            };
            proposals := updatedProposals;
        };

        private func executeProposal(proposal: T.Proposal) : async () {
            switch (proposal.data) {
                 case (#AddInitialFixtures(payload)) {
                    switch (addInitialFixtures) {
                        case (null) { };
                        case (?f) { await f(payload); };
                    };
                };
                case (#RescheduleFixture(payload)) {
                    switch (rescheduleFixture) {
                        case (null) {  };
                        case (?f) { await f(payload); };
                    };
                };
                case (#TransferPlayer(payload)) {
                    await transferPlayer(payload);
                };
                case (#LoanPlayer(payload)) {
                    await loanPlayer(payload);
                };
                case (#RecallPlayer(payload)) {
                    await recallPlayer(payload);
                };
                case (#CreatePlayer(payload)) {
                    await createPlayer(payload);
                };
                case (#UpdatePlayer(payload)) {
                    await updatePlayer(payload);
                };
                case (#SetPlayerInjury(payload)) {
                    await setPlayerInjury(payload);
                };
                case (#RetirePlayer(payload)) {
                    await retirePlayer(payload);
                };
                case (#UnretirePlayer(payload)) {
                    await unretirePlayer(payload);
                };
                case (#PromoteTeam(payload)) {
                    await promoteTeam(payload);
                };
                case (#RelegateTeam(payload)) {
                    await relegateTeam(payload);
                };
                case (#UpdateTeam(payload)) {
                    await updateTeam(payload);
                };
                case (#UpdateSystemParameters(payload)) {
                    await updateSystemParameters(payload);
                };
            };
        };

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
    
        public func setTimerBackupFunction(_setAndBackupTimer: (duration: Timer.Duration, callbackName: Text, fixtureId: T.FixtureId) -> async ()) {
            setAndBackupTimer := ?_setAndBackupTimer;
        };
    
        public func setFinaliseFixtureFunction(_finaliseFixture: (seasonId: T.SeasonId, gameweekNumber: T.GameweekNumber, fixtureId: T.FixtureId) -> async ()) {
            finaliseFixture := ?_finaliseFixture;
        };

        //REMOVE JUST FOR TESTING
        public func resetConsensusData(stable_consensus_fixture_data: [(T.FixtureId, T.ConsensusData)]) {

            consensusFixtureData := HashMap.fromIter<T.FixtureId, T.ConsensusData>(
                stable_consensus_fixture_data.vals(),
                stable_consensus_fixture_data.size(),
                Utilities.eqNat32, 
                Utilities.hashNat32
            );
        };

    }
}

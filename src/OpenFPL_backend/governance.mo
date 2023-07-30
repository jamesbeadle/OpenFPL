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

module {
    public class Governance(
        addInitialFixtures: (proposalPayload: T.AddInitialFixturesPayload) -> async (),
        rescheduleFixture: (proposalPayload: T.RescheduleFixturePayload) -> async (),
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
        updateTeam: (proposalPayload: T.UpdateTeamPayload) -> async (),
        updateSystemParameters: (proposalPayload: T.UpdateSystemParametersPayload) -> async ()){

        private let oneHour = 1_000_000_000 * 60 * 60;

        private var Revalution_Threshold: Nat64 = 0;

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
        private var proposals: List.List<T.Proposal> = List.nil<T.Proposal>();
        private var consensusDraftFixtureData: HashMap.HashMap<T.FixtureId, T.ConsensusData> = HashMap.HashMap<T.FixtureId, T.ConsensusData>(22, Utilities.eqNat32, Utilities.hashNat32);
        private var consensusFixtureData: HashMap.HashMap<T.FixtureId, T.ConsensusData> = HashMap.HashMap<T.FixtureId, T.ConsensusData>(22, Utilities.eqNat32, Utilities.hashNat32);
        private var proposalTimers: TrieMap.TrieMap<Nat, T.ProposalTimer> = TrieMap.TrieMap<Nat, T.ProposalTimer>(Nat.equal, Utilities.hashNat);

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

            proposals := List.fromArray(stable_proposals);
        };

        public func getVotingPower(principalId: Text) : Nat64 {
            switch (Array.find<Text>(admins, func (admin) { admin == principalId })) {
            case null { return 0; };
            case _ { return 1_000_000; };
            };
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

        public func submitPlayerEventData(principalId: Text, fixtureId: T.FixtureId, playerEventData: [T.PlayerEventData], isDraft: Bool) : () {
            let userVotingPower: Nat64 = getVotingPower(principalId);
            let currentTime = Time.now();

            let newSubmission: T.DataSubmission = {
                fixtureId = fixtureId;
                proposer = principalId;
                timestamp = currentTime;
                events = List.fromArray(playerEventData);
                votes_yes = List.nil<T.PlayerValuationVote>();
                votes_no = List.nil<T.PlayerValuationVote>();
            };

            let existingSubmissions = if (isDraft) {
                draftFixtureDataSubmissions.get(fixtureId)
            } else {
                fixtureDataSubmissions.get(fixtureId)
            };

            let updatedSubmission = switch (existingSubmissions) {
                case (null) {
                    newSubmission
                };
                case (?currentSubmissions) {
                    if (Utilities.eqPlayerEventDataArray(List.toArray(currentSubmissions.events), List.toArray(newSubmission.events))) {
                        let newVote: T.PlayerValuationVote = {
                            principalId = Principal.fromText(principalId);
                            votes = { amount_e8s = userVotingPower };
                        };
                        let updatedVotesYes = List.push(newVote, currentSubmissions.votes_yes);
                        { currentSubmissions with votes_yes = updatedVotesYes }
                    } else {
                        newSubmission
                    }
                }
            };

            if (isDraft) {
                draftFixtureDataSubmissions.put(fixtureId, updatedSubmission);
            } else {
                fixtureDataSubmissions.put(fixtureId, updatedSubmission);
            };

            let newConsensus = recalculateConsensus(fixtureId, isDraft);
            if (isDraft) {
                consensusDraftFixtureData.put(fixtureId, newConsensus);
            } else {
                consensusFixtureData.put(fixtureId, newConsensus);
            };
        };

        private func recalculateConsensus(fixtureId: T.FixtureId, isDraft: Bool) : T.ConsensusData {
            var dataSubmission: ?T.DataSubmission = null;

            if (isDraft) {
                dataSubmission := draftFixtureDataSubmissions.get(fixtureId);
            } else {
                dataSubmission := fixtureDataSubmissions.get(fixtureId);
            };

            let submissions = switch (dataSubmission) {
                case (null) { 
                    List.nil<T.DataSubmission>() 
                };
                case (?actualSubmissions) { 
                    List.push(actualSubmissions, List.nil<T.DataSubmission>()) 
                };
            };


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

        public func submitProposal(proposer: Principal, payload: T.ProposalPayload, proposalType: T.ProposalType, data: T.PayloadData) : Nat {
            
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

            let proposalTimerDuration = #nanoseconds (Int.abs((Time.now() + (oneHour * 2)) - Time.now()));
            let proposalTimerId = Timer.setTimer(proposalTimerDuration, proposalExpired);
      
            let newTimer: T.ProposalTimer = { timerId = proposalTimerId };
            proposalTimers.put(newId, newTimer);

            return newId;
        };

        public func proposalExpired() : async () {
            
            var updatedProposals = List.nil<T.Proposal>();
            
            for (proposal in Iter.fromList<T.Proposal>(proposals)) {
                if (Time.now() - proposal.timestamp > (oneHour * 2)) {
                    let yesVotes = List.size<T.PlayerValuationVote>(proposal.votes_yes);
                    let noVotes = List.size<T.PlayerValuationVote>(proposal.votes_no);
                    
                    if (yesVotes > noVotes) {
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
                    await addInitialFixtures(payload);
                };
                case (#RescheduleFixture(payload)) {
                    await rescheduleFixture(payload);
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
                                        if (totalVotesUp > Revalution_Threshold) {
                                            revaluedPlayers := List.append<T.RevaluedPlayer>(revaluedPlayers, List.make<T.RevaluedPlayer>({
                                                playerId = firstSubmission.playerId;
                                                direction = #Increase;
                                            }));
                                        } else if (totalVotesDown > Revalution_Threshold) {
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

    }
}

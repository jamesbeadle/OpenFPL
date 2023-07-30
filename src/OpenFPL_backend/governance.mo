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
        private var proposals: List.List<T.Proposal> = List.nil<T.Proposal>();
        private var consensusDraftFixtureData: HashMap.HashMap<T.FixtureId, T.ConsensusData> = HashMap.HashMap<T.FixtureId, T.ConsensusData>(22, Utilities.eqNat32, Utilities.hashNat32);
        private var consensusFixtureData: HashMap.HashMap<T.FixtureId, T.ConsensusData> = HashMap.HashMap<T.FixtureId, T.ConsensusData>(22, Utilities.eqNat32, Utilities.hashNat32);


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

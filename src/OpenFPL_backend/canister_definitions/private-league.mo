import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import Cycles "mo:base/ExperimentalCycles";
import Float "mo:base/Float";
import Int64 "mo:base/Int64";
import Iter "mo:base/Iter";
import List "mo:base/List";
import Nat16 "mo:base/Nat16";
import Option "mo:base/Option";
import Principal "mo:base/Principal";
import Result "mo:base/Result";
import Text "mo:base/Text";
import Timer "mo:base/Timer";
import Time "mo:base/Time";

import Constants "../utils/Constants";
import DTOs "../DTOs";
import Environment "../utils/Environment";
import T "../types";
import Utilities "../utils/utilities";

actor class _PrivateLeague() {
    
    private stable var cyclesCheckTimerId : ?Timer.TimerId = null;
    private stable var privateLeague: ?T.PrivateLeague = null;
    private stable let percentages : [Float] = [];
    private stable var leagueMembers: [T.LeagueMember] = [];
    private stable var leagueAdmins: [T.PrincipalId] = [];
    private stable var leagueInvites: [T.LeagueInvite] = [];
    private stable var approvedManagerCanisterIds: [T.CanisterId] = [];
    private stable var weeklyLeaderboards: [(T.SeasonId, [(T.GameweekNumber, T.WeeklyLeaderboard)])] = [];
    private stable var monthlyLeaderboards: [(T.SeasonId, [(T.CalendarMonth, T.MonthlyLeaderboard)])] = [];
    private stable var seasonLeaderboards: [(T.SeasonId, T.SeasonLeaderboard)] = [];
    private stable var rewardPools: [(T.SeasonId, T.PrivateLeagueRewardPool)] = [];
    private stable var weeklyRewards : List.List<T.WeeklyRewards> = List.nil();
    private stable var monthlyRewards : List.List<T.MonthlyRewards> = List.nil();
    private stable var seasonRewards : List.List<T.SeasonRewards> = List.nil();
    
    public shared ({ caller }) func getPrivateLeague() : async Result.Result<DTOs.PrivateLeagueDTO, T.Error> {
        assert not Principal.isAnonymous(caller);
        let principalId = Principal.toText(caller);
        assert principalId == Environment.BACKEND_CANISTER_ID;

        switch(privateLeague){
            case (null) { #err(#NotFound) };
            case (?foundPrivateLeague){
                #ok({
                    name = foundPrivateLeague.name;
                    maxEntrants = foundPrivateLeague.maxEntrants;
                    entrants = Nat16.fromNat(Array.size(leagueMembers));
                    picture = foundPrivateLeague.picture;
                    banner = foundPrivateLeague.banner;
                    entryType = foundPrivateLeague.entryType;
                    tokenId = foundPrivateLeague.tokenId;
                    entryFee = foundPrivateLeague.entryFee;
                    adminFee = foundPrivateLeague.adminFee; 
                    creatorPrincipalId = foundPrivateLeague.createdById;
                });
            }
        };
    };

    public shared ({ caller }) func getManagerPrivateLeague(managerId: T.PrincipalId, filters: DTOs.GameweekFiltersDTO) : async Result.Result<DTOs.ManagerPrivateLeagueDTO, T.Error> {
        assert not Principal.isAnonymous(caller);
        let principalId = Principal.toText(caller);
        assert principalId == Environment.BACKEND_CANISTER_ID;
        var seasonPosition = 0;
        var seasonPositionText = "";

        for(weeklyLeaderboard in Iter.fromArray(weeklyLeaderboards)){
            if(weeklyLeaderboard.0 == filters.seasonId){
                for (gw in Iter.fromArray(weeklyLeaderboard.1)){
                    if(gw.0 == filters.gameweek){
                        for(entry in Iter.fromList(gw.1.entries)){
                            if(entry.principalId == managerId){
                                seasonPosition := entry.position;
                                seasonPositionText := entry.positionText;
                            }
                        };
                    }
                }
            };
        };

        for(member in Iter.fromArray(leagueMembers)){
            if(member.principalId == managerId){
                switch(privateLeague){
                    case (null) {};
                    case (?foundPrivateLeague){
                        return #ok({
                            canisterId = foundPrivateLeague.canisterId;
                            created = member.joinedDate;
                            memberCount = Array.size(leagueMembers);
                            name = foundPrivateLeague.name;
                            seasonPosition = seasonPosition;
                            seasonPositionText = seasonPositionText;
                        });
                    }
                }
            };
        };

        return #err(#NotFound);
    };

    public shared ({ caller }) func calculateLeaderboards(seasonId : T.SeasonId, gameweek : T.GameweekNumber, month : T.CalendarMonth) : async () {
        assert not Principal.isAnonymous(caller);
        let principalId = Principal.toText(caller);
        assert principalId == Environment.BACKEND_CANISTER_ID;
        await calculateWeeklyLeaderboards(seasonId, gameweek);
        await calculateMonthlyLeaderboards(seasonId, month);
        await calculateSeasonLeaderboard(seasonId);
    };

    public shared ({ caller }) func payWeeklyRewards(seasonId : T.SeasonId, gameweek : T.GameweekNumber) : async (){
        assert not Principal.isAnonymous(caller);
        let principalId = Principal.toText(caller);
        assert principalId == Environment.BACKEND_CANISTER_ID;

        let seasonRewardPool = Array.find<(T.SeasonId, T.PrivateLeagueRewardPool)>(
            rewardPools,
            func(pool : (T.SeasonId, T.PrivateLeagueRewardPool)) : Bool {
                return pool.0 == seasonId;
            },
        );

        switch(seasonRewardPool){
            case (?foundRewardPool){
                label leaderboardLoop for(season in Iter.fromArray(weeklyLeaderboards)){
                    if(season.0 == seasonId){
                        for(gw in Iter.fromArray(season.1)){
                            if(gw.0 == gameweek){
                                await distributeWeeklyRewards(foundRewardPool.1.weeklyLeaderboardPool, gw.1);
                                break leaderboardLoop;
                            };
                        };
                    }
                };
            };
            case (null) { };
        };
    };

    public shared ({ caller }) func payMonthlyRewards(seasonId : T.SeasonId, month : T.CalendarMonth) : async (){
        assert not Principal.isAnonymous(caller);
        let principalId = Principal.toText(caller);
        assert principalId == Environment.BACKEND_CANISTER_ID;

        let seasonRewardPool = Array.find<(T.SeasonId, T.PrivateLeagueRewardPool)>(
            rewardPools,
            func(pool : (T.SeasonId, T.PrivateLeagueRewardPool)) : Bool {
                return pool.0 == seasonId;
            },
        );

        switch(seasonRewardPool){
            case (?foundRewardPool){
                label leaderboardLoop for(season in Iter.fromArray(monthlyLeaderboards)){
                    if(season.0 == seasonId){
                        for(mth in Iter.fromArray(season.1)){
                            if(mth.0 == month){
                                await distributeMonthlyRewards(foundRewardPool.1.monthlyLeaderboardPool, mth.1);
                                break leaderboardLoop;
                            };
                        };
                    }
                };
            };
            case (null) { };
        };
    };

    public shared ({ caller }) func paySeasonRewards(seasonId : T.SeasonId) : async (){
        assert not Principal.isAnonymous(caller);
        let principalId = Principal.toText(caller);
        assert principalId == Environment.BACKEND_CANISTER_ID;
        
        let seasonRewardPool = Array.find<(T.SeasonId, T.PrivateLeagueRewardPool)>(
            rewardPools,
            func(pool : (T.SeasonId, T.PrivateLeagueRewardPool)) : Bool {
                return pool.0 == seasonId;
            },
        );

        switch(seasonRewardPool){
            case (?foundRewardPool){
                label leaderboardLoop for(season in Iter.fromArray(seasonLeaderboards)){
                    if(season.0 == seasonId){
                        await distributeSeasonRewards(foundRewardPool.1.seasonLeaderboardPool, season.1);
                        break leaderboardLoop;
                    }
                };
            };
            case (null) { };
        };
    };






    public func distributeWeeklyRewards(weeklyRewardPool : Nat64, weeklyLeaderboard : T.WeeklyLeaderboard) : async () {

        let weeklyRewardAmount = weeklyRewardPool / 38;
        var payouts = List.nil<Float>();
        var currentEntries = weeklyLeaderboard.entries;

        let scaledPercentages = Utilities.scalePercentages(percentages, weeklyLeaderboard.totalEntries);

        while (not List.isNil(currentEntries)) {
            let (currentEntry, rest) = List.pop(currentEntries);
            currentEntries := rest;
            switch (currentEntry) {
            case (null) {};
            case (?foundEntry) {
                let (nextEntry, _) = List.pop(rest);
                switch (nextEntry) {
                    case (null) {
                        let payout = scaledPercentages[foundEntry.position - 1];
                        payouts := List.push(payout, payouts);
                    };
                    case (?foundNextEntry) {
                        if (foundEntry.points == foundNextEntry.points) {
                        let tiedEntries = Utilities.findTiedEntries(rest, foundEntry.points);
                        let startPosition = foundEntry.position;
                        let tiePayouts = Utilities.calculateTiePayouts(tiedEntries, scaledPercentages, startPosition);
                        payouts := List.append(payouts, tiePayouts);

                        var skipEntries = rest;
                        label skipLoop while (not List.isNil(skipEntries)) {
                            let (skipEntry, nextRest) = List.pop(skipEntries);
                            skipEntries := nextRest;

                            switch (skipEntry) {
                            case (null) { break skipLoop };
                            case (?entry) {
                                if (entry.points != foundEntry.points) {
                                currentEntries := skipEntries;
                                break skipLoop;
                                };
                            };
                            };
                        };
                        } else {
                        let payout = scaledPercentages[foundEntry.position - 1];
                        payouts := List.push(payout, payouts);
                        };
                    };
                };

            };
            };
        };

        payouts := List.reverse(payouts);
        let payoutsArray = List.toArray(payouts);
        let rewardBuffer = Buffer.fromArray<T.RewardEntry>([]);

        var key = 0;
        for (winner in Iter.fromList(weeklyLeaderboard.entries)) {
            
            let prize = Int64.toNat64(Float.toInt64(payoutsArray[key])) * weeklyRewardAmount;
            
            let openfpl_backend_canister = actor (Environment.BACKEND_CANISTER_ID) : actor {
                payPrivateLeagueRewards : (winnerPrincipalId: T.PrincipalId, prize: Nat64) -> async ();
            };
            
            await openfpl_backend_canister.payPrivateLeagueRewards(winner.principalId, prize);
            
            rewardBuffer.add({
                principalId = winner.principalId;
                rewardType = #WeeklyLeaderboard;
                position = winner.position;
                amount = prize;
            });
            key += 1;
        };

        let newWeeklyRewards : T.WeeklyRewards = {
            seasonId = weeklyLeaderboard.seasonId;
            gameweek = weeklyLeaderboard.gameweek;
            rewards = List.fromArray(Buffer.toArray(rewardBuffer));
        };

        weeklyRewards := List.append(weeklyRewards, List.make<T.WeeklyRewards>(newWeeklyRewards));
    };

    public func distributeMonthlyRewards(monthlyRewardPool : Nat64, monthlyLeaderboard : T.MonthlyLeaderboard) : async () {

        let monthlyRewardAmount = monthlyRewardPool / 10;
        var payouts = List.nil<Float>();
        var currentEntries = monthlyLeaderboard.entries;

        let scaledPercentages = Utilities.scalePercentages(percentages, monthlyLeaderboard.totalEntries);

        while (not List.isNil(currentEntries)) {
            let (currentEntry, rest) = List.pop(currentEntries);
            currentEntries := rest;
            switch (currentEntry) {
            case (null) {};
            case (?foundEntry) {
                let (nextEntry, _) = List.pop(rest);
                switch (nextEntry) {
                case (null) {
                    let payout = scaledPercentages[foundEntry.position - 1];
                    payouts := List.push(payout, payouts);
                };
                case (?foundNextEntry) {
                    if (foundEntry.points == foundNextEntry.points) {
                    let tiedEntries = Utilities.findTiedEntries(rest, foundEntry.points);
                    let startPosition = foundEntry.position;
                    let tiePayouts = Utilities.calculateTiePayouts(tiedEntries, scaledPercentages, startPosition);
                    payouts := List.append(payouts, tiePayouts);

                    var skipEntries = rest;
                    label skipLoop while (not List.isNil(skipEntries)) {
                        let (skipEntry, nextRest) = List.pop(skipEntries);
                        skipEntries := nextRest;

                        switch (skipEntry) {
                        case (null) { break skipLoop };
                        case (?entry) {
                            if (entry.points != foundEntry.points) {
                            currentEntries := skipEntries;
                            break skipLoop;
                            };
                        };
                        };
                    };
                    } else {
                    let payout = scaledPercentages[foundEntry.position - 1];
                    payouts := List.push(payout, payouts);
                    };
                };
                };

            };
            };
        };

        payouts := List.reverse(payouts);
        let payoutsArray = List.toArray(payouts);
        let rewardBuffer = Buffer.fromArray<T.RewardEntry>([]);

        var key = 0;
        for (winner in Iter.fromList(monthlyLeaderboard.entries)) {
            let prize = Int64.toNat64(Float.toInt64(payoutsArray[key])) * monthlyRewardAmount;
            
            let openfpl_backend_canister = actor (Environment.BACKEND_CANISTER_ID) : actor {
                payPrivateLeagueRewards : (winnerPrincipalId: T.PrincipalId, prize: Nat64) -> async ();
            };
            await openfpl_backend_canister.payPrivateLeagueRewards(winner.principalId, prize);
            
            rewardBuffer.add({
                principalId = winner.principalId;
                rewardType = #MonthlyLeaderboard;
                position = winner.position;
                amount = prize;
            });
            key += 1;
        };

        let newMonthlyRewards : T.MonthlyRewards = {
            seasonId = monthlyLeaderboard.seasonId;
            month = monthlyLeaderboard.month;
            rewards = List.fromArray(Buffer.toArray(rewardBuffer));
        };

        monthlyRewards := List.append(monthlyRewards, List.make<T.MonthlyRewards>(newMonthlyRewards));
    };

    public func distributeSeasonRewards(seasonRewardPool : Nat64, seasonLeaderboard : T.SeasonLeaderboard) : async () {

        var payouts = List.nil<Float>();
        var currentEntries = seasonLeaderboard.entries;

        let scaledPercentages = Utilities.scalePercentages(percentages, seasonLeaderboard.totalEntries);

        while (not List.isNil(currentEntries)) {
            let (currentEntry, rest) = List.pop(currentEntries);
            currentEntries := rest;
            switch (currentEntry) {
            case (null) {};
            case (?foundEntry) {
                let (nextEntry, _) = List.pop(rest);
                switch (nextEntry) {
                case (null) {
                    let payout = scaledPercentages[foundEntry.position - 1];
                    payouts := List.push(payout, payouts);
                };
                case (?foundNextEntry) {
                    if (foundEntry.points == foundNextEntry.points) {
                    let tiedEntries = Utilities.findTiedEntries(rest, foundEntry.points);
                    let startPosition = foundEntry.position;
                    let tiePayouts = Utilities.calculateTiePayouts(tiedEntries, scaledPercentages, startPosition);
                    payouts := List.append(payouts, tiePayouts);

                    var skipEntries = rest;
                    label skipLoop while (not List.isNil(skipEntries)) {
                        let (skipEntry, nextRest) = List.pop(skipEntries);
                        skipEntries := nextRest;

                        switch (skipEntry) {
                        case (null) { break skipLoop };
                        case (?entry) {
                            if (entry.points != foundEntry.points) {
                            currentEntries := skipEntries;
                            break skipLoop;
                            };
                        };
                        };
                    };
                    } else {
                    let payout = scaledPercentages[foundEntry.position - 1];
                    payouts := List.push(payout, payouts);
                    };
                };
                };

            };
            };
        };

        payouts := List.reverse(payouts);
        let payoutsArray = List.toArray(payouts);
        let rewardBuffer = Buffer.fromArray<T.RewardEntry>([]);

        var key = 0;
        for (winner in Iter.fromList(seasonLeaderboard.entries)) {
            let prize = Int64.toNat64(Float.toInt64(payoutsArray[key])) * seasonRewardPool;
            
            let openfpl_backend_canister = actor (Environment.BACKEND_CANISTER_ID) : actor {
                payPrivateLeagueRewards : (winnerPrincipalId: T.PrincipalId, prize: Nat64) -> async ();
            };
            await openfpl_backend_canister.payPrivateLeagueRewards(winner.principalId, prize);
            
            rewardBuffer.add({
                principalId = winner.principalId;
                rewardType = #WeeklyLeaderboard;
                position = winner.position;
                amount = prize;
            });
            key += 1;
        };

        let newSeasonRewards : T.SeasonRewards = {
            seasonId = seasonLeaderboard.seasonId;
            rewards = List.fromArray(Buffer.toArray(rewardBuffer));
        };
        seasonRewards := List.append(seasonRewards, List.make<T.SeasonRewards>(newSeasonRewards));
    };


    private func calculateWeeklyLeaderboards(seasonId : T.SeasonId, gameweek : T.GameweekNumber) : async () {
        /*
        let entryBuffer = Buffer.fromArray<T.LeaderboardEntry>([]);
        label seasonLoop for(season in Iter.fromArray(weeklyLeaderboards)){
            if(season.0 == seasonId){
                for(gw in Iter.fromArray(season.1)){
                    if(gw.0 == gameweek){
                        for(entry in Iter.fromList(gw.1.entries)){
                            entryBuffer.add(entry);
                        }
                    };
                };
            };
        };

        let gameweekEntries = List.fromArray(Buffer.toArray(entryBuffer));
        
        let sortedGameweekEntries = List.reverse(Utilities.mergeSortLeaderboard(gameweekEntries));
        let positionedGameweekEntries = Utilities.assignPositionText(sortedGameweekEntries);

        let currentGameweekLeaderboard : T.WeeklyLeaderboard = {
            seasonId = seasonId;
            gameweek = gameweek;
            entries = positionedGameweekEntries;
            totalEntries = List.size(positionedGameweekEntries);
        };
        
        let weeklyLeaderboardsBuffer = Buffer.fromArray<(T.SeasonId, [(T.GameweekNumber, T.WeeklyLeaderboard)])>([]);
    
        for(season in Iter.fromArray(weeklyLeaderboards)) {
            if(season.0 == seasonId){
                let gameweekBuffer = Buffer.fromArray<(T.GameweekNumber, T.WeeklyLeaderboard)>(season.1);
                for(gw in Iter.fromArray(season.1)){
                    if(gw.0 == gameweek){
                        gameweekBuffer.add(gw.0, currentGameweekLeaderboard);
                    } else { gameweekBuffer.add(gw); }
                };
                weeklyLeaderboardsBuffer.add(season.0, Buffer.toArray(gameweekBuffer));
            } else { weeklyLeaderboardsBuffer.add(season); }
        };

        weeklyLeaderboards := Buffer.toArray(weeklyLeaderboardsBuffer);
        */
    };

    private func calculateMonthlyLeaderboards(seasonId : T.SeasonId, month : T.CalendarMonth) : async () {
        /*
        let entryBuffer = Buffer.fromArray<T.LeaderboardEntry>([]);
        label seasonLoop for(season in Iter.fromArray(monthlyLeaderboards)){
            if(season.0 == seasonId){
                for(gw in Iter.fromArray(season.1)){
                    if(gw.0 == month){
                        for(entry in Iter.fromList(gw.1.entries)){
                            entryBuffer.add(entry);
                        }
                    };
                };
            };
        };

        let monthEntries = List.fromArray(Buffer.toArray(entryBuffer));
        
        let sortedMonthEntries = List.reverse(Utilities.mergeSortLeaderboard(monthEntries));
        let positionedMonthEntries = Utilities.assignPositionText(sortedMonthEntries);

        let currentMonthLeaderboard : T.MonthlyLeaderboard = {
            seasonId = seasonId;
            month = month;
            entries = positionedMonthEntries;
            totalEntries = List.size(positionedMonthEntries);
        };
        
        let monthlyLeaderboardsBuffer = Buffer.fromArray<(T.SeasonId, [(T.CalendarMonth, T.MonthlyLeaderboard)])>([]);
    
        for(season in Iter.fromArray(monthlyLeaderboards)) {
            if(season.0 == seasonId){
                let monthBuffer = Buffer.fromArray<(T.CalendarMonth, T.MonthlyLeaderboard)>(season.1);
                for(gw in Iter.fromArray(season.1)){
                    if(gw.0 == month){
                        monthBuffer.add(gw.0, currentMonthLeaderboard);
                    } else { monthBuffer.add(gw); }
                };
                monthlyLeaderboardsBuffer.add(season.0, Buffer.toArray(monthBuffer));
            } else { monthlyLeaderboardsBuffer.add(season); }
        };

        monthlyLeaderboards := Buffer.toArray(monthlyLeaderboardsBuffer);
        */
    };

    private func calculateSeasonLeaderboard(seasonId : T.SeasonId) : async () {
        /*
        let entryBuffer = Buffer.fromArray<T.LeaderboardEntry>([]);
        label seasonLoop for(season in Iter.fromArray(seasonLeaderboards)){
            if(season.0 == seasonId){
                for(entry in Iter.fromList(season.1.entries)){
                    entryBuffer.add(entry);
                }
            };
        };

        let seasonEntries = List.fromArray(Buffer.toArray(entryBuffer));
        
        let sortedSeasonEntries = List.reverse(Utilities.mergeSortLeaderboard(seasonEntries));
        let positionedSeasonEntries = Utilities.assignPositionText(sortedSeasonEntries);

        let currentSeasonLeaderboard : T.SeasonLeaderboard = {
            seasonId = seasonId;
            entries = positionedSeasonEntries;
            totalEntries = List.size(positionedSeasonEntries);
        };
        
        let seasonLeaderboardsBuffer = Buffer.fromArray<(T.SeasonId, T.SeasonLeaderboard)>([]);
    
        for(season in Iter.fromArray(seasonLeaderboards)) {
            if(season.0 == seasonId){               
                seasonLeaderboardsBuffer.add(season.0, currentSeasonLeaderboard);
            } else { seasonLeaderboardsBuffer.add(season); }
        };

        seasonLeaderboards := Buffer.toArray(seasonLeaderboardsBuffer);
        */
    };

    public shared ({ caller }) func getWeeklyLeaderboard(dto: DTOs.GetPrivateLeagueWeeklyLeaderboard) : async Result.Result<DTOs.WeeklyLeaderboardDTO, T.Error> {
        assert not Principal.isAnonymous(caller);
        let principalId = Principal.toText(caller);
        assert principalId == Environment.BACKEND_CANISTER_ID;

        for(season in Iter.fromArray(weeklyLeaderboards)){
            if(season.0 == dto.seasonId){
                for(leaderboard in Iter.fromArray(season.1)){
                    if(leaderboard.0 == dto.gameweek){
                        
                        let droppedEntries = List.drop<T.LeaderboardEntry>(leaderboard.1.entries, dto.offset);
                        let paginatedEntries = List.take<T.LeaderboardEntry>(droppedEntries, dto.limit);

                        return #ok({
                            entries = List.toArray(paginatedEntries);
                            gameweek = leaderboard.0;
                            seasonId = season.0;
                            totalEntries = List.size(leaderboard.1.entries);
                        });
                    }
                }
            };
        };

        return #err(#NotFound);
    };

    public shared ({ caller }) func getMonthlyLeaderboard(dto: DTOs.GetPrivateLeagueMonthlyLeaderboard) : async Result.Result<DTOs.MonthlyLeaderboardDTO, T.Error> {
        assert not Principal.isAnonymous(caller);
        let principalId = Principal.toText(caller);
        assert principalId == Environment.BACKEND_CANISTER_ID;

        for(seasonLeaderboard in Iter.fromArray(monthlyLeaderboards)){
            if(seasonLeaderboard.0 == dto.seasonId){
                for(leaderboard in Iter.fromArray(seasonLeaderboard.1)){
                    if(leaderboard.0 == dto.month){
                        let filteredEntries = leaderboard.1.entries;
                        let droppedEntries = List.drop<T.LeaderboardEntry>(filteredEntries, dto.offset);
                        let paginatedEntries = List.take<T.LeaderboardEntry>(droppedEntries, dto.limit);

                        return #ok({
                            entries = List.toArray(paginatedEntries);
                            month = leaderboard.0;
                            seasonId = seasonLeaderboard.0;
                            clubId = dto.clubId;
                            totalEntries = List.size(leaderboard.1.entries);
                        });
                    }
                }
            };
        };

        return #err(#NotFound);
    };

    public shared ({ caller }) func getSeasonLeaderboard(dto: DTOs.GetPrivateLeagueSeasonLeaderboard) : async Result.Result<DTOs.SeasonLeaderboardDTO, T.Error> {
        assert not Principal.isAnonymous(caller);
        let principalId = Principal.toText(caller);
        assert principalId == Environment.BACKEND_CANISTER_ID;

        for(seasonLeaderboard in Iter.fromArray(seasonLeaderboards)){
            if(seasonLeaderboard.0 == dto.seasonId){
                let filteredEntries = seasonLeaderboard.1.entries;

                let droppedEntries = List.drop<T.LeaderboardEntry>(filteredEntries, dto.offset);
                let paginatedEntries = List.take<T.LeaderboardEntry>(droppedEntries, dto.limit);

                return #ok({
                    entries = List.toArray(paginatedEntries);
                    seasonId = seasonLeaderboard.0;
                    totalEntries = List.size(seasonLeaderboard.1.entries);
                });
            };
        };

        return #err(#NotFound);
    };

    public shared ({ caller }) func getLeagueMembers(filters: DTOs.PaginationFiltersDTO) : async Result.Result<[DTOs.LeagueMemberDTO], T.Error> {
        assert not Principal.isAnonymous(caller);
        let principalId = Principal.toText(caller);
        assert principalId == Environment.BACKEND_CANISTER_ID;

        let filteredEntries = List.fromArray(leagueMembers);

        let droppedEntries = List.drop<T.LeagueMember>(filteredEntries, filters.offset);
        let paginatedEntries = List.take<T.LeagueMember>(droppedEntries, filters.limit);

        let leagueMemberDTOs = List.map<T.LeagueMember, DTOs.LeagueMemberDTO>(
            paginatedEntries,
            func(leagueMember : T.LeagueMember) : DTOs.LeagueMemberDTO {
              return {
                added = leagueMember.joinedDate;
                principalId = leagueMember.principalId;
                username = leagueMember.username;
              };
            },
          );

        return #ok(List.toArray(leagueMemberDTOs));
    };

    public shared ({ caller }) func leagueHasSpace() : async Bool {
        assert not Principal.isAnonymous(caller);
        let principalId = Principal.toText(caller);
        assert principalId == Environment.BACKEND_CANISTER_ID;
        if(Array.size(leagueMembers) >= Constants.MAX_PRIVATE_LEAGUE_SIZE){
            return false;
        };
        return true;
    };

    public shared ({ caller }) func isLeagueMember(callerId: T.PrincipalId) : async Bool {
        assert not Principal.isAnonymous(caller);
        let principalId = Principal.toText(caller);
        assert principalId == Environment.BACKEND_CANISTER_ID;

        for(member in Iter.fromArray(leagueMembers)){
            if(member.principalId == callerId){
                return true;
            }
        };

        return false;
    };

    public shared ({ caller }) func isLeagueAdmin(callerId: T.PrincipalId) : async Bool {
        assert not Principal.isAnonymous(caller);
        let principalId = Principal.toText(caller);
        assert principalId == Environment.BACKEND_CANISTER_ID;

        for(admin in Iter.fromArray(leagueAdmins)){
            if(admin == callerId){
                return true;
            }
        };

        return false;
    };

    public shared ({ caller }) func inviteUserToLeague(managerId: T.PrincipalId, sentBy: T.PrincipalId) : async Result.Result<(), T.Error> {
        assert not Principal.isAnonymous(caller);
        let principalId = Principal.toText(caller);
        assert principalId == Environment.BACKEND_CANISTER_ID;
        
        switch(privateLeague){
            case null {};
            case (?foundPrivateLeague){

                let leagueInvite: T.LeagueInvite = {
                    from = sentBy;
                    inviteStatus = #Sent;
                    leagueCanisterId = foundPrivateLeague.canisterId;
                    sent = Time.now();
                    to = managerId;
                };

                let leagueInvitesBuffer = Buffer.fromArray<T.LeagueInvite>(leagueInvites);
                leagueInvitesBuffer.add(leagueInvite);

                leagueInvites := Buffer.toArray(leagueInvitesBuffer);
                return #ok();
            }
        };

        return #err(#NotFound);
    };

    public shared ({ caller }) func acceptLeagueInvite(managerId: T.PrincipalId, managerCanisterId: T.CanisterId, username: Text) : async Result.Result<(), T.Error> {
        assert not Principal.isAnonymous(caller);
        let principalId = Principal.toText(caller);
        assert principalId == Environment.BACKEND_CANISTER_ID;

        let leagueInviteBuffer = Buffer.fromArray<T.LeagueInvite>([]);
        for(leagueInvite in Iter.fromArray(leagueInvites)){
            if(leagueInvite.to == managerId){
                leagueInviteBuffer.add({
                    from = leagueInvite.from;
                    inviteStatus = #Accepted;
                    leagueCanisterId = leagueInvite.leagueCanisterId;
                    sent = leagueInvite.sent;
                    to = leagueInvite.to
                });
            }
            else{
                leagueInviteBuffer.add(leagueInvite);
            }
        };

        leagueInvites := Buffer.toArray(leagueInviteBuffer);
        
        return await enterLeague(managerId, managerCanisterId, username);
    };

    public shared ({ caller }) func rejectLeagueInvite(managerId: T.PrincipalId) : async Result.Result<(), T.Error> {
        assert not Principal.isAnonymous(caller);
        let principalId = Principal.toText(caller);
        assert principalId == Environment.BACKEND_CANISTER_ID;

        let leagueInviteBuffer = Buffer.fromArray<T.LeagueInvite>([]);
        for(leagueInvite in Iter.fromArray(leagueInvites)){
            if(leagueInvite.to == managerId){
                leagueInviteBuffer.add({
                    from = leagueInvite.from;
                    inviteStatus = #Rejected;
                    leagueCanisterId = leagueInvite.leagueCanisterId;
                    sent = leagueInvite.sent;
                    to = leagueInvite.to
                });
            }
            else{
                leagueInviteBuffer.add(leagueInvite);
            }
        };

        leagueInvites := Buffer.toArray(leagueInviteBuffer);
        return #ok();
    };

    public shared ({ caller }) func updateLeaguePicture(picture: ?Blob) : async Result.Result<(), T.Error> {
        assert not Principal.isAnonymous(caller);
        let principalId = Principal.toText(caller);
        assert principalId == Environment.BACKEND_CANISTER_ID;

        switch(privateLeague){
            case null {};
            case (?foundPrivateLeague){

                privateLeague := ?{
                    canisterId = foundPrivateLeague.canisterId;
                    name = foundPrivateLeague.name;
                    maxEntrants = foundPrivateLeague.maxEntrants;
                    picture = picture;
                    banner = foundPrivateLeague.banner;
                    tokenId = foundPrivateLeague.tokenId;
                    entryFee = foundPrivateLeague.entryFee;
                    adminFee = foundPrivateLeague.adminFee;
                    entryType = foundPrivateLeague.entryType;
                    createdById = foundPrivateLeague.createdById;
                };
                return #ok();
            }
        };
        return #err(#NotFound);
    };

    public shared ({ caller }) func updateLeagueBanner(banner: ?Blob) : async Result.Result<(), T.Error> {
        assert not Principal.isAnonymous(caller);
        let principalId = Principal.toText(caller);
        assert principalId == Environment.BACKEND_CANISTER_ID;

        switch(privateLeague){
            case null {};
            case (?foundPrivateLeague){

                privateLeague := ?{
                    canisterId = foundPrivateLeague.canisterId;
                    name = foundPrivateLeague.name;
                    maxEntrants = foundPrivateLeague.maxEntrants;
                    picture = foundPrivateLeague.picture;
                    banner = banner;
                    tokenId = foundPrivateLeague.tokenId;
                    entryFee = foundPrivateLeague.entryFee;
                    adminFee = foundPrivateLeague.adminFee;
                    entryType = foundPrivateLeague.entryType;
                    createdById = foundPrivateLeague.createdById;
                };
                return #ok();
            }
        };
        return #err(#NotFound);
    };

    public shared ({ caller }) func updateLeagueName(name: Text) : async Result.Result<(), T.Error> {
        assert not Principal.isAnonymous(caller);
        let principalId = Principal.toText(caller);
        assert principalId == Environment.BACKEND_CANISTER_ID;

        switch(privateLeague){
            case null {};
            case (?foundPrivateLeague){

                privateLeague := ?{
                    canisterId = foundPrivateLeague.canisterId;
                    name = name;
                    maxEntrants = foundPrivateLeague.maxEntrants;
                    picture = foundPrivateLeague.picture;
                    banner = foundPrivateLeague.banner;
                    tokenId = foundPrivateLeague.tokenId;
                    entryFee = foundPrivateLeague.entryFee;
                    adminFee = foundPrivateLeague.adminFee;
                    entryType = foundPrivateLeague.entryType;
                    createdById = foundPrivateLeague.createdById;
                };
                return #ok();
            }
        };
        return #err(#NotFound);
    };

    public shared ({ caller }) func enterLeague(managerId: T.PrincipalId, managerCanisterId: T.CanisterId, username: Text) : async Result.Result<(), T.Error> {
        assert not Principal.isAnonymous(caller);
        let principalId = Principal.toText(caller);
        assert principalId == Environment.BACKEND_CANISTER_ID;

        switch(privateLeague){
            case null {};
            case (?foundPrivateLeague){
                let leagueMembersBuffer = Buffer.fromArray<T.LeagueMember>(leagueMembers);
                leagueMembersBuffer.add({
                    canisterId = foundPrivateLeague.canisterId;
                    joinedDate = Time.now();
                    principalId = managerId;
                    username = username;
                });
                leagueMembers := Buffer.toArray(leagueMembersBuffer);
                addApprovedManagerCanisterId(managerCanisterId);
                return #ok();
            }
        };
        return #err(#NotFound);
    };

    public shared ({ caller }) func inviteExists(managerId: T.PrincipalId) : async Result.Result<Bool, T.Error> {
        assert not Principal.isAnonymous(caller);
        let principalId = Principal.toText(caller);
        assert principalId == Environment.BACKEND_CANISTER_ID;
        
        for(invite in Iter.fromArray(leagueInvites)){
            if(invite.to == managerId and invite.inviteStatus == #Sent){
                return #ok(true);
            };
        };
        
        return #ok(false);
    };

    public shared ({ caller }) func sendWeeklyLeadeboardEntry(filters: DTOs.GameweekFiltersDTO, updatedEntry: T.LeaderboardEntry) : async () {
        assert not Principal.isAnonymous(caller);
        assert isApprovedManagerCanister(Principal.toText(caller));

        var seasonAdded = false;
        let seasonBuffer = Buffer.fromArray<(T.SeasonId, [(T.GameweekNumber, T.WeeklyLeaderboard)])>([]);
        for(season in Iter.fromArray(weeklyLeaderboards)){
            if(season.0 == filters.seasonId){
                let seasonGameweekBuffer = Buffer.fromArray<(T.GameweekNumber, T.WeeklyLeaderboard)>([]);
                var gameweekAdded = false;
                for(gw in Iter.fromArray(season.1)){
                    if(gw.0 == filters.gameweek){
                        let gameweekMangersBuffer = Buffer.fromArray<T.LeaderboardEntry>([]);
                        var managerAdded = false;
                        for(manager in Iter.fromList(gw.1.entries)){
                            if(manager.principalId == updatedEntry.principalId){
                                gameweekMangersBuffer.add(updatedEntry);
                                managerAdded := true;
                            } else {
                                gameweekMangersBuffer.add(manager);
                                managerAdded := true;
                            };
                        };
                        if(not managerAdded){
                            gameweekMangersBuffer.add(updatedEntry);
                        };
                        seasonGameweekBuffer.add(gw.0, 
                        {
                            entries = List.fromArray(Buffer.toArray(gameweekMangersBuffer));
                            gameweek = gw.0;
                            seasonId = season.0;
                            totalEntries = gameweekMangersBuffer.size();
                        });
                        gameweekAdded := true;
                    } else {
                        seasonGameweekBuffer.add(gw);
                        gameweekAdded := true;
                    };
                };
                if(not gameweekAdded){
                    seasonGameweekBuffer.add(filters.gameweek, 
                    {
                        entries = List.fromArray([updatedEntry]);
                        gameweek = filters.gameweek;
                        seasonId = filters.seasonId;
                        totalEntries = 1;
                    });
                };
                seasonBuffer.add(filters.seasonId, Buffer.toArray(seasonGameweekBuffer));
                seasonAdded := true;
            } else {
                seasonBuffer.add(season);
                seasonAdded := true;
            };
        };
        if(not seasonAdded){
            seasonBuffer.add(filters.seasonId, [(filters.gameweek, {
                entries = List.fromArray([updatedEntry]);
                gameweek = filters.gameweek;
                seasonId = filters.seasonId;
                totalEntries = 1;
            })]);
        };
        weeklyLeaderboards := Buffer.toArray(seasonBuffer);
    };

    public shared ({ caller }) func sendMonthlyLeaderboardEntry(seasonId: T.SeasonId, month: T.CalendarMonth, updatedEntry: T.LeaderboardEntry) : async() {
        assert not Principal.isAnonymous(caller);
        assert isApprovedManagerCanister(Principal.toText(caller));

        var seasonAdded = false;
        let seasonBuffer = Buffer.fromArray<(T.SeasonId, [(T.CalendarMonth, T.MonthlyLeaderboard)])>([]);
        for(season in Iter.fromArray(monthlyLeaderboards)){
            if(season.0 == seasonId){
                let seasonMonthBuffer = Buffer.fromArray<(T.CalendarMonth, T.MonthlyLeaderboard)>([]);
                var monthAdded = false;
                for(mth in Iter.fromArray(season.1)){
                    if(mth.0 == month){
                        let monthMangersBuffer = Buffer.fromArray<T.LeaderboardEntry>([]);
                        var managerAdded = false;
                        for(manager in Iter.fromList(mth.1.entries)){
                            if(manager.principalId == updatedEntry.principalId){
                                monthMangersBuffer.add(updatedEntry);
                                managerAdded := true;
                            } else {
                                monthMangersBuffer.add(manager);
                                managerAdded := true;
                            };
                        };
                        if(not managerAdded){
                            monthMangersBuffer.add(updatedEntry);
                        };
                        seasonMonthBuffer.add(mth.0, 
                        {
                            entries = List.fromArray(Buffer.toArray(monthMangersBuffer));
                            month = mth.0;
                            seasonId = season.0;
                            totalEntries = monthMangersBuffer.size();
                        });
                        monthAdded := true;
                    } else {
                        seasonMonthBuffer.add(mth);
                        monthAdded := true;
                    };
                };
                if(not monthAdded){
                    seasonMonthBuffer.add(month, 
                    {
                        entries = List.fromArray([updatedEntry]);
                        month = month;
                        seasonId = seasonId;
                        totalEntries = 1;
                    });
                };
                seasonBuffer.add(seasonId, Buffer.toArray(seasonMonthBuffer));
                seasonAdded := true;
            } else {
                seasonBuffer.add(season);
                seasonAdded := true;
            };
        };
        if(not seasonAdded){
            seasonBuffer.add(seasonId, [(month, {
                entries = List.fromArray([updatedEntry]);
                month = month;
                seasonId = seasonId;
                totalEntries = 1;
            })]);
        };
        monthlyLeaderboards := Buffer.toArray(seasonBuffer);
    };

    public shared ({ caller }) func sendSeasonLeaderboardEntry(seasonId: T.SeasonId, updatedEntry: T.LeaderboardEntry) : async () {
        assert not Principal.isAnonymous(caller);
        assert isApprovedManagerCanister(Principal.toText(caller));

        var seasonAdded = false;
        let seasonBuffer = Buffer.fromArray<(T.SeasonId, T.SeasonLeaderboard)>([]);
        for(season in Iter.fromArray(seasonLeaderboards)){
            if(season.0 == seasonId){
                let seasonManagersBuffer = Buffer.fromArray<T.LeaderboardEntry>([]);
                var managerAdded = false;
                for(manager in Iter.fromList(season.1.entries)){
                    if(manager.principalId == updatedEntry.principalId){
                        seasonManagersBuffer.add(updatedEntry);
                        managerAdded := true;
                    } else {
                        seasonManagersBuffer.add(manager);
                        managerAdded := true;
                    };
                };
                if(not managerAdded){
                    seasonManagersBuffer.add(updatedEntry);
                };      
                seasonBuffer.add(seasonId, {
                    entries = List.fromArray(Buffer.toArray(seasonManagersBuffer));
                    seasonId = seasonId;
                    totalEntries = seasonManagersBuffer.size();
                });
                seasonAdded := true;
            } else {
                seasonBuffer.add(season);
                seasonAdded := true;
            };
        };
        if(not seasonAdded){
            seasonBuffer.add(seasonId, {
                entries = List.fromArray([updatedEntry]);
                seasonId = seasonId;
                totalEntries = 1;
            });
        };
        seasonLeaderboards := Buffer.toArray(seasonBuffer);
    };

    private func isApprovedManagerCanister(canisterId: T.CanisterId) : Bool {
        let canisterExists = Array.find(approvedManagerCanisterIds,
            func(id : T.CanisterId) : Bool {
                return id == canisterId;
            },
        );
        return Option.isSome(canisterExists);
    };

    private func addApprovedManagerCanisterId(canisterId: T.CanisterId) : () {
        let canisterExists = Array.find(approvedManagerCanisterIds,
            func(id : T.CanisterId) : Bool {
                return id == canisterId;
            },
        );
        if(Option.isNull(canisterExists)){
            let canisterIdBuffer = Buffer.fromArray<T.CanisterId>(approvedManagerCanisterIds);
            canisterIdBuffer.add(canisterId);
            approvedManagerCanisterIds := Buffer.toArray(canisterIdBuffer);
        };
    };

    system func preupgrade() {};

    system func postupgrade() {
        switch (cyclesCheckTimerId) {
        case (null) {};
        case (?id) {
            Timer.cancelTimer(id);
            cyclesCheckTimerId := null;
        };
        };
        cyclesCheckTimerId := ?Timer.setTimer<system>(#nanoseconds(Utilities.getHour() * 24), checkCanisterCycles);
    };

    public shared ({ caller }) func initPrivateLeague(createdById: T.PrincipalId, newPrivateLeague: DTOs.CreatePrivateLeagueDTO) : async Result.Result<(), T.Error>{
        assert not Principal.isAnonymous(caller);
        let principalId = Principal.toText(caller);
        assert principalId == Environment.BACKEND_CANISTER_ID;

        let adminBuffer = Buffer.fromArray<T.PrincipalId>(leagueAdmins);
        adminBuffer.add(createdById);
        leagueAdmins := Buffer.toArray(adminBuffer);

        privateLeague := ?{
            adminFee = newPrivateLeague.adminFee;
            banner = newPrivateLeague.banner;
            createdById = createdById;
            entryFee = newPrivateLeague.entryFee;
            entryType = newPrivateLeague.entryRequirement;
            maxEntrants = newPrivateLeague.entrants;
            name = newPrivateLeague.name;
            picture = newPrivateLeague.photo;
            tokenId = newPrivateLeague.tokenId;
            canisterId = "";
        };

        return #ok();
    };

    public shared ({ caller }) func setCanisterId(canisterId: T.CanisterId) : async Result.Result<(), T.Error>{
        assert not Principal.isAnonymous(caller);
        let principalId = Principal.toText(caller);
        assert principalId == Environment.BACKEND_CANISTER_ID;

        switch(privateLeague){
            case (?foundPrivateLeague){

                privateLeague := ?{
                    adminFee = foundPrivateLeague.adminFee;
                    banner = foundPrivateLeague.banner;
                    createdById = foundPrivateLeague.createdById;
                    entryFee = foundPrivateLeague.entryFee;
                    entryType = foundPrivateLeague.entryType;
                    maxEntrants = foundPrivateLeague.maxEntrants;
                    name = foundPrivateLeague.name;
                    picture = foundPrivateLeague.picture;
                    tokenId = foundPrivateLeague.tokenId;
                    canisterId = canisterId;
                };
            };
            case (null){
                return #err(#NotFound);
            };
        };

        return #ok();
    };

    private func checkCanisterCycles() : async () {

        let balance = Cycles.balance();

        if (balance < 2_000_000_000_000) {
        let openfpl_backend_canister = actor (Environment.BACKEND_CANISTER_ID) : actor {
            requestCanisterTopup : (cycles: Nat) -> async ();
        };
        await openfpl_backend_canister.requestCanisterTopup(2_000_000_000_000);
        };
        await setCheckCyclesTimer();
    };

    private func setCheckCyclesTimer() : async () {
        switch (cyclesCheckTimerId) {
        case (null) {};
        case (?id) {
            Timer.cancelTimer(id);
            cyclesCheckTimerId := null;
        };
        };
        cyclesCheckTimerId := ?Timer.setTimer<system>(#nanoseconds(Utilities.getHour() * 24), checkCanisterCycles);
    };

    public shared func topupCanister() : async () {
        let amount = Cycles.available();
        let _ = Cycles.accept<system>(amount);
        Cycles.add<system>(amount);
    };

    public shared ({ caller }) func getCyclesBalance() : async Nat {
        assert not Principal.isAnonymous(caller);
        let principalId = Principal.toText(caller);
        assert principalId == Environment.BACKEND_CANISTER_ID;
        return Cycles.balance();
    };

    public shared ({ caller }) func getCyclesAvailable() : async Nat {
        assert not Principal.isAnonymous(caller);
        let principalId = Principal.toText(caller);
        assert principalId == Environment.BACKEND_CANISTER_ID;
        return Cycles.available();
    };
};

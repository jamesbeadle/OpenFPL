import T "../types";
import DTOs "../DTOs";
import Cycles "mo:base/ExperimentalCycles";
import Timer "mo:base/Timer";
import Iter "mo:base/Iter";
import Principal "mo:base/Principal";
import Buffer "mo:base/Buffer";
import Result "mo:base/Result";
import Array "mo:base/Array";
import Nat16 "mo:base/Nat16";
import List "mo:base/List";
import Time "mo:base/Time";
import Option "mo:base/Option";
import Order "mo:base/Order";
import Utilities "../utils/utilities";
import Environment "../utils/Environment";
import Constants "../utils/Constants";

actor class _PrivateLeague() {
    private let cyclesCheckInterval : Nat = Utilities.getHour() * 24;
    private var cyclesCheckTimerId : ?Timer.TimerId = null;
    private var main_canister_id = Environment.BACKEND_CANISTER_ID;

    private var leagueMembers: [T.LeagueMember] = [];
    private var leagueAdmins: [T.PrincipalId] = [];
    private var leagueInvites: [T.LeagueInvite] = [];

    private stable var weeklyLeaderboards: [(T.SeasonId, [(T.GameweekNumber, T.WeeklyLeaderboard)])] = [];
    private stable var monthlyLeaderboards: [(T.SeasonId, [(T.CalendarMonth, T.MonthlyLeaderboard)])] = [];
    private stable var seasonLeaderboards: [(T.SeasonId, T.SeasonLeaderboard)] = [];
    private stable var approvedManagerCanisterIds: [T.CanisterId] = [];

    private stable var privateLeague: ?T.PrivateLeague = null;
    
    public shared ({ caller }) func getPrivateLeague() : async Result.Result<DTOs.PrivateLeagueDTO, T.Error> {
        assert not Principal.isAnonymous(caller);
        let principalId = Principal.toText(caller);
        assert principalId == main_canister_id;

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
                });
            }
        };
    };

    public shared ({ caller }) func getManagerPrivateLeague(managerId: T.PrincipalId, seasonId: T.SeasonId, gameweek: T.GameweekNumber) : async Result.Result<DTOs.ManagerPrivateLeagueDTO, T.Error> {
        assert not Principal.isAnonymous(caller);
        let principalId = Principal.toText(caller);
        assert principalId == main_canister_id;
        var seasonPosition = 0;
        var seasonPositionText = "";

        for(weeklyLeaderboard in Iter.fromArray(weeklyLeaderboards)){
            if(weeklyLeaderboard.0 == seasonId){
                for (gw in Iter.fromArray(weeklyLeaderboard.1)){
                    if(gw.0 == gameweek){
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
        assert principalId == main_canister_id;
        await calculateWeeklyLeaderboards(seasonId, gameweek);
        await calculateMonthlyLeaderboards(seasonId, gameweek, month, fantasyTeamSnapshots);
        await calculateSeasonLeaderboard(seasonId, fantasyTeamSnapshots);
    };

    private func calculateWeeklyLeaderboards(seasonId : T.SeasonId, gameweek : T.GameweekNumber) : async () {
        
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
    };

    
       
      

    public shared ({ caller }) func getWeeklyLeaderboard(seasonId : T.SeasonId, gameweek: T.GameweekNumber, limit : Nat, offset : Nat) : async Result.Result<DTOs.WeeklyLeaderboardDTO, T.Error> {
        assert not Principal.isAnonymous(caller);
        let principalId = Principal.toText(caller);
        assert principalId == main_canister_id;

        for(seasonLeaderboard in Iter.fromArray(weeklyLeaderboards)){
            if(seasonLeaderboard.0 == seasonId){
                for(leaderboard in Iter.fromArray(seasonLeaderboard.1)){
                    if(leaderboard.0 == gameweek){

                        let filteredEntries = List.fromArray(leaderboard.1);

                        let droppedEntries = List.drop<T.LeaderboardEntry>(filteredEntries, offset);
                        let paginatedEntries = List.take<T.LeaderboardEntry>(droppedEntries, limit);

                        return #ok({
                            entries = List.toArray(paginatedEntries);
                            gameweek = leaderboard.0;
                            seasonId = seasonLeaderboard.0;
                            totalEntries = Array.size(leaderboard.1);
                        });
                    }
                }
            };
        };

        return #err(#NotFound);
    };

    public shared ({ caller }) func getMonthlyLeaderboard(seasonId : T.SeasonId, month: T.CalendarMonth, limit : Nat, offset : Nat) : async Result.Result<DTOs.MonthlyLeaderboardDTO, T.Error> {
        assert not Principal.isAnonymous(caller);
        let principalId = Principal.toText(caller);
        assert principalId == main_canister_id;

        for(seasonLeaderboard in Iter.fromArray(monthlyLeaderboards)){
            if(seasonLeaderboard.0 == seasonId){
                for(leaderboard in Iter.fromArray(seasonLeaderboard.1)){
                    if(leaderboard.0 == month){

                        let filteredEntries = List.fromArray(leaderboard.1);

                        let droppedEntries = List.drop<T.LeaderboardEntry>(filteredEntries, offset);
                        let paginatedEntries = List.take<T.LeaderboardEntry>(droppedEntries, limit);

                        return #ok({
                            entries = List.toArray(paginatedEntries);
                            month = leaderboard.0;
                            seasonId = seasonLeaderboard.0;
                            totalEntries = Array.size(leaderboard.1);
                            clubId = 0;
                        });
                    }
                }
            };
        };

        return #err(#NotFound);
    };

    public shared ({ caller }) func getSeasonLeaderboard(seasonId : T.SeasonId, limit : Nat, offset : Nat) : async Result.Result<DTOs.SeasonLeaderboardDTO, T.Error> {
        assert not Principal.isAnonymous(caller);
        let principalId = Principal.toText(caller);
        assert principalId == main_canister_id;

        for(seasonLeaderboard in Iter.fromArray(seasonLeaderboards)){
            if(seasonLeaderboard.0 == seasonId){
                let filteredEntries = List.fromArray(seasonLeaderboard.1);

                let droppedEntries = List.drop<T.LeaderboardEntry>(filteredEntries, offset);
                let paginatedEntries = List.take<T.LeaderboardEntry>(droppedEntries, limit);

                return #ok({
                    entries = List.toArray(paginatedEntries);
                    seasonId = seasonLeaderboard.0;
                    totalEntries = Array.size(seasonLeaderboard.1);
                });
            };
        };

        return #err(#NotFound);
    };

    public shared ({ caller }) func getLeagueMembers(limit : Nat, offset : Nat) : async Result.Result<[DTOs.LeagueMemberDTO], T.Error> {
        assert not Principal.isAnonymous(caller);
        let principalId = Principal.toText(caller);
        assert principalId == main_canister_id;

        let filteredEntries = List.fromArray(leagueMembers);

        let droppedEntries = List.drop<T.LeagueMember>(filteredEntries, offset);
        let paginatedEntries = List.take<T.LeagueMember>(droppedEntries, limit);

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
        assert principalId == main_canister_id;
        if(Array.size(leagueMembers) >= Constants.MAX_PRIVATE_LEAGUE_SIZE){
            return false;
        };
        return true;
    };

    public shared ({ caller }) func isLeagueMember(callerId: T.PrincipalId) : async Bool {
        assert not Principal.isAnonymous(caller);
        let principalId = Principal.toText(caller);
        assert principalId == main_canister_id;

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
        assert principalId == main_canister_id;

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
        assert principalId == main_canister_id;
        
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
        assert principalId == main_canister_id;

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
        assert principalId == main_canister_id;

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

    public shared ({ caller }) func updateLeaguePicture(picture: Blob) : async Result.Result<(), T.Error> {
        assert not Principal.isAnonymous(caller);
        let principalId = Principal.toText(caller);
        assert principalId == main_canister_id;

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
                };
                return #ok();
            }
        };
        return #err(#NotFound);
    };

    public shared ({ caller }) func updateLeagueBanner(banner: Blob) : async Result.Result<(), T.Error> {
        assert not Principal.isAnonymous(caller);
        let principalId = Principal.toText(caller);
        assert principalId == main_canister_id;

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
                };
                return #ok();
            }
        };
        return #err(#NotFound);
    };

    public shared ({ caller }) func updateLeagueName(name: Text) : async Result.Result<(), T.Error> {
        assert not Principal.isAnonymous(caller);
        let principalId = Principal.toText(caller);
        assert principalId == main_canister_id;

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
                };
                return #ok();
            }
        };
        return #err(#NotFound);
    };

    public shared ({ caller }) func enterLeague(managerId: T.PrincipalId, managerCanisterId: T.CanisterId, username: Text) : async Result.Result<(), T.Error> {
        assert not Principal.isAnonymous(caller);
        let principalId = Principal.toText(caller);
        assert principalId == main_canister_id;

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
        assert principalId == main_canister_id;
        
        for(invite in Iter.fromArray(leagueInvites)){
            if(invite.to == managerId and invite.inviteStatus == #Sent){
                return #ok(true);
            };
        };
        
        return #ok(false);
    };

    public shared ({ caller }) func updateManagerScore(snapshot: T.FantasyTeamSnapshot) : async Result.Result<(), T.Error> {
        assert isApprovedManagerCanister(Principal.toText(caller));
        
        let weeklyLeaderboardEntry: T.LeaderboardEntry = {
            position = 0;
            positionText = "";
            username = snapshot.username;
            principalId = snapshot.principalId;
            points = snapshot.points;
        };
        
        let monthlyLeaderboardEntry: T.LeaderboardEntry = {
            position = 0;
            positionText = "";
            username = snapshot.username;
            principalId = snapshot.principalId;
            points = snapshot.monthlyPoints;
        };
        
        let seasonLeaderboardEntry: T.LeaderboardEntry = {
            position = 0;
            positionText = "";
            username = snapshot.username;
            principalId = snapshot.principalId;
            points = snapshot.seasonPoints;
        };

        //loop through entries and find snapshot gameweek
        
        
        //add a leaderboard entry for the manager
        

        //update the leaderboard entry

        //update the 
        return #ok();
        
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
        cyclesCheckTimerId := ?Timer.setTimer<system>(#nanoseconds(cyclesCheckInterval), checkCanisterCycles);
    };

    public shared ({ caller }) func setAdmin(userId: T.PrincipalId) : async Result.Result<(), T.Error>{
        assert not Principal.isAnonymous(caller);
        let principalId = Principal.toText(caller);
        assert principalId == main_canister_id;

        let adminBuffer = Buffer.fromArray<T.PrincipalId>(leagueAdmins);
        adminBuffer.add(userId);
        leagueAdmins := Buffer.toArray(adminBuffer);
        return #ok();
    };

    private func checkCanisterCycles() : async () {

        let balance = Cycles.balance();

        if (balance < 500000000000) {
        let openfpl_backend_canister = actor (main_canister_id) : actor {
            requestCanisterTopup : () -> async ();
        };
        await openfpl_backend_canister.requestCanisterTopup();
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
        cyclesCheckTimerId := ?Timer.setTimer<system>(#nanoseconds(cyclesCheckInterval), checkCanisterCycles);
    };

    public func topupCanister() : async () {
        let amount = Cycles.available();
        let _ = Cycles.accept<system>(amount);
    };

    public func getCyclesBalance() : async Nat {
        return Cycles.balance();
    };
};

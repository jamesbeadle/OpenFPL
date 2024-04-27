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
import Utilities "../utils/utilities";
import Environment "../utils/Environment";
import Constants "../utils/Constants";

actor class _PrivateLeague() {
    private let cyclesCheckInterval : Nat = Utilities.getHour() * 24;
    private var cyclesCheckTimerId : ?Timer.TimerId = null;
    private var main_canister_id = Environment.BACKEND_CANISTER_ID;

    private var leagueMembers: [T.LeagueMember] = [];
    private var leagueAdmins: [T.PrincipalId] = [];

    private stable var weeklyLeaderboards: [(T.SeasonId, [(T.GameweekNumber, [T.LeaderboardEntry])])] = [];
    private stable var monthlyLeaderboards: [(T.SeasonId, [(T.CalendarMonth, [T.LeaderboardEntry])])] = [];
    private stable var seasonLeaderboards: [(T.SeasonId, [T.LeaderboardEntry])] = [];

    private stable var currentSeasonId: T.SeasonId = 0;
    private stable var currentMonth: T.CalendarMonth = 0;
    private stable var currentGameweek: T.GameweekNumber = 0;
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
                        for(entry in Iter.fromArray(gw.1)){
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

    public shared ({ caller }) func calculateLeaderboards() : async () {
        assert not Principal.isAnonymous(caller);
        let principalId = Principal.toText(caller);
        assert principalId == main_canister_id;
        
        let uniqueCanisterIds = Buffer.fromArray<T.CanisterId>([]);

        for (leagueMember in Iter.fromArray(leagueMembers)) {
            if (not Buffer.contains<T.CanisterId>(uniqueCanisterIds, leagueMember.canisterId, func(a : T.CanisterId, b : T.CanisterId) : Bool { a == b })) {
                uniqueCanisterIds.add(leagueMember.canisterId);
            };
        };

        //now the managers have been updated calculate the leaderboards for the current state

        //calculate leaderboards for gameweek, month and season

        //Store leaderboard entries in the gameweek, month and season

        //Pay leaderboard rewards based on gameweek, month and season

        //increment the system state

    };

    public shared ({ caller }) func getWeeklyLeaderboard(seasonId : T.SeasonId, gameweek: T.GameweekNumber, limit : Nat, offset : Nat) : async Result.Result<DTOs.WeeklyLeaderboardDTO, T.Error> {
        assert not Principal.isAnonymous(caller);
        let principalId = Principal.toText(caller);
        assert principalId == main_canister_id;
        return #err(#NotFound);
    };

    public shared ({ caller }) func getMonthlyLeaderboard(seasonId : T.SeasonId, month: T.CalendarMonth, limit : Nat, offset : Nat) : async Result.Result<DTOs.MonthlyLeaderboardDTO, T.Error> {
        assert not Principal.isAnonymous(caller);
        let principalId = Principal.toText(caller);
        assert principalId == main_canister_id;
        return #err(#NotFound);

    };

    public shared ({ caller }) func getSeasonLeaderboard(seasonId : T.SeasonId, limit : Nat, offset : Nat) : async Result.Result<DTOs.SeasonLeaderboardDTO, T.Error> {
        assert not Principal.isAnonymous(caller);
        let principalId = Principal.toText(caller);
        assert principalId == main_canister_id;
        return #err(#NotFound);

    };

    public shared ({ caller }) func getLeagueMembers(limit : Nat, offset : Nat) : async Result.Result<[DTOs.LeagueMemberDTO], T.Error> {
        assert not Principal.isAnonymous(caller);
        let principalId = Principal.toText(caller);
        assert principalId == main_canister_id;
        return #err(#NotFound);
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

    public shared ({ caller }) func isLeagueAdmin() : async Bool {
        assert not Principal.isAnonymous(caller);
        let principalId = Principal.toText(caller);
        assert principalId == main_canister_id;

        

        return false;
    };

    public shared ({ caller }) func inviteUserToLeague(managerId: T.PrincipalId) : async Result.Result<(), T.Error> {
        //todo
        return #ok();
    };

    public shared ({ caller }) func acceptLeagueInvite(managerId: T.PrincipalId) : async Result.Result<(), T.Error> {
        //todo
        return #ok();
    };

    public shared ({ caller }) func updateLeaguePicture(managerId: T.PrincipalId, picture: Blob) : async Result.Result<(), T.Error> {
        //todo
        return #ok();
    };

    public shared ({ caller }) func updateLeagueBanner(managerId: T.PrincipalId, banner: Blob) : async Result.Result<(), T.Error> {
        //todo
        return #ok();
    };

    public shared ({ caller }) func updateLeagueName(managerId: T.PrincipalId, name: Text) : async Result.Result<(), T.Error> {
        //todo
        return #ok();
    };

    public shared ({ caller }) func enterLeague(managerId: T.PrincipalId) : async Result.Result<(), T.Error> {
        //todo
        return #ok();
    };

    public shared ({ caller }) func inviteExists(managerId: T.PrincipalId) : async Result.Result<Bool, T.Error> {
        //todo
        return #ok(true);
    };

    public shared ({ caller }) func acceptInvite(managerId: T.PrincipalId) : async Result.Result<(), T.Error> {
        //todo
        return #ok();
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

import T "../types";
import DTOs "../DTOs";
import Cycles "mo:base/ExperimentalCycles";
import Timer "mo:base/Timer";
import Iter "mo:base/Iter";
import Principal "mo:base/Principal";
import Buffer "mo:base/Buffer";
import Result "mo:base/Result";
import Utilities "../utils/utilities";
import Environment "../utils/Environment";

actor class _PrivateLeague() {
    private let cyclesCheckInterval : Nat = Utilities.getHour() * 24;
    private var cyclesCheckTimerId : ?Timer.TimerId = null;
    private var main_canister_id = Environment.BACKEND_CANISTER_ID;

    private var leagueMembers: [T.LeagueMember] = [];

    private stable var weeklyLeaderboards: [(T.SeasonId, [(T.GameweekNumber, [T.LeaderboardEntry])])] = [];
    private stable var monthlyLeaderboards: [(T.SeasonId, [(T.CalendarMonth, [T.LeaderboardEntry])])] = [];
    private stable var seasonLeaderboards: [(T.SeasonId, [T.LeaderboardEntry])] = [];

    private stable var currentSeasonId: T.SeasonId = 0;
    private stable var currentMonth: T.CalendarMonth = 0;
    private stable var currentGameweek: T.GameweekNumber = 0;
    
    public shared ({ caller }) func getPrivateLeague() : async Result.Result<DTOs.PrivateLeagueDTO, T.Error> {
        assert not Principal.isAnonymous(caller);
        let principalId = Principal.toText(caller);
        assert principalId == main_canister_id;
        return #err(#NotFound);
        
    };

    public shared ({ caller }) func getManagerPrivateLeague(managerId: T.PrincipalId) : async Result.Result<DTOs.ManagerPrivateLeagueDTO, T.Error> {
        assert not Principal.isAnonymous(caller);
        let principalId = Principal.toText(caller);
        assert principalId == main_canister_id;
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

    public shared ({ caller }) func updateManager(manager: T.Manager){
        //TODO: Check caller is one of the allowed private league canisters

        //TODO: Update just the information required for the league to keep the data light
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

    public shared ({ caller }) func leagueHasSpace() : async Result.Result<Bool, T.Error> {
        assert not Principal.isAnonymous(caller);
        let principalId = Principal.toText(caller);
        assert principalId == main_canister_id;
        return #err(#NotFound);

    };

    public shared ({ caller }) func isLeagueAdmin() : async Result.Result<Bool, T.Error> {
        assert not Principal.isAnonymous(caller);
        let principalId = Principal.toText(caller);
        assert principalId == main_canister_id;
        return #err(#NotFound);

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

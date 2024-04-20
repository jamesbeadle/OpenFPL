import T "types";
import Cycles "mo:base/ExperimentalCycles";
import Timer "mo:base/Timer";
import Iter "mo:base/Iter";
import Principal "mo:base/Principal";
import Buffer "mo:base/Buffer";
import Utilities "utilities";
import Environment "Environment";

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

    public shared ({ caller }) func isLeagueMember(callerId: T.PrincipalId) : async Bool {
        assert not Principal.isAnonymous(caller);
        assert (Principal.toText(caller) == main_canister_id);
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
        
        let uniqueCanisterIds = Buffer.fromArray<T.CanisterId>([]);

        for (leagueMember in Iter.fromArray(leagueMembers)) {
            if (not Buffer.contains<T.CanisterId>(uniqueCanisterIds, leagueMember.canisterId, func(a : T.CanisterId, b : T.CanisterId) : Bool { a == b })) {
                uniqueCanisterIds.add(leagueMember.canisterId);
            };
        };

        let openfpl_backend_canister = actor (main_canister_id) : actor {
            getLeaderboardEntries : (canisterId: T.CanisterId) -> async [T.LeaderboardEntry];
        };

        for (canisterId in Iter.fromArray(Buffer.toArray(uniqueCanisterIds))) {
            
            let leaderboardEntries = await openfpl_backend_canister.getLeaderboardEntries(canisterId);

            //Put leaderboard entries in this gameweek

            //Position leaderboard entries

            //Update monthly leaderboard entries 

            //Update Season Leaderboard entries
        };

        //pay rewards based on leaderboard entries

      //when the leaderboards are updated just pay rewards based on those leaderboards
      

      //call the canister to get the managers current weekly scores passing in the ids of the users
        //what is the maximum amount I can actually transfer here?
    

        //for each manager I need their team to calculate their leaderboard
        //but I've already calculated their score so I just need to get it

        //group all manager canister ids and make a single call to get their information by canister to save space
            //will i need to store the users canister id 

        //For each member of the league
            //getWeeklyLeaderboardScore
            //getMonthlyLeaderboardScore
            //getSeasonLeaderboardScore
        
        //when this has been updated check if you need to pay rewards


        
        /*
        let fantasyTeamSnapshotsBuffer = Buffer.fromArray<T.FantasyTeamSnapshot>([]);

        for (canisterId in Iter.fromArray(uniqueManagerCanisterIds)) {
            let manager_canister = actor (canisterId) : actor {
            getSnapshots : (seasonId : T.SeasonId, gameweek : T.GameweekNumber) -> async [T.FantasyTeamSnapshot];
            };

            let snapshots = await manager_canister.getSnapshots(seasonId, gameweek);
            fantasyTeamSnapshotsBuffer.append(Buffer.fromArray(snapshots));
        };
        */

        await calculateWeeklyLeaderboards(seasonId, gameweek, Buffer.toArray(fantasyTeamSnapshotsBuffer));
        await calculateMonthlyLeaderboards(seasonId, gameweek, month, Buffer.toArray(fantasyTeamSnapshotsBuffer));
        await calculateSeasonLeaderboard(seasonId, Buffer.toArray(fantasyTeamSnapshotsBuffer));
        await payRewards();
        await incrementState();
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

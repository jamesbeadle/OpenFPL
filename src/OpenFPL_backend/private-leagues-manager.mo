
import T "types";
import DTOs "DTOs";
import Result "mo:base/Result";
import Iter "mo:base/Iter";

module {

  public class PrivateLeaguesManager() {
    
    private var privateLeagueCanisterIds: [T.CanisterId] = [];

    public func getStablePrivateLeagueCanisterIds() : [T.CanisterId] {
      return privateLeagueCanisterIds;
    };

    public func setStablePrivateLeagueCanisterIds(stable_private_league_canister_ids: [T.CanisterId]) {
      privateLeagueCanisterIds := stable_private_league_canister_ids;
    };

    public func isLeagueMember(canisterId: T.CanisterId, callerId: T.PrincipalId) : async Bool {
      let private_league_canister = actor (canisterId) : actor {
        isLeagueMember : (callerId : T.PrincipalId) -> async Bool;
      };

      return await private_league_canister.isLeagueMember(callerId);
    };
    
    public func getWeeklyLeaderboard(canisterId: T.CanisterId, seasonId: T.SeasonId, gameweek: T.GameweekNumber, limit : Nat, offset : Nat) : async Result.Result<DTOs.WeeklyLeaderboardDTO, T.Error> {
      let private_league_canister = actor (canisterId) : actor {
        getWeeklyLeaderboard : (seasonId : T.SeasonId, gameweek: T.GameweekNumber, limit : Nat, offset : Nat) -> async DTOs.WeeklyLeaderboardDTO;
      };

      return #ok(await private_league_canister.getWeeklyLeaderboard(seasonId, gameweek, limit, offset));
    };

    public func getMonthlyLeaderboard(canisterId: T.CanisterId, seasonId : T.SeasonId, month: T.CalendarMonth, limit : Nat, offset : Nat) : async Result.Result<DTOs.MonthlyLeaderboardDTO, T.Error> {
      let private_league_canister = actor (canisterId) : actor {
        getMonthlyLeaderboard : (seasonId : T.SeasonId, month: T.CalendarMonth, limit : Nat, offset : Nat) -> async DTOs.MonthlyLeaderboardDTO;
      };

      return #ok(await private_league_canister.getMonthlyLeaderboard(seasonId, month, limit, offset));
    };

    public func getSeasonLeaderboard(canisterId: T.CanisterId, seasonId : T.SeasonId, limit : Nat, offset : Nat) : async Result.Result<DTOs.SeasonLeaderboardDTO, T.Error> {
      let private_league_canister = actor (canisterId) : actor {
        getMonthlyLeaderboard : (seasonId : T.SeasonId, limit : Nat, offset : Nat) -> async DTOs.MonthlyLeaderboardDTO;
      };

      return #ok(await private_league_canister.getMonthlyLeaderboard(seasonId, limit, offset));
    };
    
    public func getLeagueMembers(canisterId: T.CanisterId, limit : Nat, offset : Nat) : async Result.Result<[DTOs.LeagueMemberDTO], T.Error> {
      let private_league_canister = actor (canisterId) : actor {
        getLeagueMembers : (limit : Nat, offset : Nat) -> async [DTOs.LeagueMemberDTO];
      };

      return #ok(await private_league_canister.getLeagueMembers(limit, offset));
    };

    public func privateLeagueIsValid(privateLeague: DTOs.CreatePrivateLeagueDTO) : Bool{
      return false;
    };

    public func nameAvailable(privateLeagueName: Text) : Bool{
      return false;
    };

    public func canAffordPrivateLeague(caller: T.PrincipalId) : Bool{
      return false;
    };

    public func createPrivateLeague(newPrivateLeague: DTOs.CreatePrivateLeagueDTO) : async () {
      //TODO: TAKE PAYMENT
    };

    public func leagueHasSpace(canisterId: T.CanisterId) : async Bool {
      let private_league_canister = actor (canisterId) : actor {
        leagueHasSpace : () -> async Bool;
      };

      return await private_league_canister.leagueHasSpace();
    };

    public func isLeagueAdmin(canisterId: T.CanisterId, principalId: T.PrincipalId) : async Bool {
      let private_league_canister = actor (canisterId) : actor {
        isLeagueAdmin : (principalId: T.PrincipalId) -> async Bool;
      };

      return await private_league_canister.isLeagueAdmin(principalId);
    };

    public func inviteUserToLeague(canisterId: T.CanisterId, managerId: T.PrincipalId) : async (){

    };

    public func acceptLeagueInvite(canisterId: T.CanisterId, managerId: T.PrincipalId) : async (){

    };

    public func updateLeaguePicture(canisterId: T.CanisterId, picture: Blob) : async (){

    };

    public func calculateLeaderboards() : async (){
      for(canisterId in Iter.fromArray(privateLeagueCanisterIds)){
        let private_league_canister = actor (canisterId) : actor {
          calculateLeaderboard : () -> async ();
        };

        return await private_league_canister.calculateLeaderboard();
      };
    };

  };
};


import T "types";
import DTOs "DTOs";
import Result "mo:base/Result";
import Iter "mo:base/Iter";
import Text "mo:base/Text";
import Array "mo:base/Array";
import Blob "mo:base/Blob";

module {

  public class PrivateLeaguesManager() {
    
    private var privateLeagueCanisterIds: [T.CanisterId] = [];
    private var privateLeagueNameIndex: [(T.CanisterId, Text)] = [];

    public func getStablePrivateLeagueCanisterIds() : [T.CanisterId] {
      return privateLeagueCanisterIds;
    };

    public func setStablePrivateLeagueCanisterIds(stable_private_league_canister_ids: [T.CanisterId]) {
      privateLeagueCanisterIds := stable_private_league_canister_ids;
    };

    public func getStablePrivateLeagueNameIndex() : [(T.CanisterId, Text)] {
      return privateLeagueNameIndex;
    };

    public func setStablePrivateLeagueNameIndex(stable_private_league_NameIndex: [(T.CanisterId, Text)]) {
      privateLeagueNameIndex := stable_private_league_NameIndex;
    };

    public func isLeagueMember(canisterId: T.CanisterId, callerId: T.PrincipalId) : async Bool {
      let private_league_canister = actor (canisterId) : actor {
        isLeagueMember : (callerId : T.PrincipalId) -> async Bool;
      };

      return await private_league_canister.isLeagueMember(callerId);
    };
    
    public func getWeeklyLeaderboard(canisterId: T.CanisterId, seasonId: T.SeasonId, gameweek: T.GameweekNumber, limit : Nat, offset : Nat) : async Result.Result<DTOs.WeeklyLeaderboardDTO, T.Error> {
      let private_league_canister = actor (canisterId) : actor {
        getWeeklyLeaderboard : (seasonId : T.SeasonId, gameweek: T.GameweekNumber, limit : Nat, offset : Nat) -> async Result.Result<DTOs.WeeklyLeaderboardDTO, T.Error>;
      };

      return await private_league_canister.getWeeklyLeaderboard(seasonId, gameweek, limit, offset);
    };

    public func getMonthlyLeaderboard(canisterId: T.CanisterId, seasonId : T.SeasonId, month: T.CalendarMonth, limit : Nat, offset : Nat) : async Result.Result<DTOs.MonthlyLeaderboardDTO, T.Error> {
      let private_league_canister = actor (canisterId) : actor {
        getMonthlyLeaderboard : (seasonId : T.SeasonId, month: T.CalendarMonth, limit : Nat, offset : Nat) -> async Result.Result<DTOs.MonthlyLeaderboardDTO, T.Error>;
      };

      return await private_league_canister.getMonthlyLeaderboard(seasonId, month, limit, offset);
    };

    public func getSeasonLeaderboard(canisterId: T.CanisterId, seasonId : T.SeasonId, limit : Nat, offset : Nat) : async Result.Result<DTOs.SeasonLeaderboardDTO, T.Error> {
      let private_league_canister = actor (canisterId) : actor {
        getSeasonLeaderboard : (seasonId : T.SeasonId, limit : Nat, offset : Nat) -> async Result.Result<DTOs.MonthlyLeaderboardDTO, T.Error>;
      };

      return await private_league_canister.getSeasonLeaderboard(seasonId, limit, offset);
    };
    
    public func getLeagueMembers(canisterId: T.CanisterId, limit : Nat, offset : Nat) : async Result.Result<[DTOs.LeagueMemberDTO], T.Error> {
      let private_league_canister = actor (canisterId) : actor {
        getLeagueMembers : (limit : Nat, offset : Nat) -> async Result.Result<[DTOs.LeagueMemberDTO], T.Error>;
      };

      return await private_league_canister.getLeagueMembers(limit, offset);
    };

    public func privateLeagueIsValid(privateLeague: DTOs.CreatePrivateLeagueDTO) : Bool{
      if(Text.size(privateLeague.name) < 2 or Text.size(privateLeague.name) > 20){
        return false;
      };

      if(privateLeague.entrants < 2 or privateLeague.entrants > 1000){
        return false;
      };

      switch(privateLeague.photo){
        case null {};
        case (?foundPicture){
          let pictureSizeKB = Array.size(Blob.toArray(foundPicture)) / 1024;
          if(pictureSizeKB <= 0 or pictureSizeKB > 500){
            return false;
          };
        }
      };

      switch(privateLeague.banner){
        case null {};
        case (?foundBanner){
          let bannerSizeKB = Array.size(Blob.toArray(foundBanner)) / 1024;
          if(bannerSizeKB <= 0 or bannerSizeKB > 500){
            return false;
          };
        }
      };

      if(privateLeague.adminFee < 0 or privateLeague.adminFee > 5){
        return false;
      };

      switch(privateLeague.entryRequirement){
        case (#FreeEntry){};
        case (#InviteOnly){};
        case (#PaidEntry){
          if(privateLeague.entryFee <= 0){
            return false;
          };
        };
        case (#PaidInviteEntry){
          if(privateLeague.entryFee <= 0){
            return false;
          };
        };
      };
      
      return true;
    };

    public func nameAvailable(privateLeagueName: Text) : Bool{
      for(name in Iter.fromArray(privateLeagueNameIndex)){
        if(name.1 == privateLeagueName){
          return false;
        }
      };
      return true;
    };

    public func createPrivateLeague(newPrivateLeague: DTOs.CreatePrivateLeagueDTO) : async Result.Result<(), T.Error> {
      //TODO: TAKE PAYMENT
      
      //create canister

      //set up canister

      return #ok();
    };

    public func leagueHasSpace(canisterId: T.CanisterId) : async Result.Result<Bool, T.Error> {
      let private_league_canister = actor (canisterId) : actor {
        leagueHasSpace : () -> async Result.Result<Bool, T.Error>;
      };

      return await private_league_canister.leagueHasSpace();
    };

    public func isLeagueAdmin(canisterId: T.CanisterId, principalId: T.PrincipalId) : async Result.Result<Bool, T.Error> {
      let private_league_canister = actor (canisterId) : actor {
        isLeagueAdmin : (principalId: T.PrincipalId) -> async Result.Result<Bool, T.Error>;
      };

      return await private_league_canister.isLeagueAdmin(principalId);
    };

    public func inviteUserToLeague(canisterId: T.CanisterId, managerId: T.PrincipalId) : async Result.Result<(), T.Error>{
      let private_league_canister = actor (canisterId) : actor {
        inviteUserToLeague : (managerId: T.PrincipalId) -> async Result.Result<(), T.Error>;
      };

      return await private_league_canister.inviteUserToLeague(managerId);
    };

    public func acceptLeagueInvite(canisterId: T.CanisterId, managerId: T.PrincipalId) : async Result.Result<(), T.Error>{
      let private_league_canister = actor (canisterId) : actor {
        acceptLeagueInvite : (managerId: T.PrincipalId) -> async Result.Result<(), T.Error>;
      };

      return await private_league_canister.acceptLeagueInvite(managerId);
    };

    public func updateLeaguePicture(canisterId: T.CanisterId, picture: Blob) : async Result.Result<(), T.Error>{
      let private_league_canister = actor (canisterId) : actor {
        updateLeaguePicture : (picture: Blob) -> async Result.Result<(), T.Error>;
      };

      return await private_league_canister.updateLeaguePicture(picture);
    };

    public func updateLeagueBanner(canisterId: T.CanisterId, banner: Blob) : async Result.Result<(), T.Error>{
      let private_league_canister = actor (canisterId) : actor {
        updateLeagueBanner : (banner: Blob) -> async Result.Result<(), T.Error>;
      };

      return await private_league_canister.updateLeagueBanner(banner);
    };

    public func updateLeagueName(canisterId: T.CanisterId, name: Text) : async Result.Result<(), T.Error>{
      let private_league_canister = actor (canisterId) : actor {
        updateLeagueName : (text: Text) -> async Result.Result<(), T.Error>;
      };

      return await private_league_canister.updateLeagueName(name);
    };

    public func enterLeague(canisterId: T.CanisterId, managerId: T.PrincipalId) : async Result.Result<(), T.Error>{
      let private_league_canister = actor (canisterId) : actor {
        enterLeague : (managerId: T.PrincipalId) -> async Result.Result<(), T.Error>;
      };

      return await private_league_canister.enterLeague(managerId);
    };

    public func inviteExists(canisterId: T.CanisterId, managerId: T.PrincipalId) : async Result.Result<Bool, T.Error> {
      let private_league_canister = actor (canisterId) : actor {
        inviteExists : (managerId: T.PrincipalId) -> async Result.Result<Bool, T.Error>;
      };

      return await private_league_canister.inviteExists(managerId);
    };

    public func acceptInvite(canisterId: T.CanisterId, managerId: T.PrincipalId) : async Result.Result<(), T.Error> {
      let private_league_canister = actor (canisterId) : actor {
        acceptInvite : (managerId: T.PrincipalId) -> async Result.Result<(), T.Error>;
      };

      return await private_league_canister.acceptInvite(managerId);
    };

    public func getPrivateLeague(canisterId: T.CanisterId) : async Result.Result<DTOs.PrivateLeagueDTO, T.Error> {
      let private_league_canister = actor (canisterId) : actor {
        getPrivateLeague : () -> async Result.Result<DTOs.PrivateLeagueDTO, T.Error>;
      };

      return await private_league_canister.getPrivateLeague();
    };

    public func calculateLeaderboards() : async (){
      for(canisterId in Iter.fromArray(privateLeagueCanisterIds)){
        let private_league_canister = actor (canisterId) : actor {
          calculateLeaderboards : () -> async ();
        };

        return await private_league_canister.calculateLeaderboards();
      };
    };

  };
};

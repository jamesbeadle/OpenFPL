
import T "types";
import DTOs "DTOs";
import Result "mo:base/Result";
import Iter "mo:base/Iter";
import Text "mo:base/Text";
import Array "mo:base/Array";
import Blob "mo:base/Blob";
import Buffer "mo:base/Buffer";
import Principal "mo:base/Principal";
import SNSToken "sns-wrappers/ledger";
import Account "./lib/Account";
import Cycles "mo:base/ExperimentalCycles";
import Float "mo:base/Float";
import Nat64 "mo:base/Nat64";
import Int64 "mo:base/Int64";
import Int "mo:base/Int";
import Time "mo:base/Time";
import PrivateLeague "canister_definitions/private-league";
import Management "./modules/Management";
import Utilities "./utils/utilities";
import Environment "./utils/Environment";

module {

  public class PrivateLeaguesManager() {
    
    private var privateLeagueCanisterIds: [T.CanisterId] = [];
    private var privateLeagueNameIndex: [(T.CanisterId, Text)] = [];
    private var backendCanisterController : ?Principal = null;
    private var unacceptedInvites: [(T.PrincipalId, T.LeagueInvite)] = [];

    public func setBackendCanisterController(controller : Principal) {
      backendCanisterController := ?controller;
    };

    public func getStablePrivateLeagueCanisterIds() : [T.CanisterId] {
      return privateLeagueCanisterIds;
    };

    public func setStablePrivateLeagueCanisterIds(stable_private_league_canister_ids: [T.CanisterId]) {
      privateLeagueCanisterIds := stable_private_league_canister_ids;
    };

    public func getStablePrivateLeagueNameIndex() : [(T.CanisterId, Text)] {
      return privateLeagueNameIndex;
    };

    public func setStablePrivateLeagueNameIndex(stable_private_league_name_index: [(T.CanisterId, Text)]) {
      privateLeagueNameIndex := stable_private_league_name_index;
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

    public func createPrivateLeague(defaultAccount : Principal, leagueCreatorId: Principal, newPrivateLeague: DTOs.CreatePrivateLeagueDTO) : async Result.Result<(), T.Error> {
      
      var ledgerCanisterId = Environment.NNS_LEDGER_CANISTER_ID;
      var entryFee: Nat64 = 100_000_000;
      var fee: Nat64 = 10_000;

      switch(newPrivateLeague.paymentChoice){
        case (#ICP){ };
        case (#FPL){
          
          let icp_coins_canister = actor (Environment.ICP_COINS_CANISTER_ID) : actor {
            get_latest : () -> async [DTOs.ICPCoinsResponse];
          };

          let allCoins = await icp_coins_canister.get_latest();
          for(coinRecord in Iter.fromArray(allCoins)){
            if(coinRecord.pairName == "FPL/ICP"){
              if(coinRecord.price <= 0){
                return #err(#InvalidData);
              };
              entryFee := Int64.toNat64(Float.toInt64(1 / coinRecord.price));
            }
          };

          ledgerCanisterId := Environment.SNS_LEDGER_CANISTER_ID;
          fee := 100_000; 
        };
      };
      
      let ledger : SNSToken.Interface = actor (ledgerCanisterId);
     
      let _ = await ledger.icrc1_transfer ({
        memo = ?Text.encodeUtf8("0");
        from_subaccount = ?Account.principalToSubaccount(leagueCreatorId);
        to = { owner = defaultAccount; subaccount = ?Account.defaultSubaccount() };
        amount = Nat64.toNat(entryFee - fee);
        fee = ?Nat64.toNat(fee);
        created_at_time = ?Nat64.fromNat(Int.abs(Time.now()))
      });

      Cycles.add<system>(2_000_000_000_000);
      let canister = await PrivateLeague._PrivateLeague();
      let IC : Management.Management = actor (Environment.Default);
      let _ = await Utilities.updateCanister_(canister, backendCanisterController, IC);
      let canister_principal = Principal.fromActor(canister);

      let _ = await canister.setAdmin(Principal.toText(leagueCreatorId));

      let nameIndexBuffer = Buffer.fromArray<(T.CanisterId, Text)>(privateLeagueNameIndex);
      nameIndexBuffer.add((Principal.toText(canister_principal),newPrivateLeague.name));
      privateLeagueNameIndex := Buffer.toArray(nameIndexBuffer);

      return #ok();
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

    public func getPrivateLeagueInvites(managerId: T.PrincipalId) : Result.Result<[DTOs.PrivateLeagueInviteDTO], T.Error> {

      let filteredInvites = Array.filter<(T.PrincipalId, T.LeagueInvite)>(
        unacceptedInvites,
        func(invite : (T.PrincipalId, T.LeagueInvite)) : Bool {
          return invite.0 == managerId;
        },
      );

      let inviteDTOs = Array.map<(T.PrincipalId, T.LeagueInvite), DTOs.PrivateLeagueInviteDTO>(
        filteredInvites,
        func(invite : (T.PrincipalId, T.LeagueInvite)) : DTOs.PrivateLeagueInviteDTO {
          return {
            inviteStatus = #Sent;
            sent = invite.1.sent;
            to = invite.1.to;
            from = invite.1.from;
            leagueCanisterId = invite.1.leagueCanisterId;
          };
        },
      );

      return #ok(inviteDTOs);
    };

    public func inviteUserToLeague(canisterId: T.CanisterId, managerId: T.PrincipalId, callerId: T.PrincipalId) : async Result.Result<(), T.Error>{
      let private_league_canister = actor (canisterId) : actor {
        inviteUserToLeague : (managerId: T.PrincipalId, sentBy: T.PrincipalId) -> async Result.Result<(), T.Error>;
      };

      let unacceptedInvitesBuffer = Buffer.fromArray<(T.PrincipalId, T.LeagueInvite)>(unacceptedInvites);

      unacceptedInvitesBuffer.add(managerId, {
        from = callerId;
        inviteStatus = #Sent;
        leagueCanisterId = canisterId;
        sent = Time.now();
        to = managerId;
      });

      unacceptedInvites := Buffer.toArray(unacceptedInvitesBuffer);

      return await private_league_canister.inviteUserToLeague(managerId, callerId);
    };

    public func acceptLeagueInvite(canisterId: T.CanisterId, managerId: T.PrincipalId, username: Text) : async Result.Result<(), T.Error>{
      let private_league_canister = actor (canisterId) : actor {
        acceptLeagueInvite : (managerId: T.PrincipalId, username: Text) -> async Result.Result<(), T.Error>;
      };

      return await private_league_canister.acceptLeagueInvite(managerId, username);
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

    public func enterLeague(canisterId: T.CanisterId, managerId: T.PrincipalId, managerCanisterId: T.CanisterId, username: Text) : async Result.Result<(), T.Error>{
      let private_league_canister = actor (canisterId) : actor {
        enterLeague : (managerId: T.PrincipalId, managerCanisterId: T.CanisterId, username: Text) -> async Result.Result<(), T.Error>;
      };

      return await private_league_canister.enterLeague(managerId, managerCanisterId, username);
    };

    public func inviteExists(canisterId: T.CanisterId, managerId: T.PrincipalId) : async Bool {
      let private_league_canister = actor (canisterId) : actor {
        inviteExists : (managerId: T.PrincipalId) -> async Bool;
      };

      return await private_league_canister.inviteExists(managerId);
    };

    public func acceptInvite(canisterId: T.CanisterId, managerId: T.PrincipalId, managerCanisterId: T.CanisterId, username: Text) : async Result.Result<(), T.Error> {
      let private_league_canister = actor (canisterId) : actor {
        acceptLeagueInvite : (managerId: T.PrincipalId, managerCanisterId: T.CanisterId, username: Text) -> async Result.Result<(), T.Error>;
      };

      return await private_league_canister.acceptLeagueInvite(managerId, managerCanisterId, username);
    };

    public func rejectInvite(canisterId: T.CanisterId, managerId: T.PrincipalId) : async Result.Result<(), T.Error> {
      let private_league_canister = actor (canisterId) : actor {
        rejectLeagueInvite : (managerId: T.PrincipalId) -> async Result.Result<(), T.Error>;
      };

      return await private_league_canister.rejectLeagueInvite(managerId);
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

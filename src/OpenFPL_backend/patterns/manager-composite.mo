import DTOs "../DTOs";
import T "../types";
import Result "mo:base/Result";
import Blob "mo:base/Blob";
import Text "mo:base/Text";
import List "mo:base/List";
import { now } = "mo:base/Time";
import HashMap "mo:base/HashMap";
import Iter "mo:base/Iter";
import Array "mo:base/Array";
import Nat16 "mo:base/Nat16";
import Nat8 "mo:base/Nat8";
import Int64 "mo:base/Int64";
import Nat64 "mo:base/Nat64";
import Cycles "mo:base/ExperimentalCycles";
import Principal "mo:base/Principal";
import Buffer "mo:base/Buffer";
import Float "mo:base/Float";
import Option "mo:base/Option";
import Time "mo:base/Time";
import Order "mo:base/Order";
import Int16 "mo:base/Int16";
import Management "../modules/Management";
import ENV "../utils/Env";
import ProfilePictureCanister "../profile-picture-canister";
import RewardPercentages "../utils/RewardPercentages";
import Utilities "../utilities";
import Token "../token";

module {

  public class ManagerComposite() {
    let tokenCanister = Token.Token(); 
    private var managers: HashMap.HashMap<T.PrincipalId, T.Manager> = HashMap.HashMap<T.PrincipalId, T.Manager>(100, Text.equal, Text.hash);
    private var profilePictureCanisterIds : HashMap.HashMap<T.PrincipalId, Text> = HashMap.HashMap<T.PrincipalId, Text>(100, Text.equal, Text.hash);   
    private var activeProfilePictureCanisterId = ""; 
    
    private var storeCanisterId : ?((canisterId : Text) -> async ()) = null;

    var backendCanisterController: ?Principal = null;

    var seasonRewards: List.List<T.SeasonRewards> = List.nil();
    var monthlyRewards: List.List<T.MonthlyRewards> = List.nil();
    var weeklyRewards: List.List<T.WeeklyRewards> = List.nil();
    var mostValuableTeamRewards: List.List<T.RewardsList> = List.nil();
    var highScoringPlayerRewards: List.List<T.RewardsList> = List.nil();
    var allTimeHighScoreRewards: List.List<T.RewardsList> = List.nil();

    var weeklyAllTimeHighScores: List.List<T.HighScoreRecord> = List.nil();
    var monthlyAllTimeHighScores: List.List<T.HighScoreRecord> = List.nil();
    var sesasonAllTimeHighScores: List.List<T.HighScoreRecord> = List.nil();

    var weeklyATHPrizePool: Nat64 = 0;
    var monthlyATHPrizePool: Nat64 = 0;
    var seasonATHPrizePool: Nat64 = 0;
    
    public func setBackendCanisterController(controller: Principal){
      backendCanisterController := ?controller;
    };
    
    public func setStoreCanisterIdFunction(
      _storeCanisterId : (canisterId : Text) -> async ()) {
      storeCanisterId := ?_storeCanisterId;
    };

    public func setStableData(stable_managers: [(T.PrincipalId, T.Manager)], stable_profile_picture_canister_ids: [(T.PrincipalId, Text)]) { 
      managers := HashMap.fromIter<T.PrincipalId, T.Manager>(
        stable_managers.vals(),
        stable_managers.size(),
        Text.equal,
        Text.hash
      );
      profilePictureCanisterIds := HashMap.fromIter<T.PrincipalId, Text>(
        stable_profile_picture_canister_ids.vals(),
        stable_profile_picture_canister_ids.size(),
        Text.equal,
        Text.hash
      );
    };
    
    public func getProfile(principalId: Text) : async Result.Result<DTOs.ProfileDTO, T.Error>{
        
        let manager = managers.get(principalId);

        switch(manager){
            case (null) {
            return #err(#NotFound);
            };
            case (?foundManager){
            
            var profilePicture = Blob.fromArray([]);
            
            if(Text.size(foundManager.profilePictureCanisterId) > 0){
                let profile_picture_canister = actor (foundManager.profilePictureCanisterId) : actor {
                getProfilePicture : (principalId: Text) -> async Blob;
                };
                profilePicture := await profile_picture_canister.getProfilePicture(foundManager.principalId);
            };
            
            let profileDTO: DTOs.ProfileDTO = {
                principalId = foundManager.principalId;
                username = foundManager.username;
                profilePicture = profilePicture;
                favouriteClubId = foundManager.favouriteClubId;
                createDate = foundManager.createDate;
            };

            return #ok(profileDTO);
            };
        }
    };

    public func getManagers() : HashMap.HashMap<T.PrincipalId, T.Manager>{
      return managers;
    };

    public func getManager(principalId: Text, seasonId: T.SeasonId, weeklyLeaderboardEntry: ?DTOs.LeaderboardEntryDTO, monthlyLeaderboardEntry: ?DTOs.LeaderboardEntryDTO, seasonLeaderboardEntry: ?DTOs.LeaderboardEntryDTO) : async Result.Result<DTOs.ManagerDTO, T.Error>{

      var weeklyPosition : Int = 0;
      var monthlyPosition : Int = 0;
      var seasonPosition : Int = 0;

      var weeklyPositionText = "N/A";
      var monthlyPositionText = "N/A";
      var seasonPositionText = "N/A";

      var weeklyPoints : Int16 = 0;
      var monthlyPoints : Int16 = 0;
      var seasonPoints : Int16 = 0;

      switch (weeklyLeaderboardEntry) {
        case (null) {};
        case (?foundEntry) {
          weeklyPosition := foundEntry.position;
          weeklyPositionText := foundEntry.positionText;
          weeklyPoints := foundEntry.points;
        };
      };

      switch (monthlyLeaderboardEntry) {
        case (null) {};
        case (?foundEntry) {
          monthlyPosition := foundEntry.position;
          monthlyPositionText := foundEntry.positionText;
          monthlyPoints := foundEntry.points;
        };
      };

      switch (seasonLeaderboardEntry) {
        case (null) {};
        case (?foundEntry) {
          seasonPosition := foundEntry.position;
          seasonPositionText := foundEntry.positionText;
          seasonPoints := foundEntry.points;
        };
      };

      let manager = managers.get(principalId);

      switch(manager){
        case (null) {
          return #err(#NotFound);
        };
        case (?foundManager){

          
          var gameweeks : [T.FantasyTeamSnapshot] = [];

          let season = List.find(
            foundManager.history,
            func(season : T.FantasyTeamSeason) : Bool {
              return season.seasonId == seasonId;
            },
          );

          switch (season) {
            case (null) {};
            case (?foundSeason) {
              gameweeks := List.toArray(foundSeason.gameweeks);
            };
          };
          
        
          var profilePicture = Blob.fromArray([]);
          if(Text.size(foundManager.profilePictureCanisterId) > 0){
              let profile_picture_canister = actor (foundManager.profilePictureCanisterId) : actor {
                getProfilePicture : (principalId: Text) -> async Blob;
              };
              profilePicture := await profile_picture_canister.getProfilePicture(foundManager.principalId);
          };
          
          let managerDTO: DTOs.ManagerDTO = {
            principalId = foundManager.principalId;
            username = foundManager.username;
            profilePicture = profilePicture;
            favouriteClubId = foundManager.favouriteClubId;
            createDate = foundManager.createDate;
            gameweeks = gameweeks;
            weeklyPosition = weeklyPosition;
            monthlyPosition = monthlyPosition;
            seasonPosition = seasonPosition;
            weeklyPositionText = weeklyPositionText;
            monthlyPositionText = monthlyPositionText;
            seasonPositionText = seasonPositionText;
            weeklyPoints = weeklyPoints;
            monthlyPoints = monthlyPoints;
            seasonPoints = seasonPoints;
          };
          return #ok(managerDTO);
        };
      }
    };
    
    public func getManagerGameweek(principalId: Text, seasonId: T.SeasonId, gameweek: T.GameweekNumber) : async Result.Result<DTOs.ManagerGameweekDTO, T.Error>{
      
      let manager = managers.get(principalId);
      switch (manager) {
        case (null) { return #err(#NotFound) };
        case (?foundTeam) {

          let teamHistory = foundTeam.history;
          switch (teamHistory) {
            case (null) { return #err(#NotFound) };
            case (foundHistory) {
              let foundSeason = List.find<T.FantasyTeamSeason>(
                foundHistory,
                func(season : T.FantasyTeamSeason) : Bool {
                  return season.seasonId == seasonId;
                },
              );
              switch (foundSeason) {
                case (null) { return #err(#NotFound) };
                case (?fs) {
                  let foundGameweek = List.find<T.FantasyTeamSnapshot>(
                    fs.gameweeks,
                    func(gw : T.FantasyTeamSnapshot) : Bool {
                      return gw.gameweek == gameweek;
                    },
                  );
                  switch (foundGameweek) {
                    case (null) { return #err(#NotFound) };
                    case (?fgw) { return #ok(fgw) };
                  };
                };
              };
            };
          };
        };
      };
    };

    public func getTotalManagers() : Nat {
      let managersWithTeams = Iter.filter<T.Manager>(managers.vals(), func (manager : T.Manager) : Bool { Array.size(manager.playerIds) == 11 });
      return Iter.size(managersWithTeams);
    };
    
    public func saveFantasyTeam(principalId: Text, updatedFantasyTeam: DTOs.UpdateFantasyTeamDTO, systemState: T.SystemState, players: [DTOs.PlayerDTO]) : async Result.Result<(), T.Error> {
      
      let manager = managers.get(principalId);
      
      if(not isUsernameValid(updatedFantasyTeam.username, principalId)){
        return #err(#InvalidData);
      };

      if(invalidBonuses(updatedFantasyTeam, manager, systemState, players)){
        return #err(#InvalidData);
      };
      
      if(invalidTransfers(updatedFantasyTeam, manager, systemState, players)){
        return #err(#InvalidTeamError);
      };  

      if(invalidTeamComposition(updatedFantasyTeam, players)){
        return #err(#InvalidTeamError);
      };
      
      switch(manager){
        case (null){
          let createProfileDTO: DTOs.ProfileDTO = {
              principalId = principalId;
              username = updatedFantasyTeam.username;
              profilePicture = Blob.fromArray([]);
              favouriteClubId = 0;
              createDate = now();
              canUpdateFavouriteClub = true;
          };
          let newManager = buildNewManager(principalId, createProfileDTO, "");
          let updatedManager: T.Manager = {
              principalId = newManager.principalId;
              username = newManager.username;
              favouriteClubId = newManager.favouriteClubId;
              createDate = newManager.createDate;
              termsAccepted = newManager.termsAccepted;
              profilePictureCanisterId = newManager.profilePictureCanisterId;
              transfersAvailable = newManager.transfersAvailable;
              monthlyBonusesAvailable = newManager.monthlyBonusesAvailable;
              bankQuarterMillions = newManager.bankQuarterMillions;
              playerIds = updatedFantasyTeam.playerIds;
              captainId = updatedFantasyTeam.captainId;
              goalGetterGameweek = updatedFantasyTeam.goalGetterGameweek;
              goalGetterPlayerId = updatedFantasyTeam.goalGetterPlayerId;
              passMasterGameweek = updatedFantasyTeam.passMasterGameweek;
              passMasterPlayerId = updatedFantasyTeam.passMasterPlayerId;
              noEntryGameweek = updatedFantasyTeam.noEntryGameweek;
              noEntryPlayerId = updatedFantasyTeam.noEntryPlayerId;
              teamBoostGameweek = updatedFantasyTeam.teamBoostGameweek;
              teamBoostClubId = updatedFantasyTeam.teamBoostClubId;
              safeHandsGameweek = updatedFantasyTeam.safeHandsGameweek;
              safeHandsPlayerId = updatedFantasyTeam.safeHandsPlayerId;
              captainFantasticGameweek = updatedFantasyTeam.captainFantasticGameweek;
              captainFantasticPlayerId = updatedFantasyTeam.captainFantasticPlayerId;
              countrymenGameweek = updatedFantasyTeam.countrymenGameweek;
              countrymenCountryId = updatedFantasyTeam.countrymenCountryId;
              prospectsGameweek = updatedFantasyTeam.prospectsGameweek;
              braceBonusGameweek = updatedFantasyTeam.braceBonusGameweek;
              hatTrickHeroGameweek = updatedFantasyTeam.hatTrickHeroGameweek;
              transferWindowGameweek = updatedFantasyTeam.transferWindowGameweek;
              history = List.nil<T.FantasyTeamSeason>();
          };
          managers.put(principalId, updatedManager);
          return #ok();
        };
        case (?foundManager){
          let updatedManager: T.Manager = {
              principalId = foundManager.principalId;
              username = foundManager.username;
              favouriteClubId = foundManager.favouriteClubId;
              createDate = foundManager.createDate;
              termsAccepted = foundManager.termsAccepted;
              profilePictureCanisterId = foundManager.profilePictureCanisterId;
              transfersAvailable = foundManager.transfersAvailable;
              monthlyBonusesAvailable = foundManager.monthlyBonusesAvailable;
              bankQuarterMillions = foundManager.bankQuarterMillions;
              playerIds = updatedFantasyTeam.playerIds;
              captainId = updatedFantasyTeam.captainId;
              goalGetterGameweek = updatedFantasyTeam.goalGetterGameweek;
              goalGetterPlayerId = updatedFantasyTeam.goalGetterPlayerId;
              passMasterGameweek = updatedFantasyTeam.passMasterGameweek;
              passMasterPlayerId = updatedFantasyTeam.passMasterPlayerId;
              noEntryGameweek = updatedFantasyTeam.noEntryGameweek;
              noEntryPlayerId = updatedFantasyTeam.noEntryPlayerId;
              teamBoostGameweek = updatedFantasyTeam.teamBoostGameweek;
              teamBoostClubId = updatedFantasyTeam.teamBoostClubId;
              safeHandsGameweek = updatedFantasyTeam.safeHandsGameweek;
              safeHandsPlayerId = updatedFantasyTeam.safeHandsPlayerId;
              captainFantasticGameweek = updatedFantasyTeam.captainFantasticGameweek;
              captainFantasticPlayerId = updatedFantasyTeam.captainFantasticPlayerId;
              countrymenGameweek = updatedFantasyTeam.countrymenGameweek;
              countrymenCountryId = updatedFantasyTeam.countrymenCountryId;
              prospectsGameweek = updatedFantasyTeam.prospectsGameweek;
              braceBonusGameweek = updatedFantasyTeam.braceBonusGameweek;
              hatTrickHeroGameweek = updatedFantasyTeam.hatTrickHeroGameweek;
              transferWindowGameweek = updatedFantasyTeam.transferWindowGameweek;
              history = foundManager.history;
          };
          managers.put(principalId, updatedManager);
          return #ok();
        };
      };
    };
      
    public func updateUsername(principalId: T.PrincipalId, updatedUsername: Text) : async Result.Result<(), T.Error> {
      if(not isUsernameValid(updatedUsername, principalId)){
        return #err(#InvalidData);
      };

      let manager = managers.get(principalId);

      switch(manager){
        case (null){
          let createProfileDTO: DTOs.ProfileDTO = {
              principalId = principalId;
              username = updatedUsername;
              profilePicture = Blob.fromArray([]);
              favouriteClubId = 0;
              createDate = now();
              canUpdateFavouriteClub = true;
          };
          let newManager = buildNewManager(principalId, createProfileDTO, "");
          managers.put(principalId, newManager);
          return #ok();
        };
        case (?foundManager){
          let updatedManager: T.Manager = {
            principalId = foundManager.principalId;
            username = updatedUsername;
            favouriteClubId = foundManager.favouriteClubId;
            createDate = foundManager.createDate;
            termsAccepted = foundManager.termsAccepted;
            profilePictureCanisterId = foundManager.profilePictureCanisterId;
            transfersAvailable = foundManager.transfersAvailable;
            monthlyBonusesAvailable = foundManager.monthlyBonusesAvailable;
            bankQuarterMillions = foundManager.bankQuarterMillions;
            playerIds = foundManager.playerIds;
            captainId = foundManager.captainId;
            goalGetterGameweek = foundManager.goalGetterGameweek;
            goalGetterPlayerId = foundManager.goalGetterPlayerId;
            passMasterGameweek = foundManager.passMasterGameweek;
            passMasterPlayerId = foundManager.passMasterPlayerId;
            noEntryGameweek = foundManager.noEntryGameweek;
            noEntryPlayerId = foundManager.noEntryPlayerId;
            teamBoostGameweek = foundManager.teamBoostGameweek;
            teamBoostClubId = foundManager.teamBoostClubId;
            safeHandsGameweek = foundManager.safeHandsGameweek;
            safeHandsPlayerId = foundManager.safeHandsPlayerId;
            captainFantasticGameweek = foundManager.captainFantasticGameweek;
            captainFantasticPlayerId = foundManager.captainFantasticPlayerId;
            countrymenGameweek = foundManager.countrymenGameweek;
            countrymenCountryId = foundManager.countrymenCountryId;
            prospectsGameweek = foundManager.prospectsGameweek;
            braceBonusGameweek = foundManager.braceBonusGameweek;
            hatTrickHeroGameweek = foundManager.hatTrickHeroGameweek;
            transferWindowGameweek = foundManager.transferWindowGameweek;
            history = foundManager.history;
          };
          managers.put(principalId, updatedManager);
          return #ok();
        };
      };
    };

    public func updateFavouriteClub(principalId : T.PrincipalId, favouriteClubId : T.ClubId, systemState: T.SystemState) : async Result.Result<(), T.Error> {
                 
      let manager = managers.get(principalId);

      switch(manager){
        case (null){

          let createProfileDTO: DTOs.ProfileDTO = {
              principalId = principalId;
              username = "";
              profilePicture = Blob.fromArray([]);
              favouriteClubId = favouriteClubId;
              createDate = now();
              canUpdateFavouriteClub = true;
          };
          let newManager = buildNewManager(principalId, createProfileDTO, "");
          managers.put(principalId, newManager);
          return #ok();
        };
        case (?foundManager){
          if((systemState.pickTeamGameweek > 1 and foundManager.favouriteClubId > 0 and List.size(foundManager.history) > 0)){
            return #err(#InvalidData);
          };
          let updatedManager: T.Manager = {
            principalId = foundManager.principalId;
            username = foundManager.username;
            favouriteClubId = favouriteClubId;
            createDate = foundManager.createDate;
            termsAccepted = foundManager.termsAccepted;
            profilePictureCanisterId = foundManager.profilePictureCanisterId;
            transfersAvailable = foundManager.transfersAvailable;
            monthlyBonusesAvailable = foundManager.monthlyBonusesAvailable;
            bankQuarterMillions = foundManager.bankQuarterMillions;
            playerIds = foundManager.playerIds;
            captainId = foundManager.captainId;
            goalGetterGameweek = foundManager.goalGetterGameweek;
            goalGetterPlayerId = foundManager.goalGetterPlayerId;
            passMasterGameweek = foundManager.passMasterGameweek;
            passMasterPlayerId = foundManager.passMasterPlayerId;
            noEntryGameweek = foundManager.noEntryGameweek;
            noEntryPlayerId = foundManager.noEntryPlayerId;
            teamBoostGameweek = foundManager.teamBoostGameweek;
            teamBoostClubId = foundManager.teamBoostClubId;
            safeHandsGameweek = foundManager.safeHandsGameweek;
            safeHandsPlayerId = foundManager.safeHandsPlayerId;
            captainFantasticGameweek = foundManager.captainFantasticGameweek;
            captainFantasticPlayerId = foundManager.captainFantasticPlayerId;
            countrymenGameweek = foundManager.countrymenGameweek;
            countrymenCountryId = foundManager.countrymenCountryId;
            prospectsGameweek = foundManager.prospectsGameweek;
            braceBonusGameweek = foundManager.braceBonusGameweek;
            hatTrickHeroGameweek = foundManager.hatTrickHeroGameweek;
            transferWindowGameweek = foundManager.transferWindowGameweek;
            history = foundManager.history;
          };
          managers.put(principalId, updatedManager);
          return #ok();
        };
      };
    };

    public func updateProfilePicture(principalId : T.PrincipalId, profilePicture : Blob) : async Result.Result<(), T.Error> {

      if(invalidProfilePicture(profilePicture)){
        return #err(#InvalidData);
      };

      let existingManager = managers.get(principalId);
      switch (existingManager) {
        case (null) {

          let profilePictureCanisterId = await setManagerProfileImage(principalId, profilePicture);

          let createProfileDTO: DTOs.ProfileDTO = {
              principalId = principalId;
              username = "";
              profilePicture = profilePicture;
              favouriteClubId = 0;
              createDate = now();
              canUpdateFavouriteClub = true;
          };

          let newManager = buildNewManager(principalId, createProfileDTO, profilePictureCanisterId);
          managers.put(principalId, newManager);

          return #ok();
        };
        case (?foundManager) {
          var profilePictureCanisterId = "";
          if(foundManager.profilePictureCanisterId == ""){
            profilePictureCanisterId := await setManagerProfileImage(principalId, profilePicture);

            let updatedManager: T.Manager = {
              principalId = foundManager.principalId;
              username = foundManager.username;
              favouriteClubId = foundManager.favouriteClubId;
              createDate = foundManager.createDate;
              termsAccepted = foundManager.termsAccepted;
              profilePictureCanisterId = profilePictureCanisterId;
              transfersAvailable = foundManager.transfersAvailable;
              monthlyBonusesAvailable = foundManager.monthlyBonusesAvailable;
              bankQuarterMillions = foundManager.bankQuarterMillions;
              playerIds = foundManager.playerIds;
              captainId = foundManager.captainId;
              goalGetterGameweek = foundManager.goalGetterGameweek;
              goalGetterPlayerId = foundManager.goalGetterPlayerId;
              passMasterGameweek = foundManager.passMasterGameweek;
              passMasterPlayerId = foundManager.passMasterPlayerId;
              noEntryGameweek = foundManager.noEntryGameweek;
              noEntryPlayerId = foundManager.noEntryPlayerId;
              teamBoostGameweek = foundManager.teamBoostGameweek;
              teamBoostClubId = foundManager.teamBoostClubId;
              safeHandsGameweek = foundManager.safeHandsGameweek;
              safeHandsPlayerId = foundManager.safeHandsPlayerId;
              captainFantasticGameweek = foundManager.captainFantasticGameweek;
              captainFantasticPlayerId = foundManager.captainFantasticPlayerId;
              countrymenGameweek = foundManager.countrymenGameweek;
              countrymenCountryId = foundManager.countrymenCountryId;
              prospectsGameweek = foundManager.prospectsGameweek;
              braceBonusGameweek = foundManager.braceBonusGameweek;
              hatTrickHeroGameweek = foundManager.hatTrickHeroGameweek;
              transferWindowGameweek = foundManager.transferWindowGameweek;
              history = foundManager.history;
            };
            managers.put(principalId, updatedManager);
          }
          else{
            let profilePictureCanister = actor (activeProfilePictureCanisterId) : actor {
              hasSpaceAvailable : () -> async Bool;
              addProfilePicture : (principalId: T.PrincipalId, profilePicture: Blob) -> async ();
            };
            await profilePictureCanister.addProfilePicture(principalId, profilePicture);
          };
          return #ok();
        };
      };
    };

    private func setManagerProfileImage(principalId: Text, profilePicture: Blob) : async Text{

      if(activeProfilePictureCanisterId == ""){
        return await createProfileCanister(principalId, profilePicture);
      }
      else{
        let profilePictureCanister = actor (activeProfilePictureCanisterId) : actor {
          hasSpaceAvailable : () -> async Bool;
          addProfilePicture : (principalId: T.PrincipalId, profilePicture: Blob) -> async ();
        };

        let hasSpaceAvailable = await profilePictureCanister.hasSpaceAvailable();
        if(hasSpaceAvailable){
          await profilePictureCanister.addProfilePicture(principalId, profilePicture);
          return activeProfilePictureCanisterId;
        }      
        else{
          return await createProfileCanister(principalId, profilePicture);
        };
      };
    };
    
    private func updateCanister_(a : actor {}) : async () {
        let cid = { canister_id = Principal.fromActor(a) };
        let IC : Management.Management = actor (ENV.Default);
        switch(backendCanisterController){
          case (null){};
          case (?controller){
            await (
                IC.update_settings({
                    canister_id = cid.canister_id;
                    settings = {
                        controllers = ?[controller];
                        compute_allocation = null;
                        memory_allocation = null;
                        freezing_threshold = ?31_540_000;
                    };
                })
            );
          }
        };
    };

    private func createProfileCanister(principalId: Text, profilePicture: Blob) : async Text {
      if(backendCanisterController == null){
        return "";
      };
      
      Cycles.add(2000000000000);
      let canister = await ProfilePictureCanister.ProfilePictureCanister();
      let IC : Management.Management = actor (ENV.Default);
      let _ = await Utilities.updateCanister_(canister, backendCanisterController, IC);
      let canister_principal = Principal.fromActor(canister);
      await canister.addProfilePicture(principalId, profilePicture);
      let canisterId = Principal.toText(canister_principal);

      switch (storeCanisterId) {
        case (null) {};
        case (?actualFunction) {
          await actualFunction(canisterId);
        };
      };

      return canisterId;
    };

    public func isUsernameValid(username: Text, principalId: Text) : Bool{
        if (Text.size(username) < 3 or Text.size(username) > 20) {
        return false;
      };

      let isAlphanumeric = func(s : Text) : Bool {
        let chars = Text.toIter(s);
        for (c in chars) {
          if (not ((c >= 'a' and c <= 'z') or (c >= 'A' and c <= 'Z') or (c >= '0' and c <= '9') or (c == ' '))) {
            return false;
          };
        };
        return true;
      };

      if (not isAlphanumeric(username)) {
        return false;
      };

      for (profile in managers.vals()) {
        if (profile.username == username and profile.principalId != principalId) {
          return false;
        };
      };

      return true;
    };

    public func getFavouriteClub(principalId: Text) : T.ClubId {
      let manager = managers.get(principalId);
      switch(manager){
        case (null) {return 0};
        case (?foundManager){
          return foundManager.favouriteClubId;
        }
      }
    };

    private func invalidBonuses(updatedFantasyTeam: DTOs.UpdateFantasyTeamDTO, existingFantasyTeam: ?T.Manager, systemState: T.SystemState, players: [DTOs.PlayerDTO]) : Bool {
      
      var bonusesPlayed = 0;
      if(updatedFantasyTeam.goalGetterGameweek == systemState.pickTeamGameweek){
        bonusesPlayed += 1;
      };
      if(updatedFantasyTeam.passMasterGameweek == systemState.pickTeamGameweek){
        bonusesPlayed += 1;
      };
      if(updatedFantasyTeam.noEntryGameweek == systemState.pickTeamGameweek){
        let bonusPlayer = List.find<DTOs.PlayerDTO>(
          List.fromArray(players),
          func(player : DTOs.PlayerDTO) : Bool {
            return player.id == updatedFantasyTeam.noEntryPlayerId;
          },
        );
        switch (bonusPlayer) {
          case (null) { return false };
          case (?player) {
            if (player.position != #Goalkeeper and player.position != #Defender) { return false };
          };
        };
        bonusesPlayed += 1;
      };
      if(updatedFantasyTeam.teamBoostGameweek == systemState.pickTeamGameweek){
        bonusesPlayed += 1;
      };
      if(updatedFantasyTeam.safeHandsGameweek == systemState.pickTeamGameweek){
        let bonusPlayer = List.find<DTOs.PlayerDTO>(
          List.fromArray(players),
          func(player : DTOs.PlayerDTO) : Bool {
            return player.id == updatedFantasyTeam.safeHandsPlayerId;
          },
        );
        switch (bonusPlayer) {
          case (null) { return false };
          case (?player) {
            if (player.position != #Goalkeeper) { return false };
          };
        };
        bonusesPlayed += 1;
      };
      if(updatedFantasyTeam.captainFantasticGameweek == systemState.pickTeamGameweek){
        bonusesPlayed += 1;
      };
      if(updatedFantasyTeam.countrymenGameweek == systemState.pickTeamGameweek){
        bonusesPlayed += 1;
      };
      if(updatedFantasyTeam.prospectsGameweek == systemState.pickTeamGameweek){
        bonusesPlayed += 1;
      };
      if(updatedFantasyTeam.braceBonusGameweek == systemState.pickTeamGameweek){
        bonusesPlayed += 1;
      };
      if(updatedFantasyTeam.hatTrickHeroGameweek == systemState.pickTeamGameweek){
        bonusesPlayed += 1;
      };

      if(bonusesPlayed > 1){
        return true;
      };

      switch(existingFantasyTeam){
        case (null){ };
        case (?foundTeam){
          if(updatedFantasyTeam.goalGetterGameweek == systemState.pickTeamGameweek and foundTeam.goalGetterGameweek != 0){  
            return true;
          };
          if(updatedFantasyTeam.passMasterGameweek == systemState.pickTeamGameweek and foundTeam.passMasterGameweek != 0){
            return true;
          };
          if(updatedFantasyTeam.noEntryGameweek == systemState.pickTeamGameweek and foundTeam.noEntryGameweek != 0){
            return true;
          };
          if(updatedFantasyTeam.teamBoostGameweek == systemState.pickTeamGameweek and foundTeam.teamBoostGameweek != 0){
            return true;
          };
          if(updatedFantasyTeam.safeHandsGameweek == systemState.pickTeamGameweek and foundTeam.safeHandsGameweek != 0){
            return true;
          };
          if(updatedFantasyTeam.captainFantasticGameweek == systemState.pickTeamGameweek and foundTeam.captainFantasticGameweek != 0){
            return true;
          };
          if(updatedFantasyTeam.countrymenGameweek == systemState.pickTeamGameweek and foundTeam.countrymenGameweek != 0){
            return true;
          };
          if(updatedFantasyTeam.prospectsGameweek == systemState.pickTeamGameweek and foundTeam.prospectsGameweek != 0){
            return true;
          };
          if(updatedFantasyTeam.braceBonusGameweek == systemState.pickTeamGameweek and foundTeam.braceBonusGameweek != 0){
            return true;
          };
          if(updatedFantasyTeam.hatTrickHeroGameweek == systemState.pickTeamGameweek and foundTeam.hatTrickHeroGameweek != 0){
            return true;
          };

          if(Int64.fromNat64(Nat64.fromNat(Nat8.toNat(foundTeam.monthlyBonusesAvailable) - bonusesPlayed)) < 0){
            return true;
          };
        };
      };

      return false;
    };
    
    private func invalidTransfers(updatedFantasyTeam: DTOs.UpdateFantasyTeamDTO, existingFantasyTeam: ?T.Manager, systemState: T.SystemState, players: [DTOs.PlayerDTO]) : Bool {
      
      if(updatedFantasyTeam.transferWindowGameweek == systemState.pickTeamGameweek and not systemState.transferWindowActive){
        return true;
      };

      switch(existingFantasyTeam){
        case (null){
          let spend = Array.foldLeft(updatedFantasyTeam.playerIds, 0, func(sum : Nat, playerId : T.PlayerId) : Nat {
            let player: ?DTOs.PlayerDTO = Array.find<DTOs.PlayerDTO>(players, func(p) { p.id == playerId });
            switch(player){
              case (null){
                sum
              };
              case (?foundPlayer){
                sum + foundPlayer.valueQuarterMillions
              }
            }
          });
          
          if(spend > 1200){
            return true;
          };
        };
        case (?foundTeam){
          let existingPlayerIds: [T.PlayerId] = foundTeam.playerIds;

          let playersBought = Array.filter(updatedFantasyTeam.playerIds, func(playerId : T.PlayerId) : Bool {
            Array.find(existingPlayerIds, func(id : T.PlayerId) : Bool { id != playerId }) == null
          });

          var newTransfersAvailable = foundTeam.transfersAvailable;
          if(not systemState.transferWindowActive){
            newTransfersAvailable := newTransfersAvailable - Nat8.fromNat(Array.size(playersBought));
          };

          if(newTransfersAvailable < 0){
            return true;
          };

          let playersSold = Array.filter(existingPlayerIds, func(playerId : T.PlayerId) : Bool {
            Array.find(updatedFantasyTeam.playerIds, func(id : T.PlayerId) : Bool { id != playerId }) == null
          });

          let spend = Array.foldLeft(playersBought, 0, func(sum : Nat, playerId : T.PlayerId) : Nat {
            let player: ?DTOs.PlayerDTO = Array.find<DTOs.PlayerDTO>(players, func(p) { p.id == playerId });
            switch(player){
              case (null){
                sum
              };
              case (?foundPlayer){
                sum + foundPlayer.valueQuarterMillions
              }
            }
          });

          let sold = Array.foldLeft(playersSold, 0, func(sum : Nat, playerId : T.PlayerId) : Nat {
            let player: ?DTOs.PlayerDTO = Array.find<DTOs.PlayerDTO>(players, func(p) { p.id == playerId });
            switch(player){
              case (null){
                sum
              };
              case (?foundPlayer){
                sum + foundPlayer.valueQuarterMillions
              }
            }
          });

          let remainingBank: Nat = foundTeam.bankQuarterMillions - spend + sold;
          if(remainingBank < 0){
            return true;
          };
        };
      };
    
      return false;
    };

    private func invalidTeamComposition(updatedFantasyTeam: DTOs.UpdateFantasyTeamDTO, players: [DTOs.PlayerDTO]) : Bool {
      
      let newTeamPlayers = Array.filter(players, func(player : DTOs.PlayerDTO) : Bool {
        Array.find(updatedFantasyTeam.playerIds, func(id : T.PlayerId) : Bool { id != player.id }) == null
      });

      let playerPositions = Array.map<DTOs.PlayerDTO, T.PlayerPosition>(newTeamPlayers, func(player : DTOs.PlayerDTO) : T.PlayerPosition { return player.position });
      
      let playerCount = playerPositions.size();
      if (playerCount != 11) {
        return false;
      };

      var teamPlayerCounts = HashMap.HashMap<Text, Nat8>(0, Text.equal, Text.hash);
      var playerIdCounts = HashMap.HashMap<Text, Nat8>(0, Text.equal, Text.hash);
      var goalkeeperCount = 0;
      var defenderCount = 0;
      var midfielderCount = 0;
      var forwardCount = 0;
      var captainInTeam = false;

      for (i in Iter.range(0, playerCount -1)) {
        let count = teamPlayerCounts.get(Nat16.toText(players[i].clubId));
        switch (count) {
          case (null) {
            teamPlayerCounts.put(Nat16.toText(players[i].clubId), 1);
          };
          case (?count) {
            teamPlayerCounts.put(Nat16.toText(players[i].clubId), count + 1);
          };
        };

        let playerIdCount = playerIdCounts.get(Nat16.toText(players[i].id));
        switch (playerIdCount) {
          case (null) { playerIdCounts.put(Nat16.toText(players[i].id), 1) };
          case (?count) {
            return true;
          };
        };

        if (players[i].position == #Goalkeeper) {
          goalkeeperCount += 1;
        };

        if (players[i].position == #Defender) {
          defenderCount += 1;
        };

        if (players[i].position == #Midfielder) {
          midfielderCount += 1;
        };

        if (players[i].position == #Forward) {
          forwardCount += 1;
        };

        if(players[i].id == updatedFantasyTeam.captainId){
          captainInTeam := true;
        }

      };

      for ((key, value) in teamPlayerCounts.entries()) {
        if (value > 2) {
          return true;
        };
      };

      if (
        goalkeeperCount != 1 or defenderCount < 3 or defenderCount > 5 or midfielderCount < 3 or midfielderCount > 5 or forwardCount < 1 or forwardCount > 3,
      ) {
        return true;
      };

      if(not captainInTeam){
        return true;
      };

      return false;
    };

    private func invalidProfilePicture(profilePicture: Blob) : Bool{
      let sizeInKB = Array.size(Blob.toArray(profilePicture)) / 1024;
      return (sizeInKB <= 0 or sizeInKB > 500);
    };

    private func buildNewManager(principalId: Text, createProfileDTO: DTOs.ProfileDTO, profilePictureCanisterId: Text) : T.Manager {
        let newManager: T.Manager = {
          principalId = principalId;
          username = createProfileDTO.username;
          favouriteClubId = createProfileDTO.favouriteClubId;
          createDate = createProfileDTO.createDate;
          termsAccepted = false;
          profilePictureCanisterId = profilePictureCanisterId;
          transfersAvailable = 3;
          monthlyBonusesAvailable = 2;
          bankQuarterMillions = 1200;
          playerIds = [];
          captainId = 0;
          goalGetterGameweek = 0;
          goalGetterPlayerId = 0;
          passMasterGameweek = 0;
          passMasterPlayerId = 0;
          noEntryGameweek = 0;
          noEntryPlayerId = 0;
          teamBoostGameweek = 0;
          teamBoostClubId = 0;
          safeHandsGameweek = 0;
          safeHandsPlayerId = 0;
          captainFantasticGameweek = 0;
          captainFantasticPlayerId = 0;
          countrymenGameweek = 0;
          countrymenCountryId = 0;
          prospectsGameweek = 0;
          braceBonusGameweek = 0;
          hatTrickHeroGameweek = 0;
          transferWindowGameweek = 0;
          history = List.nil<T.FantasyTeamSeason>();
        };

        return newManager;
    };

    public func calculateFantasyTeamScores(allPlayersList: [(T.PlayerId, DTOs.PlayerScoreDTO)], seasonId: T.SeasonId, gameweek: T.GameweekNumber) : async (){
      var allPlayers = HashMap.HashMap<T.PlayerId, DTOs.PlayerScoreDTO>(500, Utilities.eqNat16, Utilities.hashNat16);
      for ((key, value) in Iter.fromArray(allPlayersList)) {
        allPlayers.put(key, value);
      };

      for ((key, value) in managers.entries()) {

        let currentSeason = List.find<T.FantasyTeamSeason>(
          value.history,
          func(teamSeason : T.FantasyTeamSeason) : Bool {
            return teamSeason.seasonId == seasonId;
          },
        );

        switch (currentSeason) {
          case (null) {};
          case (?foundSeason) {
            let currentSnapshot = List.find<T.FantasyTeamSnapshot>(
              foundSeason.gameweeks,
              func(snapshot : T.FantasyTeamSnapshot) : Bool {
                return snapshot.gameweek == gameweek;
              },
            );
            switch (currentSnapshot) {
              case (null) {};
              case (?foundSnapshot) {

                var totalTeamPoints : Int16 = 0;
                for (i in Iter.range(0, Array.size(foundSnapshot.playerIds) -1)) {
                  let playerId = foundSnapshot.playerIds[i];
                  let playerData = allPlayers.get(playerId);
                  switch (playerData) {
                    case (null) {};
                    case (?player) {

                      var totalScore : Int16 = player.points;

                      // Goal Getter
                      if (foundSnapshot.goalGetterGameweek == gameweek and foundSnapshot.goalGetterPlayerId == playerId) {
                        totalScore += calculateGoalPoints(player.position, player.goalsScored);
                      };

                      // Pass Master
                      if (foundSnapshot.passMasterGameweek == gameweek and foundSnapshot.passMasterPlayerId == playerId) {
                        totalScore += calculateAssistPoints(player.position, player.assists);
                      };

                      // No Entry
                      if (foundSnapshot.noEntryGameweek == gameweek and (player.position == #Goalkeeper or player.position == #Defender) and player.goalsConceded == 0) {
                        totalScore := totalScore * 3;
                      };

                      // Team Boost
                      if (foundSnapshot.teamBoostGameweek == gameweek and player.clubId == foundSnapshot.teamBoostClubId) {
                        totalScore := totalScore * 2;
                      };

                      // Safe Hands
                      if (foundSnapshot.safeHandsGameweek == gameweek and player.position == #Goalkeeper and player.saves > 4) {
                        totalScore := totalScore * 3;
                      };

                      // Captain Fantastic
                      if (foundSnapshot.captainFantasticGameweek == gameweek and foundSnapshot.captainId == playerId and player.goalsScored > 0) {
                        totalScore := totalScore * 2;
                      };

                      // Countrymen
                      if (foundSnapshot.countrymenGameweek == gameweek and foundSnapshot.countrymenCountryId == player.nationality) {
                        totalScore := totalScore * 2;
                      };

                      // Prospects
                      if (foundSnapshot.prospectsGameweek == gameweek and Utilities.calculateAgeFromUnix(player.dateOfBirth) < 21) {
                        totalScore := totalScore * 2;
                      };

                      // Brace Bonus
                      if (foundSnapshot.braceBonusGameweek == gameweek and player.goalsScored >= 2) {
                        totalScore := totalScore * 2;
                      };

                      // Hat Trick Hero
                      if (foundSnapshot.hatTrickHeroGameweek == gameweek and player.goalsScored >= 3) {
                        totalScore := totalScore * 3;
                      };

                      // Handle captain bonus
                      if (playerId == foundSnapshot.captainId) {
                        totalScore := totalScore * 2;
                      };

                      totalTeamPoints += totalScore;
                    };
                  };
                };
                updateSnapshotPoints(key, seasonId, gameweek, totalTeamPoints);
              };
            }

          };
        };
      };
    };

    private func calculateGoalPoints(position : T.PlayerPosition, goalsScored : Int16) : Int16 {
      switch (position) {
        case (#Goalkeeper) { return 40 * goalsScored };
        case (#Defender) { return 40 * goalsScored };
        case (#Midfielder) { return 30 * goalsScored };
        case (#Forward) { return 20 * goalsScored };
      };
    };

    private func calculateAssistPoints(position : T.PlayerPosition, assists : Int16) : Int16 {
      switch (position) {
        case (#Goalkeeper) { return 30 * assists };
        case (#Defender) { return 30 * assists };
        case (#Midfielder) { return 20 * assists };
        case (#Forward) { return 20 * assists };
      };
    };

    private func updateSnapshotPoints(principalId : Text, seasonId : Nat16, gameweek : Nat8, teamPoints : Int16) : () {
      let manager = managers.get(principalId);

      switch (manager) {
        case (null) {};
        case (?foundManager) {

          let teamHistoryBuffer = Buffer.fromArray<T.FantasyTeamSeason>([]);

          switch (foundManager.history) {
            case (null) {};
            case (existingHistory) {
              for (season in List.toIter<T.FantasyTeamSeason>(existingHistory)) {
                if (season.seasonId == seasonId) {
                  let snapshotBuffer = Buffer.fromArray<T.FantasyTeamSnapshot>([]);

                  for (snapshot in List.toIter<T.FantasyTeamSnapshot>(season.gameweeks)) {
                    if (snapshot.gameweek == gameweek) {

                      let updatedSnapshot : T.FantasyTeamSnapshot = {
                        principalId = snapshot.principalId;
                        gameweek = snapshot.gameweek;
                        transfersAvailable = snapshot.transfersAvailable;
                        bankQuarterMillions = snapshot.bankQuarterMillions;
                        playerIds = snapshot.playerIds;
                        captainId = snapshot.captainId;
                        goalGetterGameweek = snapshot.goalGetterGameweek;
                        goalGetterPlayerId = snapshot.goalGetterPlayerId;
                        passMasterGameweek = snapshot.passMasterGameweek;
                        passMasterPlayerId = snapshot.passMasterPlayerId;
                        noEntryGameweek = snapshot.noEntryGameweek;
                        noEntryPlayerId = snapshot.noEntryPlayerId;
                        teamBoostGameweek = snapshot.teamBoostGameweek;
                        teamBoostClubId = snapshot.teamBoostClubId;
                        safeHandsGameweek = snapshot.safeHandsGameweek;
                        safeHandsPlayerId = snapshot.safeHandsPlayerId;
                        captainFantasticGameweek = snapshot.captainFantasticGameweek;
                        captainFantasticPlayerId = snapshot.captainFantasticPlayerId;
                        countrymenGameweek = snapshot.countrymenGameweek;
                        countrymenCountryId = snapshot.countrymenCountryId;
                        prospectsGameweek = snapshot.prospectsGameweek;
                        braceBonusGameweek = snapshot.braceBonusGameweek;
                        hatTrickHeroGameweek = snapshot.hatTrickHeroGameweek;
                        favouriteClubId = snapshot.favouriteClubId;
                        username = snapshot.username;
                        points = teamPoints;
                        transferWindowGameweek = snapshot.transferWindowGameweek;
                        monthlyBonusesAvailable = snapshot.monthlyBonusesAvailable;
                        teamValueQuarterMillions = snapshot.teamValueQuarterMillions;
                      };

                      snapshotBuffer.add(updatedSnapshot);

                    } else { snapshotBuffer.add(snapshot) };
                  };

                  let gameweekSnapshots = Buffer.toArray<T.FantasyTeamSnapshot>(snapshotBuffer);

                  let totalSeasonPoints = Array.foldLeft<T.FantasyTeamSnapshot, Int16>(gameweekSnapshots, 0, func(sumSoFar, x) = sumSoFar + x.points);

                  let updatedSeason : T.FantasyTeamSeason = {
                    gameweeks = List.fromArray(gameweekSnapshots);
                    seasonId = season.seasonId;
                    totalPoints = totalSeasonPoints;
                  };

                  teamHistoryBuffer.add(updatedSeason);

                } else { teamHistoryBuffer.add(season) };
              };
            };
          };

          let updatedManager : T.Manager = {
            principalId = foundManager.principalId;
            username = foundManager.username;
            termsAccepted = foundManager.termsAccepted;
            profilePictureCanisterId = foundManager.profilePictureCanisterId;
            favouriteClubId = foundManager.favouriteClubId;
            createDate = foundManager.createDate;
            transfersAvailable = foundManager.transfersAvailable;
            monthlyBonusesAvailable = foundManager.monthlyBonusesAvailable;
            bankQuarterMillions = foundManager.bankQuarterMillions;
            playerIds = foundManager.playerIds;
            captainId = foundManager.captainId;
            goalGetterGameweek = foundManager.goalGetterGameweek;
            goalGetterPlayerId = foundManager.goalGetterPlayerId;
            passMasterGameweek = foundManager.passMasterGameweek;
            passMasterPlayerId = foundManager.passMasterPlayerId;
            noEntryGameweek = foundManager.noEntryGameweek;
            noEntryPlayerId = foundManager.noEntryPlayerId;
            teamBoostGameweek = foundManager.teamBoostGameweek;
            teamBoostClubId = foundManager.teamBoostClubId;
            safeHandsGameweek = foundManager.safeHandsGameweek;
            safeHandsPlayerId = foundManager.safeHandsPlayerId;
            captainFantasticGameweek = foundManager.captainFantasticGameweek;
            captainFantasticPlayerId = foundManager.captainFantasticPlayerId;
            countrymenGameweek = foundManager.countrymenGameweek;
            countrymenCountryId = foundManager.countrymenCountryId;
            prospectsGameweek = foundManager.prospectsGameweek;
            braceBonusGameweek = foundManager.braceBonusGameweek;
            hatTrickHeroGameweek = foundManager.hatTrickHeroGameweek;
            transferWindowGameweek = foundManager.transferWindowGameweek;
            history = List.fromArray(Buffer.toArray<T.FantasyTeamSeason>(teamHistoryBuffer));
          };
          managers.put(principalId, updatedManager);
        };
      };
    };

    public func removePlayerFromTeams(playerId: T.PlayerId) : async (){
   
      let managersWithPlayer =
        HashMap.mapFilter<T.PrincipalId, T.Manager, T.Manager>(
          managers,
          Text.equal,
          Text.hash,
          func (k, v) = if (Array.find<T.PlayerId>(v.playerIds, func(id) { id == playerId }) == null) { null } else { ?v }
      );

      for ((principalId, manager) in managersWithPlayer.entries()) {
        let newPlayerIds = Array.map<T.PlayerId, T.PlayerId>(
            manager.playerIds, 
            func (id) : T.PlayerId { if (id == playerId) { 0 } else { id } }
        );

        let updatedManager: T.Manager = {
          principalId = manager.principalId;
          username = manager.username;
          favouriteClubId = manager.favouriteClubId;
          createDate = manager.createDate;
          termsAccepted = manager.termsAccepted;
          profilePictureCanisterId = manager.profilePictureCanisterId;
          transfersAvailable = manager.transfersAvailable;
          monthlyBonusesAvailable = manager.monthlyBonusesAvailable;
          bankQuarterMillions = manager.bankQuarterMillions;
          playerIds = newPlayerIds;
          captainId = manager.captainId;
          goalGetterGameweek = manager.goalGetterGameweek;
          goalGetterPlayerId = manager.goalGetterPlayerId;
          passMasterGameweek = manager.passMasterGameweek;
          passMasterPlayerId = manager.passMasterPlayerId;
          noEntryGameweek = manager.noEntryGameweek;
          noEntryPlayerId = manager.noEntryPlayerId;
          teamBoostGameweek = manager.teamBoostGameweek;
          teamBoostClubId = manager.teamBoostClubId;
          safeHandsGameweek = manager.safeHandsGameweek;
          safeHandsPlayerId = manager.safeHandsPlayerId;
          captainFantasticGameweek = manager.captainFantasticGameweek;
          captainFantasticPlayerId = manager.captainFantasticPlayerId;
          countrymenGameweek = manager.countrymenGameweek;
          countrymenCountryId = manager.countrymenCountryId;
          prospectsGameweek = manager.prospectsGameweek;
          braceBonusGameweek = manager.braceBonusGameweek;
          hatTrickHeroGameweek = manager.hatTrickHeroGameweek;
          transferWindowGameweek = manager.transferWindowGameweek;
          history = manager.history;
        };

        managers.put(principalId, updatedManager);
      };     
    };

    public func snapshotFantasyTeams(seasonId: T.SeasonId, gameweek: T.GameweekNumber, players: [DTOs.PlayerDTO]) : (){
      for ((principalId, manager) in managers.entries()) {

        let allPlayers = Array.filter<DTOs.PlayerDTO>(
          players,
          func(player : DTOs.PlayerDTO) : Bool {
            let playerId = player.id;
            let isPlayerIdInNewTeam = Array.find(
              manager.playerIds,
              func(id : Nat16) : Bool {
                return id == playerId;
              },
            );
            return Option.isSome(isPlayerIdInNewTeam);
          },
        );

        let allPlayerValues = Array.map<DTOs.PlayerDTO, Nat>(allPlayers, func(player : DTOs.PlayerDTO) : Nat { return player.valueQuarterMillions });
        let totalTeamValue = Array.foldLeft<Nat, Nat>(allPlayerValues, 0, func(sumSoFar, x) = sumSoFar + x);
        
        let newSnapshot : T.FantasyTeamSnapshot = {
          principalId = manager.principalId;
          gameweek = gameweek;
          transfersAvailable = manager.transfersAvailable;
          bankQuarterMillions = manager.bankQuarterMillions;
          playerIds = manager.playerIds;
          captainId = manager.captainId;
          goalGetterGameweek = manager.goalGetterGameweek;
          goalGetterPlayerId = manager.goalGetterPlayerId;
          passMasterGameweek = manager.passMasterGameweek;
          passMasterPlayerId = manager.passMasterPlayerId;
          noEntryGameweek = manager.noEntryGameweek;
          noEntryPlayerId = manager.noEntryPlayerId;
          teamBoostGameweek = manager.teamBoostGameweek;
          teamBoostClubId = manager.teamBoostClubId;
          safeHandsGameweek = manager.safeHandsGameweek;
          safeHandsPlayerId = manager.safeHandsPlayerId;
          captainFantasticGameweek = manager.captainFantasticGameweek;
          captainFantasticPlayerId = manager.captainFantasticPlayerId;
          countrymenGameweek = manager.countrymenGameweek;
          countrymenCountryId = manager.countrymenCountryId;
          prospectsGameweek = manager.prospectsGameweek;
          braceBonusGameweek = manager.braceBonusGameweek;
          hatTrickHeroGameweek = manager.hatTrickHeroGameweek;
          username = manager.username;
          favouriteClubId = manager.favouriteClubId;
          points = 0;
          transferWindowGameweek = manager.transferWindowGameweek;
          monthlyBonusesAvailable = manager.monthlyBonusesAvailable;
          teamValueQuarterMillions = totalTeamValue;
        };

        var seasonFound = false;

        var updatedSeasons = List.map<T.FantasyTeamSeason, T.FantasyTeamSeason>(
          manager.history,
          func(season : T.FantasyTeamSeason) : T.FantasyTeamSeason {
            if (season.seasonId == seasonId) {
              seasonFound := true;

              let otherSeasonGameweeks = List.filter<T.FantasyTeamSnapshot>(
                season.gameweeks,
                func(snapshot : T.FantasyTeamSnapshot) : Bool {
                  return snapshot.gameweek != gameweek;
                },
              );

              let updatedGameweeks = List.push(newSnapshot, otherSeasonGameweeks);

              return {
                seasonId = season.seasonId;
                totalPoints = season.totalPoints;
                gameweeks = updatedGameweeks;
              };
            };
            return season;
          },
        );

        if (not seasonFound) {
          let newSeason : T.FantasyTeamSeason = {
            seasonId = seasonId;
            totalPoints = 0;
            gameweeks = List.push(newSnapshot, List.nil());
          };

          updatedSeasons := List.push(newSeason, updatedSeasons);
        };
          
        let updatedManager: T.Manager = {
          principalId = manager.principalId;
          username = manager.username;
          favouriteClubId = manager.favouriteClubId;
          createDate = manager.createDate;
          termsAccepted = manager.termsAccepted;
          profilePictureCanisterId = manager.profilePictureCanisterId;
          transfersAvailable = manager.transfersAvailable;
          monthlyBonusesAvailable = manager.monthlyBonusesAvailable;
          bankQuarterMillions = manager.bankQuarterMillions;
          playerIds = manager.playerIds;
          captainId = manager.captainId;
          goalGetterGameweek = manager.goalGetterGameweek;
          goalGetterPlayerId = manager.goalGetterPlayerId;
          passMasterGameweek = manager.passMasterGameweek;
          passMasterPlayerId = manager.passMasterPlayerId;
          noEntryGameweek = manager.noEntryGameweek;
          noEntryPlayerId = manager.noEntryPlayerId;
          teamBoostGameweek = manager.teamBoostGameweek;
          teamBoostClubId = manager.teamBoostClubId;
          safeHandsGameweek = manager.safeHandsGameweek;
          safeHandsPlayerId = manager.safeHandsPlayerId;
          captainFantasticGameweek = manager.captainFantasticGameweek;
          captainFantasticPlayerId = manager.captainFantasticPlayerId;
          countrymenGameweek = manager.countrymenGameweek;
          countrymenCountryId = manager.countrymenCountryId;
          prospectsGameweek = manager.prospectsGameweek;
          braceBonusGameweek = manager.braceBonusGameweek;
          hatTrickHeroGameweek = manager.hatTrickHeroGameweek;
          transferWindowGameweek = manager.transferWindowGameweek;
          history = updatedSeasons;
        };

        managers.put(principalId, updatedManager);
        

      };
    };

    public func resetTransfers(isNewMonth: Bool) : (){
      
      for ((principalId, manager) in managers.entries()) {
        
        var bonusesAvailable = manager.monthlyBonusesAvailable;

        if(isNewMonth){
          bonusesAvailable := 2;
        };      
        
        let updatedManager: T.Manager = {
          principalId = manager.principalId;
          username = manager.username;
          favouriteClubId = manager.favouriteClubId;
          createDate = manager.createDate;
          termsAccepted = manager.termsAccepted;
          profilePictureCanisterId = manager.profilePictureCanisterId;
          transfersAvailable = 3;
          monthlyBonusesAvailable = bonusesAvailable;
          bankQuarterMillions = manager.bankQuarterMillions;
          playerIds = manager.playerIds;
          captainId = manager.captainId;
          goalGetterGameweek = manager.goalGetterGameweek;
          goalGetterPlayerId = manager.goalGetterPlayerId;
          passMasterGameweek = manager.passMasterGameweek;
          passMasterPlayerId = manager.passMasterPlayerId;
          noEntryGameweek = manager.noEntryGameweek;
          noEntryPlayerId = manager.noEntryPlayerId;
          teamBoostGameweek = manager.teamBoostGameweek;
          teamBoostClubId = manager.teamBoostClubId;
          safeHandsGameweek = manager.safeHandsGameweek;
          safeHandsPlayerId = manager.safeHandsPlayerId;
          captainFantasticGameweek = manager.captainFantasticGameweek;
          captainFantasticPlayerId = manager.captainFantasticPlayerId;
          countrymenGameweek = manager.countrymenGameweek;
          countrymenCountryId = manager.countrymenCountryId;
          prospectsGameweek = manager.prospectsGameweek;
          braceBonusGameweek = manager.braceBonusGameweek;
          hatTrickHeroGameweek = manager.hatTrickHeroGameweek;
          transferWindowGameweek = manager.transferWindowGameweek;
          history = manager.history;
        };

        managers.put(principalId, updatedManager);
      };
    };

    public func resetFantasyTeams() : async () {
      for ((principalId, manager) in managers.entries()) {
        let clearedTeam = clearFantasyTeam(manager);
        managers.put(principalId, clearedTeam);
      };
    };
    
    private func clearFantasyTeam(manager: T.Manager) : T.Manager {
      return {
        principalId = manager.principalId;
        username = manager.username;
        termsAccepted = manager.termsAccepted;
        profilePictureCanisterId = manager.profilePictureCanisterId;
        favouriteClubId = manager.favouriteClubId;
        createDate = manager.createDate;
        transfersAvailable = 3;
        monthlyBonusesAvailable = 2;
        bankQuarterMillions = 1200;
        playerIds = [];
        captainId = 0;
        goalGetterGameweek = 0;
        goalGetterPlayerId = 0;
        passMasterGameweek  = 0;
        passMasterPlayerId = 0;
        noEntryGameweek = 0;
        noEntryPlayerId = 0;
        teamBoostGameweek = 0;
        teamBoostClubId = 0;
        safeHandsGameweek = 0;
        safeHandsPlayerId = 0;
        captainFantasticGameweek = 0;
        captainFantasticPlayerId = 0;
        countrymenGameweek = 0;
        countrymenCountryId = 0;
        prospectsGameweek = 0;
        braceBonusGameweek = 0;
        hatTrickHeroGameweek = 0;
        transferWindowGameweek = 0;
        history = manager.history;
      };
    };

    public func payWeeklyRewards(rewardPool: T.RewardPool, weeklyLeaderboard: DTOs.WeeklyLeaderboardDTO, fixtures: List.List<DTOs.FixtureDTO>) : async (){
      await distributeWeeklyRewards(rewardPool.weeklyLeaderboardPool, weeklyLeaderboard);     
      await distributeHighestScoringPlayerRewards(rewardPool.highestScoringMatchPlayerPool, fixtures);
      await distributeWeeklyATHScoreRewards(rewardPool.allTimeWeeklyHighScorePool, weeklyLeaderboard);
    };

    public func payMonthlyRewards(rewardPool: T.RewardPool, monthlyLeaderboard: DTOs.MonthlyLeaderboardDTO) : async (){
      await distributeMonthlyRewards(rewardPool, monthlyLeaderboard);
    };

    public func payATHMonthlyRewards(rewardPool: T.RewardPool, monthlyLeaderboards: [DTOs.MonthlyLeaderboardDTO]) : async (){
      await distributeMonthlyATHScoreRewards(rewardPool.allTimeMonthlyHighScorePool, monthlyLeaderboards);
    };
    
    public func paySeasonRewards(rewardPool: T.RewardPool, seasonLeaderboard: DTOs.SeasonLeaderboardDTO, players: [DTOs.PlayerDTO]) : async (){
      await distributeSeasonRewards(rewardPool.seasonLeaderboardPool, seasonLeaderboard);
      await distributeSeasonATHScoreRewards(rewardPool.allTimeSeasonHighScorePool, seasonLeaderboard);
      await distributeMostValuableTeamRewards(rewardPool.mostValuableTeamPool, players);
    };

    public func distributeWeeklyRewards(weeklyRewardPool: Nat64, weeklyLeaderboard: DTOs.WeeklyLeaderboardDTO) : async (){
      let weeklyRewardAmount = weeklyRewardPool / 38;
      var payouts = List.nil<Float>();
      var currentEntries = List.fromArray(weeklyLeaderboard.entries);

      let scaledPercentages = if (weeklyLeaderboard.totalEntries < 100) {
          scalePercentages(RewardPercentages.percentages, weeklyLeaderboard.totalEntries)
      } else {
          RewardPercentages.percentages
      };

      while (not List.isNil(currentEntries)) {
          let (currentEntry, rest) = List.pop(currentEntries);
          currentEntries := rest;
          switch(currentEntry){
            case (null){};
            case (?foundEntry){
                let (nextEntry, _) = List.pop(rest);
                switch(nextEntry){
                  case (null){
                    let payout = scaledPercentages[foundEntry.position - 1];
                    payouts := List.push(payout, payouts);
                  };
                  case (?foundNextEntry){
                    if (foundEntry.points == foundNextEntry.points) {
                        let tiedEntries = findTiedEntries(rest, foundEntry.points);
                        let startPosition = foundEntry.position;
                        let tiePayouts = calculateTiePayouts(tiedEntries, scaledPercentages, startPosition);
                        payouts := List.append(payouts, tiePayouts);

                        var skipEntries = rest;
                        label skipLoop while (not List.isNil(skipEntries)) {
                            let (skipEntry, nextRest) = List.pop(skipEntries);
                            skipEntries := nextRest;

                            switch(skipEntry) {
                                case (null) { break skipLoop; };
                                case (?entry) {
                                    if (entry.points != foundEntry.points) {
                                        currentEntries := skipEntries;
                                        break skipLoop;
                                    }
                                };
                            };
                        };
                    } else {
                        let payout = scaledPercentages[foundEntry.position - 1];
                        payouts := List.push(payout, payouts);
                    }
                  }
                };
                
            };
          };
      };

      payouts := List.reverse(payouts);
      let payoutsArray = List.toArray(payouts);

      for (key in weeklyLeaderboard.entries.keys()) {
        let winner = weeklyLeaderboard.entries[key];      
        let prize = Int64.toNat64(Float.toInt64(payoutsArray[key])) * weeklyRewardAmount;    
        await payReward(winner.principalId, prize);
      };
    };

    private func findTiedEntries(entries: List.List<T.LeaderboardEntry>, points: Int16): List.List<T.LeaderboardEntry> {
      var tiedEntries = List.nil<T.LeaderboardEntry>();
      var currentEntries = entries;

      label currentLoop while (not List.isNil(currentEntries)) {
          let (currentEntry, rest) = List.pop(currentEntries);
          currentEntries := rest;

          switch(currentEntry) {
              case (null) {};
              case (?entry) {
                  if (entry.points == points) {
                      tiedEntries := List.push(entry, tiedEntries);
                  } else {
                      break currentLoop;
                  }
              };
          };
      };

      return List.reverse(tiedEntries);
    };

    private func calculateTiePayouts(tiedEntries: List.List<T.LeaderboardEntry>, scaledPercentages: [Float], startPosition: Nat) : List.List<Float> {
        let numTiedEntries = List.size(tiedEntries);
        var totalPayout: Float = 0.0;
        let endPosition: Int = startPosition + numTiedEntries - 1;

          label posLoop for (i in Iter.range(startPosition, endPosition)) {
            if (i > 100) {
                break posLoop;
            };
            totalPayout += scaledPercentages[i - 1];
        };

        let equalPayout = totalPayout / Float.fromInt(numTiedEntries);
        let payouts = List.replicate<Float>(numTiedEntries, equalPayout);

        return payouts;
    };

    private func scalePercentages(fixedPercentages: [Float], numParticipants: Nat) : [Float] {
      var totalPercentage: Float = 0.0;
      for (i in Iter.range(0, numParticipants)) {
        totalPercentage += fixedPercentages[i];
      };

      let scalingFactor: Float = 100.0 / totalPercentage;

      var scaledPercentagesBuffer = Buffer.fromArray<Float>([]);
      for (i in Iter.range(0, numParticipants)) {
          let scaledValue = fixedPercentages[i] * scalingFactor;
          scaledPercentagesBuffer.add(scaledValue);
      };

      return Buffer.toArray(scaledPercentagesBuffer);
    };

    public func distributeMonthlyRewards(rewardPool: T.RewardPool, monthlyLeaderboard: DTOs.MonthlyLeaderboardDTO) : async (){
      let monthlyRewardAmount = rewardPool.monthlyLeaderboardPool / 9;

      let clubManagers = HashMap.mapFilter<Text, T.Manager, T.Manager>(managers, Text.equal, Text.hash, 
        func (principal: Text, manager : T.Manager) = if (manager.favouriteClubId == monthlyLeaderboard.clubId) {?manager} else {null});
      let otherClubManagers = HashMap.mapFilter<Text, T.Manager, T.Manager>(managers, Text.equal, Text.hash, 
        func (principal: Text, manager : T.Manager) = if (manager.favouriteClubId > 0 and manager.favouriteClubId != monthlyLeaderboard.clubId) {?manager} else {null});
      
      let clubManagerCount = Iter.size(clubManagers.entries());
      let totalClubManagers = clubManagerCount + Iter.size(otherClubManagers.entries());

      let clubShare = clubManagerCount / totalClubManagers; 

      let clubManagerMonthlyRewardAmount = Nat64.toNat(monthlyRewardAmount) * clubShare;

      var payouts = List.nil<Float>();
      var currentEntries = List.fromArray(monthlyLeaderboard.entries);

      let scaledPercentages = if (monthlyLeaderboard.totalEntries < 100) {
          scalePercentages(RewardPercentages.percentages, monthlyLeaderboard.totalEntries)
      } else {
          RewardPercentages.percentages
      };

      while (not List.isNil(currentEntries)) {
          let (currentEntry, rest) = List.pop(currentEntries);
          currentEntries := rest;
          switch(currentEntry){
            case (null){};
            case (?foundEntry){
                let (nextEntry, _) = List.pop(rest);
                switch(nextEntry){
                  case (null){
                    let payout = scaledPercentages[foundEntry.position - 1];
                    payouts := List.push(payout, payouts);
                  };
                  case (?foundNextEntry){
                    if (foundEntry.points == foundNextEntry.points) {
                        let tiedEntries = findTiedEntries(rest, foundEntry.points);
                        let startPosition = foundEntry.position;
                        let tiePayouts = calculateTiePayouts(tiedEntries, scaledPercentages, startPosition);
                        payouts := List.append(payouts, tiePayouts);

                        var skipEntries = rest;
                        label skipLoop while (not List.isNil(skipEntries)) {
                            let (skipEntry, nextRest) = List.pop(skipEntries);
                            skipEntries := nextRest;

                            switch(skipEntry) {
                                case (null) { break skipLoop; };
                                case (?entry) {
                                    if (entry.points != foundEntry.points) {
                                        currentEntries := skipEntries;
                                        break skipLoop;
                                    }
                                };
                            };
                        };
                    } else {
                        let payout = scaledPercentages[foundEntry.position - 1];
                        payouts := List.push(payout, payouts);
                    }
                  }
                };
                
            };
          };
      };

      payouts := List.reverse(payouts);
      let payoutsArray = List.toArray(payouts);

      for (key in monthlyLeaderboard.entries.keys()) {
        let winner = monthlyLeaderboard.entries[key];      
        let prize = Int64.toNat64(Float.toInt64(payoutsArray[key])) * Nat64.fromNat(clubManagerMonthlyRewardAmount);    
        await payReward(winner.principalId, prize);
      };
    };

    public func distributeSeasonRewards(seasonRewardPool: Nat64, seasonLeaderboard: DTOs.SeasonLeaderboardDTO) : async (){
      var payouts = List.nil<Float>();
      var currentEntries = List.fromArray(seasonLeaderboard.entries);

      let scaledPercentages = if (seasonLeaderboard.totalEntries < 100) {
          scalePercentages(RewardPercentages.percentages, seasonLeaderboard.totalEntries)
      } else {
          RewardPercentages.percentages
      };

      while (not List.isNil(currentEntries)) {
          let (currentEntry, rest) = List.pop(currentEntries);
          currentEntries := rest;
          switch(currentEntry){
            case (null){};
            case (?foundEntry){
                let (nextEntry, _) = List.pop(rest);
                switch(nextEntry){
                  case (null){
                    let payout = scaledPercentages[foundEntry.position - 1];
                    payouts := List.push(payout, payouts);
                  };
                  case (?foundNextEntry){
                    if (foundEntry.points == foundNextEntry.points) {
                        let tiedEntries = findTiedEntries(rest, foundEntry.points);
                        let startPosition = foundEntry.position;
                        let tiePayouts = calculateTiePayouts(tiedEntries, scaledPercentages, startPosition);
                        payouts := List.append(payouts, tiePayouts);

                        var skipEntries = rest;
                        label skipLoop while (not List.isNil(skipEntries)) {
                            let (skipEntry, nextRest) = List.pop(skipEntries);
                            skipEntries := nextRest;

                            switch(skipEntry) {
                                case (null) { break skipLoop; };
                                case (?entry) {
                                    if (entry.points != foundEntry.points) {
                                        currentEntries := skipEntries;
                                        break skipLoop;
                                    }
                                };
                            };
                        };
                    } else {
                        let payout = scaledPercentages[foundEntry.position - 1];
                        payouts := List.push(payout, payouts);
                    }
                  }
                };
                
            };
          };
      };

      payouts := List.reverse(payouts);
      let payoutsArray = List.toArray(payouts);

      for (key in seasonLeaderboard.entries.keys()) {
        let winner = seasonLeaderboard.entries[key];      
        let prize = Int64.toNat64(Float.toInt64(payoutsArray[key])) * seasonRewardPool;    
        await payReward(winner.principalId, prize);
      };
    };

    public func distributeMostValuableTeamRewards(mostValuableTeamPool: Nat64, players: [DTOs.PlayerDTO], currentSeason: T.SeasonId) : async (){
      let allFinalGameweekSnapshots = HashMap.mapFilter<T.PrincipalId, T.Manager, T.FantasyTeamSnapshot>(
        managers,
        Text.equal,
        Text.hash,
        func (k, v) : ?T.FantasyTeamSnapshot {
          let gameweek38Snapshot = List.foldLeft<T.FantasyTeamSeason, ?T.FantasyTeamSnapshot>(
            v.history,
            null,
            func (acc: ?T.FantasyTeamSnapshot, season: T.FantasyTeamSeason) : ?T.FantasyTeamSnapshot {
              switch (acc) {
                case (?_) { acc };
                case null {
                  List.find<T.FantasyTeamSnapshot>(
                      season.gameweeks,
                      func (snapshot) : Bool {
                          snapshot.gameweek == 38
                      }
                  )
                };
              }
            }
          );
          return gameweek38Snapshot;
        }
      );

      var teamValues: HashMap.HashMap<T.PrincipalId, Nat> = HashMap.HashMap<T.PrincipalId, Nat>(100, Text.equal, Text.hash);
  
      for(snapshot in allFinalGameweekSnapshots.entries()){
        let allPlayers = Array.filter<DTOs.PlayerDTO>(
          players,
          func(player : DTOs.PlayerDTO) : Bool {
            let playerId = player.id;
            let isPlayerIdInNewTeam = Array.find(
              snapshot.1.playerIds,
              func(id : Nat16) : Bool {
                return id == playerId;
              },
            );
            return Option.isSome(isPlayerIdInNewTeam);
          },
        );
        
        let allPlayerValues = Array.map<DTOs.PlayerDTO, Nat>(allPlayers, func(player : DTOs.PlayerDTO) : Nat { return player.valueQuarterMillions });
        let totalTeamValue = Array.foldLeft<Nat, Nat>(allPlayerValues, 0, func(sumSoFar, x) = sumSoFar + x);
        teamValues.put(snapshot.0, totalTeamValue);        
      };
      
      let teamValuesArray : [(T.PrincipalId, Nat)] = Iter.toArray(teamValues.entries());

      let compare = func(a: (T.PrincipalId, Nat), b: (T.PrincipalId, Nat)): Order.Order {
        if (a.1 > b.1) { return #greater };
        if (a.1 < b.1) { return #less };
        return #equal;
      };

      let sortedTeamValuesArray = Array.sort(teamValuesArray, compare);

      var leaderboardEntries = Array.mapEntries<(T.PrincipalId, Nat), T.LeaderboardEntry>(
        sortedTeamValuesArray,
        func (team, index) : T.LeaderboardEntry {
          return { principalId = team.0; position = index + 1; points = Int16.fromNat16(Nat16.fromNat(team.1)); username = ""; positionText = ""; };
        }
      );

      var totalRewardEntries = 100;
      if(Array.size(leaderboardEntries) < 100){
         totalRewardEntries := Array.size(leaderboardEntries);
      };
      var rewardEntries = List.take(List.fromArray(leaderboardEntries), totalRewardEntries);

      var rewardEntriesBuffer = Buffer.fromArray<T.LeaderboardEntry>(List.toArray(rewardEntries));

      if (totalRewardEntries == 100) {
        let lastEntry = List.toArray(rewardEntries)[99];
        let tiedEntries = Array.filter<T.LeaderboardEntry>(
          leaderboardEntries,
          func (entry) : Bool { entry.points == lastEntry.points and entry.position > 100 }
        );
        rewardEntriesBuffer.append(Buffer.fromArray(tiedEntries));
      };
      rewardEntries := List.fromArray(Buffer.toArray(rewardEntriesBuffer));

      var scaledPercentages = RewardPercentages.percentages;

      if(List.size(rewardEntries) < 100){
        scaledPercentages := scalePercentages(RewardPercentages.percentages, List.size(rewardEntries));
      };
      
      let rewardEntriesArray = List.toArray(rewardEntries);

      let teamValueLeaderboard = {
        seasonId = currentSeason;
        entries = rewardEntries;
        totalEntries = List.size(rewardEntries);
      };

      //TODO: Save the team value leaderboard

      for (index in Iter.range(0, Array.size(rewardEntriesArray) - 1)) {
        let entry = rewardEntriesArray[index];
        let payoutPercentage = scaledPercentages[entry.position - 1];
        
        let prize = Float.fromInt64(Int64.fromNat64(mostValuableTeamPool)) * payoutPercentage;
        await payReward(entry.principalId, Int64.toNat64(Float.toInt64(prize)));
      };
    };

    public func distributeHighestScoringPlayerRewards(highestScoringPlayerRewardPool: Nat64, fixtures: List.List<DTOs.FixtureDTO>) : async (){
      
      let highestScoringPlayerIdBuffer = Buffer.fromArray<T.PlayerId>([]);

      for(fixture in Iter.fromList(fixtures)){
        if(fixture.highestScoringPlayerId > 0){
          highestScoringPlayerIdBuffer.add(fixture.highestScoringPlayerId);
        };
      };

      let highestScoringPlayerIds = Buffer.toArray(highestScoringPlayerIdBuffer);

      let gameweekRewardAmount = highestScoringPlayerRewardPool / 38;

      let playerRewardShare = Nat64.toNat(gameweekRewardAmount) / Array.size(highestScoringPlayerIds);

      for(highestScoringPlayerId in Iter.fromArray(highestScoringPlayerIds)){

          let managersWithPlayer = HashMap.mapFilter<T.PrincipalId, T.Manager, T.Manager>(
            managers,
            Text.equal,
            Text.hash,
            func (k, v) = if (Array.find<T.PlayerId>(v.playerIds, func(id) { id == highestScoringPlayerId }) == null) { null } else { ?v }
          );

          let prize = Nat64.fromNat(Nat64.toNat(gameweekRewardAmount) / managersWithPlayer.size());

          for ((principalId, manager) in managersWithPlayer.entries()) { 
            await payReward(principalId, prize);
          };
      };
    };

    public func distributeWeeklyATHScoreRewards(weeklyRewardPool: Nat64, weeklyLeaderboard: DTOs.WeeklyLeaderboardDTO) : async (){
      //TODO
      //check for ties
      //check to see if the first entry has broken the all time high score for a gameweek
        //if they have pay the gameweek all time high score pot

    };

    public func distributeMonthlyATHScoreRewards(monthlyRewardPool: Nat64, monthlyLeaderboards: [DTOs.MonthlyLeaderboardDTO]) : async (){
      //TODO:
      //get the highest monthly score from all the monthly leaderboards
      //ensure ties are split

      //check it aagainst the current highest monthly score

      //if highest beaten pay the cumulative total 

      //if not add to the cumulative total for breaking the ATH monthly score

      //mint the tokens but send to the treasury
    };

    public func distributeSeasonATHScoreRewards(seasonRewardPool: Nat64, seasonLeaderboard: DTOs.SeasonLeaderboardDTO) : async (){
      //TODO
      //check to see if the first entry has broken the all time high score for a season
        //if they have pay the season all time high score pot
      //check for ties

    };

    private func payReward(principalId: T.PrincipalId, fpl: Nat64) : async (){
      return await tokenCanister.transferToken(principalId, Nat64.toNat(fpl));
    };

    public func getStableManagers(): [(T.PrincipalId, T.Manager)] {
      return Iter.toArray(managers.entries());
    };

    public func setStableManagers(stable_managers: [(T.PrincipalId, T.Manager)]) {
       managers := HashMap.fromIter<T.PrincipalId, T.Manager>(
        stable_managers.vals(),
        stable_managers.size(),
        Text.equal,
        Text.hash
      );
    };

    public func getStableProfilePictureCanisterIds(): [(T.PrincipalId, Text)] {
      return Iter.toArray(profilePictureCanisterIds.entries());
    };

    public func setStableProfilePictureCanisterIds(stable_profile_picture_canister_ids: [(T.PrincipalId, Text)])  {
      profilePictureCanisterIds := HashMap.fromIter<T.PrincipalId, Text>(
        stable_profile_picture_canister_ids.vals(),
        stable_profile_picture_canister_ids.size(),
        Text.equal,
        Text.hash
      );
    };
  };
};

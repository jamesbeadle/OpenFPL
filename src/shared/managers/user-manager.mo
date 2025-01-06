import Result "mo:base/Result";
import TrieMap "mo:base/TrieMap";
import List "mo:base/List";
import Text "mo:base/Text";
import Iter "mo:base/Iter";
import Principal "mo:base/Principal";
import Buffer "mo:base/Buffer";
import DTOs "../../shared/dtos/DTOs";
import Base "../../shared/types/base_types";
import FootballTypes "../../shared/types/football_types";
import T "../../shared/types/app_types";
import RequestDTOs "../../shared/dtos/request_DTOs";
import Utilities "../../shared/utils/utilities";
import Management "../../shared/utils/Management";
import ManagerCanister "../canister_definitions/manager-canister";
import Cycles "mo:base/ExperimentalCycles";
import Time "mo:base/Time";
import Int64 "mo:base/Int64";
import Nat64 "mo:base/Nat64";
import Nat8 "mo:base/Nat8";
import Array "mo:base/Array";
import Option "mo:base/Option";
import Blob "mo:base/Blob";
import Nat16 "mo:base/Nat16";
import Bool "mo:base/Bool";
import Debug "mo:base/Debug";
import NetworkEnvironmentVariables "../network_environment_variables";

module {

  public class UserManager(controllerPrincipalId: Base.PrincipalId, fixturesPerClub: Nat8) {
    
    private var managerCanisterIds :  TrieMap.TrieMap<Base.PrincipalId, Base.CanisterId> = TrieMap.TrieMap<Base.PrincipalId, Base.CanisterId>(Text.equal, Text.hash);
    private var usernames: TrieMap.TrieMap<Base.PrincipalId, Text> = TrieMap.TrieMap<Base.PrincipalId, Text>(Text.equal, Text.hash);

    private var uniqueManagerCanisterIds: List.List<Base.CanisterId> = List.nil();
    private var totalManagers : Nat = 0;
    private var activeManagerCanisterId : Base.CanisterId = "";    
    
    public func getProfile(request: RequestDTOs.RequestProfileDTO) : async Result.Result<DTOs.ProfileDTO, T.Error> {
      
      let userManagerCanisterId = managerCanisterIds.get(request.principalId);
      
      switch(userManagerCanisterId){
        case (?foundUserCanisterId){

          let manager_canister = actor (foundUserCanisterId) : actor {
              getManager : Base.PrincipalId -> async ?T.Manager;
          };
          let manager = await manager_canister.getManager(request.principalId);
          
          switch (manager) {
              case (null) {
                  return #err(#NotFound);
              };
              case (?foundManager) {

                let profileDTO : DTOs.ProfileDTO = {
                    principalId = request.principalId;
                    username = foundManager.username;
                    termsAccepted = foundManager.termsAccepted;
                    profilePicture = foundManager.profilePicture;
                    profilePictureType = foundManager.profilePictureType;
                    favouriteClubId = foundManager.favouriteClubId;
                    createDate = foundManager.createDate;
                };
                return #ok(profileDTO);
              };
          };
        };
        case (null){
            return #err(#NotFound);
        }
      };
    };

    public func getManager(dto: RequestDTOs.RequestManagerDTO, weeklyLeaderboardEntry : ?DTOs.LeaderboardEntryDTO, monthlyLeaderboardEntry : ?DTOs.LeaderboardEntryDTO, seasonLeaderboardEntry : ?DTOs.LeaderboardEntryDTO) : async Result.Result<DTOs.ManagerDTO, T.Error> {
      
      let managerCanisterId = managerCanisterIds.get(dto.managerId);
      
      switch (managerCanisterId) {
        case (null) {
          return #err(#NotFound);
        };
        case (?foundCanisterId) {
          let manager_canister = actor (foundCanisterId) : actor {
            getManager : Base.PrincipalId -> async ?T.Manager;
          };
      
         let manager = await manager_canister.getManager(dto.managerId);
          switch (manager) {
            case (null) {
              return #err(#NotFound);
            };
            case (?foundManager) {
              for (managerSeason in Iter.fromList(foundManager.history)) {
                if (managerSeason.seasonId == dto.seasonId) {

                  var weeklyPosition : Int = 0;
                  var weeklyPoints : Int16 = 0;
                  var monthlyPosition : Int = 0;
                  var monthlyPoints : Int16 = 0;
                  var seasonPosition : Int = 0;
                  var seasonPoints : Int16 = 0;
                  var weeklyPositionText = "N/A";
                  var monthlyPositionText = "N/A";
                  var seasonPositionText = "N/A";

                  switch (weeklyLeaderboardEntry) {
                    case (null) {};
                    case (?foundEntry) {
                      weeklyPosition := foundEntry.position;
                      weeklyPoints := foundEntry.points;
                      weeklyPositionText := foundEntry.positionText;
                    };
                  };

                  switch (monthlyLeaderboardEntry) {
                    case (null) {};
                    case (?foundEntry) {
                      monthlyPosition := foundEntry.position;
                      monthlyPoints := foundEntry.points;
                      monthlyPositionText := foundEntry.positionText;
                    };
                  };

                  switch (seasonLeaderboardEntry) {
                    case (null) {};
                    case (?foundEntry) {
                      seasonPosition := foundEntry.position;
                      seasonPoints := foundEntry.points;
                      seasonPositionText := foundEntry.positionText;
                    };
                  };

                  let managerDTO : DTOs.ManagerDTO = {
                    principalId = foundManager.principalId;
                    username = foundManager.username;
                    profilePicture = foundManager.profilePicture;
                    favouriteClubId = foundManager.favouriteClubId;
                    createDate = foundManager.createDate;
                    gameweeks = List.toArray(managerSeason.gameweeks);
                    weeklyPosition = weeklyPosition;
                    monthlyPosition = monthlyPosition;
                    seasonPosition = seasonPosition;
                    weeklyPositionText = weeklyPositionText;
                    monthlyPositionText = monthlyPositionText;
                    seasonPositionText = seasonPositionText;
                    weeklyPoints =  weeklyPoints;
                    monthlyPoints = monthlyPoints;
                    seasonPoints = seasonPoints;
                    profilePictureType = foundManager.profilePictureType;
                  };
                  return #ok(managerDTO);

                };
              };
              return #err(#NotFound);
            };
          };
        };
      };
    };

    public func getManagerByUsername(username : Text) : async Result.Result<DTOs.ManagerDTO, T.Error> {

      for (managerUsername in usernames.entries()){
        if(managerUsername.1 == username){
          let managerPrincipalId = managerUsername.0;
          let managerCanisterId = managerCanisterIds.get(managerPrincipalId);
          switch(managerCanisterId){
            case null { return #err(#NotFound) };
            case (?foundCanisterId) {
              let manager_canister = actor (foundCanisterId) : actor {
                getManager : Base.PrincipalId -> async ?T.Manager;
              };

              let manager = await manager_canister.getManager(managerPrincipalId);
              switch (manager) {
                case (null) {
                  return #err(#NotFound);
                };
                case (?foundManager) {
                  
                  var weeklyPosition : Int = 0;
                  var weeklyPoints : Int16 = 0;
                  var monthlyPosition : Int = 0;
                  var monthlyPoints : Int16 = 0;
                  var seasonPosition : Int = 0;
                  var seasonPoints : Int16 = 0;
                  var weeklyPositionText = "N/A";
                  var monthlyPositionText = "N/A";
                  var seasonPositionText = "N/A";
                  
                  let managerDTO : DTOs.ManagerDTO = {
                    principalId = managerPrincipalId;
                    username = foundManager.username;
                    profilePicture = foundManager.profilePicture;
                    favouriteClubId = foundManager.favouriteClubId;
                    createDate = foundManager.createDate;
                    gameweeks = [];
                    weeklyPosition = weeklyPosition;
                    monthlyPosition = monthlyPosition;
                    seasonPosition = seasonPosition;
                    weeklyPositionText = weeklyPositionText;
                    monthlyPositionText = monthlyPositionText;
                    seasonPositionText = seasonPositionText;
                    weeklyPoints = weeklyPoints;
                    monthlyPoints = monthlyPoints;
                    seasonPoints = seasonPoints;
                    profilePictureType = foundManager.profilePictureType;
                  };
                  return #ok(managerDTO);
                };
              };
            }
          };
        };
      };
      return #err(#NotFound);
    };
    
    public func getUniqueManagerCanisterIds() : [Base.CanisterId] {
      return List.toArray(uniqueManagerCanisterIds);
    };

    public func getCurrentTeam(principalId : Text, currentSeasonId: FootballTypes.SeasonId) : async Result.Result<DTOs.PickTeamDTO, T.Error> {

      let managerCanisterId = managerCanisterIds.get(principalId);
      switch (managerCanisterId) {
        case (null) {
          return #err(#NotFound);
        };
        case (?foundCanisterId) {

          let manager_canister = actor (foundCanisterId) : actor {
            getManager : Base.PrincipalId -> async ?T.Manager;
          };
          let manager = await manager_canister.getManager(principalId);
          switch (manager) {
            case (null) {
              return #err(#NotFound);
            };
            case (?foundManager) {

              var firstGameweek = true;
              let currentManagerSeason = List.find<T.FantasyTeamSeason>(foundManager.history, func(season: T.FantasyTeamSeason) : Bool {
                season.seasonId == currentSeasonId;
              });

              let hasPlayersInTeam = Array.size(foundManager.playerIds) > 0;
          
              switch(currentManagerSeason){
                case (?foundSeason){
                  firstGameweek := List.size(foundSeason.gameweeks) == 0 or not hasPlayersInTeam;
                };
                case (null){ }
              };

              let pickTeamDTO : DTOs.PickTeamDTO = {
                principalId = foundManager.principalId;
                username = foundManager.username;
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
                oneNationGameweek = foundManager.oneNationGameweek;
                oneNationCountryId = foundManager.oneNationCountryId;
                prospectsGameweek = foundManager.prospectsGameweek;
                braceBonusGameweek = foundManager.braceBonusGameweek;
                hatTrickHeroGameweek = foundManager.hatTrickHeroGameweek;
                transferWindowGameweek = foundManager.transferWindowGameweek;
                canisterId = foundCanisterId;
                firstGameweek = firstGameweek;
              };

              return #ok(pickTeamDTO);
            };
          };
        };
      };
    };

    public func snapshotFantasyTeams(leagueId: FootballTypes.LeagueId, seasonId : FootballTypes.SeasonId, gameweek : FootballTypes.GameweekNumber, month : Base.CalendarMonth) : async () {
      
      for (canisterId in Iter.fromList(uniqueManagerCanisterIds)) {

        let manager_canister = actor (canisterId) : actor {
          snapshotFantasyTeams : (leagueId: FootballTypes.LeagueId, seasonId : FootballTypes.SeasonId, gameweek : FootballTypes.GameweekNumber, month : Base.CalendarMonth) -> async ();
        };

        await manager_canister.snapshotFantasyTeams(leagueId, seasonId, gameweek, month);
      };
    };

    public func calculateFantasyTeamScores(leagueId: FootballTypes.LeagueId, seasonId : FootballTypes.SeasonId, gameweek : FootballTypes.GameweekNumber, month : Base.CalendarMonth) : async () {
      for (canisterId in Iter.fromList(uniqueManagerCanisterIds)) {

        let manager_canister = actor (canisterId) : actor {
          calculateFantasyTeamScores : (leagueId: FootballTypes.LeagueId, seasonId : FootballTypes.SeasonId, gameweek : FootballTypes.GameweekNumber, month : Base.CalendarMonth) -> async ();
        };

        await manager_canister.calculateFantasyTeamScores(leagueId, seasonId, gameweek, month);
      };
    };

    public func resetWeeklyTransfers() : async () {
      for (canisterId in Iter.fromList(uniqueManagerCanisterIds)) {

        let manager_canister = actor (canisterId) : actor {
          resetWeeklyTransfers : () -> async ();
        };

        await manager_canister.resetWeeklyTransfers();
      };
    };

    public func resetBonusesAvailable() : async () {
      for (canisterId in Iter.fromList(uniqueManagerCanisterIds)) {

        let manager_canister = actor (canisterId) : actor {
          resetBonusesAvailable : () -> async ();
        };

        await manager_canister.resetBonusesAvailable();
      };
    };

    public func resetFantasyTeams() : async () {
      for (canisterId in Iter.fromList(uniqueManagerCanisterIds)) {

        let manager_canister = actor (canisterId) : actor {
          resetFantasyTeams : () -> async ();
        };

        await manager_canister.resetFantasyTeams();
      };
    };

    public func getFantasyTeamSnapshot(dto: DTOs.GetFantasyTeamSnapshotDTO) : async Result.Result<DTOs.FantasyTeamSnapshotDTO, T.Error>{
     let managerCanisterId = managerCanisterIds.get(dto.managerPrincipalId);
      switch (managerCanisterId) {
        case (null) {
          return #err(#NotFound);
        };
        case (?foundCanisterId) {
          let manager_canister = actor (foundCanisterId) : actor {
            getFantasyTeamSnapshot : (dto: DTOs.GetFantasyTeamSnapshotDTO) -> async ?T.FantasyTeamSnapshot;
          };
    
         let snapshot = await manager_canister.getFantasyTeamSnapshot(dto);
          switch (snapshot) {
            case (null) {
              return #err(#NotFound);
            };
            case (?foundSnapshot) {

              var favouriteClubId: FootballTypes.ClubId = 0;
              switch(foundSnapshot.favouriteClubId){
                case (?foundFavouriteClubId){
                  favouriteClubId := foundFavouriteClubId;
                };
                case (null){
                }
              };
              #ok({
                bankQuarterMillions = foundSnapshot.bankQuarterMillions;
                braceBonusGameweek = foundSnapshot.braceBonusGameweek;
                captainFantasticGameweek = foundSnapshot.captainFantasticGameweek;
                captainFantasticPlayerId = foundSnapshot.captainFantasticPlayerId;
                captainId = foundSnapshot.captainId;
                favouriteClubId = favouriteClubId;
                gameweek = foundSnapshot.gameweek;
                goalGetterGameweek = foundSnapshot.goalGetterGameweek;
                goalGetterPlayerId = foundSnapshot.goalGetterPlayerId;
                hatTrickHeroGameweek = foundSnapshot.hatTrickHeroGameweek;
                month = foundSnapshot.month;
                monthlyBonusesAvailable = foundSnapshot.monthlyBonusesAvailable;
                monthlyPoints = foundSnapshot.monthlyPoints;
                noEntryGameweek = foundSnapshot.noEntryGameweek;
                noEntryPlayerId = foundSnapshot.noEntryPlayerId;
                oneNationCountryId = foundSnapshot.oneNationCountryId;
                oneNationGameweek = foundSnapshot.oneNationGameweek;
                passMasterGameweek = foundSnapshot.passMasterGameweek;
                passMasterPlayerId = foundSnapshot.passMasterPlayerId;
                playerIds = foundSnapshot.playerIds;
                points = foundSnapshot.points;
                principalId = foundSnapshot.principalId;
                prospectsGameweek = foundSnapshot.prospectsGameweek;
                safeHandsGameweek = foundSnapshot.safeHandsGameweek;
                safeHandsPlayerId = foundSnapshot.safeHandsPlayerId;
                seasonId = foundSnapshot.seasonId;
                seasonPoints = foundSnapshot.seasonPoints;
                teamBoostClubId = foundSnapshot.teamBoostClubId;
                teamBoostGameweek = foundSnapshot.teamBoostGameweek;
                teamValueQuarterMillions = foundSnapshot.teamValueQuarterMillions;
                transferWindowGameweek = foundSnapshot.transferWindowGameweek;
                transfersAvailable = foundSnapshot.transfersAvailable;
                username = foundSnapshot.username
              });
            };
          };
        };
      };
    };

    public func getTotalManagers() : Result.Result<Nat, T.Error> {
      return #ok(totalManagers);
    };

    public func isUsernameValid(username: Text) : Bool {
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
      return true;
    };

    public func isUsernameTaken(username : Text, principalId : Text) : Bool {
      for (managerUsername in usernames.entries()) {

        let lowerCaseUsername = Utilities.toLowercase(username);
        let existingUsername = Utilities.toLowercase(managerUsername.1);

        if (lowerCaseUsername == existingUsername and managerUsername.0 != principalId) {
          return true;
        };
      };

      return false;
    };

    public func updateUsername(managerPrincipalId : Base.PrincipalId, username: Text, gameweek: FootballTypes.GameweekNumber) : async Result.Result<(), T.Error> {
      if (not isUsernameValid(username)) {
        return #err(#InvalidData);
      };

      if (isUsernameTaken(username, managerPrincipalId)) {
        return #err(#InvalidData);
      };

      let managerCanisterId = managerCanisterIds.get(managerPrincipalId);
      switch(managerCanisterId){
        case (null){
          return await createNewManager(managerPrincipalId, username, 0, null, "", null, gameweek, []);
        };  
        case (?foundManagerCanisterId){
          
          let manager_canister = actor (foundManagerCanisterId) : actor {
            updateUsername : (dto : DTOs.UsernameUpdateDTO) -> async Result.Result<(), T.Error>;
          };
          let updatedUsernameDTO : DTOs.UsernameUpdateDTO = {
            principalId = managerPrincipalId;
            updatedUsername = {username = username};
          };
          usernames.put(managerPrincipalId, username);
          return await manager_canister.updateUsername(updatedUsernameDTO);
        }
      };
    };

    private func createNewManager(managerPrincipalId: Base.PrincipalId, username: Text, favouriteClubId: FootballTypes.ClubId, profilePicture: ?Blob, profilePictureType: Text, dto : ?DTOs.UpdateTeamSelectionDTO, gameweek: FootballTypes.GameweekNumber, players: [DTOs.PlayerDTO]) : async Result.Result<(), T.Error>{
      
      if(activeManagerCanisterId == ""){
        activeManagerCanisterId := await createManagerCanister();
      };

      var monthlyBonuses: Nat8 = 2;
      var bankBalance: Nat16 = 1200;
      var playerIds: [FootballTypes.PlayerId] = [];
      var captainId: FootballTypes.PlayerId = 0;
      var goalGetterGameweek: FootballTypes.GameweekNumber = 0;
      var goalGetterPlayerId: FootballTypes.PlayerId = 0;
      var passMasterGameweek: FootballTypes.GameweekNumber = 0;
      var passMasterPlayerId: FootballTypes.PlayerId = 0;
      var noEntryGameweek: FootballTypes.GameweekNumber = 0;
      var noEntryPlayerId: FootballTypes.PlayerId = 0;
      var teamBoostGameweek: FootballTypes.GameweekNumber = 0;
      var teamBoostClubId: FootballTypes.ClubId = 0;
      var safeHandsGameweek: FootballTypes.GameweekNumber = 0;
      var safeHandsPlayerId: FootballTypes.PlayerId = 0;
      var captainFantasticGameweek: FootballTypes.GameweekNumber = 0;
      var captainFantasticPlayerId: FootballTypes.PlayerId = 0;
      var oneNationGameweek: FootballTypes.GameweekNumber = 0;
      var oneNationCountryId: Base.CountryId = 0;
      var prospectsGameweek: FootballTypes.GameweekNumber = 0;
      var braceBonusGameweek: FootballTypes.GameweekNumber = 0;
      var hatTrickHeroGameweek: FootballTypes.GameweekNumber = 0;

      switch(dto){
        case (null){ };
        case (?foundDTO){

        if (await invalidBonuses(null, foundDTO, gameweek, players)) {
          return #err(#InvalidBonuses);
        };

        var bonusPlayed = foundDTO.goalGetterGameweek == gameweek 
          or foundDTO.passMasterGameweek == gameweek 
          or foundDTO.noEntryGameweek == gameweek 
          or foundDTO.teamBoostGameweek == gameweek 
          or foundDTO.safeHandsGameweek == gameweek 
          or foundDTO.captainFantasticGameweek == gameweek 
          or foundDTO.oneNationGameweek == gameweek 
          or foundDTO.prospectsGameweek == gameweek 
          or foundDTO.braceBonusGameweek == gameweek 
          or foundDTO.hatTrickHeroGameweek == gameweek;

          if(bonusPlayed){
            monthlyBonuses := 1;
          };

          bankBalance := bankBalance - Utilities.getTeamValue(foundDTO.playerIds, players);
          

          playerIds := foundDTO.playerIds;
          captainId := foundDTO.captainId;
          goalGetterGameweek := foundDTO.goalGetterGameweek;
          goalGetterPlayerId := foundDTO.goalGetterPlayerId;
          passMasterGameweek := foundDTO.passMasterGameweek;
          passMasterPlayerId := foundDTO.passMasterPlayerId;
          noEntryGameweek := foundDTO.noEntryGameweek;
          noEntryPlayerId := foundDTO.noEntryPlayerId;
          teamBoostGameweek := foundDTO.teamBoostGameweek;
          teamBoostClubId := foundDTO.teamBoostClubId;
          safeHandsGameweek := foundDTO.safeHandsGameweek;
          safeHandsPlayerId := foundDTO.safeHandsPlayerId;
          captainFantasticGameweek := foundDTO.captainFantasticGameweek;
          captainFantasticPlayerId := foundDTO.captainFantasticPlayerId;
          oneNationGameweek := foundDTO.oneNationGameweek;
          oneNationCountryId := foundDTO.oneNationCountryId;
          prospectsGameweek := foundDTO.prospectsGameweek;
          braceBonusGameweek := foundDTO.braceBonusGameweek;
          hatTrickHeroGameweek := foundDTO.hatTrickHeroGameweek;
        };
      };
      
      let manager_canister = actor (activeManagerCanisterId) : actor {
        addNewManager : (manager : T.Manager) -> async Result.Result<(), T.Error>;
        getTotalManagers : () -> async Nat;
        getManager : (principalId : Base.PrincipalId) -> async ?T.Manager;
      };

      let canisterManagerCount = await manager_canister.getTotalManagers();
      if (canisterManagerCount >= 12000) {
        activeManagerCanisterId := await createManagerCanister();
        let new_manager_canister = actor (activeManagerCanisterId) : actor {
          addNewManager : (manager : T.Manager) -> async Result.Result<(), T.Error>;
        };
        managerCanisterIds.put(managerPrincipalId, activeManagerCanisterId);
        totalManagers := totalManagers + 1;

        let newManager : T.Manager = {
          principalId = managerPrincipalId;
          username = username;
          favouriteClubId = ?favouriteClubId;
          createDate = Time.now();
          termsAccepted = false;
          profilePicture = profilePicture;
          profilePictureType = profilePictureType;
          transfersAvailable = 3;
          monthlyBonusesAvailable = monthlyBonuses;
          bankQuarterMillions = bankBalance;
          playerIds = playerIds;
          captainId = captainId;
          goalGetterGameweek = goalGetterGameweek;
          goalGetterPlayerId = goalGetterPlayerId;
          passMasterGameweek = passMasterGameweek;
          passMasterPlayerId = passMasterPlayerId;
          noEntryGameweek = noEntryGameweek;
          noEntryPlayerId = noEntryPlayerId;
          teamBoostGameweek = teamBoostGameweek;
          teamBoostClubId = teamBoostClubId;
          safeHandsGameweek = safeHandsGameweek;
          safeHandsPlayerId = safeHandsPlayerId;
          captainFantasticGameweek = captainFantasticGameweek;
          captainFantasticPlayerId = captainFantasticPlayerId;
          oneNationGameweek = oneNationGameweek;
          oneNationCountryId = oneNationCountryId;
          prospectsGameweek = prospectsGameweek;
          braceBonusGameweek = braceBonusGameweek;
          hatTrickHeroGameweek = hatTrickHeroGameweek;
          transferWindowGameweek = 0;
          history = List.nil();
          canisterId = activeManagerCanisterId;
        };
        
        return await new_manager_canister.addNewManager(newManager);
      };

      totalManagers := totalManagers + 1;
      managerCanisterIds.put(managerPrincipalId, activeManagerCanisterId);

      let newManager : T.Manager = {
        principalId = managerPrincipalId;
        username = username;
        favouriteClubId = ?favouriteClubId;
        createDate = Time.now();
        termsAccepted = false;
        profilePicture = profilePicture;
        profilePictureType = profilePictureType;
        transfersAvailable = 2;
        monthlyBonusesAvailable = monthlyBonuses;
        bankQuarterMillions = bankBalance;
        playerIds = playerIds;
        captainId = captainId;
        goalGetterGameweek = goalGetterGameweek;
        goalGetterPlayerId = goalGetterPlayerId;
        passMasterGameweek = passMasterGameweek;
        passMasterPlayerId = passMasterPlayerId;
        noEntryGameweek = noEntryGameweek;
        noEntryPlayerId = noEntryPlayerId;
        teamBoostGameweek = teamBoostGameweek;
        teamBoostClubId = teamBoostClubId;
        safeHandsGameweek = safeHandsGameweek;
        safeHandsPlayerId = safeHandsPlayerId;
        captainFantasticGameweek = captainFantasticGameweek;
        captainFantasticPlayerId = captainFantasticPlayerId;
        oneNationGameweek = oneNationGameweek;
        oneNationCountryId = oneNationCountryId;
        prospectsGameweek = prospectsGameweek;
        braceBonusGameweek = braceBonusGameweek;
        hatTrickHeroGameweek = hatTrickHeroGameweek;
        transferWindowGameweek = 0;
        history = List.nil();
        canisterId = activeManagerCanisterId;
      };
      
      return await manager_canister.addNewManager(newManager);
    };

    private func createManagerCanister() : async Text {
      Cycles.add<system>(50_000_000_000_000);
      let canister = await ManagerCanister._ManagerCanister();
      await canister.initialise(controllerPrincipalId, fixturesPerClub);
      let IC : Management.Management = actor (NetworkEnvironmentVariables.Default);
      let principal = ?Principal.fromText(controllerPrincipalId);
      let _ = await Utilities.updateCanister_(canister, principal, IC);

      let canister_principal = Principal.fromActor(canister);
      let canisterId = Principal.toText(canister_principal);

      if (canisterId == "") {
        return canisterId;
      };
      
      let uniqueCanisterIdBuffer = Buffer.fromArray<Base.CanisterId>(List.toArray(uniqueManagerCanisterIds));
      uniqueCanisterIdBuffer.add(canisterId);
      uniqueManagerCanisterIds := List.fromArray(Buffer.toArray(uniqueCanisterIdBuffer));
      activeManagerCanisterId := canisterId;
      return canisterId;
    };

    private func invalidBonuses(manager: ?T.Manager, updatedFantasyTeam : DTOs.UpdateTeamSelectionDTO, gameweek: FootballTypes.GameweekNumber, players : [DTOs.PlayerDTO]) : async Bool {
      switch(manager){
        case (null){ };
        case (?foundManager){
          let goalGetterPlayed = updatedFantasyTeam.goalGetterGameweek == gameweek;
          let passMasterPlayed = updatedFantasyTeam.passMasterGameweek == gameweek;
          let noEntryPlayed = updatedFantasyTeam.noEntryGameweek == gameweek;
          let teamBoostPlayed = updatedFantasyTeam.teamBoostGameweek == gameweek;
          let safeHandsPlayed = updatedFantasyTeam.safeHandsGameweek == gameweek;
          let captainFantasticPlayed = updatedFantasyTeam.captainFantasticGameweek == gameweek;
          let prospectsPlayed = updatedFantasyTeam.prospectsGameweek == gameweek;
          let oneNationPlayed = updatedFantasyTeam.oneNationGameweek == gameweek;
          let braceBonusPlayed = updatedFantasyTeam.braceBonusGameweek == gameweek;
          let hatTrickHeroPlayed = updatedFantasyTeam.hatTrickHeroGameweek == gameweek;
         
          if(goalGetterPlayed and updatedFantasyTeam.goalGetterPlayerId == 0){
            return true;
          };

          if(passMasterPlayed and updatedFantasyTeam.passMasterPlayerId == 0){
            return true;
          };

          if(noEntryPlayed and updatedFantasyTeam.noEntryPlayerId == 0){
            return true;
          };

          if(teamBoostPlayed and updatedFantasyTeam.teamBoostClubId == 0){
            return true;
          };

          if(safeHandsPlayed and updatedFantasyTeam.safeHandsPlayerId == 0){
            return true;
          };

          if(captainFantasticPlayed and updatedFantasyTeam.captainFantasticPlayerId == 0){
            return true;
          };

          if(oneNationPlayed and updatedFantasyTeam.oneNationCountryId == 0){
            return true;
          };


          var bonusesPlayed: Int = 0;

          if (goalGetterPlayed and foundManager.goalGetterGameweek != gameweek) {
            bonusesPlayed += 1;
          };
          if (passMasterPlayed and foundManager.passMasterGameweek != gameweek) {
            bonusesPlayed += 1;
          };
          
          if (noEntryPlayed and foundManager.noEntryGameweek != gameweek) {
            let bonusPlayer = List.find<DTOs.PlayerDTO>(
              List.fromArray(players),
              func(player : DTOs.PlayerDTO) : Bool {
                return player.id == updatedFantasyTeam.noEntryPlayerId;
              },
            );
            switch (bonusPlayer) {
              case (null) { return true };
              case (?player) {
                if (player.position != #Goalkeeper and player.position != #Defender) {
                  return true;
                };
              };
            };
            bonusesPlayed += 1;
          };
          
          if (teamBoostPlayed and foundManager.teamBoostGameweek != gameweek) {
            bonusesPlayed += 1;
          };
          if (safeHandsPlayed and foundManager.safeHandsGameweek != gameweek) {
            let bonusPlayer = List.find<DTOs.PlayerDTO>(
              List.fromArray(players),
              func(player : DTOs.PlayerDTO) : Bool {
                return player.id == updatedFantasyTeam.safeHandsPlayerId;
              },
            );
            switch (bonusPlayer) {
              case (null) { return true };
              case (?player) {
                if (player.position != #Goalkeeper) { return true };
              };
            };
            bonusesPlayed += 1;
          };
          if (captainFantasticPlayed and foundManager.captainFantasticGameweek != gameweek) {
            bonusesPlayed += 1;
          };
          if (oneNationPlayed and foundManager.oneNationGameweek != gameweek) {
            bonusesPlayed += 1;
          };
          if (prospectsPlayed and foundManager.prospectsGameweek != gameweek) {
            bonusesPlayed += 1;
          };
          if (braceBonusPlayed and foundManager.braceBonusGameweek != gameweek) {
            bonusesPlayed += 1;
          };
          if (hatTrickHeroPlayed and foundManager.hatTrickHeroGameweek != gameweek) {
            bonusesPlayed += 1;
          };

          if (bonusesPlayed > 1) {
            return true;
          };  
          
          if(updatedFantasyTeam.goalGetterGameweek == gameweek and 
            (foundManager.goalGetterGameweek != gameweek and foundManager.goalGetterGameweek != 0)){
            return true;
          };
          
          if(updatedFantasyTeam.passMasterGameweek == gameweek and 
            (foundManager.passMasterGameweek != gameweek and foundManager.passMasterGameweek != 0)){
            return true;
          };
          
          if(updatedFantasyTeam.noEntryGameweek == gameweek and 
            (foundManager.noEntryGameweek != gameweek and foundManager.noEntryGameweek != 0)){
            return true;
          };
          
          if(updatedFantasyTeam.teamBoostGameweek == gameweek and 
            (foundManager.teamBoostGameweek != gameweek and foundManager.teamBoostGameweek != 0)){
            return true;
          };
          
          if(updatedFantasyTeam.safeHandsGameweek == gameweek and 
            (foundManager.safeHandsGameweek != gameweek and foundManager.safeHandsGameweek != 0)){
            return true;
          };
          
          if(updatedFantasyTeam.captainFantasticGameweek == gameweek and 
            (foundManager.captainFantasticGameweek != gameweek and foundManager.captainFantasticGameweek != 0)){
            return true;
          };
          
          if(updatedFantasyTeam.prospectsGameweek == gameweek and 
            (foundManager.prospectsGameweek != gameweek and foundManager.prospectsGameweek != 0)){
            return true;
          };
          
          if(updatedFantasyTeam.oneNationGameweek == gameweek and 
            (foundManager.oneNationGameweek != gameweek and foundManager.oneNationGameweek != 0)){
            return true;
          };
          
          if(updatedFantasyTeam.braceBonusGameweek == gameweek and 
            (foundManager.braceBonusGameweek != gameweek and foundManager.braceBonusGameweek != 0)){
            return true;
          };
          
          if(updatedFantasyTeam.hatTrickHeroGameweek == gameweek and 
            (foundManager.hatTrickHeroGameweek != gameweek and foundManager.hatTrickHeroGameweek != 0)){
            return true;
          };

          var monthlyBonuses: Int = 0;
          let foundManagerBonuses: Nat8 = foundManager.monthlyBonusesAvailable;
          
          if(foundManagerBonuses > 0){
            monthlyBonuses := Int64.toInt(Int64.fromNat64(Nat64.fromNat(Nat8.toNat(foundManager.monthlyBonusesAvailable))));
          };

          monthlyBonuses -= bonusesPlayed;

          if (monthlyBonuses < 0) {
            return true;
          };
        };
      };
      return false;
    };

    public func updateFavouriteClub(managerPrincipalId : Base.PrincipalId, favouriteClubId : FootballTypes.ClubId, gameweek: FootballTypes.GameweekNumber, activeClubs : [FootballTypes.Club]) : async Result.Result<(), T.Error> {

      let isClubActive = Array.find(
        activeClubs,
        func(club : FootballTypes.Club) : Bool {
          return club.id == favouriteClubId;
        },
      );
      if (not Option.isSome(isClubActive)) {
        return #err(#NotFound);
      };

      if (favouriteClubId <= 0) {
        return #err(#InvalidData);
      };

      let managerCanisterId = managerCanisterIds.get(managerPrincipalId);
      switch(managerCanisterId){
        case (null){
          return await createNewManager(managerPrincipalId, "", favouriteClubId, null, "", null, gameweek, []);
        };  
        case (?foundManagerCanisterId){
          
          let manager_canister = actor (foundManagerCanisterId) : actor {
            updateFavouriteClub : (dto : DTOs.FavouriteClubUpdateDTO) -> async Result.Result<(), T.Error>;
          };
          let updatedUsernameDTO : DTOs.FavouriteClubUpdateDTO = {
            principalId = managerPrincipalId;
            favouriteClubId = favouriteClubId;
          };
          return await manager_canister.updateFavouriteClub(updatedUsernameDTO);
        }
      };
    };

    public func updateProfilePicture(managerPrincipalId: Base.PrincipalId, dto: DTOs.UpdateProfilePictureDTO, gameweek: FootballTypes.GameweekNumber) : async Result.Result<(), T.Error> {

      if (invalidProfilePicture(dto.profilePicture)) {

        return #err(#InvalidData);
      };

      let managerCanisterId = managerCanisterIds.get(managerPrincipalId);
      switch(managerCanisterId){
        case (null){
          return await createNewManager(managerPrincipalId, "", 0, ?dto.profilePicture, dto.extension, null, gameweek, []);
        };  
        case (?foundManagerCanisterId){
          
          let manager_canister = actor (foundManagerCanisterId) : actor {
            updateProfilePicture : (dto : DTOs.ProfilePictureUpdateDTO) -> async Result.Result<(), T.Error>;
          };
          let profilePictureDTO : DTOs.ProfilePictureUpdateDTO = {
            principalId = managerPrincipalId;
            updatedProfilePicture = dto;
          };
          return await manager_canister.updateProfilePicture(profilePictureDTO);
        }
      };
    };

    private func invalidProfilePicture(profilePicture : Blob) : Bool {
      let sizeInKB = Array.size(Blob.toArray(profilePicture)) / 1024;
      return (sizeInKB <= 0 or sizeInKB > 500);
    };

    public func saveFantasyTeam(managerPrincipalId: Base.PrincipalId, updatedFantasyTeamDTO : DTOs.UpdateTeamSelectionDTO, seasonId: FootballTypes.SeasonId, gameweek: FootballTypes.GameweekNumber, players : [DTOs.PlayerDTO]) : async Result.Result<(), T.Error> {
      
      let teamValidResult = teamValid(updatedFantasyTeamDTO, players);
      switch(teamValidResult){
        case (#ok _){ };
        case (#err errorResult){
          return #err(errorResult);
        }
      };

      let usernameUpdated = updatedFantasyTeamDTO.username != "";
      
      if (usernameUpdated and not isUsernameValid(updatedFantasyTeamDTO.username)) {
        return #err(#InvalidData);
      };

      if (usernameUpdated and isUsernameTaken(updatedFantasyTeamDTO.username, managerPrincipalId)) {
        return #err(#InvalidData);
      };  
      
      let managerCanisterId = managerCanisterIds.get(managerPrincipalId);
      
      var result: ?Result.Result<(), T.Error> = null;
      switch(managerCanisterId){
        case (null){
      
          result := ?(await createNewManager(managerPrincipalId, updatedFantasyTeamDTO.username, 0, null, "", ?updatedFantasyTeamDTO, gameweek, players));
        };  
        case (?foundManagerCanisterId){
      
          result := ?(await updateFantasyTeam(foundManagerCanisterId, managerPrincipalId, updatedFantasyTeamDTO, seasonId, gameweek, players));
        }
      };

      switch(result){
        case null{
          return #err(#NotFound);
        };
        case (?#ok ok_result){
          if(usernameUpdated){
            usernames.put(managerPrincipalId, updatedFantasyTeamDTO.username);
          };
          return #ok(ok_result);
        };
        case (?#err err_result) {
          return #err(err_result);
        };
      };
    };

    private func teamValid(updatedFantasyTeam : DTOs.UpdateTeamSelectionDTO, players : [DTOs.PlayerDTO]) : Result.Result<(), T.Error> {
     
      let newTeamPlayers = Array.filter<DTOs.PlayerDTO>(
        players,
        func(player : DTOs.PlayerDTO) : Bool {
          let isPlayerIdInNewTeam = Array.find(
            updatedFantasyTeam.playerIds,
            func(id : Nat16) : Bool {
              return id == player.id;
            },
          );
          return Option.isSome(isPlayerIdInNewTeam);
        },
      );

     let playerCount = newTeamPlayers.size();

      if (playerCount != 11) {
        return #err(#Not11Players);
      };

      var teamPlayerCounts = TrieMap.TrieMap<Text, Nat8>(Text.equal, Text.hash);
      var playerIdCounts = TrieMap.TrieMap<Text, Nat8>(Text.equal, Text.hash);
      var goalkeeperCount = 0;
      var defenderCount = 0;
      var midfielderCount = 0;
      var forwardCount = 0;
      var captainInTeam = false;
      

      for (i in Iter.range(0, playerCount -1)) {

        let count = teamPlayerCounts.get(Nat16.toText(newTeamPlayers[i].clubId));
        switch (count) {
          case (null) {
            teamPlayerCounts.put(Nat16.toText(newTeamPlayers[i].clubId), 1);
          };
          case (?count) {
            teamPlayerCounts.put(Nat16.toText(newTeamPlayers[i].clubId), count + 1);
          };
        };

        let playerIdCount = playerIdCounts.get(Nat16.toText(newTeamPlayers[i].id));
        switch (playerIdCount) {
          case (null) { playerIdCounts.put(Nat16.toText(newTeamPlayers[i].id), 1) };
          case (?count) {

            return #err(#DuplicatePlayerInTeam);
          };
        };

        if (newTeamPlayers[i].position == #Goalkeeper) {
          goalkeeperCount += 1;
        };

        if (newTeamPlayers[i].position == #Defender) {
          defenderCount += 1;
        };

        if (newTeamPlayers[i].position == #Midfielder) {
          midfielderCount += 1;
        };

        if (newTeamPlayers[i].position == #Forward) {
          forwardCount += 1;
        };

        if (newTeamPlayers[i].id == updatedFantasyTeam.captainId) {
          captainInTeam := true;
        }

      };

      for ((key, value) in teamPlayerCounts.entries()) {
        if (value > 2) {

            return #err(#MoreThan2PlayersFromClub);
        };
      };

      if (
        goalkeeperCount != 1 or defenderCount < 3 or defenderCount > 5 or midfielderCount < 3 or midfielderCount > 5 or forwardCount < 1 or forwardCount > 3,
      ) {

            return #err(#NumberPerPositionError);
      };

      if (not captainInTeam) {
            return #err(#SelectedCaptainNotInTeam);
      };

      return #ok();
    };

     private func updateFantasyTeam(managerCanisterId: Base.CanisterId, managerPrincipalId: Base.PrincipalId, dto : DTOs.UpdateTeamSelectionDTO, seasonId: FootballTypes.SeasonId, gameweek: FootballTypes.GameweekNumber, allPlayers: [DTOs.PlayerDTO]) : async Result.Result<(), T.Error>{
      let manager_canister = actor (managerCanisterId) : actor {
        getManager : Base.PrincipalId -> async ?T.Manager;
        updateTeamSelection : (updateManagerDTO : DTOs.TeamUpdateDTO, transfersAvailable : Nat8, monthlyBonuses : Nat8, newBankBalance : Nat16) -> async Result.Result<(), T.Error>;
      };

      let manager = await manager_canister.getManager(managerPrincipalId);  
              

      if (await invalidBonuses(manager, dto, gameweek, allPlayers)) {
        return #err(#InvalidBonuses);
      };

      switch(manager){
        case (null){
          return #err(#NotFound);
        };
        case (?foundManager){

          if(overspent(foundManager.bankQuarterMillions, foundManager.playerIds, dto.playerIds, allPlayers)){
            return #err(#TeamOverspend);
          };
          
          var transfersAvailable = 3;
          var firstGameweek = true;
          let currentManagerSeason = List.find<T.FantasyTeamSeason>(foundManager.history, func(season: T.FantasyTeamSeason) : Bool {
            season.seasonId == seasonId;
          });

          switch(currentManagerSeason){
            case (?foundSeason){
              firstGameweek := List.size(foundSeason.gameweeks) == 0;
            };
            case (null){ }
          };

          let hasPlayersInTeam = Array.size(foundManager.playerIds) > 0;
          
          if(not firstGameweek and hasPlayersInTeam){
            transfersAvailable := getTransfersAvailable(foundManager, dto.playerIds, allPlayers);
            if (transfersAvailable < 0) {
              return #err(#TooManyTransfers);
            };
          };
          
          var monthlyBonuses = getMonthlyBonuses(foundManager, dto, gameweek);
          var newBankBalance = getNewBankBalance(foundManager, dto, allPlayers);
          return await manager_canister.updateTeamSelection({
            principalId = managerPrincipalId;
            updatedTeamSelection = dto;
          }, Nat8.fromNat(Nat64.toNat(Nat64.fromIntWrap(transfersAvailable))), monthlyBonuses, newBankBalance);
        }
      };
      return #ok;
    };

    private func overspent(currentBankBalance: Nat16, existingPlayerIds: [FootballTypes.PlayerId], updatedPlayerIds: [FootballTypes.PlayerId], allPlayers: [DTOs.PlayerDTO]) : Bool{
      
      let updatedPlayers = Array.filter<DTOs.PlayerDTO>(
        allPlayers,
        func(player : DTOs.PlayerDTO) : Bool {
          let playerId = player.id;
          let isPlayerIdInNewTeam = Array.find(
            updatedPlayerIds,
            func(id : Nat16) : Bool {
              return id == playerId;
            },
          );
          return Option.isSome(isPlayerIdInNewTeam);
        },
      );

      let playersAdded = Array.filter<DTOs.PlayerDTO>(
        updatedPlayers,
        func(player : DTOs.PlayerDTO) : Bool {
          let playerId = player.id;
          let isPlayerIdInExistingTeam = Array.find(
            existingPlayerIds,
            func(id : Nat16) : Bool {
              return id == playerId;
            },
          );
          return Option.isNull(isPlayerIdInExistingTeam);
        },
      );

      let playersRemoved = Array.filter<Nat16>(
        existingPlayerIds,
        func(playerId : Nat16) : Bool {
          let isPlayerIdInPlayers = Array.find(
            updatedPlayers,
            func(player : DTOs.PlayerDTO) : Bool {
              return player.id == playerId;
            },
          );
          return Option.isNull(isPlayerIdInPlayers);
        },
      );

      let spentNat16 = Array.foldLeft<DTOs.PlayerDTO, Nat16>(playersAdded, 0, func(sumSoFar, x) = sumSoFar + x.valueQuarterMillions);
      var sold : Int = 0;
      
      for (i in Iter.range(0, Array.size(playersRemoved) -1)) {
        let foundPlayer = List.find<DTOs.PlayerDTO>(
          List.fromArray(allPlayers),
          func(player : DTOs.PlayerDTO) : Bool {
            return player.id == playersRemoved[i];
          },
        );
        switch (foundPlayer) {
          case (null) {};
          case (?player) {
            sold := sold + Nat16.toNat(player.valueQuarterMillions);
          };
        };
      };
      
      let netSpendQMs : Int = Int64.toInt(Int64.fromNat64(Nat64.fromNat(Nat16.toNat(spentNat16)))) - sold;
      let newBankBalance: Int = Int64.toInt(Int64.fromNat64(Nat64.fromNat(Nat16.toNat(currentBankBalance)))) - netSpendQMs;
       if (newBankBalance < 0) {
        return true;
      };

      return false;
    };

    private func getTransfersAvailable(manager: T.Manager, updatedPlayerIds: [FootballTypes.PlayerId], allPlayers: [DTOs.PlayerDTO]) : Nat {
      

      let newPlayers = Array.filter<DTOs.PlayerDTO>(
        allPlayers,
        func(player : DTOs.PlayerDTO) : Bool {
          return Option.isSome(Array.find(
            updatedPlayerIds,
            func(id : Nat16) : Bool {
              return id == player.id;
            },
          ));
        },
      );

      let oldPlayers = Array.filter<DTOs.PlayerDTO>(
        allPlayers,
        func(player : DTOs.PlayerDTO) : Bool {
          return Option.isSome(Array.find(
            manager.playerIds,
            func(id : Nat16) : Bool {
              return id == player.id;
            },
          ));
        },
      );

      let additions = Array.filter<DTOs.PlayerDTO>(
        newPlayers,
        func(newPlayer : DTOs.PlayerDTO) : Bool {
          return Option.isNull(Array.find(
            oldPlayers,
            func(oldPlayer: DTOs.PlayerDTO) : Bool {
              return oldPlayer.id == newPlayer.id;
            },
          ));
        },
      );

      let transfersAvailable: Nat = Nat8.toNat(manager.transfersAvailable) -  Array.size(additions);
      return transfersAvailable;
    };

     private func getMonthlyBonuses(manager: T.Manager, dto: DTOs.UpdateTeamSelectionDTO, gameweek: FootballTypes.GameweekNumber) : Nat8 {
      
      var monthlyBonuses = manager.monthlyBonusesAvailable;
      if(monthlyBonuses == 0){
        return 0;
      };
      
      

      var newBonusPlayed = 
        (dto.goalGetterGameweek == gameweek and manager.goalGetterGameweek == 0) 
        or (dto.passMasterGameweek == gameweek and manager.passMasterGameweek == 0)
        or (dto.noEntryGameweek == gameweek and manager.noEntryGameweek == 0)
        or (dto.teamBoostGameweek == gameweek and manager.teamBoostGameweek == 0)
        or (dto.safeHandsGameweek == gameweek and manager.safeHandsGameweek == 0)
        or (dto.captainFantasticGameweek == gameweek and manager.captainFantasticGameweek == 0)
        or (dto.oneNationGameweek == gameweek and manager.oneNationGameweek == 0)
        or (dto.prospectsGameweek == gameweek and manager.prospectsGameweek == 0)
        or (dto.braceBonusGameweek == gameweek and manager.braceBonusGameweek == 0)
        or (dto.hatTrickHeroGameweek == gameweek and manager.hatTrickHeroGameweek == 0);
      
      if(newBonusPlayed){
        monthlyBonuses := monthlyBonuses - 1;  
      };

      return monthlyBonuses;
    };

    private func getNewBankBalance(manager: T.Manager, dto: DTOs.UpdateTeamSelectionDTO, allPlayers: [DTOs.PlayerDTO]) : Nat16 {
      let updatedPlayers = Array.filter<DTOs.PlayerDTO>(
        allPlayers,
        func(player : DTOs.PlayerDTO) : Bool {
          let playerId = player.id;
          let isPlayerIdInNewTeam = Array.find(
            dto.playerIds,
            func(id : Nat16) : Bool {
              return id == playerId;
            },
          );
          return Option.isSome(isPlayerIdInNewTeam);
        },
      );

      let playersAdded = Array.filter<DTOs.PlayerDTO>(
        updatedPlayers,
        func(player : DTOs.PlayerDTO) : Bool {
          let playerId = player.id;
          let isPlayerIdInExistingTeam = Array.find(
            manager.playerIds,
            func(id : Nat16) : Bool {
              return id == playerId;
            },
          );
          return Option.isNull(isPlayerIdInExistingTeam);
        },
      );

      let playersRemoved = Array.filter<Nat16>(
        manager.playerIds,
        func(playerId : Nat16) : Bool {
          let isPlayerIdInPlayers = Array.find(
            updatedPlayers,
            func(player : DTOs.PlayerDTO) : Bool {
              return player.id == playerId;
            },
          );
          return Option.isNull(isPlayerIdInPlayers);
        },
      );

      let spent = Array.foldLeft<DTOs.PlayerDTO, Nat16>(playersAdded, 0, func(sumSoFar, x) = sumSoFar + x.valueQuarterMillions);
      var sold : Nat16 = 0;
      for (i in Iter.range(0, Array.size(playersRemoved) -1)) {
        let foundPlayer = List.find<DTOs.PlayerDTO>(
          List.fromArray(allPlayers),
          func(player : DTOs.PlayerDTO) : Bool {
            return player.id == playersRemoved[i];
          },
        );
        switch (foundPlayer) {
          case (null) {};
          case (?player) {
            sold := sold + player.valueQuarterMillions;
          };
        };
      };
      
      return manager.bankQuarterMillions + sold - spent;
    };



    public func removePlayerFromTeams(leagueId: FootballTypes.LeagueId, playerId : FootballTypes.PlayerId, parentCanisterId: Base.CanisterId) : async () {
      for (canisterId in Iter.fromList(uniqueManagerCanisterIds)) {
 
        let manager_canister = actor (canisterId) : actor {
          removePlayerFromTeams : (leagueId: FootballTypes.LeagueId, playerId : FootballTypes.PlayerId, parentCanisterId: Base.CanisterId) -> async ();
        };

        await manager_canister.removePlayerFromTeams(leagueId, playerId, parentCanisterId);
      };
    };
 
    public func getManagerCanisterIds() : [(Base.PrincipalId, Base.CanisterId)] {
      return Iter.toArray(managerCanisterIds.entries());
    };

    //AI based functions to get manager snapshots
    public func getManagerSnapshotData() : async [T.FantasyTeamSnapshot] {
      
      let managerSnapshotsBuffer = Buffer.fromArray<T.FantasyTeamSnapshot>([]);
      
      for(canister in Iter.fromList(uniqueManagerCanisterIds)){

        let manager_canister = actor (canister) : actor {
          getSnapshots : () -> async [T.FantasyTeamSnapshot];
        };
        let managerSnapshots = await manager_canister.getSnapshots();
        
        managerSnapshotsBuffer.append(Buffer.fromArray(managerSnapshots));
      };

      return Buffer.toArray(managerSnapshotsBuffer);
    };

    //stable getters and setters

    

    public func getStableManagerCanisterIds() : [(Base.PrincipalId, Base.CanisterId)] {
      return Iter.toArray(managerCanisterIds.entries());
    };

    public func setStableManagerCanisterIds(stable_manager_canister_ids : [(Base.PrincipalId, Base.CanisterId)]) : () {
      let canisterIds : TrieMap.TrieMap<Base.PrincipalId, Base.CanisterId> = TrieMap.TrieMap<Base.PrincipalId, Base.CanisterId>(Text.equal, Text.hash);

      for (canisterId in Iter.fromArray(stable_manager_canister_ids)) {
        canisterIds.put(canisterId);
      };
      managerCanisterIds := canisterIds;
    };

    public func getStableUsernames() : [(Base.PrincipalId, Text)] {
      return Iter.toArray(usernames.entries());
    };

    public func setStableUsernames(stable_manager_usernames : [(Base.PrincipalId, Text)]) : () {
      let usernameMap : TrieMap.TrieMap<Base.PrincipalId, Base.CanisterId> = TrieMap.TrieMap<Base.PrincipalId, Base.CanisterId>(Text.equal, Text.hash);

      for (username in Iter.fromArray(stable_manager_usernames)) {
        usernameMap.put(username);
      };
      usernames := usernameMap;
    };


    public func getStableUniqueManagerCanisterIds() : [Base.CanisterId] {
      return List.toArray(uniqueManagerCanisterIds);
    };

    public func setStableUniqueManagerCanisterIds(stable_unique_manager_canister_ids : [Base.CanisterId]) : () {
      uniqueManagerCanisterIds := List.fromArray(stable_unique_manager_canister_ids);
    };

    public func resetManagerCount() {
      totalManagers := 0;
    };

    public func getStableTotalManagers() : Nat {
      return totalManagers;
    };

    public func setStableTotalManagers(stable_total_managers : Nat) : () {
      totalManagers := stable_total_managers;
    };

    public func getStableActiveManagerCanisterId() : Text {
      return activeManagerCanisterId;
    };

    public func setStableActiveManagerCanisterId(stable_active_manager_canister_id : Base.CanisterId) : () {
      activeManagerCanisterId := stable_active_manager_canister_id;
    };
  }
};
import Result "mo:base/Result";
import TrieMap "mo:base/TrieMap";
import List "mo:base/List";
import Text "mo:base/Text";
import Iter "mo:base/Iter";
import Principal "mo:base/Principal";
import Buffer "mo:base/Buffer";
import DTOs "../../shared/DTOs";
import Requests "../../shared/RequestDTOs";
import T "../../shared/types";
import RequestDTOs "../../shared/RequestDTOs";
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
import Debug "mo:base/Debug";
import NetworkEnvironmentVariables "../network_environment_variables";

module {

  public class UserManager(controllerPrincipalId: T.PrincipalId, fixturesPerClub: Nat8) {
    
    //need to store for each league the manager canister id dictionary

    private var managerCanisterIds :  TrieMap.TrieMap<T.PrincipalId, T.CanisterId> = TrieMap.TrieMap<T.PrincipalId, T.CanisterId>(Text.equal, Text.hash);
    private var usernames: TrieMap.TrieMap<T.PrincipalId, Text> = TrieMap.TrieMap<T.PrincipalId, Text>(Text.equal, Text.hash);

    private var uniqueManagerCanisterIds: List.List<T.CanisterId> = List.nil();
    private var totalManagers : Nat = 0;
    private var activeManagerCanisterId : T.CanisterId = "";    
    
    public func getProfile(request: RequestDTOs.RequestProfileDTO) : async Result.Result<DTOs.ProfileDTO, T.Error> {
        
      let userManagerCanisterId = managerCanisterIds.get(request.principalId);
      switch(userManagerCanisterId){
        case (?foundUserCanisterId){

          let manager_canister = actor (foundUserCanisterId) : actor {
              getManager : T.PrincipalId -> async ?T.Manager;
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

    public func getManager(dto: Requests.RequestManagerDTO, weeklyLeaderboardEntry : ?DTOs.LeaderboardEntryDTO, monthlyLeaderboardEntry : ?DTOs.LeaderboardEntryDTO, seasonLeaderboardEntry : ?DTOs.LeaderboardEntryDTO) : async Result.Result<DTOs.ManagerDTO, T.Error> {
      let managerCanisterId = managerCanisterIds.get(dto.managerId);
      
      switch (managerCanisterId) {
        case (null) {
          return #err(#NotFound);
        };
        case (?foundCanisterId) {
          let manager_canister = actor (foundCanisterId) : actor {
            getManager : T.PrincipalId -> async ?T.Manager;
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
                    };
                  };

                  switch (monthlyLeaderboardEntry) {
                    case (null) {};
                    case (?foundEntry) {
                      monthlyPosition := foundEntry.position;
                    };
                  };

                  switch (seasonLeaderboardEntry) {
                    case (null) {};
                    case (?foundEntry) {
                      seasonPosition := foundEntry.position;
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
                getManager : T.PrincipalId -> async ?T.Manager;
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
    
    public func getUniqueManagerCanisterIds() : [T.CanisterId] {
      return List.toArray(uniqueManagerCanisterIds);
    };

    public func getCurrentTeam(principalId : Text) : async Result.Result<DTOs.PickTeamDTO, T.Error> {

      let managerCanisterId = managerCanisterIds.get(principalId);
      switch (managerCanisterId) {
        case (null) {
          return #err(#NotFound);
        };
        case (?foundCanisterId) {

          let manager_canister = actor (foundCanisterId) : actor {
            getManager : T.PrincipalId -> async ?T.Manager;
          };
          let manager = await manager_canister.getManager(principalId);
          switch (manager) {
            case (null) {
              return #err(#NotFound);
            };
            case (?foundManager) {

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
              };

              return #ok(pickTeamDTO);
            };
          };
        };
      };
    };

    public func snapshotFantasyTeams(seasonId : T.SeasonId, gameweek : T.GameweekNumber, month : T.CalendarMonth) : async () {
      for (canisterId in Iter.fromList(uniqueManagerCanisterIds)) {

        let manager_canister = actor (canisterId) : actor {
          snapshotFantasyTeams : (seasonId : T.SeasonId, gameweek : T.GameweekNumber, month : T.CalendarMonth) -> async ();
        };

        await manager_canister.snapshotFantasyTeams(seasonId, gameweek, month);
      };
    };

    public func calculateFantasyTeamScores(leagueId: T.FootballLeagueId, seasonId : T.SeasonId, gameweek : T.GameweekNumber, month : T.CalendarMonth) : async () {
      for (canisterId in Iter.fromList(uniqueManagerCanisterIds)) {

        let manager_canister = actor (canisterId) : actor {
          calculateFantasyTeamScores : (leagueId: T.FootballLeagueId, seasonId : T.SeasonId, gameweek : T.GameweekNumber, month : T.CalendarMonth) -> async ();
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
            getFantasyTeamSnapshot : (dto: DTOs.GetFantasyTeamSnapshotDTO) -> async ?DTOs.FantasyTeamSnapshotDTO;
          };
      
          let snapshot = await manager_canister.getFantasyTeamSnapshot(dto);
          switch (snapshot) {
            case (null) {
              return #err(#NotFound);
            };
            case (?foundSnapshot) {
              #ok(foundSnapshot);
            };
          };
        };
      };
    };

    public func getTotalManagers() : async Result.Result<Nat, T.Error> {
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

    public func updateUsername(managerPrincipalId : T.PrincipalId, username: Text, systemState: DTOs.SystemStateDTO) : async Result.Result<(), T.Error> {
      if (not isUsernameValid(username)) {
        return #err(#InvalidData);
      };

      if (isUsernameTaken(username, managerPrincipalId)) {
        return #err(#InvalidData);
      };

      let managerCanisterId = managerCanisterIds.get(managerPrincipalId);
      switch(managerCanisterId){
        case (null){
          return await createNewManager(managerPrincipalId, username, 0, null, "", null, systemState, []);
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

    private func createNewManager(managerPrincipalId: T.PrincipalId, username: Text, favouriteClubId: T.ClubId, profilePicture: ?Blob, profilePictureType: Text, dto : ?DTOs.UpdateTeamSelectionDTO, systemState: DTOs.SystemStateDTO, players: [DTOs.PlayerDTO]) : async Result.Result<(), T.Error>{
      
      Debug.print("create new canister");
      Debug.print(debug_show managerPrincipalId);
      Debug.print(debug_show username);
      Debug.print(debug_show favouriteClubId);
      Debug.print(debug_show profilePicture);
      Debug.print(debug_show profilePictureType);
      Debug.print(debug_show dto);
      Debug.print(debug_show systemState);

      Debug.print(debug_show activeManagerCanisterId);
      if(activeManagerCanisterId == ""){
        activeManagerCanisterId := await createManagerCanister();
      };

      var monthlyBonuses: Nat8 = 2;
      var bankBalance: Nat16 = 1200;
      var playerIds: [T.PlayerId] = [];
      var captainId: T.PlayerId = 0;
      var goalGetterGameweek: T.GameweekNumber = 0;
      var goalGetterPlayerId: T.PlayerId = 0;
      var passMasterGameweek: T.GameweekNumber = 0;
      var passMasterPlayerId: T.PlayerId = 0;
      var noEntryGameweek: T.GameweekNumber = 0;
      var noEntryPlayerId: T.PlayerId = 0;
      var teamBoostGameweek: T.GameweekNumber = 0;
      var teamBoostClubId: T.ClubId = 0;
      var safeHandsGameweek: T.GameweekNumber = 0;
      var safeHandsPlayerId: T.PlayerId = 0;
      var captainFantasticGameweek: T.GameweekNumber = 0;
      var captainFantasticPlayerId: T.PlayerId = 0;
      var oneNationGameweek: T.GameweekNumber = 0;
      var oneNationCountryId: T.CountryId = 0;
      var prospectsGameweek: T.GameweekNumber = 0;
      var braceBonusGameweek: T.GameweekNumber = 0;
      var hatTrickHeroGameweek: T.GameweekNumber = 0;

      switch(dto){
        case (null){ };
        case (?foundDTO){

        if (invalidBonuses(null, foundDTO, systemState, players)) {
          return #err(#InvalidBonuses);
        };

        var bonusPlayed = foundDTO.goalGetterGameweek == systemState.pickTeamGameweek 
          or foundDTO.passMasterGameweek == systemState.pickTeamGameweek 
          or foundDTO.noEntryGameweek == systemState.pickTeamGameweek 
          or foundDTO.teamBoostGameweek == systemState.pickTeamGameweek 
          or foundDTO.safeHandsGameweek == systemState.pickTeamGameweek 
          or foundDTO.captainFantasticGameweek == systemState.pickTeamGameweek 
          or foundDTO.oneNationGameweek == systemState.pickTeamGameweek 
          or foundDTO.prospectsGameweek == systemState.pickTeamGameweek 
          or foundDTO.braceBonusGameweek == systemState.pickTeamGameweek 
          or foundDTO.hatTrickHeroGameweek == systemState.pickTeamGameweek;

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
        getManager : (principalId : T.PrincipalId) -> async ?T.Manager;
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
      
      let uniqueCanisterIdBuffer = Buffer.fromArray<T.CanisterId>(List.toArray(uniqueManagerCanisterIds));
      uniqueCanisterIdBuffer.add(canisterId);
      uniqueManagerCanisterIds := List.fromArray(Buffer.toArray(uniqueCanisterIdBuffer));
      activeManagerCanisterId := canisterId;
      return canisterId;
    };

    private func invalidBonuses(manager: ?T.Manager, updatedFantasyTeam : DTOs.UpdateTeamSelectionDTO, systemState: DTOs.SystemStateDTO, players : [DTOs.PlayerDTO]) : Bool {
      switch(manager){
        case (null){ };
        case (?foundManager){
          var bonusesPlayed: Int = 0;

          if (updatedFantasyTeam.goalGetterGameweek == systemState.pickTeamGameweek and foundManager.goalGetterGameweek != systemState.pickTeamGameweek) {
            bonusesPlayed += 1;
          };
          if (updatedFantasyTeam.passMasterGameweek == systemState.pickTeamGameweek and foundManager.passMasterGameweek != systemState.pickTeamGameweek) {
            bonusesPlayed += 1;
          };
          
          if (updatedFantasyTeam.noEntryGameweek == systemState.pickTeamGameweek and foundManager.noEntryGameweek != systemState.pickTeamGameweek) {
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
          
          if (updatedFantasyTeam.teamBoostGameweek == systemState.pickTeamGameweek and foundManager.teamBoostGameweek != systemState.pickTeamGameweek) {
            bonusesPlayed += 1;
          };
          if (updatedFantasyTeam.safeHandsGameweek == systemState.pickTeamGameweek and foundManager.safeHandsGameweek != systemState.pickTeamGameweek) {
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
          if (updatedFantasyTeam.captainFantasticGameweek == systemState.pickTeamGameweek and foundManager.captainFantasticGameweek != systemState.pickTeamGameweek) {
            bonusesPlayed += 1;
          };
          if (updatedFantasyTeam.oneNationGameweek == systemState.pickTeamGameweek and foundManager.oneNationGameweek != systemState.pickTeamGameweek) {
            bonusesPlayed += 1;
          };
          if (updatedFantasyTeam.prospectsGameweek == systemState.pickTeamGameweek and foundManager.prospectsGameweek != systemState.pickTeamGameweek) {
            bonusesPlayed += 1;
          };
          if (updatedFantasyTeam.braceBonusGameweek == systemState.pickTeamGameweek and foundManager.braceBonusGameweek != systemState.pickTeamGameweek) {
            bonusesPlayed += 1;
          };
          if (updatedFantasyTeam.hatTrickHeroGameweek == systemState.pickTeamGameweek and foundManager.hatTrickHeroGameweek != systemState.pickTeamGameweek) {
            bonusesPlayed += 1;
          };

          if (bonusesPlayed > 1) {
            return true;
          };      

          if(not systemState.seasonActive){
            return false;
          };    
          
          if(updatedFantasyTeam.goalGetterGameweek == systemState.pickTeamGameweek and 
            (foundManager.goalGetterGameweek != systemState.pickTeamGameweek and foundManager.goalGetterGameweek != 0)){
            return true;
          };
          
          if(updatedFantasyTeam.passMasterGameweek == systemState.pickTeamGameweek and 
            (foundManager.passMasterGameweek != systemState.pickTeamGameweek and foundManager.passMasterGameweek != 0)){
            return true;
          };
          
          if(updatedFantasyTeam.noEntryGameweek == systemState.pickTeamGameweek and 
            (foundManager.noEntryGameweek != systemState.pickTeamGameweek and foundManager.noEntryGameweek != 0)){
            return true;
          };
          
          if(updatedFantasyTeam.teamBoostGameweek == systemState.pickTeamGameweek and 
            (foundManager.teamBoostGameweek != systemState.pickTeamGameweek and foundManager.teamBoostGameweek != 0)){
            return true;
          };
          
          if(updatedFantasyTeam.safeHandsGameweek == systemState.pickTeamGameweek and 
            (foundManager.safeHandsGameweek != systemState.pickTeamGameweek and foundManager.safeHandsGameweek != 0)){
            return true;
          };
          
          if(updatedFantasyTeam.captainFantasticGameweek == systemState.pickTeamGameweek and 
            (foundManager.captainFantasticGameweek != systemState.pickTeamGameweek and foundManager.captainFantasticGameweek != 0)){
            return true;
          };
          
          if(updatedFantasyTeam.prospectsGameweek == systemState.pickTeamGameweek and 
            (foundManager.prospectsGameweek != systemState.pickTeamGameweek and foundManager.prospectsGameweek != 0)){
            return true;
          };
          
          if(updatedFantasyTeam.oneNationGameweek == systemState.pickTeamGameweek and 
            (foundManager.oneNationGameweek != systemState.pickTeamGameweek and foundManager.oneNationGameweek != 0)){
            return true;
          };
          
          if(updatedFantasyTeam.braceBonusGameweek == systemState.pickTeamGameweek and 
            (foundManager.braceBonusGameweek != systemState.pickTeamGameweek and foundManager.braceBonusGameweek != 0)){
            return true;
          };
          
          if(updatedFantasyTeam.hatTrickHeroGameweek == systemState.pickTeamGameweek and 
            (foundManager.hatTrickHeroGameweek != systemState.pickTeamGameweek and foundManager.hatTrickHeroGameweek != 0)){
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

    public func updateFavouriteClub(managerPrincipalId : T.PrincipalId, favouriteClubId : T.ClubId, systemState : DTOs.SystemStateDTO, activeClubs : [T.Club]) : async Result.Result<(), T.Error> {

      let isClubActive = Array.find(
        activeClubs,
        func(club : T.Club) : Bool {
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
          return await createNewManager(managerPrincipalId, "", favouriteClubId, null, "", null, systemState, []);
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

    public func updateProfilePicture(managerPrincipalId: T.PrincipalId, dto: DTOs.UpdateProfilePictureDTO, systemState: DTOs.SystemStateDTO) : async Result.Result<(), T.Error> {

      if (invalidProfilePicture(dto.profilePicture)) {

        return #err(#InvalidData);
      };

      let managerCanisterId = managerCanisterIds.get(managerPrincipalId);
      switch(managerCanisterId){
        case (null){
          return await createNewManager(managerPrincipalId, "", 0, ?dto.profilePicture, dto.extension, null, systemState, []);
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

    public func saveFantasyTeam(managerPrincipalId: T.PrincipalId, updatedFantasyTeamDTO : DTOs.UpdateTeamSelectionDTO, systemState : DTOs.SystemStateDTO, players : [DTOs.PlayerDTO]) : async Result.Result<(), T.Error> {
      Debug.print("Saving fantasy team in usermanager");
      
      if (systemState.onHold) {
        return #err(#SystemOnHold);
      };

      let teamValidResult = teamValid(updatedFantasyTeamDTO, players);
      Debug.print("Z");
      switch(teamValidResult){
        case (#ok _){ };
        case (#err errorResult){
          return #err(errorResult);
        }
      };

      let usernameUpdated = updatedFantasyTeamDTO.username != "";
      Debug.print("Y");
      
      if (usernameUpdated and not isUsernameValid(updatedFantasyTeamDTO.username)) {
        return #err(#InvalidData);
      };

      if (usernameUpdated and isUsernameTaken(updatedFantasyTeamDTO.username, managerPrincipalId)) {
        return #err(#InvalidData);
      };  
      Debug.print("X");
      
      let managerCanisterId = managerCanisterIds.get(managerPrincipalId);
      Debug.print("managerCanisterId");
      Debug.print(debug_show managerCanisterId);
     
      var result: ?Result.Result<(), T.Error> = null;
      switch(managerCanisterId){
        case (null){
          Debug.print("Creating new manager");
      
          result := ?(await createNewManager(managerPrincipalId, updatedFantasyTeamDTO.username, 0, null, "", ?updatedFantasyTeamDTO, systemState, players));
        };  
        case (?foundManagerCanisterId){
          Debug.print("Updating existing manager");
      
          result := ?(await updateFantasyTeam(foundManagerCanisterId, managerPrincipalId, updatedFantasyTeamDTO, systemState, players));
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
      Debug.print("checking team valid");
      Debug.print(debug_show updatedFantasyTeam);
      Debug.print(debug_show players);

      let newTeamPlayers = Array.filter<DTOs.PlayerDTO>(
        players,
        func(player : DTOs.PlayerDTO) : Bool {
          let playerId = player.id;
          let isPlayerIdInNewTeam = Array.find(
            updatedFantasyTeam.playerIds,
            func(id : Nat16) : Bool {
              return id == playerId;
            },
          );
          return Option.isSome(isPlayerIdInNewTeam);
        },
      );

      Debug.print(debug_show newTeamPlayers);

      let playerPositions = Array.map<DTOs.PlayerDTO, T.PlayerPosition>(newTeamPlayers, func(player : DTOs.PlayerDTO) : T.PlayerPosition { return player.position });
      let playerCount = playerPositions.size();

      Debug.print(debug_show playerCount);
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
      

      Debug.print(debug_show "A");
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

      Debug.print(debug_show "B");
      for ((key, value) in teamPlayerCounts.entries()) {
        if (value > 2) {

            return #err(#MoreThan2PlayersFromClub);
        };
      };

      Debug.print(debug_show "C");
      if (
        goalkeeperCount != 1 or defenderCount < 3 or defenderCount > 5 or midfielderCount < 3 or midfielderCount > 5 or forwardCount < 1 or forwardCount > 3,
      ) {

            return #err(#NumberPerPositionError);
      };

      Debug.print(debug_show "D");
      if (not captainInTeam) {
            return #err(#SelectedCaptainNotInTeam);
      };

      return #ok();
    };

     private func updateFantasyTeam(managerCanisterId: T.CanisterId, managerPrincipalId: T.PrincipalId, dto : DTOs.UpdateTeamSelectionDTO, systemState: DTOs.SystemStateDTO, allPlayers: [DTOs.PlayerDTO]) : async Result.Result<(), T.Error>{
       Debug.print(debug_show "Update Manager");
      let manager_canister = actor (managerCanisterId) : actor {
        getManager : T.PrincipalId -> async ?T.Manager;
        updateTeamSelection : (updateManagerDTO : DTOs.TeamUpdateDTO, transfersAvailable : Nat8, monthlyBonuses : Nat8, newBankBalance : Nat16) -> async Result.Result<(), T.Error>;
      };

      let manager = await manager_canister.getManager(managerPrincipalId);  
      Debug.print(debug_show "manager");
      Debug.print(debug_show manager);
          
      if (invalidBonuses(manager, dto, systemState, allPlayers)) {
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
          var transfersAvailable = 2;
          if(systemState.pickTeamGameweek > 1){
            let transfersAvailable = getTransfersAvailable(foundManager, dto.playerIds, allPlayers);
            if (transfersAvailable < 0) {
              return #err(#TooManyTransfers);
            };
          };
          
          var monthlyBonuses = getMonthlyBonuses(foundManager, dto, systemState);
          var newBankBalance = getNewBankBalance(foundManager, dto, allPlayers);
          return await manager_canister.updateTeamSelection({
            principalId = managerPrincipalId;
            updatedTeamSelection = dto;
          }, Nat8.fromNat(Nat64.toNat(Nat64.fromIntWrap(transfersAvailable))), monthlyBonuses, newBankBalance);
        }
      };
      return #ok;
    };

    private func overspent(currentBankBalance: Nat16, existingPlayerIds: [T.PlayerId], updatedPlayerIds: [T.PlayerId], allPlayers: [DTOs.PlayerDTO]) : Bool{
      
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

    private func getTransfersAvailable(manager: T.Manager, updatedPlayerIds: [T.PlayerId], allPlayers: [DTOs.PlayerDTO]) : Int {
      

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

      let transfersAvailable: Int = Int64.toInt(Int64.fromNat64(Nat64.fromNat(Nat8.toNat(manager.transfersAvailable)))) -  Array.size(additions);
      return transfersAvailable;
    };

     private func getMonthlyBonuses(manager: T.Manager, dto: DTOs.UpdateTeamSelectionDTO, systemState: DTOs.SystemStateDTO) : Nat8 {
      
      var monthlyBonuses = manager.monthlyBonusesAvailable;
      if(monthlyBonuses == 0){
        return 0;
      };
      
      

      var newBonusPlayed = 
        (dto.goalGetterGameweek == systemState.pickTeamGameweek and manager.goalGetterGameweek == 0) 
        or (dto.passMasterGameweek == systemState.pickTeamGameweek and manager.passMasterGameweek == 0)
        or (dto.noEntryGameweek == systemState.pickTeamGameweek and manager.noEntryGameweek == 0)
        or (dto.teamBoostGameweek == systemState.pickTeamGameweek and manager.teamBoostGameweek == 0)
        or (dto.safeHandsGameweek == systemState.pickTeamGameweek and manager.safeHandsGameweek == 0)
        or (dto.captainFantasticGameweek == systemState.pickTeamGameweek and manager.captainFantasticGameweek == 0)
        or (dto.oneNationGameweek == systemState.pickTeamGameweek and manager.oneNationGameweek == 0)
        or (dto.prospectsGameweek == systemState.pickTeamGameweek and manager.prospectsGameweek == 0)
        or (dto.braceBonusGameweek == systemState.pickTeamGameweek and manager.braceBonusGameweek == 0)
        or (dto.hatTrickHeroGameweek == systemState.pickTeamGameweek and manager.hatTrickHeroGameweek == 0);
      
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



    //stable getters and setters

    

    public func getStableManagerCanisterIds() : [(T.PrincipalId, T.CanisterId)] {
      return Iter.toArray(managerCanisterIds.entries());
    };

    public func setStableManagerCanisterIds(stable_manager_canister_ids : [(T.PrincipalId, T.CanisterId)]) : () {
      let canisterIds : TrieMap.TrieMap<T.PrincipalId, T.CanisterId> = TrieMap.TrieMap<T.PrincipalId, T.CanisterId>(Text.equal, Text.hash);

      for (canisterId in Iter.fromArray(stable_manager_canister_ids)) {
        canisterIds.put(canisterId);
      };
      managerCanisterIds := canisterIds;
    };

    public func getStableUsernames() : [(T.PrincipalId, Text)] {
      return Iter.toArray(usernames.entries());
    };

    public func setStableUsernames(stable_manager_usernames : [(T.PrincipalId, Text)]) : () {
      let usernameMap : TrieMap.TrieMap<T.PrincipalId, T.CanisterId> = TrieMap.TrieMap<T.PrincipalId, T.CanisterId>(Text.equal, Text.hash);

      for (username in Iter.fromArray(stable_manager_usernames)) {
        usernameMap.put(username);
      };
      usernames := usernameMap;
    };


    public func getStableUniqueManagerCanisterIds() : [T.CanisterId] {
      return List.toArray(uniqueManagerCanisterIds);
    };

    public func setStableUniqueManagerCanisterIds(stable_unique_manager_canister_ids : [T.CanisterId]) : () {
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

    public func setStableActiveManagerCanisterId(stable_active_manager_canister_id : T.CanisterId) : () {
      activeManagerCanisterId := stable_active_manager_canister_id;
    };
  }
};
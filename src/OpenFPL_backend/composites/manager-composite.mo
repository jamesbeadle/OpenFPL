import Array "mo:base/Array";
import Blob "mo:base/Blob";
import Iter "mo:base/Iter";
import List "mo:base/List";
import Nat16 "mo:base/Nat16";
import Result "mo:base/Result";
import Text "mo:base/Text";
import DTOs "../DTOs";
import T "../types";
import Nat8 "mo:base/Nat8";
import Nat64 "mo:base/Nat64";
import Cycles "mo:base/ExperimentalCycles";
import Principal "mo:base/Principal";
import Buffer "mo:base/Buffer";
import Option "mo:base/Option";
import Time "mo:base/Time";
import Int16 "mo:base/Int16";
import Management "../modules/Management";
import ManagerCanister "../canister_definitions/manager-canister";
import Rewards "./rewards-composite";
import Utilities "../utils/utilities";
import TrieMap "mo:base/TrieMap";
import Debug "mo:base/Debug";
import Nat "mo:base/Nat";
import Int64 "mo:base/Int64";
import Int "mo:base/Int";
import Environment "../utils/Environment";

module {

  public class ManagerComposite() {

    private let rewards : Rewards.Rewards = Rewards.Rewards();
    private var managerCanisterIds : TrieMap.TrieMap<T.PrincipalId, T.CanisterId> = TrieMap.TrieMap<T.PrincipalId, T.CanisterId>(Text.equal, Text.hash);
    private var managerUsernames : TrieMap.TrieMap<T.PrincipalId, Text> = TrieMap.TrieMap<T.PrincipalId, Text>(Text.equal, Text.hash);
    private var uniqueManagerCanisterIds : List.List<T.CanisterId> = List.nil();
    private var totalManagers : Nat = 0;
    private var activeManagerCanisterId : T.CanisterId = "";
    private var storeCanisterId : ?((canisterId : Text) -> async ()) = null;
    public func setStoreCanisterIdFunction(
      _storeCanisterId : (canisterId : Text) -> async (),
    ) {
      storeCanisterId := ?_storeCanisterId;
    };
    private var recordSystemEvent : ?((eventLog: T.EventLogEntry) -> ()) = null;
    public func setRecordSystemEventFunction(
      _recordSystemEvent : ((eventLog: T.EventLogEntry) -> ()),
    ) {
      recordSystemEvent := ?_recordSystemEvent;
    };

    public func getManager(principalId : T.PrincipalId, calculationSeasonId : T.SeasonId, weeklyLeaderboardEntry : ?DTOs.LeaderboardEntryDTO, monthlyLeaderboardEntry : ?DTOs.LeaderboardEntryDTO, seasonLeaderboardEntry : ?DTOs.LeaderboardEntryDTO) : async Result.Result<DTOs.ManagerDTO, T.Error> {

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
              for (managerSeason in Iter.fromList(foundManager.history)) {
                if (managerSeason.seasonId == calculationSeasonId) {

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
                    principalId = principalId;
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
                    weeklyPoints = weeklyPoints;
                    monthlyPoints = monthlyPoints;
                    seasonPoints = seasonPoints;
                    privateLeagueMemberships = List.toArray(foundManager.privateLeagueMemberships);
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

      for (managerUsername in managerUsernames.entries()){
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
                    privateLeagueMemberships = List.toArray(foundManager.privateLeagueMemberships);
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

    public func getProfile(principalId : Text) : async Result.Result<DTOs.ProfileDTO, T.Error> {
      let emptyDTO : DTOs.ProfileDTO = {
        principalId = principalId;
        username = "";
        termsAccepted = false;
        profilePicture = null;
        profilePictureType = "";
        favouriteClubId = 0;
        createDate = 0;
      };
      let managerCanisterId = managerCanisterIds.get(principalId);
      switch (managerCanisterId) {
        case (null) {
          return #ok(emptyDTO);
        };
        case (?foundCanisterId) {
          let manager_canister = actor (foundCanisterId) : actor {
            getManager : T.PrincipalId -> async ?T.Manager;
          };

          let manager = await manager_canister.getManager(principalId);
          switch (manager) {
            case (null) {
              return #ok(emptyDTO);
            };
            case (?foundManager) {
              let profileDTO : DTOs.ProfileDTO = {
                principalId = principalId;
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
      };
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
                countrymenGameweek = foundManager.countrymenGameweek;
                countrymenCountryId = foundManager.countrymenCountryId;
                prospectsGameweek = foundManager.prospectsGameweek;
                braceBonusGameweek = foundManager.braceBonusGameweek;
                hatTrickHeroGameweek = foundManager.hatTrickHeroGameweek;
                transferWindowGameweek = foundManager.transferWindowGameweek;
              };

              return #ok(pickTeamDTO);
            };
          };
        };
      };
    };

    public func getTotalManagers() : Nat {
      return totalManagers;
    };

    public func getManagerUsername(principalId: Text) : ?Text {
      return managerUsernames.get(principalId);
    };

    public func getManagerCanisterId(principalId: Text) : ?T.CanisterId {
      return managerCanisterIds.get(principalId);
    };

    public func getManagerCanisterIds() : TrieMap.TrieMap<T.PrincipalId, T.CanisterId> {
      return managerCanisterIds;
    };

    public func saveFantasyTeam(managerPrincipalId: T.PrincipalId, updatedFantasyTeamDTO : DTOs.UpdateTeamSelectionDTO, systemState : T.SystemState, players : [DTOs.PlayerDTO]) : async Result.Result<(), T.Error> {
      if (systemState.onHold) {
        return #err(#SystemOnHold);
      };
      if (invalidTeamComposition(updatedFantasyTeamDTO, players)) {
        return #err(#InvalidTeamError);
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
          result := ?(await createNewManager(managerPrincipalId, updatedFantasyTeamDTO.username, 0, null, "", ?updatedFantasyTeamDTO, systemState, players));
        };  
        case (?foundManagerCanisterId){
          result := ?(await updateFantasyTeam(foundManagerCanisterId, managerPrincipalId, updatedFantasyTeamDTO, systemState, players));
        }
      };

      switch(result){
        case null{
          return #err(#NotFound);
        };
        case (?#ok ok_result){
          if(usernameUpdated){
            managerUsernames.put(managerPrincipalId, updatedFantasyTeamDTO.username);
          };
          return #ok(ok_result);
        };
        case (?#err err_result) {
          return #err(err_result);
        };
      };
    };

    private func updateFantasyTeam(managerCanisterId: T.CanisterId, managerPrincipalId: T.PrincipalId, dto : DTOs.UpdateTeamSelectionDTO, systemState: T.SystemState, allPlayers: [DTOs.PlayerDTO]) : async Result.Result<(), T.Error>{
      let manager_canister = actor (managerCanisterId) : actor {
        getManager : T.PrincipalId -> async ?T.Manager;
        updateTeamSelection : (updateManagerDTO : DTOs.TeamUpdateDTO, transfersAvailable : Nat8, monthlyBonuses : Nat8, newBankBalance : Nat16) -> async Result.Result<(), T.Error>;
      };

      let manager = await manager_canister.getManager(managerPrincipalId);      
      if (invalidBonuses(manager, dto, systemState, allPlayers)) {
        return #err(#InvalidTeamError);
      };

      switch(manager){
        case (null){
          return #err(#NotFound);
        };
        case (?foundManager){

          if(overspent(foundManager.bankQuarterMillions, foundManager.playerIds, dto.playerIds, allPlayers)){

            return #err(#InvalidTeamError);
          };
          var transfersAvailable = 2;
          if(systemState.pickTeamGameweek > 1){
            let transfersAvailable = getTransfersAvailable(foundManager, dto.playerIds, allPlayers);
            if (transfersAvailable < 0) {
              return #err(#InvalidTeamError);
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

    private func createNewManager(managerPrincipalId: T.PrincipalId, username: Text, favouriteClubId: T.ClubId, profilePicture: ?Blob, profilePictureType: Text, dto : ?DTOs.UpdateTeamSelectionDTO, systemState: T.SystemState, players: [DTOs.PlayerDTO]) : async Result.Result<(), T.Error>{
      
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
      var countrymenGameweek: T.GameweekNumber = 0;
      var countrymenCountryId: T.CountryId = 0;
      var prospectsGameweek: T.GameweekNumber = 0;
      var braceBonusGameweek: T.GameweekNumber = 0;
      var hatTrickHeroGameweek: T.GameweekNumber = 0;

      switch(dto){
        case (null){ };
        case (?foundDTO){

        if (invalidBonuses(null, foundDTO, systemState, players)) {
          return #err(#InvalidTeamError);
        };

        var bonusPlayed = foundDTO.goalGetterGameweek == systemState.pickTeamGameweek 
          or foundDTO.passMasterGameweek == systemState.pickTeamGameweek 
          or foundDTO.noEntryGameweek == systemState.pickTeamGameweek 
          or foundDTO.teamBoostGameweek == systemState.pickTeamGameweek 
          or foundDTO.safeHandsGameweek == systemState.pickTeamGameweek 
          or foundDTO.captainFantasticGameweek == systemState.pickTeamGameweek 
          or foundDTO.countrymenGameweek == systemState.pickTeamGameweek 
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
          countrymenGameweek := foundDTO.countrymenGameweek;
          countrymenCountryId := foundDTO.countrymenCountryId;
          prospectsGameweek := foundDTO.prospectsGameweek;
          braceBonusGameweek := foundDTO.braceBonusGameweek;
          hatTrickHeroGameweek := foundDTO.hatTrickHeroGameweek;
        };
      };
      
      let newManager : T.Manager = {
        principalId = managerPrincipalId;
        username = username;
        favouriteClubId = favouriteClubId;
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
        countrymenGameweek = countrymenGameweek;
        countrymenCountryId = countrymenCountryId;
        prospectsGameweek = prospectsGameweek;
        braceBonusGameweek = braceBonusGameweek;
        hatTrickHeroGameweek = hatTrickHeroGameweek;
        transferWindowGameweek = 0;
        history = List.nil();
        ownedPrivateLeagues = List.nil();
        privateLeagueMemberships = List.nil();
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
        switch(recordSystemEvent){
          case null {};
          case (?function){
            function({
              eventDetail = "New manager canister created, ID: " # activeManagerCanisterId;
              eventId = 0;
              eventTime = Time.now();
              eventTitle = "New Manager Canister Created";
              eventType = #ManagerCanisterCreated;
            });
          }
        };
        return await new_manager_canister.addNewManager(newManager);
      };

      totalManagers := totalManagers + 1;
      managerCanisterIds.put(managerPrincipalId, activeManagerCanisterId);
      return await manager_canister.addNewManager(newManager);
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
      
      //get the players in the team
      
      let newPlayers = Array.filter<DTOs.PlayerDTO>(
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

      //get the players in the old team
      let oldPlayers = Array.filter<DTOs.PlayerDTO>(
        allPlayers,
        func(player : DTOs.PlayerDTO) : Bool {
          let playerId = player.id;
          let isPlayerInOldTeam = Array.find(
            manager.playerIds,
            func(id : Nat16) : Bool {
              return id == playerId;
            },
          );
          return Option.isSome(isPlayerInOldTeam);
        },
      );

      let transfersAvailable: Int = Int64.toInt(Int64.fromNat64(Nat64.fromNat(Nat8.toNat(manager.transfersAvailable))));
      let totalNewPlayers: Int = Array.size(newPlayers);
      let totalOldPlayers: Int = Array.size(oldPlayers);
      if(totalNewPlayers != totalOldPlayers){
        return 0;
      };
      return transfersAvailable - totalNewPlayers;
    };

    private func getMonthlyBonuses(manager: T.Manager, dto: DTOs.UpdateTeamSelectionDTO, systemState: T.SystemState) : Nat8 {
      
      var monthlyBonuses = manager.monthlyBonusesAvailable;
      
      var bonusPlayed = dto.goalGetterGameweek == systemState.pickTeamGameweek 
        or dto.passMasterGameweek == systemState.pickTeamGameweek 
        or dto.noEntryGameweek == systemState.pickTeamGameweek 
        or dto.teamBoostGameweek == systemState.pickTeamGameweek 
        or dto.safeHandsGameweek == systemState.pickTeamGameweek 
        or dto.captainFantasticGameweek == systemState.pickTeamGameweek 
        or dto.countrymenGameweek == systemState.pickTeamGameweek 
        or dto.prospectsGameweek == systemState.pickTeamGameweek 
        or dto.braceBonusGameweek == systemState.pickTeamGameweek 
        or dto.hatTrickHeroGameweek == systemState.pickTeamGameweek;
      
      if(bonusPlayed){
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

    private func invalidBonuses(manager: ?T.Manager, updatedFantasyTeam : DTOs.UpdateTeamSelectionDTO, systemState : T.SystemState, players : [DTOs.PlayerDTO]) : Bool {
      var bonusesPlayed: Int = 0;
      if (updatedFantasyTeam.goalGetterGameweek == systemState.pickTeamGameweek) {
        bonusesPlayed += 1;
      };
      if (updatedFantasyTeam.passMasterGameweek == systemState.pickTeamGameweek) {
        bonusesPlayed += 1;
      };
      
      if (updatedFantasyTeam.noEntryGameweek == systemState.pickTeamGameweek) {
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
      
      if (updatedFantasyTeam.teamBoostGameweek == systemState.pickTeamGameweek) {
        bonusesPlayed += 1;
      };
      if (updatedFantasyTeam.safeHandsGameweek == systemState.pickTeamGameweek) {
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
      if (updatedFantasyTeam.captainFantasticGameweek == systemState.pickTeamGameweek) {
        bonusesPlayed += 1;
      };
      if (updatedFantasyTeam.countrymenGameweek == systemState.pickTeamGameweek) {
        bonusesPlayed += 1;
      };
      if (updatedFantasyTeam.prospectsGameweek == systemState.pickTeamGameweek) {
        bonusesPlayed += 1;
      };
      if (updatedFantasyTeam.braceBonusGameweek == systemState.pickTeamGameweek) {
        bonusesPlayed += 1;
      };
      if (updatedFantasyTeam.hatTrickHeroGameweek == systemState.pickTeamGameweek) {
        bonusesPlayed += 1;
      };

      if (bonusesPlayed > 1) {
        return true;
      };
      
      switch(manager){
        case (null){ };
        case (?foundManager){
          
          if(updatedFantasyTeam.goalGetterGameweek == systemState.pickTeamGameweek and foundManager.goalGetterGameweek != 0){
            return true;
          };
          if(updatedFantasyTeam.passMasterGameweek == systemState.pickTeamGameweek and foundManager.passMasterGameweek != 0){
            return true;
          };
          if(updatedFantasyTeam.noEntryGameweek == systemState.pickTeamGameweek and foundManager.noEntryGameweek != 0){
            return true;
          };
          if(updatedFantasyTeam.teamBoostGameweek == systemState.pickTeamGameweek and foundManager.teamBoostGameweek != 0){
            return true;
          };
          if(updatedFantasyTeam.safeHandsGameweek == systemState.pickTeamGameweek and foundManager.safeHandsGameweek != 0){
            return true;
          };
          if(updatedFantasyTeam.captainFantasticGameweek == systemState.pickTeamGameweek and foundManager.captainFantasticGameweek != 0){
            return true;
          };
          if(updatedFantasyTeam.prospectsGameweek == systemState.pickTeamGameweek and foundManager.prospectsGameweek != 0){
            return true;
          };
          if(updatedFantasyTeam.countrymenGameweek == systemState.pickTeamGameweek and foundManager.countrymenGameweek != 0){
            return true;
          };
          if(updatedFantasyTeam.braceBonusGameweek == systemState.pickTeamGameweek and foundManager.braceBonusGameweek != 0){
            return true;
          };
          if(updatedFantasyTeam.hatTrickHeroGameweek == systemState.pickTeamGameweek and foundManager.hatTrickHeroGameweek != 0){
            return true;
          };


          var monthlyBonuses: Int = 0;
          let foundManagerBonuses: Nat8 = foundManager.monthlyBonusesAvailable;
          
          if(foundManagerBonuses > 0){
            monthlyBonuses := Int64.toInt(Int64.fromNat64(Nat64.fromNat(Nat8.toNat(foundManager.monthlyBonusesAvailable))));
          };

          monthlyBonuses -= bonusesPlayed;

          //var monthlyBonuses: Int = Int64.toInt(Int64.fromNat64(Nat64.fromNat(Nat8.toNat(foundManager.monthlyBonusesAvailable)))) - bonusesPlayed;

          if (monthlyBonuses < 0) {
            return true;
          };
        };
      };
      return false;
    };

    private func invalidTeamComposition(updatedFantasyTeam : DTOs.UpdateTeamSelectionDTO, players : [DTOs.PlayerDTO]) : Bool {

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

      let playerPositions = Array.map<DTOs.PlayerDTO, T.PlayerPosition>(newTeamPlayers, func(player : DTOs.PlayerDTO) : T.PlayerPosition { return player.position });
      let playerCount = playerPositions.size();
      if (playerCount != 11) {
        return false;
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
            return true;
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
          return true;
        };
      };

      if (
        goalkeeperCount != 1 or defenderCount < 3 or defenderCount > 5 or midfielderCount < 3 or midfielderCount > 5 or forwardCount < 1 or forwardCount > 3,
      ) {
        return true;
      };

      if (not captainInTeam) {
        return true;
      };

      return false;
    };

    public func updateUsername(managerPrincipalId : T.PrincipalId, username: Text, systemState: T.SystemState) : async Result.Result<(), T.Error> {
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
          managerUsernames.put(managerPrincipalId, username);
          return await manager_canister.updateUsername(updatedUsernameDTO);
        }
      };
    };

    public func updateFavouriteClub(managerPrincipalId : T.PrincipalId, favouriteClubId : T.ClubId, systemState : T.SystemState, activeClubs : [T.Club]) : async Result.Result<(), T.Error> {

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
            updatedFavouriteClub = {favouriteClubId};
          };
          return await manager_canister.updateFavouriteClub(updatedUsernameDTO);
        }
      };
    };

    public func updateProfilePicture(managerPrincipalId: T.PrincipalId, dto: DTOs.UpdateProfilePictureDTO, systemState: T.SystemState) : async Result.Result<(), T.Error> {

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
      for (managerUsername in managerUsernames.entries()) {
        if (managerUsername.1 == username and managerUsername.0 != principalId) {
          return true;
        };
      };

      return false;
    };

    public func searchByUsername(username : Text) : async ?DTOs.ManagerDTO {
      
      var principalId = "";
      
      label usernameLoop for (managerUsername in managerUsernames.entries()) {
        if (managerUsername.1 == username) {
          principalId := managerUsername.0;
          break usernameLoop;
        };
      };

      label managerCanisterLoop for (managerCanisterId in managerCanisterIds.entries()){
        if(managerCanisterId.0 == principalId){
          
          let manager_canister = actor (managerCanisterId.1) : actor {
            getManager : T.PrincipalId -> async ?T.Manager;
          };

          let manager = await manager_canister.getManager(principalId);
          switch(manager){
            case (null){ return null; };
            case (?foundManager){

              let dto : DTOs.ManagerDTO = {
                principalId = foundManager.principalId;
                username = foundManager.username;
                profilePicture = foundManager.profilePicture;
                favouriteClubId = foundManager.favouriteClubId;
                createDate  = foundManager.createDate;
                gameweeks = [];
                weeklyPosition = 0;
                monthlyPosition = 0;
                seasonPosition = 0;
                weeklyPositionText  = "";
                monthlyPositionText = "";
                seasonPositionText = "";
                weeklyPoints = 0;
                monthlyPoints = 0;
                seasonPoints = 0;
                privateLeagueMemberships = [];

              };
              return ?dto;

            }
          }
        };
      };

      return null;
    };

    public func getFavouriteClub(principalId : Text) : async Result.Result<T.ClubId, T.Error> {
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
            case (null) { return #err(#NotFound) };
            case (?foundManager) {
              return #ok(foundManager.favouriteClubId);
            };
          };
        };
      };
    };

    private func invalidProfilePicture(profilePicture : Blob) : Bool {
      let sizeInKB = Array.size(Blob.toArray(profilePicture)) / 1024;
      return (sizeInKB <= 0 or sizeInKB > 500);
    };

    public func calculateFantasyTeamScores(allPlayersList : [(T.PlayerId, DTOs.PlayerScoreDTO)], seasonId : T.SeasonId, gameweek : T.GameweekNumber, month : T.CalendarMonth) : async () {
      var allPlayers = TrieMap.TrieMap<T.PlayerId, DTOs.PlayerScoreDTO>(Utilities.eqNat16, Utilities.hashNat16);
      for ((key, value) in Iter.fromArray(allPlayersList)) {
        allPlayers.put(key, value);
      };

      for (canisterId in Iter.fromList(uniqueManagerCanisterIds)) {
        let manager_canister = actor (canisterId) : actor {
          calculateFantasyTeamScores : (allPlayersList : [(T.PlayerId, DTOs.PlayerScoreDTO)], seasonId : T.SeasonId, gameweek : T.GameweekNumber, month : T.CalendarMonth) -> async ();
        };

        return await manager_canister.calculateFantasyTeamScores(allPlayersList, seasonId, gameweek, month);
      };
    };

    public func removePlayerFromTeams(playerId : T.PlayerId, allPlayers : [DTOs.PlayerDTO]) : async () {
      for (canisterId in Iter.fromList(uniqueManagerCanisterIds)) {

        let manager_canister = actor (canisterId) : actor {
          removePlayerFromTeams : (playerId : T.PlayerId, allPlayers : [DTOs.PlayerDTO]) -> async ();
        };

        await manager_canister.removePlayerFromTeams(playerId, allPlayers);
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

    public func resetBonusesAvailable() : async () {
      for (canisterId in Iter.fromList(uniqueManagerCanisterIds)) {

        let manager_canister = actor (canisterId) : actor {
          resetBonusesAvailable : () -> async ();
        };

        await manager_canister.resetBonusesAvailable();
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

    public func resetFantasyTeams(seasonId : T.SeasonId) : async () {
      for (canisterId in Iter.fromList(uniqueManagerCanisterIds)) {

        let manager_canister = actor (canisterId) : actor {
          resetFantasyTeams : T.SeasonId -> async ();
        };

        await manager_canister.resetFantasyTeams(seasonId);
      };
    };

    public func payWeeklyRewards(defaultAccount: Principal, rewardPool : T.RewardPool, weeklyLeaderboard : DTOs.WeeklyLeaderboardDTO, filters: DTOs.GameweekFiltersDTO, fixtures : List.List<DTOs.FixtureDTO>) : async () {
      await rewards.distributeWeeklyRewards(defaultAccount, rewardPool.weeklyLeaderboardPool, weeklyLeaderboard);
      await rewards.distributeHighestScoringPlayerRewards(defaultAccount, filters.seasonId, filters.gameweek, rewardPool.highestScoringMatchPlayerPool, fixtures, uniqueManagerCanisterIds);
      await rewards.distributeWeeklyATHScoreRewards(defaultAccount, rewardPool.allTimeWeeklyHighScorePool, weeklyLeaderboard);
    };

    public func payMonthlyRewards(defaultAccount: Principal, rewardPool : T.RewardPool, monthlyLeaderboard : DTOs.ClubLeaderboardDTO) : async () {
      await rewards.distributeMonthlyRewards(defaultAccount, rewardPool, monthlyLeaderboard, uniqueManagerCanisterIds);
    };

    public func distributeMonthlyATHScoreRewards(defaultAccount: Principal, rewardPool : T.RewardPool, monthlyLeaderboards : [DTOs.ClubLeaderboardDTO]) : async () {
      await rewards.distributeMonthlyATHScoreRewards(defaultAccount, rewardPool.allTimeMonthlyHighScorePool, monthlyLeaderboards);
    };

    public func paySeasonRewards(defaultAccount: Principal, rewardPool : T.RewardPool, seasonLeaderboard : DTOs.SeasonLeaderboardDTO, players : [DTOs.PlayerDTO], seasonId : T.SeasonId) : async () {
      await rewards.distributeSeasonRewards(defaultAccount, rewardPool.seasonLeaderboardPool , seasonLeaderboard);
      await rewards.distributeSeasonATHScoreRewards(defaultAccount, rewardPool.allTimeSeasonHighScorePool, seasonLeaderboard);
      await rewards.distributeMostValuableTeamRewards(defaultAccount, rewardPool.mostValuableTeamPool, players, seasonId, uniqueManagerCanisterIds);
    };

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

    public func getStableManagerUsernames() : [(T.PrincipalId, Text)] {
      return Iter.toArray(managerUsernames.entries());
    };

    public func setStableManagerUsernames(stable_manager_usernames : [(T.PrincipalId, Text)]) : () {
      let usernames : TrieMap.TrieMap<T.PrincipalId, T.CanisterId> = TrieMap.TrieMap<T.PrincipalId, T.CanisterId>(Text.equal, Text.hash);

      for (username in Iter.fromArray(stable_manager_usernames)) {
        usernames.put(username);
      };
      managerUsernames := usernames;
    };

    public func getStableUniqueManagerCanisterIds() : [T.CanisterId] {
      return List.toArray(uniqueManagerCanisterIds);
    };

    public func setStableUniqueManagerCanisterIds(stable_unique_manager_canister_ids : [T.CanisterId]) : () {
      let canisterIdBuffer = Buffer.fromArray<T.CanisterId>([]);

      for (canisterId in Iter.fromArray(stable_unique_manager_canister_ids)) {
        canisterIdBuffer.add(canisterId);
      };
      uniqueManagerCanisterIds := List.fromArray(Buffer.toArray(canisterIdBuffer));
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

    public func getStableTeamValueLeaderboards() : [(T.SeasonId, T.TeamValueLeaderboard)] {
      return rewards.getStableTeamValueLeaderboards();
    };

    public func setStableTeamValueLeaderboards(stable_team_value_leaderboards : [(T.SeasonId, T.TeamValueLeaderboard)]) {
      return rewards.setStableTeamValueLeaderboards(stable_team_value_leaderboards);
    };

    public func getStableSeasonRewards() : [T.SeasonRewards] {
      return rewards.getStableSeasonRewards();
    };

    public func setStableSeasonRewards(stable_season_rewards : [T.SeasonRewards]) {
      return rewards.setStableSeasonRewards(stable_season_rewards);
    };

    public func getStableMonthlyRewards() : [T.MonthlyRewards] {
      return rewards.getStableMonthlyRewards();
    };

    public func setStableMonthlyRewards(stable_monthly_rewards : [T.MonthlyRewards]) {
      return rewards.setStableMonthlyRewards(stable_monthly_rewards);
    };

    public func getStableWeeklyRewards() : [T.WeeklyRewards] {
      return rewards.getStableWeeklyRewards();
    };

    public func setStableWeeklyRewards(stable_weekly_rewards : [T.WeeklyRewards]) {
      return rewards.setStableWeeklyRewards(stable_weekly_rewards);
    };

    public func getStableMostValuableTeamRewards() : [T.RewardsList] {
      return rewards.getStableMostValuableTeamRewards();
    };

    public func setStableMostValuableTeamRewards(stable_most_valuable_team_rewards : [T.RewardsList]) {
      return rewards.setStableMostValuableTeamRewards(stable_most_valuable_team_rewards);
    };

    public func getStableHighestScoringPlayerRewards() : [T.RewardsList] {
      return rewards.getStableHighestScoringPlayerRewards();
    };

    public func setStableHighestScoringPlayerRewards(stable_highest_scoring_player_rewards : [T.RewardsList]) {
      return rewards.setStableHighestScoringPlayerRewards(stable_highest_scoring_player_rewards);
    };

    public func getStableWeeklyATHScores() : [T.HighScoreRecord] {
      return rewards.getStableWeeklyATHScores();
    };

    public func setStableWeeklyATHScores(stable_weekly_ath_scores : [T.HighScoreRecord]) {
      return rewards.setStableWeeklyATHScores(stable_weekly_ath_scores);
    };

    public func getStableMonthlyATHScores() : [T.HighScoreRecord] {
      return rewards.getStableMonthlyATHScores();
    };

    public func setStableMonthlyATHScores(stable_monthly_ath_scores : [T.HighScoreRecord]) {
      return rewards.setStableMonthlyATHScores(stable_monthly_ath_scores);
    };

    public func getStableSeasonATHScores() : [T.HighScoreRecord] {
      return rewards.getStableSeasonATHScores();
    };

    public func setStableSeasonATHScores(stable_season_ath_scores : [T.HighScoreRecord]) {
      return rewards.setStableMonthlyATHScores(stable_season_ath_scores);
    };

    public func getStableWeeklyATHPrizePool() : Nat64 {
      return rewards.getStableWeeklyATHPrizePool();
    };

    public func setStableWeeklyATHPrizePool(stable_weekly_ath_prize_pool : Nat64) {
      return rewards.setStableWeeklyATHPrizePool(stable_weekly_ath_prize_pool);
    };

    public func getStableMonthlyATHPrizePool() : Nat64 {
      return rewards.getStableMonthlyATHPrizePool();
    };

    public func setStableMonthlyATHPrizePool(stable_monthly_ath_prize_pool : Nat64) {
      return rewards.setStableMonthlyATHPrizePool(stable_monthly_ath_prize_pool);
    };

    public func getStableSeasonATHPrizePool() : Nat64 {
      return rewards.getSeasonATHPrizePool();
    };

    public func setStableSeasonATHPrizePool(stable_season_ath_prize_pool : Nat64) {
      return rewards.setSeasonATHPrizePool(stable_season_ath_prize_pool);
    };

    private func createManagerCanister() : async Text {
      Cycles.add<system>(2_000_000_000_000);
      let canister = await ManagerCanister._ManagerCanister();
      let IC : Management.Management = actor (Environment.Default);
      let principal = ?Principal.fromText(Environment.BACKEND_CANISTER_ID);
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

    public func getTotalCanisters() : Nat{
      return managerCanisterIds.size();
    };
  };
};

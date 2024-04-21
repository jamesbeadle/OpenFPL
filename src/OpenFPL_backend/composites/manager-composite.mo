import DTOs "../DTOs";
import T "../types";
import Result "mo:base/Result";
import Blob "mo:base/Blob";
import Text "mo:base/Text";
import List "mo:base/List";
import Iter "mo:base/Iter";
import Array "mo:base/Array";
import Nat16 "mo:base/Nat16";
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
import Environment "../utils/Environment";

module {

  public class ManagerComposite() {

    private var managerCanisterIds : TrieMap.TrieMap<T.PrincipalId, T.CanisterId> = TrieMap.TrieMap<T.PrincipalId, T.CanisterId>(Text.equal, Text.hash);
    private var managerUsernames : TrieMap.TrieMap<T.PrincipalId, Text> = TrieMap.TrieMap<T.PrincipalId, Text>(Text.equal, Text.hash);
    private var uniqueManagerCanisterIds : List.List<T.CanisterId> = List.nil();

    private var totalManagers : Nat = 0;
    private var activeManagerCanisterId : T.CanisterId = "";

    private var storeCanisterId : ?((canisterId : Text) -> async ()) = null;

    private let rewards : Rewards.Rewards = Rewards.Rewards();

    public func setStoreCanisterIdFunction(
      _storeCanisterId : (canisterId : Text) -> async (),
    ) {
      storeCanisterId := ?_storeCanisterId;
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

    public func saveFantasyTeam(updatedFantasyTeamDTO : DTOs.UpdateTeamSelectionDTO, systemState : T.SystemState, players : [DTOs.PlayerDTO]) : async Result.Result<(), T.Error> {

      if (systemState.onHold) {
        return #err(#SystemOnHold);
      };

      if (invalidBonuses(updatedFantasyTeamDTO, systemState, players)) {
        return #err(#InvalidTeamError);
      };

      if (invalidTeamComposition(updatedFantasyTeamDTO, players)) {
        return #err(#InvalidTeamError);
      };

      let managerCanisterId = managerCanisterIds.get(updatedFantasyTeamDTO.principalId);

      var result : Result.Result<(), T.Error> = #err(#NotFound);

      switch (managerCanisterId) {
        case (null) {

          let updatedPlayers = Array.filter<DTOs.PlayerDTO>(
            players,
            func(player : DTOs.PlayerDTO) : Bool {
              let playerId = player.id;
              let isPlayerIdInNewTeam = Array.find(
                updatedFantasyTeamDTO.playerIds,
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
                updatedFantasyTeamDTO.playerIds,
                func(id : Nat16) : Bool {
                  return id == playerId;
                },
              );
              return Option.isNull(isPlayerIdInExistingTeam);
            },
          );

          let spent = Array.foldLeft<DTOs.PlayerDTO, Nat16>(playersAdded, 0, func(sumSoFar, x) = sumSoFar + x.valueQuarterMillions);

          if (spent > 1200) {
            return #err(#InvalidTeamError);
          };

          var bonusPlayed = updatedFantasyTeamDTO.goalGetterGameweek == systemState.pickTeamGameweek or updatedFantasyTeamDTO.passMasterGameweek == systemState.pickTeamGameweek or updatedFantasyTeamDTO.noEntryGameweek == systemState.pickTeamGameweek or updatedFantasyTeamDTO.teamBoostGameweek == systemState.pickTeamGameweek or updatedFantasyTeamDTO.safeHandsGameweek == systemState.pickTeamGameweek or updatedFantasyTeamDTO.captainFantasticGameweek == systemState.pickTeamGameweek or updatedFantasyTeamDTO.countrymenGameweek == systemState.pickTeamGameweek or updatedFantasyTeamDTO.prospectsGameweek == systemState.pickTeamGameweek or updatedFantasyTeamDTO.braceBonusGameweek == systemState.pickTeamGameweek or updatedFantasyTeamDTO.hatTrickHeroGameweek == systemState.pickTeamGameweek;

          var monthlyBonuses : Nat8 = 2;
          if (bonusPlayed) {
            monthlyBonuses := monthlyBonuses - 1;
          };

          let newManager : T.Manager = {
            principalId = updatedFantasyTeamDTO.principalId;
            username = "";
            favouriteClubId = 0;
            createDate = Time.now();
            termsAccepted = false;
            profilePicture = null;
            profilePictureType = "";
            transfersAvailable = 2;
            monthlyBonusesAvailable = monthlyBonuses;
            bankQuarterMillions = 1200 - spent;
            playerIds = updatedFantasyTeamDTO.playerIds;
            captainId = updatedFantasyTeamDTO.captainId;
            goalGetterGameweek = updatedFantasyTeamDTO.goalGetterGameweek;
            goalGetterPlayerId = updatedFantasyTeamDTO.goalGetterPlayerId;
            passMasterGameweek = updatedFantasyTeamDTO.passMasterGameweek;
            passMasterPlayerId = updatedFantasyTeamDTO.passMasterPlayerId;
            noEntryGameweek = updatedFantasyTeamDTO.noEntryGameweek;
            noEntryPlayerId = updatedFantasyTeamDTO.noEntryPlayerId;
            teamBoostGameweek = updatedFantasyTeamDTO.teamBoostGameweek;
            teamBoostClubId = updatedFantasyTeamDTO.teamBoostClubId;
            safeHandsGameweek = updatedFantasyTeamDTO.safeHandsGameweek;
            safeHandsPlayerId = updatedFantasyTeamDTO.safeHandsPlayerId;
            captainFantasticGameweek = updatedFantasyTeamDTO.captainFantasticGameweek;
            captainFantasticPlayerId = updatedFantasyTeamDTO.captainFantasticPlayerId;
            countrymenGameweek = updatedFantasyTeamDTO.countrymenGameweek;
            countrymenCountryId = updatedFantasyTeamDTO.countrymenCountryId;
            prospectsGameweek = updatedFantasyTeamDTO.prospectsGameweek;
            braceBonusGameweek = updatedFantasyTeamDTO.braceBonusGameweek;
            hatTrickHeroGameweek = updatedFantasyTeamDTO.hatTrickHeroGameweek;
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

          let foundManager = await manager_canister.getManager(updatedFantasyTeamDTO.principalId);

          if (invalidTransfers(updatedFantasyTeamDTO, foundManager, systemState, players)) {
            return #err(#InvalidTeamError);
          };

          let canisterManagerCount = await manager_canister.getTotalManagers();

          if (canisterManagerCount >= 12000) {
            let newManagerCanisterId = await createManagerCanister();

            let new_manager_canister = actor (newManagerCanisterId) : actor {
              addNewManager : (manager : T.Manager) -> async Result.Result<(), T.Error>;
            };
            result := await new_manager_canister.addNewManager(newManager);
            totalManagers := totalManagers + 1;
            activeManagerCanisterId := newManagerCanisterId;
            managerCanisterIds.put(newManager.principalId, newManagerCanisterId);
            return result;
          } else {
            totalManagers := totalManagers + 1;
            result := await manager_canister.addNewManager(newManager);
            managerCanisterIds.put(newManager.principalId, activeManagerCanisterId);
          };
        };
        case (?foundCanisterId) {
          let manager_canister = actor (foundCanisterId) : actor {
            getManager : T.PrincipalId -> async ?T.Manager;
            updateTeamSelection : (updateManagerDTO : DTOs.UpdateTeamSelectionDTO, transfersAvailable : Nat8, monthlyBonuses : Nat8, newBankBalance : Nat16) -> async Result.Result<(), T.Error>;
          };

          let manager = await manager_canister.getManager(updatedFantasyTeamDTO.principalId);

          switch (manager) {
            case (null) { return #err(#NotFound) };
            case (?foundManager) {

              let updatedPlayers = Array.filter<DTOs.PlayerDTO>(
                players,
                func(player : DTOs.PlayerDTO) : Bool {
                  let playerId = player.id;
                  let isPlayerIdInNewTeam = Array.find(
                    updatedFantasyTeamDTO.playerIds,
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
                    foundManager.playerIds,
                    func(id : Nat16) : Bool {
                      return id == playerId;
                    },
                  );
                  return Option.isNull(isPlayerIdInExistingTeam);
                },
              );

              let playersRemoved = Array.filter<Nat16>(
                foundManager.playerIds,
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
                  List.fromArray(players),
                  func(player : DTOs.PlayerDTO) : Bool {
                    return player.id == updatedFantasyTeamDTO.noEntryPlayerId;
                  },
                );
                switch (foundPlayer) {
                  case (null) {};
                  case (?player) {
                    sold := sold + player.valueQuarterMillions;
                  };
                };
              };

              let netSpendQMs : Nat16 = spent - sold;
              let newBankBalance = foundManager.bankQuarterMillions - netSpendQMs;
              if (newBankBalance > 0) {
                return #err(#InvalidTeamError);
              };

              let transfersAvailable = foundManager.transfersAvailable - Nat8.fromNat(Array.size(playersAdded));

              var bonusPlayed = updatedFantasyTeamDTO.goalGetterGameweek == systemState.pickTeamGameweek or updatedFantasyTeamDTO.passMasterGameweek == systemState.pickTeamGameweek or updatedFantasyTeamDTO.noEntryGameweek == systemState.pickTeamGameweek or updatedFantasyTeamDTO.teamBoostGameweek == systemState.pickTeamGameweek or updatedFantasyTeamDTO.safeHandsGameweek == systemState.pickTeamGameweek or updatedFantasyTeamDTO.captainFantasticGameweek == systemState.pickTeamGameweek or updatedFantasyTeamDTO.countrymenGameweek == systemState.pickTeamGameweek or updatedFantasyTeamDTO.prospectsGameweek == systemState.pickTeamGameweek or updatedFantasyTeamDTO.braceBonusGameweek == systemState.pickTeamGameweek or updatedFantasyTeamDTO.hatTrickHeroGameweek == systemState.pickTeamGameweek;

              var monthlyBonuses = foundManager.monthlyBonusesAvailable;
              if (bonusPlayed) {
                monthlyBonuses := monthlyBonuses - 1;
              };

              if (monthlyBonuses < 0) {
                return #err(#InvalidTeamError);
              };

              if (updatedFantasyTeamDTO.goalGetterGameweek == systemState.pickTeamGameweek and foundManager.goalGetterGameweek != 0) {
                return #err(#InvalidTeamError);
              };
              if (updatedFantasyTeamDTO.passMasterGameweek == systemState.pickTeamGameweek and foundManager.passMasterGameweek != 0) {
                return #err(#InvalidTeamError);
              };
              if (updatedFantasyTeamDTO.noEntryGameweek == systemState.pickTeamGameweek and foundManager.noEntryGameweek != 0) {
                return #err(#InvalidTeamError);
              };
              if (updatedFantasyTeamDTO.teamBoostGameweek == systemState.pickTeamGameweek and foundManager.teamBoostGameweek != 0) {
                return #err(#InvalidTeamError);
              };
              if (updatedFantasyTeamDTO.safeHandsGameweek == systemState.pickTeamGameweek and foundManager.safeHandsGameweek != 0) {
                return #err(#InvalidTeamError);
              };
              if (updatedFantasyTeamDTO.captainFantasticGameweek == systemState.pickTeamGameweek and foundManager.captainFantasticGameweek != 0) {
                return #err(#InvalidTeamError);
              };
              if (updatedFantasyTeamDTO.countrymenGameweek == systemState.pickTeamGameweek and foundManager.countrymenGameweek != 0) {
                return #err(#InvalidTeamError);
              };
              if (updatedFantasyTeamDTO.prospectsGameweek == systemState.pickTeamGameweek and foundManager.prospectsGameweek != 0) {
                return #err(#InvalidTeamError);
              };
              if (updatedFantasyTeamDTO.braceBonusGameweek == systemState.pickTeamGameweek and foundManager.braceBonusGameweek != 0) {
                return #err(#InvalidTeamError);
              };
              if (updatedFantasyTeamDTO.hatTrickHeroGameweek == systemState.pickTeamGameweek and foundManager.hatTrickHeroGameweek != 0) {
                return #err(#InvalidTeamError);
              };

              return await manager_canister.updateTeamSelection(updatedFantasyTeamDTO, transfersAvailable, monthlyBonuses, newBankBalance);
            };
          };
        };
      };

      return result;
    };

    public func updateUsername(principalId : T.PrincipalId, updatedUsername : Text) : async Result.Result<(), T.Error> {
      if (not isUsernameValid(updatedUsername)) {
        return #err(#InvalidData);
      };

      if (isUsernameTaken(updatedUsername, principalId)) {
        return #err(#InvalidData);
      };

      let managerCanisterId = managerCanisterIds.get(principalId);

      var result : Result.Result<(), T.Error> = #err(#NotFound);

      switch (managerCanisterId) {
        case (null) {

          let newManager : T.Manager = {
            principalId = principalId;
            username = updatedUsername;
            favouriteClubId = 0;
            createDate = Time.now();
            termsAccepted = false;
            profilePicture = null;
            profilePictureType = "";
            transfersAvailable = 0;
            monthlyBonusesAvailable = 0;
            bankQuarterMillions = 1200;
            playerIds = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
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
            history = List.nil();
            ownedPrivateLeagues = List.nil();
            privateLeagueMemberships = List.nil();
          };

          let manager_canister = actor (activeManagerCanisterId) : actor {
            addNewManager : (manager : T.Manager) -> async Result.Result<(), T.Error>;
            getTotalManagers : () -> async Nat;
          };

          let canisterManagerCount = await manager_canister.getTotalManagers();

          if (canisterManagerCount >= 12000) {
            let newManagerCanisterId = await createManagerCanister();

            let new_manager_canister = actor (newManagerCanisterId) : actor {
              addNewManager : (manager : T.Manager) -> async Result.Result<(), T.Error>;
            };
            result := await new_manager_canister.addNewManager(newManager);
            totalManagers := totalManagers + 1;
            activeManagerCanisterId := newManagerCanisterId;
            managerCanisterIds.put(newManager.principalId, newManagerCanisterId);
            return result;
          } else {
            totalManagers := totalManagers + 1;
            result := await manager_canister.addNewManager(newManager);
            managerCanisterIds.put(newManager.principalId, activeManagerCanisterId);
            managerUsernames.put(principalId, updatedUsername);
            return result;
          };
        };
        case (?foundCanisterId) {

          let manager_canister = actor (foundCanisterId) : actor {
            updateUsername : (dto : DTOs.UpdateUsernameDTO) -> async Result.Result<(), T.Error>;
          };
          let dto : DTOs.UpdateUsernameDTO = {
            principalId = principalId;
            username = updatedUsername;
          };
          result := await manager_canister.updateUsername(dto);
          managerUsernames.put(principalId, updatedUsername);
          return result;
        };
      };
      return #err(#NotFound);
    };

    public func updateFavouriteClub(principalId : T.PrincipalId, favouriteClubId : T.ClubId, systemState : T.SystemState, activeClubs : [T.Club]) : async Result.Result<(), T.Error> {

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

      let managerCanisterId = managerCanisterIds.get(principalId);

      var result : Result.Result<(), T.Error> = #err(#NotFound);

      switch (managerCanisterId) {
        case (null) {

          let newManager : T.Manager = {
            principalId = principalId;
            username = "";
            favouriteClubId = favouriteClubId;
            createDate = Time.now();
            termsAccepted = false;
            profilePicture = null;
            profilePictureType = "";
            transfersAvailable = 0;
            monthlyBonusesAvailable = 0;
            bankQuarterMillions = 1200;
            playerIds = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
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
            history = List.nil();
            ownedPrivateLeagues = List.nil();
            privateLeagueMemberships = List.nil();
          };

          let manager_canister = actor (activeManagerCanisterId) : actor {
            addNewManager : (manager : T.Manager) -> async Result.Result<(), T.Error>;
            getTotalManagers : () -> async Nat;
          };

          let canisterManagerCount = await manager_canister.getTotalManagers();

          if (canisterManagerCount >= 12000) {
            let newManagerCanisterId = await createManagerCanister();

            let new_manager_canister = actor (newManagerCanisterId) : actor {
              addNewManager : (manager : T.Manager) -> async Result.Result<(), T.Error>;
            };
            result := await new_manager_canister.addNewManager(newManager);
            totalManagers := totalManagers + 1;
            activeManagerCanisterId := newManagerCanisterId;
            managerCanisterIds.put(newManager.principalId, newManagerCanisterId);
            return result;
          } else {
            totalManagers := totalManagers + 1;
            result := await manager_canister.addNewManager(newManager);
            managerCanisterIds.put(newManager.principalId, activeManagerCanisterId);
            return result;
          };
        };
        case (?foundCanisterId) {

          let manager_canister = actor (foundCanisterId) : actor {
            getManager : T.PrincipalId -> async ?T.Manager;
            updateFavouriteClub : (dto : DTOs.UpdateFavouriteClubDTO) -> async Result.Result<(), T.Error>;
          };

          if (systemState.pickTeamGameweek > 1) {
            let manager = await manager_canister.getManager(principalId);
            switch (manager) {
              case (null) {
                return #err(#NotFound);

              };
              case (?foundManager) {
                if (foundManager.favouriteClubId > 0) {
                  return #err(#InvalidData);
                };
              };
            };
          };

          let dto : DTOs.UpdateFavouriteClubDTO = {
            principalId = principalId;
            favouriteClubId = favouriteClubId;
          };

          result := await manager_canister.updateFavouriteClub(dto);
          return result;
        };
      };

      return #err(#NotFound);
    };

    public func updateProfilePicture(principalId : T.PrincipalId, profilePicture : Blob, profilePictureType : Text) : async Result.Result<(), T.Error> {

      if (invalidProfilePicture(profilePicture)) {

        return #err(#InvalidData);
      };

      let managerCanisterId = managerCanisterIds.get(principalId);
      var result : Result.Result<(), T.Error> = #err(#NotFound);

      switch (managerCanisterId) {
        case (null) {
          let newManager : T.Manager = {
            principalId = principalId;
            username = "";
            favouriteClubId = 0;
            createDate = Time.now();
            termsAccepted = false;
            profilePicture = ?profilePicture;
            profilePictureType = profilePictureType;
            transfersAvailable = 0;
            monthlyBonusesAvailable = 0;
            bankQuarterMillions = 1200;
            playerIds = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
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
            history = List.nil();
            ownedPrivateLeagues = List.nil();
            privateLeagueMemberships = List.nil();
          };

          let manager_canister = actor (activeManagerCanisterId) : actor {
            addNewManager : (manager : T.Manager) -> async Result.Result<(), T.Error>;
            getTotalManagers : () -> async Nat;
          };

          let canisterManagerCount = await manager_canister.getTotalManagers();

          if (canisterManagerCount >= 12000) {
            let newManagerCanisterId = await createManagerCanister();

            let new_manager_canister = actor (newManagerCanisterId) : actor {
              addNewManager : (manager : T.Manager) -> async Result.Result<(), T.Error>;
            };
            result := await new_manager_canister.addNewManager(newManager);
            totalManagers := totalManagers + 1;
            activeManagerCanisterId := newManagerCanisterId;
            managerCanisterIds.put(newManager.principalId, newManagerCanisterId);
            return result;
          } else {
            totalManagers := totalManagers + 1;
            result := await manager_canister.addNewManager(newManager);
            managerCanisterIds.put(newManager.principalId, activeManagerCanisterId);
            return result;
          };
        };
        case (?foundCanisterId) {

          let manager_canister = actor (foundCanisterId) : actor {
            getManager : T.PrincipalId -> async ?T.Manager;
            updateProfilePicture : (dto : DTOs.UpdateProfilePictureDTO) -> async Result.Result<(), T.Error>;
          };

          let dto : DTOs.UpdateProfilePictureDTO = {
            principalId = principalId;
            profilePicture = ?profilePicture;
            extension = profilePictureType;
          };

          result := await manager_canister.updateProfilePicture(dto);
          return result;
        };
      };

      return #err(#NotFound);
    };

    public func isUsernameValid(username : Text) : Bool {
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

    private func invalidBonuses(updatedFantasyTeam : DTOs.UpdateTeamSelectionDTO, systemState : T.SystemState, players : [DTOs.PlayerDTO]) : Bool {

      var bonusesPlayed = 0;
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

      return false;
    };

    private func invalidTransfers(updatedFantasyTeam : DTOs.UpdateTeamSelectionDTO, existingFantasyTeam : ?T.Manager, systemState : T.SystemState, players : [DTOs.PlayerDTO]) : Bool {

      if (updatedFantasyTeam.transferWindowGameweek == systemState.pickTeamGameweek and not systemState.transferWindowActive) {
        return true;
      };

      switch (existingFantasyTeam) {
        case (null) {
          let spend = Array.foldLeft(
            updatedFantasyTeam.playerIds,
            0,
            func(sum : Nat, playerId : T.PlayerId) : Nat {
              let player : ?DTOs.PlayerDTO = Array.find<DTOs.PlayerDTO>(players, func(p) { p.id == playerId });
              switch (player) {
                case (null) {
                  sum;
                };
                case (?foundPlayer) {
                  sum + Nat16.toNat(foundPlayer.valueQuarterMillions);
                };
              };
            },
          );

          if (spend > 1200) {
            return true;
          };
        };
        case (?foundTeam) {
          let existingPlayerIds : [T.PlayerId] = foundTeam.playerIds;

          let playersBought = Array.filter(
            updatedFantasyTeam.playerIds,
            func(playerId : T.PlayerId) : Bool {
              Array.find(existingPlayerIds, func(id : T.PlayerId) : Bool { id != playerId }) == null;
            },
          );

          var newTransfersAvailable = foundTeam.transfersAvailable;
          if (not systemState.transferWindowActive) {
            newTransfersAvailable := newTransfersAvailable - Nat8.fromNat(Array.size(playersBought));
          };

          if (newTransfersAvailable < 0) {
            return true;
          };

          let playersSold = Array.filter(
            existingPlayerIds,
            func(playerId : T.PlayerId) : Bool {
              Array.find(updatedFantasyTeam.playerIds, func(id : T.PlayerId) : Bool { id != playerId }) == null;
            },
          );

          let spend = Array.foldLeft(
            playersBought,
            0,
            func(sum : Nat, playerId : T.PlayerId) : Nat {
              let player : ?DTOs.PlayerDTO = Array.find<DTOs.PlayerDTO>(players, func(p) { p.id == playerId });
              switch (player) {
                case (null) {
                  sum;
                };
                case (?foundPlayer) {
                  sum + Nat16.toNat(foundPlayer.valueQuarterMillions);
                };
              };
            },
          );

          let sold = Array.foldLeft(
            playersSold,
            0,
            func(sum : Nat, playerId : T.PlayerId) : Nat {
              let player : ?DTOs.PlayerDTO = Array.find<DTOs.PlayerDTO>(players, func(p) { p.id == playerId });
              switch (player) {
                case (null) {
                  sum;
                };
                case (?foundPlayer) {
                  sum + Nat16.toNat(foundPlayer.valueQuarterMillions);
                };
              };
            },
          );

          let remainingBank : Nat16 = foundTeam.bankQuarterMillions - Nat16.fromNat(spend) + Nat16.fromNat(sold);
          if (remainingBank < 0) {
            return true;
          };
        };
      };

      return false;
    };

    private func invalidTeamComposition(updatedFantasyTeam : DTOs.UpdateTeamSelectionDTO, players : [DTOs.PlayerDTO]) : Bool {

      let newTeamPlayers = Array.filter(
        players,
        func(player : DTOs.PlayerDTO) : Bool {
          Array.find(updatedFantasyTeam.playerIds, func(id : T.PlayerId) : Bool { id != player.id }) == null;
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

        if (players[i].id == updatedFantasyTeam.captainId) {
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

    public func payWeeklyRewards(rewardPool : T.RewardPool, weeklyLeaderboard : DTOs.WeeklyLeaderboardDTO, fixtures : List.List<DTOs.FixtureDTO>) : async () {
      await distributeWeeklyRewards(rewardPool.weeklyLeaderboardPool, weeklyLeaderboard);
      await distributeHighestScoringPlayerRewards(weeklyLeaderboard.seasonId, weeklyLeaderboard.gameweek, rewardPool.highestScoringMatchPlayerPool, fixtures, uniqueManagerCanisterIds);
      await distributeWeeklyATHScoreRewards(rewardPool.allTimeWeeklyHighScorePool, weeklyLeaderboard);
    };

    public func payMonthlyRewards(rewardPool : T.RewardPool, monthlyLeaderboard : DTOs.MonthlyLeaderboardDTO) : async () {
      await distributeMonthlyRewards(rewardPool, monthlyLeaderboard, uniqueManagerCanisterIds);
    };

    public func payATHMonthlyRewards(rewardPool : T.RewardPool, monthlyLeaderboards : [DTOs.MonthlyLeaderboardDTO]) : async () {
      await distributeMonthlyATHScoreRewards(rewardPool.allTimeMonthlyHighScorePool, monthlyLeaderboards);
    };

    public func paySeasonRewards(rewardPool : T.RewardPool, seasonLeaderboard : DTOs.SeasonLeaderboardDTO, players : [DTOs.PlayerDTO], seasonId : T.SeasonId) : async () {
      await distributeSeasonRewards(rewardPool.seasonLeaderboardPool, seasonLeaderboard, uniqueManagerCanisterIds);
      await distributeSeasonATHScoreRewards(rewardPool.allTimeSeasonHighScorePool, seasonLeaderboard);
      await distributeMostValuableTeamRewards(rewardPool.mostValuableTeamPool, players, seasonId, uniqueManagerCanisterIds);
    };

    public func distributeWeeklyRewards(weeklyRewardPool : Nat64, weeklyLeaderboard : DTOs.WeeklyLeaderboardDTO) : async () {

      await rewards.distributeWeeklyRewards(weeklyRewardPool, weeklyLeaderboard);

    };

    public func distributeMonthlyRewards(rewardPool : T.RewardPool, monthlyLeaderboard : DTOs.MonthlyLeaderboardDTO, uniqueManagerCanisterIds : List.List<T.CanisterId>) : async () {
      await rewards.distributeMonthlyRewards(rewardPool, monthlyLeaderboard, uniqueManagerCanisterIds);
    };

    public func distributeSeasonRewards(seasonRewardPool : Nat64, seasonLeaderboard : DTOs.SeasonLeaderboardDTO, uniqueManagerCanisterIds : List.List<T.CanisterId>) : async () {
      await rewards.distributeSeasonRewards(seasonRewardPool, seasonLeaderboard);
    };

    public func distributeMostValuableTeamRewards(mostValuableTeamPool : Nat64, players : [DTOs.PlayerDTO], currentSeason : T.SeasonId, uniqueManagerCanisterIds : List.List<T.CanisterId>) : async () {
      await rewards.distributeMostValuableTeamRewards(mostValuableTeamPool, players, currentSeason, uniqueManagerCanisterIds);
    };

    public func distributeHighestScoringPlayerRewards(seasonId : T.SeasonId, gameweek : T.GameweekNumber, highestScoringPlayerRewardPool : Nat64, fixtures : List.List<DTOs.FixtureDTO>, uniqueManagerCanisterIds : List.List<T.CanisterId>) : async () {
      await rewards.distributeHighestScoringPlayerRewards(seasonId, gameweek, highestScoringPlayerRewardPool, fixtures, uniqueManagerCanisterIds);
    };

    public func distributeWeeklyATHScoreRewards(weeklyRewardPool : Nat64, weeklyLeaderboard : DTOs.WeeklyLeaderboardDTO) : async () {
      await rewards.distributeWeeklyATHScoreRewards(weeklyRewardPool, weeklyLeaderboard);
    };

    public func distributeMonthlyATHScoreRewards(monthlyRewardPool : Nat64, monthlyLeaderboards : [DTOs.MonthlyLeaderboardDTO]) : async () {
      await rewards.distributeMonthlyATHScoreRewards(monthlyRewardPool, monthlyLeaderboards);
    };

    public func distributeSeasonATHScoreRewards(seasonRewardPool : Nat64, seasonLeaderboard : DTOs.SeasonLeaderboardDTO) : async () {
      await rewards.distributeSeasonATHScoreRewards(seasonRewardPool, seasonLeaderboard);
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

    public func init() : async () {
      let result = await createManagerCanister();
      activeManagerCanisterId := result;
    };
  };
};

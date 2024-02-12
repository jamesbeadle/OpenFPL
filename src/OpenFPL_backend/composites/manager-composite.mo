import DTOs "../DTOs";
import T "../types";
import Result "mo:base/Result";
import Blob "mo:base/Blob";
import Text "mo:base/Text";
import List "mo:base/List";
import { now } = "mo:base/Time";
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
import Debug "mo:base/Debug";
import Management "../modules/Management";
import ENV "../utils/Env";
import ManagerCanister "../manager-canister";
import RewardPercentages "../utils/RewardPercentages";
import Utilities "../utilities";
import Token "../token";
import SeasonLeaderboard "../season-leaderboard";
import TrieMap "mo:base/TrieMap";
import Error "mo:base/Error";

module {

  public class ManagerComposite() {

    let tokenCanister = Token.Token();

    private var managerCanisterIds : TrieMap.TrieMap<T.PrincipalId, T.CanisterId> = TrieMap.TrieMap<T.PrincipalId, T.CanisterId>(Text.equal, Text.hash);
    private var managerUsernames : TrieMap.TrieMap<T.PrincipalId, Text> = TrieMap.TrieMap<T.PrincipalId, Text>(Text.equal, Text.hash);
    private var uniqueManagerCanisterIds : List.List<T.CanisterId> = List.nil();

    private var totalManagers : Nat = 0;
    private var activeManagerCanisterId : T.CanisterId = "";

    private var storeCanisterId : ?((canisterId : Text) -> async ()) = null;
    private var backendCanisterController : ?Principal = null;

    private var teamValueLeaderboards : TrieMap.TrieMap<T.SeasonId, T.TeamValueLeaderboard> = TrieMap.TrieMap<T.SeasonId, T.TeamValueLeaderboard>(Utilities.eqNat16, Utilities.hashNat16);

    private var seasonRewards : List.List<T.SeasonRewards> = List.nil();
    private var monthlyRewards : List.List<T.MonthlyRewards> = List.nil();
    private var weeklyRewards : List.List<T.WeeklyRewards> = List.nil();
    private var mostValuableTeamRewards : List.List<T.RewardsList> = List.nil();
    private var highScoringPlayerRewards : List.List<T.RewardsList> = List.nil();

    private var weeklyAllTimeHighScores : List.List<T.HighScoreRecord> = List.nil();
    private var monthlyAllTimeHighScores : List.List<T.HighScoreRecord> = List.nil();
    private var seasonAllTimeHighScores : List.List<T.HighScoreRecord> = List.nil();

    private var weeklyATHPrizePool : Nat64 = 0;
    private var monthlyATHPrizePool : Nat64 = 0;
    private var seasonATHPrizePool : Nat64 = 0;

    public func setBackendCanisterController(controller : Principal) {
      backendCanisterController := ?controller;
    };

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
              let managerGameweeksBuffer = Buffer.fromArray<T.FantasyTeamSeason>([]);

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
              let profileDTO : DTOs.ProfileDTO = {
                principalId = principalId;
                username = foundManager.username;
                termsAccepted = foundManager.termsAccepted;
                profilePicture = foundManager.profilePicture;
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
          } else {
            result := await manager_canister.addNewManager(newManager);
          };
          totalManagers := totalManagers + 1;

        };
        case (?foundCanisterId) {
          let manager_canister = actor (foundCanisterId) : actor {
            getManager : (managerPrincipal : Text) -> async ?T.Manager;
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

              let transfersAvailable = foundManager.transfersAvailable - Nat8.fromNat(Array.size(playersAdded));

              var bonusPlayed = updatedFantasyTeamDTO.goalGetterGameweek == systemState.pickTeamGameweek or updatedFantasyTeamDTO.passMasterGameweek == systemState.pickTeamGameweek or updatedFantasyTeamDTO.noEntryGameweek == systemState.pickTeamGameweek or updatedFantasyTeamDTO.teamBoostGameweek == systemState.pickTeamGameweek or updatedFantasyTeamDTO.safeHandsGameweek == systemState.pickTeamGameweek or updatedFantasyTeamDTO.captainFantasticGameweek == systemState.pickTeamGameweek or updatedFantasyTeamDTO.countrymenGameweek == systemState.pickTeamGameweek or updatedFantasyTeamDTO.prospectsGameweek == systemState.pickTeamGameweek or updatedFantasyTeamDTO.braceBonusGameweek == systemState.pickTeamGameweek or updatedFantasyTeamDTO.hatTrickHeroGameweek == systemState.pickTeamGameweek;

              var monthlyBonuses = foundManager.monthlyBonusesAvailable;
              if (bonusPlayed) {
                monthlyBonuses := monthlyBonuses - 1;
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
          } else {
            result := await manager_canister.addNewManager(newManager);
          };
          totalManagers := totalManagers + 1;
        };
        case (?foundCanisterId) {

          let manager_canister = actor (foundCanisterId) : actor {
            updateUsername : (principalId : Text, username : Text) -> async Result.Result<(), T.Error>;
          };

          result := await manager_canister.updateUsername(principalId, updatedUsername);
        };
      };

      if (result == #ok) {
        managerUsernames.put(principalId, updatedUsername);
        return #ok();
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
          } else {
            result := await manager_canister.addNewManager(newManager);
          };
          totalManagers := totalManagers + 1;
        };
        case (?foundCanisterId) {

          let manager_canister = actor (foundCanisterId) : actor {
            getManager : (principalId : Text) -> async ?T.Manager;
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
        };
      };

      return #err(#NotFound);
    };

    public func updateProfilePicture(principalId : T.PrincipalId, profilePicture : Blob) : async Result.Result<(), T.Error> {

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
          } else {
            result := await manager_canister.addNewManager(newManager);
          };
          totalManagers := totalManagers + 1;
        };
        case (?foundCanisterId) {

          let manager_canister = actor (foundCanisterId) : actor {
            getManager : (principalId : Text) -> async ?T.Manager;
            updateProfilePicture : (dto : DTOs.UpdateProfilePictureDTO) -> async Result.Result<(), T.Error>;
          };

          let dto : DTOs.UpdateProfilePictureDTO = {
            principalId = principalId;
            profilePicture = ?profilePicture;
          };

          result := await manager_canister.updateProfilePicture(dto);
        };
      };

      return #err(#NotFound);
    };

    //Should be good:

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
          return false;
        };
      };

      return true;
    };

    public func getFavouriteClub(principalId : Text) : async Result.Result<T.ClubId, T.Error> {
      let managerCanisterId = managerCanisterIds.get(principalId);

      switch (managerCanisterId) {
        case (null) {
          return #err(#NotFound);
        };
        case (?foundCanisterId) {
          let manager_canister = actor (foundCanisterId) : actor {
            getManager : (principalId : Text) -> async ?T.Manager;
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
          case (null) { return false };
          case (?player) {
            if (player.position != #Goalkeeper and player.position != #Defender) {
              return false;
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
          case (null) { return false };
          case (?player) {
            if (player.position != #Goalkeeper) { return false };
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

    //todo:redo

    public func calculateFantasyTeamScores(allPlayersList : [(T.PlayerId, DTOs.PlayerScoreDTO)], seasonId : T.SeasonId, gameweek : T.GameweekNumber) : async () {
      var allPlayers = TrieMap.TrieMap<T.PlayerId, DTOs.PlayerScoreDTO>(Utilities.eqNat16, Utilities.hashNat16);
      for ((key, value) in Iter.fromArray(allPlayersList)) {
        allPlayers.put(key, value);
      };

      //TODO: Create function that does this but also merges a new set from the next canister

      for (canisterId in Iter.fromList(uniqueManagerCanisterIds)) {
        let manager_canister = actor (canisterId) : actor {
          getManagers : () -> async [T.Manager];
        };

        let managers = await manager_canister.getManagers();

        for (value in Iter.fromArray(managers)) {

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
                  await updateSnapshotPoints(value.principalId, seasonId, gameweek, totalTeamPoints);
                };
              };
            };
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

    private func updateSnapshotPoints(principalId : Text, seasonId : Nat16, gameweek : Nat8, teamPoints : Int16) : async () {

      let managerCanisterId = managerCanisterIds.get(principalId);
      switch (managerCanisterId) {
        case (null) {};
        case (?foundCanisterId) {
          let manager_canister = actor (foundCanisterId) : actor {
            updateSnapshotPoints : (T.PrincipalId, T.SeasonId, gameweek : T.GameweekNumber, points : Int16) -> async ();
          };

          await manager_canister.updateSnapshotPoints(principalId, seasonId, gameweek, teamPoints);
        };
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

    public func snapshotFantasyTeams(seasonId : T.SeasonId, gameweek : T.GameweekNumber, players : [DTOs.PlayerDTO]) : async () {
      for (canisterId in Iter.fromList(uniqueManagerCanisterIds)) {

        let manager_canister = actor (canisterId) : actor {
          snapshotFantasyTeams : (seasonId : T.SeasonId, gameweek : T.GameweekNumber) -> async ();
        };

        await manager_canister.snapshotFantasyTeams(seasonId, gameweek);
      };
    };

    public func resetTransfers() : async () {
      for (canisterId in Iter.fromList(uniqueManagerCanisterIds)) {

        let manager_canister = actor (canisterId) : actor {
          resetTransfers : () -> async ();
        };

        await manager_canister.resetTransfers();
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

    public func payWeeklyRewards(rewardPool : T.RewardPool, weeklyLeaderboard : DTOs.WeeklyLeaderboardDTO, fixtures : List.List<DTOs.FixtureDTO>) : async () {
      await distributeWeeklyRewards(rewardPool.weeklyLeaderboardPool, weeklyLeaderboard);
      await distributeHighestScoringPlayerRewards(weeklyLeaderboard.seasonId, weeklyLeaderboard.gameweek, rewardPool.highestScoringMatchPlayerPool, fixtures);
      await distributeWeeklyATHScoreRewards(rewardPool.allTimeWeeklyHighScorePool, weeklyLeaderboard);
    };

    public func payMonthlyRewards(rewardPool : T.RewardPool, monthlyLeaderboard : DTOs.MonthlyLeaderboardDTO) : async () {
      await distributeMonthlyRewards(rewardPool, monthlyLeaderboard);
    };

    public func payATHMonthlyRewards(rewardPool : T.RewardPool, monthlyLeaderboards : [DTOs.MonthlyLeaderboardDTO]) : async () {
      await distributeMonthlyATHScoreRewards(rewardPool.allTimeMonthlyHighScorePool, monthlyLeaderboards);
    };

    public func paySeasonRewards(rewardPool : T.RewardPool, seasonLeaderboard : DTOs.SeasonLeaderboardDTO, players : [DTOs.PlayerDTO], seasonId : T.SeasonId) : async () {
      await distributeSeasonRewards(rewardPool.seasonLeaderboardPool, seasonLeaderboard);
      await distributeSeasonATHScoreRewards(rewardPool.allTimeSeasonHighScorePool, seasonLeaderboard);
      await distributeMostValuableTeamRewards(rewardPool.mostValuableTeamPool, players, seasonId);
    };

    //Need to redo

    public func distributeWeeklyRewards(weeklyRewardPool : Nat64, weeklyLeaderboard : DTOs.WeeklyLeaderboardDTO) : async () {
      let weeklyRewardAmount = weeklyRewardPool / 38;
      var payouts = List.nil<Float>();
      var currentEntries = List.fromArray(weeklyLeaderboard.entries);

      let scaledPercentages = if (weeklyLeaderboard.totalEntries < 100) {
        scalePercentages(RewardPercentages.percentages, weeklyLeaderboard.totalEntries);
      } else {
        RewardPercentages.percentages;
      };

      while (not List.isNil(currentEntries)) {
        let (currentEntry, rest) = List.pop(currentEntries);
        currentEntries := rest;
        switch (currentEntry) {
          case (null) {};
          case (?foundEntry) {
            let (nextEntry, _) = List.pop(rest);
            switch (nextEntry) {
              case (null) {
                let payout = scaledPercentages[foundEntry.position - 1];
                payouts := List.push(payout, payouts);
              };
              case (?foundNextEntry) {
                if (foundEntry.points == foundNextEntry.points) {
                  let tiedEntries = findTiedEntries(rest, foundEntry.points);
                  let startPosition = foundEntry.position;
                  let tiePayouts = calculateTiePayouts(tiedEntries, scaledPercentages, startPosition);
                  payouts := List.append(payouts, tiePayouts);

                  var skipEntries = rest;
                  label skipLoop while (not List.isNil(skipEntries)) {
                    let (skipEntry, nextRest) = List.pop(skipEntries);
                    skipEntries := nextRest;

                    switch (skipEntry) {
                      case (null) { break skipLoop };
                      case (?entry) {
                        if (entry.points != foundEntry.points) {
                          currentEntries := skipEntries;
                          break skipLoop;
                        };
                      };
                    };
                  };
                } else {
                  let payout = scaledPercentages[foundEntry.position - 1];
                  payouts := List.push(payout, payouts);
                };
              };
            };

          };
        };
      };

      payouts := List.reverse(payouts);
      let payoutsArray = List.toArray(payouts);
      let rewardBuffer = Buffer.fromArray<T.RewardEntry>([]);

      for (key in weeklyLeaderboard.entries.keys()) {
        let winner = weeklyLeaderboard.entries[key];
        let prize = Int64.toNat64(Float.toInt64(payoutsArray[key])) * weeklyRewardAmount;
        await payReward(winner.principalId, prize);
        rewardBuffer.add({
          principalId = winner.principalId;
          rewardType = #WeeklyLeaderboard;
          position = winner.position;
          amount = prize;
        });
      };

      let newWeeklyRewards : T.WeeklyRewards = {
        seasonId = weeklyLeaderboard.seasonId;
        gameweek = weeklyLeaderboard.gameweek;
        rewards = List.fromArray(Buffer.toArray(rewardBuffer));
      };

      weeklyRewards := List.append(weeklyRewards, List.make<T.WeeklyRewards>(newWeeklyRewards));
    };

    private func findTiedEntries(entries : List.List<T.LeaderboardEntry>, points : Int16) : List.List<T.LeaderboardEntry> {
      var tiedEntries = List.nil<T.LeaderboardEntry>();
      var currentEntries = entries;

      label currentLoop while (not List.isNil(currentEntries)) {
        let (currentEntry, rest) = List.pop(currentEntries);
        currentEntries := rest;

        switch (currentEntry) {
          case (null) {};
          case (?entry) {
            if (entry.points == points) {
              tiedEntries := List.push(entry, tiedEntries);
            } else {
              break currentLoop;
            };
          };
        };
      };

      return List.reverse(tiedEntries);
    };

    private func calculateTiePayouts(tiedEntries : List.List<T.LeaderboardEntry>, scaledPercentages : [Float], startPosition : Nat) : List.List<Float> {
      let numTiedEntries = List.size(tiedEntries);
      var totalPayout : Float = 0.0;
      let endPosition : Int = startPosition + numTiedEntries - 1;

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

    private func scalePercentages(fixedPercentages : [Float], numParticipants : Nat) : [Float] {
      var totalPercentage : Float = 0.0;
      for (i in Iter.range(0, numParticipants)) {
        totalPercentage += fixedPercentages[i];
      };

      let scalingFactor : Float = 100.0 / totalPercentage;

      var scaledPercentagesBuffer = Buffer.fromArray<Float>([]);
      for (i in Iter.range(0, numParticipants)) {
        let scaledValue = fixedPercentages[i] * scalingFactor;
        scaledPercentagesBuffer.add(scaledValue);
      };

      return Buffer.toArray(scaledPercentagesBuffer);
    };

    public func distributeMonthlyRewards(rewardPool : T.RewardPool, monthlyLeaderboard : DTOs.MonthlyLeaderboardDTO) : async () {
      let monthlyRewardAmount = rewardPool.monthlyLeaderboardPool / 9;

      let clubManagersBuffer = Buffer.fromArray<T.PrincipalId>([]);
      var nonClubManagersCount : Nat = 0;

      for (canisterId in Iter.fromList(uniqueManagerCanisterIds)) {
        let manager_canister = actor (canisterId) : actor {
          getClubManagers : (clubId : T.ClubId) -> async [T.PrincipalId];
          getNonClubManagers : (clubId : T.ClubId) -> async Nat;
        };

        let managers = await manager_canister.getClubManagers(monthlyLeaderboard.clubId);
        let nonClubCount = await manager_canister.getNonClubManagers(monthlyLeaderboard.clubId);

        clubManagersBuffer.append(Buffer.fromArray(managers));
        nonClubManagersCount := nonClubManagersCount + nonClubCount;
      };

      let clubManagers = Buffer.toArray(clubManagersBuffer);

      let clubManagerCount = clubManagers.size();
      let totalClubManagers = clubManagerCount + nonClubManagersCount;

      let clubShare = clubManagerCount / totalClubManagers;

      let clubManagerMonthlyRewardAmount = Nat64.toNat(monthlyRewardAmount) * clubShare;

      var payouts = List.nil<Float>();
      var currentEntries = List.fromArray(monthlyLeaderboard.entries);

      let scaledPercentages = if (monthlyLeaderboard.totalEntries < 100) {
        scalePercentages(RewardPercentages.percentages, monthlyLeaderboard.totalEntries);
      } else {
        RewardPercentages.percentages;
      };

      while (not List.isNil(currentEntries)) {
        let (currentEntry, rest) = List.pop(currentEntries);
        currentEntries := rest;
        switch (currentEntry) {
          case (null) {};
          case (?foundEntry) {
            let (nextEntry, _) = List.pop(rest);
            switch (nextEntry) {
              case (null) {
                let payout = scaledPercentages[foundEntry.position - 1];
                payouts := List.push(payout, payouts);
              };
              case (?foundNextEntry) {
                if (foundEntry.points == foundNextEntry.points) {
                  let tiedEntries = findTiedEntries(rest, foundEntry.points);
                  let startPosition = foundEntry.position;
                  let tiePayouts = calculateTiePayouts(tiedEntries, scaledPercentages, startPosition);
                  payouts := List.append(payouts, tiePayouts);

                  var skipEntries = rest;
                  label skipLoop while (not List.isNil(skipEntries)) {
                    let (skipEntry, nextRest) = List.pop(skipEntries);
                    skipEntries := nextRest;

                    switch (skipEntry) {
                      case (null) { break skipLoop };
                      case (?entry) {
                        if (entry.points != foundEntry.points) {
                          currentEntries := skipEntries;
                          break skipLoop;
                        };
                      };
                    };
                  };
                } else {
                  let payout = scaledPercentages[foundEntry.position - 1];
                  payouts := List.push(payout, payouts);
                };
              };
            };

          };
        };
      };

      payouts := List.reverse(payouts);
      let payoutsArray = List.toArray(payouts);
      let rewardBuffer = Buffer.fromArray<T.RewardEntry>([]);

      for (key in monthlyLeaderboard.entries.keys()) {
        let winner = monthlyLeaderboard.entries[key];
        let prize = Int64.toNat64(Float.toInt64(payoutsArray[key])) * Nat64.fromNat(clubManagerMonthlyRewardAmount);
        await payReward(winner.principalId, prize);
        rewardBuffer.add({
          principalId = winner.principalId;
          rewardType = #MonthlyLeaderboard;
          position = winner.position;
          amount = prize;
        });
      };

      let newMonthlyRewards : T.MonthlyRewards = {
        seasonId = monthlyLeaderboard.seasonId;
        month = monthlyLeaderboard.month;
        clubId = monthlyLeaderboard.clubId;
        rewards = List.fromArray(Buffer.toArray(rewardBuffer));
      };
      monthlyRewards := List.append(monthlyRewards, List.make<T.MonthlyRewards>(newMonthlyRewards));
    };

    public func distributeSeasonRewards(seasonRewardPool : Nat64, seasonLeaderboard : DTOs.SeasonLeaderboardDTO) : async () {
      var payouts = List.nil<Float>();
      var currentEntries = List.fromArray(seasonLeaderboard.entries);

      let scaledPercentages = if (seasonLeaderboard.totalEntries < 100) {
        scalePercentages(RewardPercentages.percentages, seasonLeaderboard.totalEntries);
      } else {
        RewardPercentages.percentages;
      };

      while (not List.isNil(currentEntries)) {
        let (currentEntry, rest) = List.pop(currentEntries);
        currentEntries := rest;
        switch (currentEntry) {
          case (null) {};
          case (?foundEntry) {
            let (nextEntry, _) = List.pop(rest);
            switch (nextEntry) {
              case (null) {
                let payout = scaledPercentages[foundEntry.position - 1];
                payouts := List.push(payout, payouts);
              };
              case (?foundNextEntry) {
                if (foundEntry.points == foundNextEntry.points) {
                  let tiedEntries = findTiedEntries(rest, foundEntry.points);
                  let startPosition = foundEntry.position;
                  let tiePayouts = calculateTiePayouts(tiedEntries, scaledPercentages, startPosition);
                  payouts := List.append(payouts, tiePayouts);

                  var skipEntries = rest;
                  label skipLoop while (not List.isNil(skipEntries)) {
                    let (skipEntry, nextRest) = List.pop(skipEntries);
                    skipEntries := nextRest;

                    switch (skipEntry) {
                      case (null) { break skipLoop };
                      case (?entry) {
                        if (entry.points != foundEntry.points) {
                          currentEntries := skipEntries;
                          break skipLoop;
                        };
                      };
                    };
                  };
                } else {
                  let payout = scaledPercentages[foundEntry.position - 1];
                  payouts := List.push(payout, payouts);
                };
              };
            };

          };
        };
      };

      payouts := List.reverse(payouts);
      let payoutsArray = List.toArray(payouts);
      let rewardBuffer = Buffer.fromArray<T.RewardEntry>([]);

      for (key in seasonLeaderboard.entries.keys()) {
        let winner = seasonLeaderboard.entries[key];
        let prize = Int64.toNat64(Float.toInt64(payoutsArray[key])) * seasonRewardPool;
        await payReward(winner.principalId, prize);
        rewardBuffer.add({
          principalId = winner.principalId;
          rewardType = #WeeklyLeaderboard;
          position = winner.position;
          amount = prize;
        });
      };

      let newSeasonRewards : T.SeasonRewards = {
        seasonId = seasonLeaderboard.seasonId;
        rewards = List.fromArray(Buffer.toArray(rewardBuffer));
      };
      seasonRewards := List.append(seasonRewards, List.make<T.SeasonRewards>(newSeasonRewards));
    };

    public func distributeMostValuableTeamRewards(mostValuableTeamPool : Nat64, players : [DTOs.PlayerDTO], currentSeason : T.SeasonId) : async () {

      //call each canister and get the top 100 most valuable teams

      //combine and distribute rewards
      let gameweek38Snapshots = Buffer.fromArray<T.FantasyTeamSnapshot>([]);
      let mostValuableTeamsBuffer = Buffer.fromArray<T.FantasyTeamSnapshot>([]);
      for (canisterId in Iter.fromList(uniqueManagerCanisterIds)) {
        let manager_canister = actor (canisterId) : actor {
          getGameweek38Snapshots : () -> async [T.FantasyTeamSnapshot];
          getMostValuableTeams : () -> async [T.FantasyTeamSnapshot];
        };

        let gameweek38Snapshots = await manager_canister.getGameweek38Snapshots();

        let mostValuableTeams = await manager_canister.getMostValuableTeams();
        mostValuableTeamsBuffer.append(Buffer.fromArray(mostValuableTeams));
      };

      let allFinalGameweekSnapshots = Buffer.toArray(gameweek38Snapshots);

      var teamValues : TrieMap.TrieMap<T.PrincipalId, Nat16> = TrieMap.TrieMap<T.PrincipalId, Nat16>(Text.equal, Text.hash);

      for (snapshot in Iter.fromArray(allFinalGameweekSnapshots)) {
        let allPlayers = Array.filter<DTOs.PlayerDTO>(
          players,
          func(player : DTOs.PlayerDTO) : Bool {
            let playerId = player.id;
            let isPlayerIdInNewTeam = Array.find(
              snapshot.playerIds,
              func(id : Nat16) : Bool {
                return id == playerId;
              },
            );
            return Option.isSome(isPlayerIdInNewTeam);
          },
        );

        let allPlayerValues = Array.map<DTOs.PlayerDTO, Nat16>(allPlayers, func(player : DTOs.PlayerDTO) : Nat16 { return player.valueQuarterMillions });
        let totalTeamValue = Array.foldLeft<Nat16, Nat16>(allPlayerValues, 0, func(sumSoFar, x) = sumSoFar + x);
        teamValues.put(snapshot.principalId, totalTeamValue);
      };

      let teamValuesArray : [(T.PrincipalId, Nat16)] = Iter.toArray(teamValues.entries());

      let compare = func(a : (T.PrincipalId, Nat16), b : (T.PrincipalId, Nat16)) : Order.Order {
        if (a.1 > b.1) { return #greater };
        if (a.1 < b.1) { return #less };
        return #equal;
      };

      let sortedTeamValuesArray = Array.sort(teamValuesArray, compare);

      var leaderboardEntries = Array.mapEntries<(T.PrincipalId, Nat16), T.LeaderboardEntry>(
        sortedTeamValuesArray,
        func(team, index) : T.LeaderboardEntry {
          return {
            principalId = team.0;
            position = index + 1;
            points = Int16.fromNat16(team.1);
            username = "";
            positionText = "";
          };
        },
      );

      var totalRewardEntries = 100;
      if (Array.size(leaderboardEntries) < 100) {
        totalRewardEntries := Array.size(leaderboardEntries);
      };
      var rewardEntries = List.take(List.fromArray(leaderboardEntries), totalRewardEntries);

      var rewardEntriesBuffer = Buffer.fromArray<T.LeaderboardEntry>(List.toArray(rewardEntries));

      if (totalRewardEntries == 100) {
        let lastEntry = List.toArray(rewardEntries)[99];
        let tiedEntries = Array.filter<T.LeaderboardEntry>(
          leaderboardEntries,
          func(entry) : Bool {
            entry.points == lastEntry.points and entry.position > 100
          },
        );
        rewardEntriesBuffer.append(Buffer.fromArray(tiedEntries));
      };
      rewardEntries := List.fromArray(Buffer.toArray(rewardEntriesBuffer));

      var scaledPercentages = RewardPercentages.percentages;

      if (List.size(rewardEntries) < 100) {
        scaledPercentages := scalePercentages(RewardPercentages.percentages, List.size(rewardEntries));
      };

      let rewardEntriesArray = List.toArray(rewardEntries);

      let teamValueLeaderboard : T.TeamValueLeaderboard = {
        seasonId = currentSeason;
        entries = rewardEntries;
        totalEntries = List.size(rewardEntries);
      };

      teamValueLeaderboards.put(currentSeason, teamValueLeaderboard);
      let rewardBuffer = Buffer.fromArray<T.RewardEntry>([]);

      for (index in Iter.range(0, Array.size(rewardEntriesArray) - 1)) {
        let entry = rewardEntriesArray[index];
        let payoutPercentage = scaledPercentages[entry.position - 1];

        let prize = Float.fromInt64(Int64.fromNat64(mostValuableTeamPool)) * payoutPercentage;
        await payReward(entry.principalId, Int64.toNat64(Float.toInt64(prize)));
        rewardBuffer.add({
          principalId = entry.principalId;
          rewardType = #MostValuableTeam;
          position = entry.position;
          amount = Int64.toNat64(Float.toInt64(prize));
        });
      };

      let newMVTRewards : T.SeasonRewards = {
        seasonId = currentSeason;
        rewards = List.fromArray(Buffer.toArray(rewardBuffer));
      };
      mostValuableTeamRewards := List.append(mostValuableTeamRewards, List.make<T.SeasonRewards>(newMVTRewards));
    };

    public func distributeHighestScoringPlayerRewards(seasonId : T.SeasonId, gameweek : T.GameweekNumber, highestScoringPlayerRewardPool : Nat64, fixtures : List.List<DTOs.FixtureDTO>) : async () {

      let highestScoringPlayerIdBuffer = Buffer.fromArray<T.PlayerId>([]);

      for (fixture in Iter.fromList(fixtures)) {
        if (fixture.highestScoringPlayerId > 0) {
          highestScoringPlayerIdBuffer.add(fixture.highestScoringPlayerId);
        };
      };

      let highestScoringPlayerIds = Buffer.toArray(highestScoringPlayerIdBuffer);

      let gameweekRewardAmount = highestScoringPlayerRewardPool / 38;

      let playerRewardShare = Nat64.toNat(gameweekRewardAmount) / Array.size(highestScoringPlayerIds);

      for (highestScoringPlayerId in Iter.fromArray(highestScoringPlayerIds)) {

        let managersWithPlayerBuffer = Buffer.fromArray<T.PrincipalId>([]);
        for (canisterIds in Iter.fromList(uniqueManagerCanisterIds)) {
          let manager_canister = actor (canisterIds) : actor {
            getManagersWithPlayer : (playerId : T.PlayerId) -> async [T.PrincipalId];
          };

          let managerIds = await manager_canister.getManagersWithPlayer(highestScoringPlayerId);

          managersWithPlayerBuffer.append(Buffer.fromArray(managerIds));
        };

        let prize = Nat64.fromNat(Nat64.toNat(gameweekRewardAmount) / managersWithPlayerBuffer.size());
        let rewardBuffer = Buffer.fromArray<T.RewardEntry>([]);

        let managersWithPlayers = Buffer.toArray(managersWithPlayerBuffer);

        for (managerPrincipalId in Iter.fromArray(managersWithPlayers)) {
          await payReward(managerPrincipalId, prize);
          rewardBuffer.add({
            principalId = managerPrincipalId;
            rewardType = #WeeklyLeaderboard;
            position = 0;
            amount = prize;
          });
        };

        let newHSPRewards : T.WeeklyRewards = {
          seasonId = seasonId;
          gameweek = gameweek;
          rewards = List.fromArray(Buffer.toArray(rewardBuffer));
        };
        highScoringPlayerRewards := List.append(highScoringPlayerRewards, List.make<T.SeasonRewards>(newHSPRewards));
      };
    };

    public func distributeWeeklyATHScoreRewards(weeklyRewardPool : Nat64, weeklyLeaderboard : DTOs.WeeklyLeaderboardDTO) : async () {
      let weeklyATHReward = weeklyRewardPool / 38;
      let maybeLastHighScore = List.last<T.HighScoreRecord>(weeklyAllTimeHighScores);
      var highestWeeklyScore : Int16 = 0;
      switch (maybeLastHighScore) {
        case (null) {
          highestWeeklyScore := 0;
        };
        case (?lastHighScore) {
          highestWeeklyScore := lastHighScore.points;
        };
      };

      let leaderboardEntries = weeklyLeaderboard.entries;
      let topScore : Int16 = if (leaderboardEntries.size() > 0) {
        leaderboardEntries[0].points;
      } else {
        0;
      };

      if (topScore > highestWeeklyScore) {
        weeklyAllTimeHighScores := List.append(weeklyAllTimeHighScores, List.make({ recordType = #WeeklyHighScore; points = topScore; createDate = Time.now() }));
        await payReward(leaderboardEntries[0].principalId, weeklyRewardPool);
        weeklyATHPrizePool := 0;
      };

      var tiedWinners = Array.filter<T.LeaderboardEntry>(
        leaderboardEntries,
        func(entry) : Bool { entry.points == topScore },
      );

      if (tiedWinners.size() > 1 and topScore > highestWeeklyScore) {
        let payoutPerWinner = weeklyRewardPool / Nat64.fromNat(tiedWinners.size());
        for (winner in Iter.fromArray(tiedWinners)) {
          await payReward(winner.principalId, payoutPerWinner);
          weeklyAllTimeHighScores := List.append(weeklyAllTimeHighScores, List.make({ recordType = #WeeklyHighScore; points = winner.points; createDate = Time.now() }));
          weeklyATHPrizePool := 0;
        };
      } else {
        await mintToTreasury(weeklyATHReward);
        weeklyATHPrizePool := weeklyATHPrizePool + weeklyATHReward;
      };
    };

    public func distributeMonthlyATHScoreRewards(monthlyRewardPool : Nat64, monthlyLeaderboards : [DTOs.MonthlyLeaderboardDTO]) : async () {
      let monthlyATHReward = monthlyRewardPool / 9;

      let maybeLastHighScore = List.last<T.HighScoreRecord>(monthlyAllTimeHighScores);
      var highestMonthlyScore : Int16 = 0;
      switch (maybeLastHighScore) {
        case (null) {
          highestMonthlyScore := 0;
        };
        case (?lastHighScore) {
          highestMonthlyScore := lastHighScore.points;
        };
      };

      var winnersBuffer = Buffer.fromArray<T.LeaderboardEntry>([]);
      var newRecordSet = false;

      var winners = Buffer.toArray(winnersBuffer);
      for (monthlyLeaderboard in Iter.fromArray(monthlyLeaderboards)) {
        let leaderboardEntries = monthlyLeaderboard.entries;
        if (leaderboardEntries.size() > 0) {
          let topScore = leaderboardEntries[0].points;
          if (topScore > highestMonthlyScore) {
            highestMonthlyScore := topScore;
            winnersBuffer.clear();
            winnersBuffer.add(leaderboardEntries[0]);
            newRecordSet := true;

            winners := Buffer.toArray(winnersBuffer);
            for (entry in leaderboardEntries.vals()) {
              if (entry.points == topScore and entry.principalId != winners[0].principalId) {
                winnersBuffer.add(entry);
              };
            };
          };
        };
      };

      winners := Buffer.toArray(winnersBuffer);
      if (newRecordSet) {
        let totalPayout = monthlyATHReward * Nat64.fromNat(winners.size());
        for (winner in Iter.fromArray(winners)) {
          await payReward(winner.principalId, totalPayout / Nat64.fromNat(winners.size()));
          monthlyAllTimeHighScores := List.append(monthlyAllTimeHighScores, List.make({ recordType = #MonthlyHighScore; points = winner.points; createDate = Time.now() }));
          monthlyATHPrizePool := 0;
        };
      } else {
        await mintToTreasury(monthlyATHReward);
        monthlyATHPrizePool := monthlyATHPrizePool + monthlyATHReward;
      };
    };

    public func distributeSeasonATHScoreRewards(seasonRewardPool : Nat64, seasonLeaderboard : DTOs.SeasonLeaderboardDTO) : async () {
      let maybeLastHighScore = List.last<T.HighScoreRecord>(seasonAllTimeHighScores);
      var highestSeasonScore : Int16 = 0;
      switch (maybeLastHighScore) {
        case (null) {
          highestSeasonScore := 0;
        };
        case (?lastHighScore) {
          highestSeasonScore := lastHighScore.points;
        };
      };

      let leaderboardEntries = seasonLeaderboard.entries;
      let topScore : Int16 = if (leaderboardEntries.size() > 0) {
        leaderboardEntries[0].points;
      } else {
        0;
      };

      if (topScore > highestSeasonScore) {
        seasonAllTimeHighScores := List.append(seasonAllTimeHighScores, List.make({ recordType = #SeasonHighScore; points = topScore; createDate = Time.now() }));
        await payReward(leaderboardEntries[0].principalId, seasonRewardPool);
        seasonATHPrizePool := 0;
      };

      var tiedWinners = Array.filter<T.LeaderboardEntry>(
        leaderboardEntries,
        func(entry) : Bool { entry.points == topScore },
      );

      if (tiedWinners.size() > 1 and topScore > highestSeasonScore) {
        let payoutPerWinner = seasonRewardPool / Nat64.fromNat(tiedWinners.size());
        let rewardBuffer = Buffer.fromArray<T.RewardEntry>([]);
        for (winner in Iter.fromArray(tiedWinners)) {
          await payReward(winner.principalId, payoutPerWinner);
          seasonAllTimeHighScores := List.append(seasonAllTimeHighScores, List.make({ recordType = #SeasonHighScore; points = winner.points; createDate = Time.now() }));
          seasonATHPrizePool := 0;
        };
      } else {
        await mintToTreasury(seasonRewardPool);
        weeklyATHPrizePool := weeklyATHPrizePool + seasonRewardPool;
      };
    };

    private func payReward(principalId : T.PrincipalId, fpl : Nat64) : async () {
      return await tokenCanister.transferToken(principalId, Nat64.toNat(fpl));
    };

    private func mintToTreasury(fpl : Nat64) : async () {
      return await tokenCanister.mintToTreasury(Nat64.toNat(fpl));
    };

    //TODO: Redo stable storage

    //redo: merge with stable functions at bottom and redo

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
      return Iter.toArray(teamValueLeaderboards.entries());
    };

    public func setStableTeamValueLeaderboards(stable_team_value_leaderboards : [(T.SeasonId, T.TeamValueLeaderboard)]) {
      teamValueLeaderboards := TrieMap.fromEntries<T.SeasonId, T.TeamValueLeaderboard>(
        Iter.fromArray(stable_team_value_leaderboards),
        Utilities.eqNat16,
        Utilities.hashNat16,
      );
    };

    public func getStableSeasonRewards() : [T.SeasonRewards] {
      return List.toArray(seasonRewards);
    };

    public func setStableSeasonRewards(stable_season_rewards : [T.SeasonRewards]) {
      seasonRewards := List.fromArray(stable_season_rewards);
    };

    public func getStableMonthlyRewards() : [T.MonthlyRewards] {
      return List.toArray(monthlyRewards);
    };

    public func setStableMonthlyRewards(stable_monthly_rewards : [T.MonthlyRewards]) {
      seasonRewards := List.fromArray(stable_monthly_rewards);
    };

    public func getStableWeeklyRewards() : [T.WeeklyRewards] {
      return List.toArray(weeklyRewards);
    };

    public func setStableWeeklyRewards(stable_weekly_rewards : [T.WeeklyRewards]) {
      seasonRewards := List.fromArray(stable_weekly_rewards);
    };

    public func getStableMostValuableTeamRewards() : [T.RewardsList] {
      return List.toArray(mostValuableTeamRewards);
    };

    public func setStableMostValuableTeamRewards(stable_most_valuable_team_rewards : [T.RewardsList]) {
      mostValuableTeamRewards := List.fromArray(stable_most_valuable_team_rewards);
    };

    public func getStableHighestScoringPlayerRewards() : [T.RewardsList] {
      return List.toArray(highScoringPlayerRewards);
    };

    public func setStableHighestScoringPlayerRewards(stable_highest_scoring_player_rewards : [T.RewardsList]) {
      highScoringPlayerRewards := List.fromArray(stable_highest_scoring_player_rewards);
    };

    public func getStableWeeklyATHScores() : [T.HighScoreRecord] {
      return List.toArray(weeklyAllTimeHighScores);
    };

    public func setStableWeeklyATHScores(stable_weekly_ath_scores : [T.HighScoreRecord]) {
      weeklyAllTimeHighScores := List.fromArray(stable_weekly_ath_scores);
    };

    public func getStableMonthlyATHScores() : [T.HighScoreRecord] {
      return List.toArray(monthlyAllTimeHighScores);
    };

    public func setStableMonthlyATHScores(stable_monthly_ath_scores : [T.HighScoreRecord]) {
      monthlyAllTimeHighScores := List.fromArray(stable_monthly_ath_scores);
    };

    public func getStableSeasonATHScores() : [T.HighScoreRecord] {
      return List.toArray(seasonAllTimeHighScores);
    };

    public func setStableSeasonATHScores(stable_season_ath_scores : [T.HighScoreRecord]) {
      seasonAllTimeHighScores := List.fromArray(stable_season_ath_scores);
    };

    public func getStableWeeklyATHPrizePool() : Nat64 {
      return weeklyATHPrizePool;
    };

    public func setStableWeeklyATHPrizePool(stable_weekly_ath_prize_pool : Nat64) {
      weeklyATHPrizePool := stable_weekly_ath_prize_pool;
    };

    public func getStableMonthlyATHPrizePool() : Nat64 {
      return monthlyATHPrizePool;
    };

    public func setStableMonthlyATHPrizePool(stable_monthly_ath_prize_pool : Nat64) {
      monthlyATHPrizePool := stable_monthly_ath_prize_pool;
    };

    public func getSeasonATHPrizePool() : Nat64 {
      return seasonATHPrizePool;
    };

    public func setSeasonATHPrizePool(stable_season_ath_prize_pool : Nat64) {
      seasonATHPrizePool := stable_season_ath_prize_pool;
    };

    private func createManagerCanister() : async Text {

      Cycles.add(2_000_000_000_000);
      let canister = await ManagerCanister.ManagerCanister();
      let IC : Management.Management = actor (ENV.Default);
      let _ = await Utilities.updateCanister_(canister, backendCanisterController, IC);
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

    public func init() : async Result.Result<(), T.Error> {
      let result = await createManagerCanister();
      if (result == "") {
        return #err(#CanisterCreateError);
      };
      return #ok;
    };
  };
};

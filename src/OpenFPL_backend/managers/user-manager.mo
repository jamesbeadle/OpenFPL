import Result "mo:base/Result";
import TrieMap "mo:base/TrieMap";
import List "mo:base/List";
import Text "mo:base/Text";
import Iter "mo:base/Iter";
import Principal "mo:base/Principal";
import Buffer "mo:base/Buffer";
import Base "mo:waterway-mops/BaseTypes";
import Ids "mo:waterway-mops/Ids";
import Enums "mo:waterway-mops/Enums";
import IcfcEnums "mo:waterway-mops/ICFCEnums";
import Management "mo:waterway-mops/Management";
import CanisterUtilities "mo:waterway-mops/CanisterUtilities";
import CanisterIds "mo:waterway-mops/CanisterIds";
import Helpers "mo:waterway-mops/Helpers";
import FootballDefinitions "mo:waterway-mops/football/FootballDefinitions";
import FootballIds "mo:waterway-mops/football/FootballIds";
import BaseDefinitions "mo:waterway-mops/BaseDefinitions";
import Cycles "mo:base/ExperimentalCycles";
import Time "mo:base/Time";
import Nat64 "mo:base/Nat64";
import Nat8 "mo:base/Nat8";
import Array "mo:base/Array";
import Option "mo:base/Option";
import Nat16 "mo:base/Nat16";
import Bool "mo:base/Bool";
import Debug "mo:base/Debug";
import UserQueries "../queries/user_queries";
import AppTypes "../types/app_types";
import LeaderboardQueries "../queries/leaderboard_queries";
import UserCommands "../commands/user_commands";
import PickTeamUtilities "../utilities/pick_team_utilities";
import ManagerCanister "../canister_definitions/manager-canister";
import DataCanister "canister:data_canister";
import SHA224 "mo:waterway-mops/SHA224";

module {

  public class UserManager() {

    //stable use storage storage

    private var managerCanisterIds : TrieMap.TrieMap<Ids.PrincipalId, Ids.CanisterId> = TrieMap.TrieMap<Ids.PrincipalId, Ids.CanisterId>(Text.equal, Text.hash);
    private var usernames : TrieMap.TrieMap<Ids.PrincipalId, Text> = TrieMap.TrieMap<Ids.PrincipalId, Text>(Text.equal, Text.hash);
    private var uniqueManagerCanisterIds : List.List<Ids.CanisterId> = List.nil();
    private var totalManagers : Nat = 0;
    private var activeManagerCanisterId : Ids.CanisterId = "";

    private var userICFCProfiles : TrieMap.TrieMap<Ids.PrincipalId, UserQueries.ICFCProfile> = TrieMap.TrieMap<Ids.PrincipalId, UserQueries.ICFCProfile>(Text.equal, Text.hash);

    //Getters

    public func getProfile(dto: UserQueries.GetProfile) : async Result.Result<UserQueries.Profile, Enums.Error> {
      let userManagerCanisterId = managerCanisterIds.get(dto.principalId);

      switch (userManagerCanisterId) {
        case (?foundUserCanisterId) {

          let manager_canister = actor (foundUserCanisterId) : actor {
            getManager : Ids.PrincipalId -> async ?AppTypes.Manager;
          };
          let manager = await manager_canister.getManager(dto.principalId);

          switch (manager) {
            case (null) {
              return #err(#NotFound);
            };
            case (?foundManager) {

              let profileDTO : UserQueries.Profile = {
                principalId = dto.principalId;
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
        case (null) {
          return #err(#NotFound);
        };
      };
    };

    /*
    public func getUserICFCProfileStatus(managerPrincipalId : Ids.PrincipalId) : async Result.Result<IcfcEnums.ICFCLinkStatus, Enums.Error> {
      let icfcProfile : ?UserQueries.ICFCProfile = userICFCProfiles.get(managerPrincipalId);

      switch (icfcProfile) {
        case (null) {
          return #err(#NotFound);
        };
        case (?foundICFCProfile) {
          return #ok(foundICFCProfile.linkStatus);
        };
      };
    };
    */

    public func getICFCProfile(dto : UserQueries.GetICFCProfile) : async Result.Result<UserQueries.ICFCProfile, Enums.Error> {
      let icfcProfile : ?UserQueries.ICFCProfile = userICFCProfiles.get(dto.principalId);

      switch (icfcProfile) {
        case (null) {
          return #err(#NotFound);
        };
        case (?icfcProfile) {

          let icfc_canister = actor (CanisterIds.ICFC_BACKEND_CANISTER_ID) : actor {
            getICFCProfileSummary : UserQueries.GetICFCProfile -> async Result.Result<UserQueries.ICFCProfile, Enums.Error>
          };

          let icfcMembershipDTO : UserQueries.GetICFCProfile = {
            principalId = icfcProfile.principalId;
          };

          return await icfc_canister.getICFCProfileSummary(icfcMembershipDTO);

        };
      };
    };
    
    public func getManager(dto : UserQueries.GetManager, seasonId: FootballIds.SeasonId, weeklyLeaderboardEntry : ?LeaderboardQueries.LeaderboardEntry, monthlyLeaderboardEntry : ?LeaderboardQueries.LeaderboardEntry, seasonLeaderboardEntry : ?LeaderboardQueries.LeaderboardEntry) : async Result.Result<UserQueries.Manager, Enums.Error> {

      let managerCanisterId = managerCanisterIds.get(dto.principalId);

      switch (managerCanisterId) {
        case (null) {
          return #err(#NotFound);
        };
        case (?foundCanisterId) {
          let manager_canister = actor (foundCanisterId) : actor {
            getManager : Ids.PrincipalId -> async ?AppTypes.Manager;
          };

          let manager = await manager_canister.getManager(dto.principalId);
          switch (manager) {
            case (null) {
              return #err(#NotFound);
            };
            case (?foundManager) {
              for (managerSeason in Iter.fromList(foundManager.history)) {
                if (managerSeason.seasonId == seasonId) {

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

                  let managerDTO : UserQueries.Manager = {
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
                    weeklyPoints = weeklyPoints;
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

    public func getManagerByUsername(username : Text) : async Result.Result<UserQueries.Manager, Enums.Error> {

      for (managerUsername in usernames.entries()) {
        if (managerUsername.1 == username) {
          let managerPrincipalId = managerUsername.0;
          let managerCanisterId = managerCanisterIds.get(managerPrincipalId);
          switch (managerCanisterId) {
            case null { return #err(#NotFound) };
            case (?foundCanisterId) {
              let manager_canister = actor (foundCanisterId) : actor {
                getManager : Ids.PrincipalId -> async ?AppTypes.Manager;
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

                  let managerDTO : UserQueries.Manager = {
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
            };
          };
        };
      };
      return #err(#NotFound);
    };
    
    public func getTeamSetup(dto: UserQueries.GetTeamSetup, currentSeasonId: FootballIds.SeasonId) : async Result.Result<UserQueries.TeamSetup, Enums.Error> {

      let managerCanisterId = managerCanisterIds.get(dto.principalId);
      switch (managerCanisterId) {
        case (null) {
          return #err(#NotFound);
        };
        case (?foundCanisterId) {

          let manager_canister = actor (foundCanisterId) : actor {
            getManager : Ids.PrincipalId -> async ?AppTypes.Manager;
          };
          let manager = await manager_canister.getManager(dto.principalId);
          switch (manager) {
            case (null) {
              return #err(#NotFound);
            };
            case (?foundManager) {

              var firstGameweek = true;
              let currentManagerSeason = List.find<AppTypes.FantasyTeamSeason>(
                foundManager.history,
                func(season : AppTypes.FantasyTeamSeason) : Bool {
                  season.seasonId == currentSeasonId;
                },
              );

              let hasPlayersInTeam = Array.size(foundManager.playerIds) > 0;

              switch (currentManagerSeason) {
                case (?foundSeason) {
                  let validGameweeks = List.filter<AppTypes.FantasyTeamSnapshot>(
                    foundSeason.gameweeks,
                    func(entry : AppTypes.FantasyTeamSnapshot) {
                      entry.gameweek > 28; // TODO Update next season
                    },
                  );
                  firstGameweek := List.size(validGameweeks) == 0 or not hasPlayersInTeam;
                };
                case (null) {};
              };

              let pickTeamDTO : UserQueries.TeamSetup = {
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
    
    public func getFantasyTeamSnapshot(dto : UserQueries.GetFantasyTeamSnapshot) : async Result.Result<UserQueries.FantasyTeamSnapshot, Enums.Error> {
      let managerCanisterId = managerCanisterIds.get(dto.principalId);
      switch (managerCanisterId) {
        case (null) {
          return #err(#NotFound);
        };
        case (?foundCanisterId) {
          let manager_canister = actor (foundCanisterId) : actor {
            getFantasyTeamSnapshot : (managerPrincipalId : Ids.PrincipalId, dto : UserQueries.GetFantasyTeamSnapshot) -> async ?UserQueries.FantasyTeamSnapshot;
          };

          let snapshot = await manager_canister.getFantasyTeamSnapshot(dto.principalId, dto);
          switch (snapshot) {
            case (null) {
              return #err(#NotFound);
            };
            case (?foundSnapshot) {

              #ok({
                bankQuarterMillions = foundSnapshot.bankQuarterMillions;
                braceBonusGameweek = foundSnapshot.braceBonusGameweek;
                captainFantasticGameweek = foundSnapshot.captainFantasticGameweek;
                captainFantasticPlayerId = foundSnapshot.captainFantasticPlayerId;
                captainId = foundSnapshot.captainId;
                favouriteClubId = foundSnapshot.favouriteClubId;
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
                username = foundSnapshot.username;
              });
            };
          };
        };
      };
    };

    public func getManagerCanisterIds() : [(Ids.PrincipalId, Ids.CanisterId)] {
      return Iter.toArray(managerCanisterIds.entries());
    };

    public func getUniqueManagerCanisterIds() : [Ids.CanisterId] {
      return List.toArray(uniqueManagerCanisterIds);
    };

    public func getTotalManagers() : Result.Result<Nat, Enums.Error> {
      return #ok(totalManagers);
    };

    public func isUsernameTaken(username : Text, principalId : Text) : Bool {
      for (managerUsername in usernames.entries()) {

        let lowerCaseUsername = Helpers.toLowercase(username);
        let existingUsername = Helpers.toLowercase(managerUsername.1);

        if (lowerCaseUsername == existingUsername and managerUsername.0 != principalId) {
          return true;
        };
      };

      return false;
    };

    //User updates


    //TODO: I think we only need one

    /*

    public func linkICFCProfile(dto : UserCommands.LinkICFCProfile) : async Result.Result<(), Enums.Error> {
      let icfcProfile : AppTypes.ICFCProfile = {
        principalId = dto.icfcPrincipalId;
        linkStatus = #PendingVerification;
        dataHash = await SHA224.getRandomHash();
        membershipType = dto.membershipType;
      };
      userICFCProfiles.put(dto.subAppUserPrincipalId, icfcProfile);
      return #ok();
    };

    */
    
    public func updateFavouriteClub(dto : UserCommands.SetFavouriteClub, activeClubs : [DataCanister.Club], seasonActive : Bool) : async Result.Result<(), Enums.Error> {

      // TODO: John, This can set in a profile here and allow to be different in OpenFPL from profile value

      let isClubActive = Array.find(
        activeClubs,
        func(club : DataCanister.Club) : Bool {
          return club.id == dto.favouriteClubId;
        },
      );
      if (not Option.isSome(isClubActive)) {
        return #err(#NotFound);
      };

      if (dto.favouriteClubId <= 0) {
        return #err(#InvalidData);
      };

      let managerCanisterId = managerCanisterIds.get(dto.principalId);
      switch (managerCanisterId) {
        case (null) {
          return #err(#NotFound);
        };
        case (?foundManagerCanisterId) {

          let manager_canister = actor (foundManagerCanisterId) : actor {
            getManager : Ids.PrincipalId -> async ?AppTypes.Manager;
            updateFavouriteClub : (dto : UserCommands.SetFavouriteClub) -> async Result.Result<(), Enums.Error>;
          };

          let manager = await manager_canister.getManager(dto.principalId);
          if (not seasonActive) {
            return await manager_canister.updateFavouriteClub(dto);
          };

          switch (manager) {
            case (?foundManager) {
              switch (foundManager.favouriteClubId) {
                case (?foundClubId) {
                  if (foundClubId > 0) {
                    return #err(#InvalidData);
                  };
                };
                case (null) {};
              };
              return await manager_canister.updateFavouriteClub(dto);
            };
            case (null) {
              return #err(#NotFound);
            };
          };
        };
      };
    };

    //What are we updating here?

    /*

    public func updateICFCProfile(dto : UserCommands.UpdateICFCProfile) : async Result.Result<(), Enums.Error> {
      let icfcProfile : ?T.ICFCProfile = userICFCProfiles.get(dto.subAppUserPrincipalId);

      switch (icfcProfile) {
        case (null) {
          return #err(#NotFound);
        };
        case (?foundICFCProfile) {
          let newHash = await SHA224.getRandomHash();
          let _ = userICFCProfiles.put(
            dto.subAppUserPrincipalId,
            {
              principalId = foundICFCProfile.principalId;
              linkStatus = foundICFCProfile.linkStatus;
              dataHash = newHash;
              membershipType = dto.membershipType;
            },
          );
          return #ok();
        };
      };
    };

    */

    public func saveBonusSelection(dto : UserCommands.PlayBonus, gameweek : FootballDefinitions.GameweekNumber) : async Result.Result<(), Enums.Error> {
      let managerCanisterId = managerCanisterIds.get(dto.principalId);

      switch (managerCanisterId) {
        case (null) {
          return #err(#NotFound);
        };
        case (?foundManagerCanisterId) {
          return await useBonus(foundManagerCanisterId, dto, gameweek);
        };
      };
    };
    
    public func saveTeamSelection(dto : UserCommands.SaveFantasyTeam, seasonId : FootballIds.SeasonId, players : [DataCanister.Player]) : async Result.Result<(), Enums.Error> {

      let teamValidResult = PickTeamUtilities.teamValid(dto, players);
      switch (teamValidResult) {
        case (#ok _) {};
        case (#err errorResult) {
          return #err(errorResult);
        };
      };

      let managerCanisterId = managerCanisterIds.get(dto.principalId);

      switch (managerCanisterId) {
        case (null) {
          return #err(#NotFound);
        };
        case (?foundManagerCanisterId) {
          return await updateFantasyTeam(foundManagerCanisterId, dto, seasonId, players);
        };
      };
    };

    //Private data modification functions

    //need to think when the new manager object is created
/*
    private func createNewManager(dto : UserCommands.LinkICFCProfile) : async Result.Result<(), Enums.Error> {

      if (activeManagerCanisterId == "") {
        activeManagerCanisterId := await createManagerCanister();
      };

      let manager_canister = actor (activeManagerCanisterId) : actor {
        getTotalManagers : () -> async Nat;
      };

      let canisterManagerCount = await manager_canister.getTotalManagers();
      if (canisterManagerCount >= 12000) {
        activeManagerCanisterId := await createManagerCanister();
      };

      let newManager : AppTypes.Manager = {
        principalId = dto.principalId;
        username = dto.username;
        favouriteClubId = dto.favouriteClubId;
        createDate = Time.now();
        termsAccepted = false;
        profilePicture = null;
        profilePictureType = "";
        transfersAvailable = 3;
        monthlyBonusesAvailable = 2;
        bankQuarterMillions = 1400;
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
        oneNationGameweek = 0;
        oneNationCountryId = 0;
        prospectsGameweek = 0;
        braceBonusGameweek = 0;
        hatTrickHeroGameweek = 0;
        transferWindowGameweek = 0;
        history = List.nil();
        canisterId = activeManagerCanisterId;
      };

      let new_manager_canister = actor (activeManagerCanisterId) : actor {
        addNewManager : (manager : AppTypes.Manager) -> async Result.Result<(), Enums.Error>;
      };

      let result = await new_manager_canister.addNewManager(newManager);

      return result;
    };
    */
    private func updateFantasyTeam(managerCanisterId : Ids.CanisterId, dto : UserCommands.SaveFantasyTeam, seasonId : FootballIds.SeasonId, allPlayers : [DataCanister.Player]) : async Result.Result<(), Enums.Error> {
      let manager_canister = actor (managerCanisterId) : actor {
        getManager : Ids.PrincipalId -> async ?AppTypes.Manager;
        updateTeamSelection : (dto : UserCommands.SaveFantasyTeam, transfersAvailable : Nat8, newBankBalance : Nat16) -> async Result.Result<(), Enums.Error>;
      };

      let manager = await manager_canister.getManager(dto.principalId);

      switch (manager) {
        case (null) {
          return #err(#NotFound);
        };
        case (?foundManager) {

          if (PickTeamUtilities.overspent(foundManager.bankQuarterMillions, foundManager.playerIds, dto.playerIds, allPlayers)) {
            return #err(#MaxDataExceeded);
          };

          var transfersAvailable = 3;
          var firstGameweek = true;
          let currentManagerSeason = List.find<AppTypes.FantasyTeamSeason>(
            foundManager.history,
            func(season : AppTypes.FantasyTeamSeason) : Bool {
              season.seasonId == seasonId;
            },
          );

          switch (currentManagerSeason) {
            case (?foundSeason) {
              firstGameweek := List.size(foundSeason.gameweeks) == 0;
            };
            case (null) {};
          };

          let hasPlayersInTeam = Array.size(foundManager.playerIds) > 0;

          if (not firstGameweek and hasPlayersInTeam) {
            transfersAvailable := PickTeamUtilities.getTransfersAvailable(foundManager, dto.playerIds, allPlayers);
            if (transfersAvailable < 0) {
              return #err(#MaxDataExceeded);
            };
          };

          var newBankBalanceResult = PickTeamUtilities.getNewBankBalance(foundManager, dto, allPlayers);
          switch (newBankBalanceResult) {
            case (#ok newBankBalance) {
              return await manager_canister.updateTeamSelection(
                dto,
                Nat8.fromNat(Nat64.toNat(Nat64.fromIntWrap(transfersAvailable))),
                newBankBalance,
              );
            };
            case (#err error) {
              return #err(error);
            };
          };
        };
      };
    };
    
    private func useBonus(managerCanisterId : Ids.CanisterId, dto : UserCommands.PlayBonus, gameweek : FootballDefinitions.GameweekNumber) : async Result.Result<(), Enums.Error> {
      let manager_canister = actor (managerCanisterId) : actor {
        getManager : Ids.PrincipalId -> async ?AppTypes.Manager;
        useBonus : (dto : UserCommands.PlayBonus, monthlyBonuses : Nat8) -> async Result.Result<(), Enums.Error>;
      };

      let manager = await manager_canister.getManager(dto.principalId);

      switch (manager) {
        case (null) {
          return #err(#NotFound);
        };
        case (?foundManager) {
          
          let bonusAlreadyPaid = PickTeamUtilities.selectedBonusPlayedAlready(foundManager, dto);
          if (bonusAlreadyPaid) {
            return #err(#InvalidData);
          };

          if (foundManager.monthlyBonusesAvailable == 0) {
            return #err(#InvalidData);
          };

          if (PickTeamUtilities.isGameweekBonusUsed(foundManager, gameweek)) {
            return #err(#InvalidData);
          };

          return await manager_canister.useBonus(dto, 2); // TODO: John this needs to not always be 2 
        };
      };
    };

    //Called by application

    public func snapshotFantasyTeams(seasonId : FootballIds.SeasonId, gameweek : FootballDefinitions.GameweekNumber, month : BaseDefinitions.CalendarMonth) : async () {

      for (canisterId in Iter.fromList(uniqueManagerCanisterIds)) {

        let manager_canister = actor (canisterId) : actor {
          snapshotFantasyTeams : (seasonId : FootballIds.SeasonId, gameweek : FootballDefinitions.GameweekNumber, month : BaseDefinitions.CalendarMonth) -> async ();
        };

        await manager_canister.snapshotFantasyTeams(seasonId, gameweek, month);
      };
    };

    public func calculateFantasyTeamScores(leagueId : FootballIds.LeagueId, seasonId : FootballIds.SeasonId, gameweek : FootballDefinitions.GameweekNumber, month : BaseDefinitions.CalendarMonth) : async () {
      for (canisterId in Iter.fromList(uniqueManagerCanisterIds)) {

        let manager_canister = actor (canisterId) : actor {
          calculateFantasyTeamScores : (leagueId : FootballIds.LeagueId, seasonId : FootballIds.SeasonId, gameweek : FootballDefinitions.GameweekNumber, month : BaseDefinitions.CalendarMonth) -> async ();
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

    public func removePlayerFromTeams(leagueId : FootballIds.LeagueId, playerId : FootballIds.PlayerId, parentCanisterId : Ids.CanisterId) : async () {
      for (canisterId in Iter.fromList(uniqueManagerCanisterIds)) {

        let manager_canister = actor (canisterId) : actor {
          removePlayerFromTeams : (leagueId : FootballIds.LeagueId, playerId : FootballIds.PlayerId, parentCanisterId : Ids.CanisterId) -> async ();
        };

        await manager_canister.removePlayerFromTeams(leagueId, playerId, parentCanisterId);
      };
    };

    //Canister management functions

    private func createManagerCanister() : async Text {
      Cycles.add<system>(50_000_000_000_000);
      let canister = await ManagerCanister._ManagerCanister();
      let IC : Management.Management = actor (CanisterIds.Default);
      let _ = await CanisterUtilities.updateCanister_(canister, ?Principal.fromText(CanisterIds.OPENFPL_BACKEND_CANISTER_ID), IC);

      let canister_principal = Principal.fromActor(canister);
      let canisterId = Principal.toText(canister_principal);

      if (canisterId == "") {
        return canisterId;
      };

      let uniqueCanisterIdBuffer = Buffer.fromArray<Ids.CanisterId>(List.toArray(uniqueManagerCanisterIds));
      uniqueCanisterIdBuffer.add(canisterId);
      uniqueManagerCanisterIds := List.fromArray(Buffer.toArray(uniqueCanisterIdBuffer));
      activeManagerCanisterId := canisterId;
      return canisterId;
    };

    //stable getters and setters

    public func getStableManagerCanisterIds() : [(Ids.PrincipalId, Ids.CanisterId)] {
      return Iter.toArray(managerCanisterIds.entries());
    };

    public func setStableManagerCanisterIds(stable_manager_canister_ids : [(Ids.PrincipalId, Ids.CanisterId)]) : () {
      let canisterIds : TrieMap.TrieMap<Ids.PrincipalId, Ids.CanisterId> = TrieMap.TrieMap<Ids.PrincipalId, Ids.CanisterId>(Text.equal, Text.hash);

      for (canisterId in Iter.fromArray(stable_manager_canister_ids)) {
        canisterIds.put(canisterId);
      };
      managerCanisterIds := canisterIds;
    };

    public func getStableUsernames() : [(Ids.PrincipalId, Text)] {
      return Iter.toArray(usernames.entries());
    };

    public func setStableUsernames(stable_manager_usernames : [(Ids.PrincipalId, Text)]) : () {
      let usernameMap : TrieMap.TrieMap<Ids.PrincipalId, Ids.CanisterId> = TrieMap.TrieMap<Ids.PrincipalId, Ids.CanisterId>(Text.equal, Text.hash);

      for (username in Iter.fromArray(stable_manager_usernames)) {
        usernameMap.put(username);
      };
      usernames := usernameMap;
    };

    public func getStableUniqueManagerCanisterIds() : [Ids.CanisterId] {
      return List.toArray(uniqueManagerCanisterIds);
    };

    public func setStableUniqueManagerCanisterIds(stable_unique_manager_canister_ids : [Ids.CanisterId]) : () {
      uniqueManagerCanisterIds := List.fromArray(stable_unique_manager_canister_ids);
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

    public func setStableActiveManagerCanisterId(stable_active_manager_canister_id : Ids.CanisterId) : () {
      activeManagerCanisterId := stable_active_manager_canister_id;
    };

    public func getStableUserICFCProfiles() : [(Ids.PrincipalId, UserQueries.ICFCProfile)] {
      return Iter.toArray(userICFCProfiles.entries());
    };
/*
    public func setStableUserICFCProfiles(stable_user_icfc_profiles : [(Ids.PrincipalId, UserQueries.ICFCProfile)]) : () {
      let profileMap : TrieMap.TrieMap<Ids.PrincipalId, T.ICFCProfile> = TrieMap.TrieMap<Ids.PrincipalId, T.ICFCProfile>(Text.equal, Text.hash);

      for (profile in Iter.fromArray(stable_user_icfc_profiles)) {
        profileMap.put(profile);
      };
      userICFCProfiles := profileMap;
    };
    */
  };
  
};

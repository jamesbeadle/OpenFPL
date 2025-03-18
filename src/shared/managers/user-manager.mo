import Result "mo:base/Result";
import TrieMap "mo:base/TrieMap";
import List "mo:base/List";
import Text "mo:base/Text";
import Iter "mo:base/Iter";
import Principal "mo:base/Principal";
import Buffer "mo:base/Buffer";
import DTOs "../../shared/dtos/dtos";
import Base "mo:waterway-mops/BaseTypes";
import FootballTypes "mo:waterway-mops/FootballTypes";
import T "../../shared/types/app_types";
import Management "../../shared/utils/Management";
import ManagerCanister "../canister_definitions/manager-canister";
import Cycles "mo:base/ExperimentalCycles";
import Time "mo:base/Time";
import Nat64 "mo:base/Nat64";
import Nat8 "mo:base/Nat8";
import Array "mo:base/Array";
import Option "mo:base/Option";
import Nat16 "mo:base/Nat16";
import Bool "mo:base/Bool";
import Debug "mo:base/Debug";
import NetworkEnvironmentVariables "../network_environment_variables";
import Queries "../cqrs/queries";
import Commands "../cqrs/commands";
import CanisterUtilities "../utils/canister_utilities";
import Helpers "../utils/helpers";
import ProfileUtilities "../utils/profile_utilities";
import PickTeamUtilities "../utils/pick_team_utilities";

module {

  public class UserManager(controllerPrincipalId : Base.PrincipalId) {

    private var managerCanisterIds : TrieMap.TrieMap<Base.PrincipalId, Base.CanisterId> = TrieMap.TrieMap<Base.PrincipalId, Base.CanisterId>(Text.equal, Text.hash);
    private var usernames : TrieMap.TrieMap<Base.PrincipalId, Text> = TrieMap.TrieMap<Base.PrincipalId, Text>(Text.equal, Text.hash);

    private var uniqueManagerCanisterIds : List.List<Base.CanisterId> = List.nil();
    private var totalManagers : Nat = 0;
    private var activeManagerCanisterId : Base.CanisterId = "";

    private var userICFCProfiles : TrieMap.TrieMap<Base.PrincipalId, T.ICFCProfile> = TrieMap.TrieMap<Base.PrincipalId, T.ICFCProfile>(Text.equal, Text.hash);

    //Getters

    public func getProfile(managerPrincipalId : Base.PrincipalId) : async Result.Result<DTOs.ProfileDTO, T.Error> {
      let userManagerCanisterId = managerCanisterIds.get(managerPrincipalId);

      switch (userManagerCanisterId) {
        case (?foundUserCanisterId) {

          let manager_canister = actor (foundUserCanisterId) : actor {
            getManager : Base.PrincipalId -> async ?T.Manager;
          };
          let manager = await manager_canister.getManager(managerPrincipalId);

          switch (manager) {
            case (null) {
              return #err(#NotFound);
            };
            case (?foundManager) {

              let profileDTO : DTOs.ProfileDTO = {
                principalId = managerPrincipalId;
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

    public func getUserICFCProfileStatus (managerPrincipalId : Base.PrincipalId) : async Result.Result<T.ICFCLinkStatus, T.Error> {
      let icfcProfile : ?T.ICFCProfile = userICFCProfiles.get(managerPrincipalId);

      switch (icfcProfile) {
        case (null) {
          return #err(#NotFound);
        };
        case (?foundICFCProfile) {
          return #ok(foundICFCProfile.linkStatus);
        };
      };
    };

    public func getUserICFCMembership(managerPrincipalId : Base.PrincipalId) : async Result.Result<Queries.ICFCMembershipDTO, T.Error> {

      let icfcProfile : ?T.ICFCProfile = userICFCProfiles.get(managerPrincipalId);

      switch (icfcProfile) {
        case (null) {
          return #err(#NotFound);
        };
        case (?icfcProfile) {

          let icfc_canister = actor (NetworkEnvironmentVariables.ICFC_BACKEND_CANISTER_ID) : actor {
            getICFCMembership : Commands.GetICFCMembership -> async Result.Result<Queries.ICFCMembershipDTO, T.Error>;
          };

          let icfcMembershipDTO : Commands.GetICFCMembership = {
            principalId = icfcProfile.principalId;

          };

          return await icfc_canister.getICFCMembership(icfcMembershipDTO);

        };
      };
    };

    public func getManager(dto : Queries.GetManagerDTO, weeklyLeaderboardEntry : ?DTOs.LeaderboardEntryDTO, monthlyLeaderboardEntry : ?DTOs.LeaderboardEntryDTO, seasonLeaderboardEntry : ?DTOs.LeaderboardEntryDTO) : async Result.Result<DTOs.ManagerDTO, T.Error> {

      let managerCanisterId = managerCanisterIds.get(dto.principalId);

      switch (managerCanisterId) {
        case (null) {
          return #err(#NotFound);
        };
        case (?foundCanisterId) {
          let manager_canister = actor (foundCanisterId) : actor {
            getManager : Base.PrincipalId -> async ?T.Manager;
          };

          let manager = await manager_canister.getManager(dto.principalId);
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

    public func getManagerByUsername(username : Text) : async Result.Result<DTOs.ManagerDTO, T.Error> {

      for (managerUsername in usernames.entries()) {
        if (managerUsername.1 == username) {
          let managerPrincipalId = managerUsername.0;
          let managerCanisterId = managerCanisterIds.get(managerPrincipalId);
          switch (managerCanisterId) {
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
            };
          };
        };
      };
      return #err(#NotFound);
    };

    public func getCurrentTeam(managerPrincipalId : Base.PrincipalId, currentSeasonId : FootballTypes.SeasonId) : async Result.Result<Queries.TeamSelectionDTO, T.Error> {

      let managerCanisterId = managerCanisterIds.get(managerPrincipalId);
      switch (managerCanisterId) {
        case (null) {
          return #err(#NotFound);
        };
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

              var firstGameweek = true;
              let currentManagerSeason = List.find<T.FantasyTeamSeason>(
                foundManager.history,
                func(season : T.FantasyTeamSeason) : Bool {
                  season.seasonId == currentSeasonId;
                },
              );

              let hasPlayersInTeam = Array.size(foundManager.playerIds) > 0;

              switch (currentManagerSeason) {
                case (?foundSeason) {
                  let validGameweeks = List.filter<T.FantasyTeamSnapshot>(
                    foundSeason.gameweeks,
                    func(entry : T.FantasyTeamSnapshot) {
                      entry.gameweek > 28; //Update next season
                    },
                  );
                  firstGameweek := List.size(validGameweeks) == 0 or not hasPlayersInTeam;
                };
                case (null) {};
              };

              let pickTeamDTO : Queries.TeamSelectionDTO = {
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

    public func getFantasyTeamSnapshot(dto : Queries.GetManagerGameweekDTO) : async Result.Result<DTOs.ManagerGameweekDTO, T.Error> {
      let managerCanisterId = managerCanisterIds.get(dto.principalId);
      switch (managerCanisterId) {
        case (null) {
          return #err(#NotFound);
        };
        case (?foundCanisterId) {
          let manager_canister = actor (foundCanisterId) : actor {
            getFantasyTeamSnapshot : (managerPrincipalId : Base.PrincipalId, dto : Queries.GetManagerGameweekDTO) -> async ?T.FantasyTeamSnapshot;
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

    public func getManagerCanisterIds() : [(Base.PrincipalId, Base.CanisterId)] {
      return Iter.toArray(managerCanisterIds.entries());
    };

    public func getUniqueManagerCanisterIds() : [Base.CanisterId] {
      return List.toArray(uniqueManagerCanisterIds);
    };

    public func getTotalManagers() : Result.Result<Nat, T.Error> {
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

    public func linkICFCProfile(dto : Commands.NotifyAppofLink) : async Result.Result<(), T.Error> {
      let icfcProfile : T.ICFCProfile = {
        principalId = dto.icfcPrincipalId;
        linkStatus = #PendingVerification;
      };
      userICFCProfiles.put(dto.subAppUserPrincipalId, icfcProfile);
      return #ok();
    };

    public func verifyICFCProfile(dto : Commands.VerifyICFCProfile) : async Result.Result<(), T.Error> {
      let icfcProfile : ?T.ICFCProfile = userICFCProfiles.get(dto.principalId);

      switch (icfcProfile) {
        case (null) {
          return #err(#NotFound);
        };
        case (?foundICFCProfile) {

          let icfc_canister = actor (NetworkEnvironmentVariables.ICFC_BACKEND_CANISTER_ID) : actor {
            verifySubApp : Commands.VerifySubApp -> async Result.Result<(), T.Error>;
          };

          let verifySubAppDTO : Commands.VerifySubApp = {
            subAppUserPrincipalId = dto.principalId;
            subApp = #OpenFPL;
            icfcPrincipalId = foundICFCProfile.principalId;
          };

          let result = await icfc_canister.verifySubApp(verifySubAppDTO);
          switch (result) {
            case (#ok(_)) {

              let _ = userICFCProfiles.put(
                dto.principalId,
                {
                  principalId = foundICFCProfile.principalId;
                  linkStatus = #Verified;
                },
              );

              return #ok();

            };
            case (#err error) {
              return #err(error);
            };
          };
        };
      };
    };

    public func createManager(managerPrincipalId : Base.PrincipalId, dto : Commands.CreateManagerDTO) : async Result.Result<(), T.Error> {

      let managerCanisterId = managerCanisterIds.get(managerPrincipalId);

      switch (managerCanisterId) {
        case (null) {
          let result = await createNewManager(managerPrincipalId, dto);
          switch (result) {
            case (#ok _) {
              totalManagers := totalManagers + 1;
              managerCanisterIds.put(managerPrincipalId, activeManagerCanisterId);
              return #ok();
            };
            case (#err error) {
              return #err(error);
            };
          };
        };
        case (?_) {
          return #err(#AlreadyExists);
        };
      };
    };

    public func updateUsername(managerPrincipalId : Base.PrincipalId, dto : Commands.UpdateUsernameDTO) : async Result.Result<(), T.Error> {
      if (not ProfileUtilities.isUsernameValid(dto.username)) {
        return #err(#InvalidData);
      };

      if (isUsernameTaken(dto.username, managerPrincipalId)) {
        return #err(#InvalidData);
      };

      let managerCanisterId = managerCanisterIds.get(managerPrincipalId);
      switch (managerCanisterId) {
        case (null) {
          return #err(#NotFound);
        };
        case (?foundManagerCanisterId) {

          let manager_canister = actor (foundManagerCanisterId) : actor {
            updateUsername : (dto : Commands.UpdateUsernameDTO) -> async Result.Result<(), T.Error>;
          };
          usernames.put(managerPrincipalId, dto.username);
          return await manager_canister.updateUsername(dto);
        };
      };
    };

    public func updateFavouriteClub(managerPrincipalId : Base.PrincipalId, dto : Commands.UpdateFavouriteClubDTO, activeClubs : [FootballTypes.Club], seasonActive : Bool) : async Result.Result<(), T.Error> {

      let isClubActive = Array.find(
        activeClubs,
        func(club : FootballTypes.Club) : Bool {
          return club.id == dto.favouriteClubId;
        },
      );
      if (not Option.isSome(isClubActive)) {
        return #err(#NotFound);
      };

      if (dto.favouriteClubId <= 0) {
        return #err(#InvalidData);
      };

      let managerCanisterId = managerCanisterIds.get(managerPrincipalId);
      switch (managerCanisterId) {
        case (null) {
          return #err(#NotFound);
        };
        case (?foundManagerCanisterId) {

          let manager_canister = actor (foundManagerCanisterId) : actor {
            getManager : Base.PrincipalId -> async ?T.Manager;
            updateFavouriteClub : (managerPrincipalId : Base.PrincipalId, dto : Commands.UpdateFavouriteClubDTO) -> async Result.Result<(), T.Error>;
          };

          let manager = await manager_canister.getManager(managerPrincipalId);
          if (not seasonActive) {
            return await manager_canister.updateFavouriteClub(managerPrincipalId, dto);
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
              return await manager_canister.updateFavouriteClub(managerPrincipalId, dto);
            };
            case (null) {
              return #err(#NotFound);
            };
          };
        };
      };
    };

    public func updateProfilePicture(managerPrincipalId : Base.PrincipalId, dto : Commands.UpdateProfilePictureDTO) : async Result.Result<(), T.Error> {

      if (not ProfileUtilities.isProfilePictureValid(dto.profilePicture)) {
        return #err(#InvalidData);
      };

      let managerCanisterId = managerCanisterIds.get(managerPrincipalId);
      switch (managerCanisterId) {
        case (null) {
          return #err(#NotFound);
        };
        case (?foundManagerCanisterId) {

          let manager_canister = actor (foundManagerCanisterId) : actor {
            updateProfilePicture : (managerPrincipalId : Base.PrincipalId, dto : Commands.UpdateProfilePictureDTO) -> async Result.Result<(), T.Error>;
          };
          return await manager_canister.updateProfilePicture(managerPrincipalId, dto);
        };
      };
    };

    public func saveBonusSelection(managerPrincipalId : Base.PrincipalId, dto : Commands.SaveBonusDTO, gameweek : FootballTypes.GameweekNumber) : async Result.Result<(), T.Error> {

      let managerCanisterId = managerCanisterIds.get(managerPrincipalId);

      switch (managerCanisterId) {
        case (null) {
          return #err(#NotFound);
        };
        case (?foundManagerCanisterId) {
          return await useBonus(foundManagerCanisterId, managerPrincipalId, dto, gameweek);
        };
      };
    };

    public func saveTeamSelection(managerPrincipalId : Base.PrincipalId, dto : Commands.SaveTeamDTO, seasonId : FootballTypes.SeasonId, players : [DTOs.PlayerDTO]) : async Result.Result<(), T.Error> {

      let teamValidResult = PickTeamUtilities.teamValid(dto, players);
      switch (teamValidResult) {
        case (#ok _) {};
        case (#err errorResult) {
          return #err(errorResult);
        };
      };

      let managerCanisterId = managerCanisterIds.get(managerPrincipalId);

      switch (managerCanisterId) {
        case (null) {
          return #err(#NotFound);
        };
        case (?foundManagerCanisterId) {
          return await updateFantasyTeam(foundManagerCanisterId, managerPrincipalId, dto, seasonId, players);
        };
      };
    };

    //Private data modification functions

    private func createNewManager(managerPrincipalId : Base.PrincipalId, dto : Commands.CreateManagerDTO) : async Result.Result<(), T.Error> {

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

      let newManager : T.Manager = {
        principalId = managerPrincipalId;
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
        addNewManager : (manager : T.Manager) -> async Result.Result<(), T.Error>;
      };

      let result = await new_manager_canister.addNewManager(newManager);

      return result;
    };

    private func updateFantasyTeam(managerCanisterId : Base.CanisterId, managerPrincipalId : Base.PrincipalId, dto : Commands.SaveTeamDTO, seasonId : FootballTypes.SeasonId, allPlayers : [DTOs.PlayerDTO]) : async Result.Result<(), T.Error> {
      let manager_canister = actor (managerCanisterId) : actor {
        getManager : Base.PrincipalId -> async ?T.Manager;
        updateTeamSelection : (dto : Commands.SaveTeamDTO, managerPrincipalId : Base.PrincipalId, transfersAvailable : Nat8, newBankBalance : Nat16) -> async Result.Result<(), T.Error>;
      };

      let manager = await manager_canister.getManager(managerPrincipalId);

      switch (manager) {
        case (null) {
          return #err(#NotFound);
        };
        case (?foundManager) {

          if (PickTeamUtilities.overspent(foundManager.bankQuarterMillions, foundManager.playerIds, dto.playerIds, allPlayers)) {
            return #err(#TeamOverspend);
          };

          var transfersAvailable = 3;
          var firstGameweek = true;
          let currentManagerSeason = List.find<T.FantasyTeamSeason>(
            foundManager.history,
            func(season : T.FantasyTeamSeason) : Bool {
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
              return #err(#TooManyTransfers);
            };
          };

          var newBankBalanceResult = PickTeamUtilities.getNewBankBalance(foundManager, dto, allPlayers);
          switch (newBankBalanceResult) {
            case (#ok newBankBalance) {
              return await manager_canister.updateTeamSelection(
                dto,
                foundManager.principalId,
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

    private func useBonus(managerCanisterId : Base.CanisterId, managerPrincipalId : Base.PrincipalId, dto : Commands.SaveBonusDTO, gameweek : FootballTypes.GameweekNumber) : async Result.Result<(), T.Error> {
      let manager_canister = actor (managerCanisterId) : actor {
        getManager : Base.PrincipalId -> async ?T.Manager;
        useBonus : (dto : Commands.SaveBonusDTO, managerPrincipalId : Base.PrincipalId, monthlyBonuses : Nat8) -> async Result.Result<(), T.Error>;
      };

      let manager = await manager_canister.getManager(managerPrincipalId);

      switch (manager) {
        case (null) {
          return #err(#NotFound);
        };
        case (?foundManager) {

          let bonusAlreadyPaid = PickTeamUtilities.selectedBonusPlayedAlready(foundManager, dto);
          if (bonusAlreadyPaid) {
            return #err(#InvalidBonuses);
          };

          /*

          if (foundManager.monthlyBonusesAvailable == 0) {
            return #err(#InvalidBonuses);
          };

          */

          if (PickTeamUtilities.isGameweekBonusUsed(foundManager, gameweek)) {
            return #err(#InvalidBonuses);
          };

          return await manager_canister.useBonus(dto, managerPrincipalId, 2);
        };
      };
    };

    //Called by application

    public func snapshotFantasyTeams(seasonId : FootballTypes.SeasonId, gameweek : FootballTypes.GameweekNumber, month : Base.CalendarMonth) : async () {

      for (canisterId in Iter.fromList(uniqueManagerCanisterIds)) {

        let manager_canister = actor (canisterId) : actor {
          snapshotFantasyTeams : (seasonId : FootballTypes.SeasonId, gameweek : FootballTypes.GameweekNumber, month : Base.CalendarMonth) -> async ();
        };

        await manager_canister.snapshotFantasyTeams(seasonId, gameweek, month);
      };
    };

    public func calculateFantasyTeamScores(leagueId : FootballTypes.LeagueId, seasonId : FootballTypes.SeasonId, gameweek : FootballTypes.GameweekNumber, month : Base.CalendarMonth) : async () {
      for (canisterId in Iter.fromList(uniqueManagerCanisterIds)) {

        let manager_canister = actor (canisterId) : actor {
          calculateFantasyTeamScores : (leagueId : FootballTypes.LeagueId, seasonId : FootballTypes.SeasonId, gameweek : FootballTypes.GameweekNumber, month : Base.CalendarMonth) -> async ();
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

    public func removePlayerFromTeams(leagueId : FootballTypes.LeagueId, playerId : FootballTypes.PlayerId, parentCanisterId : Base.CanisterId) : async () {
      for (canisterId in Iter.fromList(uniqueManagerCanisterIds)) {

        let manager_canister = actor (canisterId) : actor {
          removePlayerFromTeams : (leagueId : FootballTypes.LeagueId, playerId : FootballTypes.PlayerId, parentCanisterId : Base.CanisterId) -> async ();
        };

        await manager_canister.removePlayerFromTeams(leagueId, playerId, parentCanisterId);
      };
    };

    //Canister management functions

    private func createManagerCanister() : async Text {
      Cycles.add<system>(50_000_000_000_000);
      let canister = await ManagerCanister._ManagerCanister();
      await canister.initialise(controllerPrincipalId);
      let IC : Management.Management = actor (NetworkEnvironmentVariables.Default);
      let principal = ?Principal.fromText(controllerPrincipalId);
      let _ = await CanisterUtilities.updateCanister_(canister, principal, IC);

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

    public func getStableUserICFCProfiles() : [(Base.PrincipalId, T.ICFCProfile)] {
      return Iter.toArray(userICFCProfiles.entries());
    };

    public func setStableUserICFCProfiles(stable_user_icfc_profiles : [(Base.PrincipalId, T.ICFCProfile)]) : () {
      let profileMap : TrieMap.TrieMap<Base.PrincipalId, T.ICFCProfile> = TrieMap.TrieMap<Base.PrincipalId, T.ICFCProfile>(Text.equal, Text.hash);

      for (profile in Iter.fromArray(stable_user_icfc_profiles)) {
        profileMap.put(profile);
      };
      userICFCProfiles := profileMap;
    };
  };
};

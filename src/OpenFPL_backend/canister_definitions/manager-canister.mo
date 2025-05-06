import BaseDefinitions "mo:waterway-mops/BaseDefinitions";
import BaseUtilities "mo:waterway-mops/BaseUtilities";
import DateTimeUtilities "mo:waterway-mops/DateTimeUtilities";
import Enums "mo:waterway-mops/Enums";
import FootballDefinitions "mo:waterway-mops/football/FootballDefinitions";
import FootballEnums "mo:waterway-mops/football/FootballEnums";
import FootballIds "mo:waterway-mops/football/FootballIds";
import Ids "mo:waterway-mops/Ids";

import IcfcTypes "mo:waterway-mops/ICFCTypes"; // TODO - I think gameweek number should be in football definitions
import PlayerQueries "mo:waterway-mops/queries/football-queries/PlayerQueries";
import LogsManager "mo:waterway-mops/logs-management/LogsManager";
import { message } "mo:base/Error";

/* ----- Mops Packages ----- */

import Array "mo:base/Array";
import Bool "mo:base/Bool";
import Buffer "mo:base/Buffer";
import Int "mo:base/Int";
import Int16 "mo:base/Int16";
import Iter "mo:base/Iter";
import List "mo:base/List";
import Nat "mo:base/Nat";
import Nat8 "mo:base/Nat8";
import Nat16 "mo:base/Nat16";
import Option "mo:base/Option";
import Order "mo:base/Order";
import Principal "mo:base/Principal";
import Result "mo:base/Result";
import Text "mo:base/Text";
import Timer "mo:base/Timer";
import TrieMap "mo:base/TrieMap";

/* ----- Queries ----- */

import UserQueries "../queries/user_queries";
import AppQueries "../queries/app_queries";

/* ----- Commands ----- */

import UserCommands "../commands/user_commands";

/* ----- Only Stable Variables Should Use Types ----- */

import AppTypes "../types/app_types";

/* ----- Application Environment & Utility Files ----- */

import Environment "../Environment";

actor class _ManagerCanister() {

  /* ----- Stable Canister Bucket Definitions ----- */

  private stable var managerGroup1 : [AppTypes.Manager] = [];
  private stable var managerGroup2 : [AppTypes.Manager] = [];
  private stable var managerGroup3 : [AppTypes.Manager] = [];
  private stable var managerGroup4 : [AppTypes.Manager] = [];
  private stable var managerGroup5 : [AppTypes.Manager] = [];
  private stable var managerGroup6 : [AppTypes.Manager] = [];
  private stable var managerGroup7 : [AppTypes.Manager] = [];
  private stable var managerGroup8 : [AppTypes.Manager] = [];
  private stable var managerGroup9 : [AppTypes.Manager] = [];
  private stable var managerGroup10 : [AppTypes.Manager] = [];
  private stable var managerGroup11 : [AppTypes.Manager] = [];
  private stable var managerGroup12 : [AppTypes.Manager] = [];

  /* ----- Stable Canister Variables ----- */
  private stable var stable_manager_group_indexes : [(Ids.PrincipalId, Nat8)] = [];
  private stable var activeGroupIndex : Nat8 = 0;
  private stable var totalManagers = 0;

  private var managerGroupIndexes : TrieMap.TrieMap<Ids.PrincipalId, Nat8> = TrieMap.TrieMap<Ids.PrincipalId, Nat8>(Text.equal, Text.hash);

  private let logsManager = LogsManager.LogsManager();

  public shared ({ caller }) func updateTeamSelection(dto : UserCommands.SaveFantasyTeam, transfersAvailable : Nat8, newBankBalance : Nat16, currentGameweek : IcfcTypes.GameweekNumber) : async Result.Result<(), Enums.Error> {
    assert not Principal.isAnonymous(caller);
    let backendPrincipalId = Principal.toText(caller);
    assert backendPrincipalId == Environment.BACKEND_CANISTER_ID;

    let managerBuffer = Buffer.fromArray<AppTypes.Manager>([]);
    let managerGroupIndex = managerGroupIndexes.get(dto.principalId);
    switch (managerGroupIndex) {
      case (null) {};
      case (?foundGroupIndex) {
        switch (foundGroupIndex) {
          case 0 {
            for (manager in Iter.fromArray(managerGroup1)) {
              if (manager.principalId == dto.principalId) {
                managerBuffer.add(mergeTeamSelection(dto, manager, transfersAvailable, newBankBalance, currentGameweek));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup1 := Buffer.toArray(managerBuffer);
          };
          case 1 {
            for (manager in Iter.fromArray(managerGroup2)) {
              if (manager.principalId == dto.principalId) {
                managerBuffer.add(mergeTeamSelection(dto, manager, transfersAvailable, newBankBalance, currentGameweek));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup2 := Buffer.toArray(managerBuffer);
          };
          case 2 {
            for (manager in Iter.fromArray(managerGroup3)) {
              if (manager.principalId == dto.principalId) {
                managerBuffer.add(mergeTeamSelection(dto, manager, transfersAvailable, newBankBalance, currentGameweek));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup3 := Buffer.toArray(managerBuffer);
          };
          case 3 {
            for (manager in Iter.fromArray(managerGroup4)) {
              if (manager.principalId == dto.principalId) {
                managerBuffer.add(mergeTeamSelection(dto, manager, transfersAvailable, newBankBalance, currentGameweek));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup4 := Buffer.toArray(managerBuffer);
          };
          case 4 {
            for (manager in Iter.fromArray(managerGroup5)) {
              if (manager.principalId == dto.principalId) {
                managerBuffer.add(mergeTeamSelection(dto, manager, transfersAvailable, newBankBalance, currentGameweek));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup5 := Buffer.toArray(managerBuffer);
          };
          case 5 {
            for (manager in Iter.fromArray(managerGroup6)) {
              if (manager.principalId == dto.principalId) {
                managerBuffer.add(mergeTeamSelection(dto, manager, transfersAvailable, newBankBalance, currentGameweek));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup6 := Buffer.toArray(managerBuffer);
          };
          case 6 {
            for (manager in Iter.fromArray(managerGroup7)) {
              if (manager.principalId == dto.principalId) {
                managerBuffer.add(mergeTeamSelection(dto, manager, transfersAvailable, newBankBalance, currentGameweek));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup7 := Buffer.toArray(managerBuffer);
          };
          case 7 {
            for (manager in Iter.fromArray(managerGroup8)) {
              if (manager.principalId == dto.principalId) {
                managerBuffer.add(mergeTeamSelection(dto, manager, transfersAvailable, newBankBalance, currentGameweek));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup8 := Buffer.toArray(managerBuffer);
          };
          case 8 {
            for (manager in Iter.fromArray(managerGroup9)) {
              if (manager.principalId == dto.principalId) {
                managerBuffer.add(mergeTeamSelection(dto, manager, transfersAvailable, newBankBalance, currentGameweek));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup9 := Buffer.toArray(managerBuffer);
          };
          case 9 {
            for (manager in Iter.fromArray(managerGroup10)) {
              if (manager.principalId == dto.principalId) {
                managerBuffer.add(mergeTeamSelection(dto, manager, transfersAvailable, newBankBalance, currentGameweek));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup10 := Buffer.toArray(managerBuffer);
          };
          case 10 {
            for (manager in Iter.fromArray(managerGroup11)) {
              if (manager.principalId == dto.principalId) {
                managerBuffer.add(mergeTeamSelection(dto, manager, transfersAvailable, newBankBalance, currentGameweek));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup11 := Buffer.toArray(managerBuffer);
          };
          case 11 {
            for (manager in Iter.fromArray(managerGroup12)) {
              if (manager.principalId == dto.principalId) {
                managerBuffer.add(mergeTeamSelection(dto, manager, transfersAvailable, newBankBalance, currentGameweek));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup12 := Buffer.toArray(managerBuffer);
          };
          case _ {};
        };
      };
    };
    return #ok;

  };

  private func mergeTeamSelection(dto : UserCommands.SaveFantasyTeam, manager : AppTypes.Manager, transfersAvailable : Nat8, newBankBalance : Nat16, currentGameweek : IcfcTypes.GameweekNumber) : AppTypes.Manager {

    var transferWindowGameweek = manager.transferWindowGameweek;
    if (transferWindowGameweek == 0 and dto.playTransferWindowBonus) {
      transferWindowGameweek := currentGameweek;
    };

    return {
      principalId = manager.principalId;
      username = manager.username;
      favouriteClubId = manager.favouriteClubId;
      createDate = manager.createDate;
      termsAccepted = manager.termsAccepted;
      profilePicture = manager.profilePicture;
      transfersAvailable = transfersAvailable;
      monthlyBonusesAvailable = manager.monthlyBonusesAvailable;
      bankQuarterMillions = newBankBalance;
      playerIds = dto.playerIds;
      captainId = dto.captainId;
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
      oneNationGameweek = manager.oneNationGameweek;
      oneNationCountryId = manager.oneNationCountryId;
      prospectsGameweek = manager.prospectsGameweek;
      braceBonusGameweek = manager.braceBonusGameweek;
      hatTrickHeroGameweek = manager.hatTrickHeroGameweek;
      transferWindowGameweek;
      history = manager.history;
      profilePictureType = manager.profilePictureType;
      canisterId = manager.canisterId;
    };
  };

  public shared ({ caller }) func useBonus(dto : UserCommands.PlayBonus, monthlyBonuses : Nat8, gameweek : IcfcTypes.GameweekNumber) : async Result.Result<(), Enums.Error> {
    assert not Principal.isAnonymous(caller);
    let backendPrincipalId = Principal.toText(caller);
    assert backendPrincipalId == Environment.BACKEND_CANISTER_ID;

    let managerBuffer = Buffer.fromArray<AppTypes.Manager>([]);
    let managerGroupIndex = managerGroupIndexes.get(dto.principalId);
    switch (managerGroupIndex) {
      case (null) {};
      case (?foundGroupIndex) {
        switch (foundGroupIndex) {
          case 0 {
            for (manager in Iter.fromArray(managerGroup1)) {
              if (manager.principalId == dto.principalId) {
                managerBuffer.add(mergeBonus(dto, manager, gameweek, monthlyBonuses));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup1 := Buffer.toArray(managerBuffer);
          };
          case 1 {
            for (manager in Iter.fromArray(managerGroup2)) {
              if (manager.principalId == dto.principalId) {
                managerBuffer.add(mergeBonus(dto, manager, gameweek, monthlyBonuses));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup2 := Buffer.toArray(managerBuffer);
          };
          case 2 {
            for (manager in Iter.fromArray(managerGroup3)) {
              if (manager.principalId == dto.principalId) {
                managerBuffer.add(mergeBonus(dto, manager, gameweek, monthlyBonuses));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup3 := Buffer.toArray(managerBuffer);
          };
          case 3 {
            for (manager in Iter.fromArray(managerGroup4)) {
              if (manager.principalId == dto.principalId) {
                managerBuffer.add(mergeBonus(dto, manager, gameweek, monthlyBonuses));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup4 := Buffer.toArray(managerBuffer);
          };
          case 4 {
            for (manager in Iter.fromArray(managerGroup5)) {
              if (manager.principalId == dto.principalId) {
                managerBuffer.add(mergeBonus(dto, manager, gameweek, monthlyBonuses));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup5 := Buffer.toArray(managerBuffer);
          };
          case 5 {
            for (manager in Iter.fromArray(managerGroup6)) {
              if (manager.principalId == dto.principalId) {
                managerBuffer.add(mergeBonus(dto, manager, gameweek, monthlyBonuses));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup6 := Buffer.toArray(managerBuffer);
          };
          case 6 {
            for (manager in Iter.fromArray(managerGroup7)) {
              if (manager.principalId == dto.principalId) {
                managerBuffer.add(mergeBonus(dto, manager, gameweek, monthlyBonuses));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup7 := Buffer.toArray(managerBuffer);
          };
          case 7 {
            for (manager in Iter.fromArray(managerGroup8)) {
              if (manager.principalId == dto.principalId) {
                managerBuffer.add(mergeBonus(dto, manager, gameweek, monthlyBonuses));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup8 := Buffer.toArray(managerBuffer);
          };
          case 8 {
            for (manager in Iter.fromArray(managerGroup9)) {
              if (manager.principalId == dto.principalId) {
                managerBuffer.add(mergeBonus(dto, manager, gameweek, monthlyBonuses));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup9 := Buffer.toArray(managerBuffer);
          };
          case 9 {
            for (manager in Iter.fromArray(managerGroup10)) {
              if (manager.principalId == dto.principalId) {
                managerBuffer.add(mergeBonus(dto, manager, gameweek, monthlyBonuses));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup10 := Buffer.toArray(managerBuffer);
          };
          case 10 {
            for (manager in Iter.fromArray(managerGroup11)) {
              if (manager.principalId == dto.principalId) {
                managerBuffer.add(mergeBonus(dto, manager, gameweek, monthlyBonuses));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup11 := Buffer.toArray(managerBuffer);
          };
          case 11 {
            for (manager in Iter.fromArray(managerGroup12)) {
              if (manager.principalId == dto.principalId) {
                managerBuffer.add(mergeBonus(dto, manager, gameweek, monthlyBonuses));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup12 := Buffer.toArray(managerBuffer);
          };
          case _ {};
        };
      };
    };
    return #ok;

  };

  private func mergeBonus(dto : UserCommands.PlayBonus, manager : AppTypes.Manager, gameweek : FootballDefinitions.GameweekNumber, monthlyBonusesAvailable : Nat8) : AppTypes.Manager {

    var updatedGoalGetterGameweek = manager.goalGetterGameweek;
    var updatedPassMasterGameweek = manager.passMasterGameweek;
    var updatedNoEntryGameweek = manager.noEntryGameweek;
    var updatedTeamBoostGameweek = manager.teamBoostGameweek;
    var updatedSafeHandsGameweek = manager.safeHandsGameweek;
    var updatedCaptainFantasticGameweek = manager.captainFantasticGameweek;
    var updatedOneNationGameweek = manager.oneNationGameweek;
    var updatedProspectsGameweek = manager.prospectsGameweek;
    var updatedBraceBonusGameweek = manager.braceBonusGameweek;
    var updatedHatTrickHeroGameweek = manager.hatTrickHeroGameweek;

    var updatedGoalGetterPlayerId = manager.goalGetterPlayerId;
    var updatedPassMasterPlayerId = manager.passMasterPlayerId;
    var updatedNoEntryPlayerId = manager.noEntryPlayerId;
    var updatedSafeHandsPlayerId = manager.safeHandsPlayerId;
    var updatedCaptainFantasticPlayerId = manager.captainFantasticPlayerId;

    var updatedTeamBoostClubId = manager.teamBoostClubId;

    var updatedOneNationCountryId = manager.oneNationCountryId;

    switch (dto.bonusType) {
      case (#GoalGetter) {
        updatedGoalGetterGameweek := gameweek;
        updatedGoalGetterPlayerId := dto.playerId;
      };
      case (#BraceBonus) {
        updatedBraceBonusGameweek := gameweek;
      };
      case (#CaptainFantastic) {
        updatedCaptainFantasticGameweek := gameweek;
        updatedCaptainFantasticPlayerId := dto.playerId;
      };
      case (#HatTrickHero) {
        updatedHatTrickHeroGameweek := gameweek;
      };
      case (#NoEntry) {
        updatedNoEntryGameweek := gameweek;
        updatedNoEntryPlayerId := dto.playerId;
      };
      case (#OneNation) {
        updatedOneNationGameweek := gameweek;
        updatedOneNationCountryId := dto.countryId;
      };
      case (#PassMaster) {
        updatedPassMasterGameweek := gameweek;
        updatedPassMasterPlayerId := dto.playerId;
      };
      case (#Prospects) {
        updatedProspectsGameweek := gameweek;
      };
      case (#SafeHands) {
        updatedSafeHandsGameweek := gameweek;
        updatedSafeHandsPlayerId := dto.playerId;
      };
      case (#TeamBoost) {
        updatedTeamBoostGameweek := gameweek;
        updatedTeamBoostClubId := dto.clubId;
      };

    };

    return {
      principalId = manager.principalId;
      username = manager.username;
      favouriteClubId = manager.favouriteClubId;
      createDate = manager.createDate;
      termsAccepted = manager.termsAccepted;
      profilePicture = manager.profilePicture;
      transfersAvailable = manager.transfersAvailable;
      monthlyBonusesAvailable = monthlyBonusesAvailable;
      bankQuarterMillions = manager.bankQuarterMillions;
      playerIds = manager.playerIds;
      captainId = manager.captainId;
      transferWindowGameweek = manager.transferWindowGameweek;
      history = manager.history;
      profilePictureType = manager.profilePictureType;
      canisterId = manager.canisterId;
      goalGetterGameweek = updatedGoalGetterGameweek;
      goalGetterPlayerId = updatedGoalGetterPlayerId;
      passMasterGameweek = updatedPassMasterGameweek;
      passMasterPlayerId = updatedPassMasterPlayerId;
      noEntryGameweek = updatedNoEntryGameweek;
      noEntryPlayerId = updatedNoEntryPlayerId;
      teamBoostGameweek = updatedTeamBoostGameweek;
      teamBoostClubId = updatedTeamBoostClubId;
      safeHandsGameweek = updatedSafeHandsGameweek;
      safeHandsPlayerId = updatedSafeHandsPlayerId;
      captainFantasticGameweek = updatedCaptainFantasticGameweek;
      captainFantasticPlayerId = updatedCaptainFantasticPlayerId;
      oneNationGameweek = updatedOneNationGameweek;
      oneNationCountryId = updatedOneNationCountryId;
      prospectsGameweek = updatedProspectsGameweek;
      braceBonusGameweek = updatedBraceBonusGameweek;
      hatTrickHeroGameweek = updatedHatTrickHeroGameweek;
    };
  };

  public shared ({ caller }) func updateFavouriteClub(dto : UserCommands.SetFavouriteClub) : async Result.Result<(), Enums.Error> {
    assert not Principal.isAnonymous(caller);
    let backendPrincipalId = Principal.toText(caller);
    assert backendPrincipalId == Environment.BACKEND_CANISTER_ID;

    let managerBuffer = Buffer.fromArray<AppTypes.Manager>([]);
    let managerGroupIndex = managerGroupIndexes.get(dto.principalId);
    switch (managerGroupIndex) {
      case (null) {};
      case (?foundGroupIndex) {
        switch (foundGroupIndex) {
          case 0 {
            for (manager in Iter.fromArray(managerGroup1)) {
              if (manager.principalId == dto.principalId) {
                managerBuffer.add(mergeManagerFavouriteClub(manager, dto.favouriteClubId));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup1 := Buffer.toArray(managerBuffer);
          };
          case 1 {
            for (manager in Iter.fromArray(managerGroup2)) {
              if (manager.principalId == dto.principalId) {
                managerBuffer.add(mergeManagerFavouriteClub(manager, dto.favouriteClubId));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup2 := Buffer.toArray(managerBuffer);
          };
          case 2 {
            for (manager in Iter.fromArray(managerGroup3)) {
              if (manager.principalId == dto.principalId) {
                managerBuffer.add(mergeManagerFavouriteClub(manager, dto.favouriteClubId));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup3 := Buffer.toArray(managerBuffer);
          };
          case 3 {
            for (manager in Iter.fromArray(managerGroup4)) {
              if (manager.principalId == dto.principalId) {
                managerBuffer.add(mergeManagerFavouriteClub(manager, dto.favouriteClubId));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup4 := Buffer.toArray(managerBuffer);
          };
          case 4 {
            for (manager in Iter.fromArray(managerGroup5)) {
              if (manager.principalId == dto.principalId) {
                managerBuffer.add(mergeManagerFavouriteClub(manager, dto.favouriteClubId));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup5 := Buffer.toArray(managerBuffer);
          };
          case 5 {
            for (manager in Iter.fromArray(managerGroup6)) {
              if (manager.principalId == dto.principalId) {
                managerBuffer.add(mergeManagerFavouriteClub(manager, dto.favouriteClubId));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup6 := Buffer.toArray(managerBuffer);
          };
          case 6 {
            for (manager in Iter.fromArray(managerGroup7)) {
              if (manager.principalId == dto.principalId) {
                managerBuffer.add(mergeManagerFavouriteClub(manager, dto.favouriteClubId));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup7 := Buffer.toArray(managerBuffer);
          };
          case 7 {
            for (manager in Iter.fromArray(managerGroup8)) {
              if (manager.principalId == dto.principalId) {
                managerBuffer.add(mergeManagerFavouriteClub(manager, dto.favouriteClubId));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup8 := Buffer.toArray(managerBuffer);
          };
          case 8 {
            for (manager in Iter.fromArray(managerGroup9)) {
              if (manager.principalId == dto.principalId) {
                managerBuffer.add(mergeManagerFavouriteClub(manager, dto.favouriteClubId));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup9 := Buffer.toArray(managerBuffer);
          };
          case 9 {
            for (manager in Iter.fromArray(managerGroup10)) {
              if (manager.principalId == dto.principalId) {
                managerBuffer.add(mergeManagerFavouriteClub(manager, dto.favouriteClubId));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup10 := Buffer.toArray(managerBuffer);
          };
          case 10 {
            for (manager in Iter.fromArray(managerGroup11)) {
              if (manager.principalId == dto.principalId) {
                managerBuffer.add(mergeManagerFavouriteClub(manager, dto.favouriteClubId));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup11 := Buffer.toArray(managerBuffer);
          };
          case 11 {
            for (manager in Iter.fromArray(managerGroup12)) {
              if (manager.principalId == dto.principalId) {
                managerBuffer.add(mergeManagerFavouriteClub(manager, dto.favouriteClubId));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup12 := Buffer.toArray(managerBuffer);
          };
          case _ {};
        };
      };
    };

    return #ok();
  };

  private func mergeManagerFavouriteClub(manager : AppTypes.Manager, favouriteClubId : FootballIds.ClubId) : AppTypes.Manager {
    return {
      principalId = manager.principalId;
      username = manager.username;
      termsAccepted = manager.termsAccepted;
      favouriteClubId = ?favouriteClubId;
      createDate = manager.createDate;
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
      oneNationGameweek = manager.oneNationGameweek;
      oneNationCountryId = manager.oneNationCountryId;
      prospectsGameweek = manager.prospectsGameweek;
      braceBonusGameweek = manager.braceBonusGameweek;
      hatTrickHeroGameweek = manager.hatTrickHeroGameweek;
      transferWindowGameweek = manager.transferWindowGameweek;
      history = manager.history;
      profilePicture = manager.profilePicture;
      profilePictureType = manager.profilePictureType;
      canisterId = manager.canisterId;
    };
  };

  public shared ({ caller }) func getManager(managerPrincipal : Text) : async ?AppTypes.Manager {
    assert not Principal.isAnonymous(caller);
    let backendPrincipalId = Principal.toText(caller);
    assert backendPrincipalId == Environment.BACKEND_CANISTER_ID;

    let managerGroupIndex = managerGroupIndexes.get(managerPrincipal);
    switch (managerGroupIndex) {
      case (null) {
        return null;
      };
      case (?foundIndex) {
        switch (foundIndex) {
          case (0) {
            for (manager in Iter.fromArray<AppTypes.Manager>(managerGroup1)) {
              if (manager.principalId == managerPrincipal) {
                return ?manager;
              };
            };
          };
          case (1) {
            for (manager in Iter.fromArray<AppTypes.Manager>(managerGroup2)) {
              if (manager.principalId == managerPrincipal) {
                return ?manager;
              };
            };
          };
          case (2) {
            for (manager in Iter.fromArray<AppTypes.Manager>(managerGroup3)) {
              if (manager.principalId == managerPrincipal) {
                return ?manager;
              };
            };
          };
          case (3) {
            for (manager in Iter.fromArray<AppTypes.Manager>(managerGroup4)) {
              if (manager.principalId == managerPrincipal) {
                return ?manager;
              };
            };
          };
          case (4) {
            for (manager in Iter.fromArray<AppTypes.Manager>(managerGroup5)) {
              if (manager.principalId == managerPrincipal) {
                return ?manager;
              };
            };
          };
          case (5) {
            for (manager in Iter.fromArray<AppTypes.Manager>(managerGroup6)) {
              if (manager.principalId == managerPrincipal) {
                return ?manager;
              };
            };
          };
          case (6) {
            for (manager in Iter.fromArray<AppTypes.Manager>(managerGroup7)) {
              if (manager.principalId == managerPrincipal) {
                return ?manager;
              };
            };
          };
          case (7) {
            for (manager in Iter.fromArray<AppTypes.Manager>(managerGroup8)) {
              if (manager.principalId == managerPrincipal) {
                return ?manager;
              };
            };
          };
          case (8) {
            for (manager in Iter.fromArray<AppTypes.Manager>(managerGroup9)) {
              if (manager.principalId == managerPrincipal) {
                return ?manager;
              };
            };
          };
          case (9) {
            for (manager in Iter.fromArray<AppTypes.Manager>(managerGroup10)) {
              if (manager.principalId == managerPrincipal) {
                return ?manager;
              };
            };
          };
          case (10) {
            for (manager in Iter.fromArray<AppTypes.Manager>(managerGroup11)) {
              if (manager.principalId == managerPrincipal) {
                return ?manager;
              };
            };
          };
          case (11) {
            for (manager in Iter.fromArray<AppTypes.Manager>(managerGroup12)) {
              if (manager.principalId == managerPrincipal) {
                return ?manager;
              };
            };
          };
          case _ {

          };
        };
        return null;
      };
    };
  };

  public shared ({ caller }) func getManagersWithPlayer(playerId : FootballIds.PlayerId) : async [Ids.PrincipalId] {
    assert not Principal.isAnonymous(caller);
    let backendPrincipalId = Principal.toText(caller);
    assert backendPrincipalId == Environment.BACKEND_CANISTER_ID;

    let allManagersBuffer = Buffer.fromArray<Ids.PrincipalId>([]);
    for (index in Iter.range(0, 11)) {
      switch (index) {
        case 0 {
          for (manager in Iter.fromArray(managerGroup1)) {
            let isPlayerInTeam = Array.find(
              manager.playerIds,
              func(pId : FootballIds.PlayerId) : Bool {
                return pId == playerId;
              },
            );
            if (Option.isSome(isPlayerInTeam)) {
              allManagersBuffer.add(manager.principalId);
            };
          };
        };
        case 1 {
          for (manager in Iter.fromArray(managerGroup2)) {
            let isPlayerInTeam = Array.find(
              manager.playerIds,
              func(pId : FootballIds.PlayerId) : Bool {
                return pId == playerId;
              },
            );
            if (Option.isSome(isPlayerInTeam)) {
              allManagersBuffer.add(manager.principalId);
            };
          };
        };
        case 2 {
          for (manager in Iter.fromArray(managerGroup3)) {
            let isPlayerInTeam = Array.find(
              manager.playerIds,
              func(pId : FootballIds.PlayerId) : Bool {
                return pId == playerId;
              },
            );
            if (Option.isSome(isPlayerInTeam)) {
              allManagersBuffer.add(manager.principalId);
            };
          };
        };
        case 3 {
          for (manager in Iter.fromArray(managerGroup4)) {
            let isPlayerInTeam = Array.find(
              manager.playerIds,
              func(pId : FootballIds.PlayerId) : Bool {
                return pId == playerId;
              },
            );
            if (Option.isSome(isPlayerInTeam)) {
              allManagersBuffer.add(manager.principalId);
            };
          };
        };
        case 4 {
          for (manager in Iter.fromArray(managerGroup5)) {
            let isPlayerInTeam = Array.find(
              manager.playerIds,
              func(pId : FootballIds.PlayerId) : Bool {
                return pId == playerId;
              },
            );
            if (Option.isSome(isPlayerInTeam)) {
              allManagersBuffer.add(manager.principalId);
            };
          };
        };
        case 5 {
          for (manager in Iter.fromArray(managerGroup6)) {
            let isPlayerInTeam = Array.find(
              manager.playerIds,
              func(pId : FootballIds.PlayerId) : Bool {
                return pId == playerId;
              },
            );
            if (Option.isSome(isPlayerInTeam)) {
              allManagersBuffer.add(manager.principalId);
            };
          };
        };
        case 6 {
          for (manager in Iter.fromArray(managerGroup7)) {
            let isPlayerInTeam = Array.find(
              manager.playerIds,
              func(pId : FootballIds.PlayerId) : Bool {
                return pId == playerId;
              },
            );
            if (Option.isSome(isPlayerInTeam)) {
              allManagersBuffer.add(manager.principalId);
            };
          };
        };
        case 7 {
          for (manager in Iter.fromArray(managerGroup8)) {
            let isPlayerInTeam = Array.find(
              manager.playerIds,
              func(pId : FootballIds.PlayerId) : Bool {
                return pId == playerId;
              },
            );
            if (Option.isSome(isPlayerInTeam)) {
              allManagersBuffer.add(manager.principalId);
            };
          };
        };
        case 8 {
          for (manager in Iter.fromArray(managerGroup9)) {
            let isPlayerInTeam = Array.find(
              manager.playerIds,
              func(pId : FootballIds.PlayerId) : Bool {
                return pId == playerId;
              },
            );
            if (Option.isSome(isPlayerInTeam)) {
              allManagersBuffer.add(manager.principalId);
            };
          };
        };
        case 9 {
          for (manager in Iter.fromArray(managerGroup10)) {
            let isPlayerInTeam = Array.find(
              manager.playerIds,
              func(pId : FootballIds.PlayerId) : Bool {
                return pId == playerId;
              },
            );
            if (Option.isSome(isPlayerInTeam)) {
              allManagersBuffer.add(manager.principalId);
            };
          };
        };
        case 10 {
          for (manager in Iter.fromArray(managerGroup11)) {
            let isPlayerInTeam = Array.find(
              manager.playerIds,
              func(pId : FootballIds.PlayerId) : Bool {
                return pId == playerId;
              },
            );
            if (Option.isSome(isPlayerInTeam)) {
              allManagersBuffer.add(manager.principalId);
            };
          };
        };
        case 11 {
          for (manager in Iter.fromArray(managerGroup12)) {
            let isPlayerInTeam = Array.find(
              manager.playerIds,
              func(pId : FootballIds.PlayerId) : Bool {
                return pId == playerId;
              },
            );
            if (Option.isSome(isPlayerInTeam)) {
              allManagersBuffer.add(manager.principalId);
            };
          };
        };
        case _ {

        };

      };
    };
    return Buffer.toArray(allManagersBuffer);
  };

  public shared ({ caller }) func getFantasyTeamSnapshot(dto : UserQueries.GetFantasyTeamSnapshot) : async ?UserQueries.FantasyTeamSnapshot {
    assert not Principal.isAnonymous(caller);
    let backendPrincipalId = Principal.toText(caller);
    assert backendPrincipalId == Environment.BACKEND_CANISTER_ID;

    let managerGroupIndex = managerGroupIndexes.get(dto.principalId);

    var managers : [AppTypes.Manager] = [];

    switch (managerGroupIndex) {
      case (null) {};
      case (?foundGroupIndex) {

        switch (foundGroupIndex) {
          case 0 {
            managers := managerGroup1;
          };
          case 1 {
            managers := managerGroup2;
          };
          case 2 {
            managers := managerGroup3;
          };
          case 3 {
            managers := managerGroup4;
          };
          case 4 {
            managers := managerGroup5;
          };
          case 5 {
            managers := managerGroup6;
          };
          case 6 {
            managers := managerGroup7;
          };
          case 7 {
            managers := managerGroup8;
          };
          case 8 {
            managers := managerGroup9;
          };
          case 9 {
            managers := managerGroup10;
          };
          case 10 {
            managers := managerGroup11;
          };
          case 11 {
            managers := managerGroup12;
          };
          case _ {

          };
        };

        for (manager in Iter.fromArray(managers)) {
          if (manager.principalId == dto.principalId) {
            switch (manager.history) {
              case (null) {};
              case (history) {
                for (season in Iter.fromList(history)) {
                  if (season.seasonId == dto.seasonId) {
                    for (gameweek in Iter.fromList(season.gameweeks)) {
                      if (gameweek.gameweek == dto.gameweek) {
                        return ?gameweek;
                      };
                    };
                  };
                };
              };
            };

          };
        };
      };
    };
    return null;
  };

  public shared ({ caller }) func getOrderedSnapshots(seasonId : FootballIds.SeasonId, gameweek : FootballDefinitions.GameweekNumber) : async [UserQueries.FantasyTeamSnapshot] {

    assert not Principal.isAnonymous(caller);
    let backendPrincipalId = Principal.toText(caller);
    assert backendPrincipalId == Environment.BACKEND_CANISTER_ID;

    let allManagersBuffer = Buffer.fromArray<UserQueries.FantasyTeamSnapshot>([]);
    for (index in Iter.range(0, 11)) {

      var managers : [AppTypes.Manager] = [];
      switch (index) {
        case 0 {
          managers := managerGroup1;
        };
        case 1 {
          managers := managerGroup2;
        };
        case 2 {
          managers := managerGroup3;
        };
        case 3 {
          managers := managerGroup4;
        };
        case 4 {
          managers := managerGroup5;
        };
        case 5 {
          managers := managerGroup6;
        };
        case 6 {
          managers := managerGroup7;
        };
        case 7 {
          managers := managerGroup8;
        };
        case 8 {
          managers := managerGroup9;
        };
        case 9 {
          managers := managerGroup10;
        };
        case 10 {
          managers := managerGroup11;
        };
        case 11 {
          managers := managerGroup12;
        };
        case _ {};
      };

      for (manager in Iter.fromArray(managers)) {
        let currentSeason = List.find<AppTypes.FantasyTeamSeason>(
          manager.history,
          func(season : AppTypes.FantasyTeamSeason) : Bool {
            return season.seasonId == seasonId;
          },
        );
        switch (currentSeason) {
          case (null) {};
          case (?foundSeason) {
            let foundSnapshot = List.find<UserQueries.FantasyTeamSnapshot>(
              foundSeason.gameweeks,
              func(foundGameweek : UserQueries.FantasyTeamSnapshot) : Bool {
                return foundGameweek.gameweek == gameweek;
              },
            );
            switch (foundSnapshot) {
              case (null) {};
              case (?snapshot) {
                allManagersBuffer.add(snapshot);
              };
            };
          };
        };
      };
    };

    let allManagerSnapshots = Buffer.toArray(allManagersBuffer);
    let sortedManagerSnapshots = Array.sort(
      allManagerSnapshots,
      func(a : UserQueries.FantasyTeamSnapshot, b : UserQueries.FantasyTeamSnapshot) : Order.Order {
        if (a.points < b.points) { return #greater };
        if (a.points == b.points) { return #equal };
        return #less;
      },
    );

    return sortedManagerSnapshots;
  };

  public shared ({ caller }) func addNewManager(newManager : AppTypes.Manager) : async Result.Result<(), Enums.Error> {
    assert not Principal.isAnonymous(caller);
    let backendPrincipalId = Principal.toText(caller);
    assert backendPrincipalId == Environment.BACKEND_CANISTER_ID;

    var managerBuffer = Buffer.fromArray<AppTypes.Manager>([]);
    switch (activeGroupIndex) {
      case 0 {
        managerBuffer := Buffer.fromArray(managerGroup1);
        managerBuffer.add(newManager);
        managerGroup1 := Buffer.toArray(managerBuffer);
      };
      case 1 {
        managerBuffer := Buffer.fromArray(managerGroup2);
        managerBuffer.add(newManager);
        managerGroup2 := Buffer.toArray(managerBuffer);
      };
      case 2 {
        managerBuffer := Buffer.fromArray(managerGroup3);
        managerBuffer.add(newManager);
        managerGroup3 := Buffer.toArray(managerBuffer);
      };
      case 3 {
        managerBuffer := Buffer.fromArray(managerGroup4);
        managerBuffer.add(newManager);
        managerGroup4 := Buffer.toArray(managerBuffer);
      };
      case 4 {
        managerBuffer := Buffer.fromArray(managerGroup5);
        managerBuffer.add(newManager);
        managerGroup5 := Buffer.toArray(managerBuffer);
      };
      case 5 {
        managerBuffer := Buffer.fromArray(managerGroup6);
        managerBuffer.add(newManager);
        managerGroup6 := Buffer.toArray(managerBuffer);
      };
      case 6 {
        managerBuffer := Buffer.fromArray(managerGroup7);
        managerBuffer.add(newManager);
        managerGroup7 := Buffer.toArray(managerBuffer);
      };
      case 7 {
        managerBuffer := Buffer.fromArray(managerGroup8);
        managerBuffer.add(newManager);
        managerGroup8 := Buffer.toArray(managerBuffer);
      };
      case 8 {
        managerBuffer := Buffer.fromArray(managerGroup9);
        managerBuffer.add(newManager);
        managerGroup9 := Buffer.toArray(managerBuffer);
      };
      case 9 {
        managerBuffer := Buffer.fromArray(managerGroup10);
        managerBuffer.add(newManager);
        managerGroup10 := Buffer.toArray(managerBuffer);
      };
      case 10 {
        managerBuffer := Buffer.fromArray(managerGroup11);
        managerBuffer.add(newManager);
        managerGroup11 := Buffer.toArray(managerBuffer);
      };
      case 11 {
        managerBuffer := Buffer.fromArray(managerGroup12);
        managerBuffer.add(newManager);
        managerGroup12 := Buffer.toArray(managerBuffer);
      };
      case _ {};
    };

    let managerGroupCount = managerBuffer.size();
    if (managerGroupCount > 1000) {
      activeGroupIndex := activeGroupIndex + 1;
    };
    totalManagers := totalManagers + 1;
    managerGroupIndexes.put(newManager.principalId, activeGroupIndex);
    return #ok();
  };

  public shared ({ caller }) func getTotalManagers() : async Nat {
    assert not Principal.isAnonymous(caller);
    let backendPrincipalId = Principal.toText(caller);
    assert backendPrincipalId == Environment.BACKEND_CANISTER_ID;
    return totalManagers;
  };

  public shared ({ caller }) func getClubManagers(clubId : FootballIds.ClubId) : async [Ids.PrincipalId] {
    assert not Principal.isAnonymous(caller);
    let backendPrincipalId = Principal.toText(caller);
    assert backendPrincipalId == Environment.BACKEND_CANISTER_ID;

    let clubManagerIdBuffer = Buffer.fromArray<Ids.PrincipalId>([]);

    for (index in Iter.range(0, 11)) {
      switch (index) {
        case 0 {
          let clubManagerIds = getGroupClubManagerIds(managerGroup1, clubId);
          for (managerId in Iter.fromArray(clubManagerIds)) {
            clubManagerIdBuffer.add(managerId);
          };
        };
        case 1 {
          let clubManagerIds = getGroupClubManagerIds(managerGroup2, clubId);
          for (managerId in Iter.fromArray(clubManagerIds)) {
            clubManagerIdBuffer.add(managerId);
          };
        };
        case 2 {
          let clubManagerIds = getGroupClubManagerIds(managerGroup3, clubId);
          for (managerId in Iter.fromArray(clubManagerIds)) {
            clubManagerIdBuffer.add(managerId);
          };
        };
        case 3 {
          let clubManagerIds = getGroupClubManagerIds(managerGroup4, clubId);
          for (managerId in Iter.fromArray(clubManagerIds)) {
            clubManagerIdBuffer.add(managerId);
          };
        };
        case 4 {
          let clubManagerIds = getGroupClubManagerIds(managerGroup5, clubId);
          for (managerId in Iter.fromArray(clubManagerIds)) {
            clubManagerIdBuffer.add(managerId);
          };
        };
        case 5 {
          let clubManagerIds = getGroupClubManagerIds(managerGroup6, clubId);
          for (managerId in Iter.fromArray(clubManagerIds)) {
            clubManagerIdBuffer.add(managerId);
          };
        };
        case 6 {
          let clubManagerIds = getGroupClubManagerIds(managerGroup7, clubId);
          for (managerId in Iter.fromArray(clubManagerIds)) {
            clubManagerIdBuffer.add(managerId);
          };
        };
        case 7 {
          let clubManagerIds = getGroupClubManagerIds(managerGroup8, clubId);
          for (managerId in Iter.fromArray(clubManagerIds)) {
            clubManagerIdBuffer.add(managerId);
          };
        };
        case 8 {
          let clubManagerIds = getGroupClubManagerIds(managerGroup9, clubId);
          for (managerId in Iter.fromArray(clubManagerIds)) {
            clubManagerIdBuffer.add(managerId);
          };
        };
        case 9 {
          let clubManagerIds = getGroupClubManagerIds(managerGroup10, clubId);
          for (managerId in Iter.fromArray(clubManagerIds)) {
            clubManagerIdBuffer.add(managerId);
          };
        };
        case 10 {
          let clubManagerIds = getGroupClubManagerIds(managerGroup11, clubId);
          for (managerId in Iter.fromArray(clubManagerIds)) {
            clubManagerIdBuffer.add(managerId);
          };
        };
        case 11 {
          let clubManagerIds = getGroupClubManagerIds(managerGroup12, clubId);
          for (managerId in Iter.fromArray(clubManagerIds)) {
            clubManagerIdBuffer.add(managerId);
          };
        };
        case _ {

        };
      };
    };

    return Buffer.toArray(clubManagerIdBuffer);
  };

  private func getGroupClubManagerIds(managers : [AppTypes.Manager], clubId : FootballIds.ClubId) : [Ids.PrincipalId] {
    let managerIdBuffer = Buffer.fromArray<Ids.PrincipalId>([]);
    for (manager in Iter.fromArray(managers)) {
      switch (manager.favouriteClubId) {
        case (?foundClubId) {
          if (foundClubId == clubId) {
            managerIdBuffer.add(manager.principalId);
          };
        };
        case (null) {};
      };
    };
    return Buffer.toArray(managerIdBuffer);
  };

  //Timer callback functions

  //Snapshot teams:

  public shared ({ caller }) func snapshotFantasyTeams(seasonId : FootballIds.SeasonId, gameweek : FootballDefinitions.GameweekNumber, month : BaseDefinitions.CalendarMonth) : async () {
    assert not Principal.isAnonymous(caller);
    let backendPrincipalId = Principal.toText(caller);
    assert backendPrincipalId == Environment.BACKEND_CANISTER_ID;

    for (index in Iter.range(0, 11)) {
      await snapshotManagers(index, seasonId, gameweek, month);
    };
  };

  private func snapshotManagers(managerGroup : Int, seasonId : FootballIds.SeasonId, gameweek : FootballDefinitions.GameweekNumber, month : BaseDefinitions.CalendarMonth) : async () {

    try {
      let backend_canister = actor (Environment.BACKEND_CANISTER_ID) : actor {
        getPlayersSnapshot : shared (dto : AppQueries.GetPlayersSnapshot) -> async Result.Result<AppQueries.PlayersSnapshot, Enums.Error>;
      };

      let res = await backend_canister.getPlayersSnapshot({
        seasonId;
        gameweek;
      });

      var players : AppQueries.PlayersSnapshot = {
        players = [];
      };

      switch (res) {
        case (#ok(playersSnapshot)) {
          players := playersSnapshot;
        };
        case (#err(err)) {
          let _ = await logsManager.addApplicationLog({
            logType = #Error;
            title = "Error getting players snapshot";
            error = ?err;
            detail = "Error getting players snapshot";
            app = #OpenFPL;
          });
        };
      };

      let managerBuffer = Buffer.fromArray<AppTypes.Manager>([]);

      var managers : [AppTypes.Manager] = [];

      switch (managerGroup) {
        case 0 {
          managers := managerGroup1;
        };
        case 1 {
          managers := managerGroup2;
        };
        case 2 {
          managers := managerGroup3;
        };
        case 3 {
          managers := managerGroup4;
        };
        case 4 {
          managers := managerGroup5;
        };
        case 5 {
          managers := managerGroup6;
        };
        case 6 {
          managers := managerGroup7;
        };
        case 7 {
          managers := managerGroup8;
        };
        case 8 {
          managers := managerGroup9;
        };
        case 9 {
          managers := managerGroup10;
        };
        case 10 {
          managers := managerGroup11;
        };
        case 11 {
          managers := managerGroup12;
        };
        case _ {

        };
      };

      for (manager in Iter.fromArray(managers)) {

        var seasonFound = false;
        var updatedSeasons = List.map<AppTypes.FantasyTeamSeason, AppTypes.FantasyTeamSeason>(
          manager.history,
          func(season : AppTypes.FantasyTeamSeason) : AppTypes.FantasyTeamSeason {
            if (season.seasonId == seasonId) {
              seasonFound := true;

              let otherSeasonGameweeks = List.filter<UserQueries.FantasyTeamSnapshot>(
                season.gameweeks,
                func(snapshot : UserQueries.FantasyTeamSnapshot) : Bool {
                  return snapshot.gameweek != gameweek;
                },
              );

              let managerPlayers = Array.filter<AppTypes.SnapshotPlayer>(
                players.players,
                func(player) {
                  Option.isSome(
                    Array.find<FootballIds.PlayerId>(
                      manager.playerIds,
                      func(playerId) : Bool {
                        playerId == player.id;
                      },
                    )
                  );
                },
              );

              let allPlayerValues = Array.map<AppTypes.SnapshotPlayer, Nat16>(managerPlayers, func(player : AppTypes.SnapshotPlayer) : Nat16 { return player.valueQuarterMillions });
              let totalTeamValue = Array.foldLeft<Nat16, Nat16>(allPlayerValues, 0, func(sumSoFar, x) = sumSoFar + x);

              let newSnapshot : UserQueries.FantasyTeamSnapshot = {
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
                oneNationGameweek = manager.oneNationGameweek;
                oneNationCountryId = manager.oneNationCountryId;
                prospectsGameweek = manager.prospectsGameweek;
                braceBonusGameweek = manager.braceBonusGameweek;
                hatTrickHeroGameweek = manager.hatTrickHeroGameweek;
                username = manager.username;
                favouriteClubId = manager.favouriteClubId;
                points = 0;
                transferWindowGameweek = manager.transferWindowGameweek;
                monthlyBonusesAvailable = manager.monthlyBonusesAvailable;
                teamValueQuarterMillions = totalTeamValue;
                month = month;
                monthlyPoints = 0;
                seasonPoints = 0;
                seasonId = seasonId;
              };

              let updatedGameweeks = List.push(newSnapshot, otherSeasonGameweeks);

              return {
                seasonId = season.seasonId;
                totalPoints = season.totalPoints;
                gameweeks = updatedGameweeks;
              };
            } else {
              return season;
            };
          },
        );

        let updatedSeasonsBuffer = Buffer.fromArray<AppTypes.FantasyTeamSeason>(List.toArray(updatedSeasons));

        if (not seasonFound) {

          let managerPlayers = Array.filter<AppTypes.SnapshotPlayer>(
            players.players,
            func(player) {
              Option.isSome(
                Array.find<FootballIds.PlayerId>(
                  manager.playerIds,
                  func(playerId) : Bool {
                    playerId == player.id;
                  },
                )
              );
            },
          );

          let allPlayerValues = Array.map<AppTypes.SnapshotPlayer, Nat16>(managerPlayers, func(player : AppTypes.SnapshotPlayer) : Nat16 { return player.valueQuarterMillions });
          let totalTeamValue = Array.foldLeft<Nat16, Nat16>(allPlayerValues, 0, func(sumSoFar, x) = sumSoFar + x);

          let newSnapshot : UserQueries.FantasyTeamSnapshot = {
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
            oneNationGameweek = manager.oneNationGameweek;
            oneNationCountryId = manager.oneNationCountryId;
            prospectsGameweek = manager.prospectsGameweek;
            braceBonusGameweek = manager.braceBonusGameweek;
            hatTrickHeroGameweek = manager.hatTrickHeroGameweek;
            username = manager.username;
            favouriteClubId = manager.favouriteClubId;
            points = 0;
            transferWindowGameweek = manager.transferWindowGameweek;
            monthlyBonusesAvailable = manager.monthlyBonusesAvailable;
            teamValueQuarterMillions = totalTeamValue;
            month = month;
            monthlyPoints = 0;
            seasonPoints = 0;
            seasonId = seasonId;
          };

          updatedSeasonsBuffer.add({
            gameweeks = List.fromArray([newSnapshot]);
            seasonId = seasonId;
            totalPoints = 0;
          });
        };

        let updatedManager : AppTypes.Manager = {

          principalId = manager.principalId;
          username = manager.username;
          termsAccepted = manager.termsAccepted;
          favouriteClubId = manager.favouriteClubId;
          createDate = manager.createDate;
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
          oneNationGameweek = manager.oneNationGameweek;
          oneNationCountryId = manager.oneNationCountryId;
          prospectsGameweek = manager.prospectsGameweek;
          braceBonusGameweek = manager.braceBonusGameweek;
          hatTrickHeroGameweek = manager.hatTrickHeroGameweek;
          transferWindowGameweek = manager.transferWindowGameweek;
          history = List.fromArray(Buffer.toArray(updatedSeasonsBuffer));
          profilePicture = manager.profilePicture;
          profilePictureType = manager.profilePictureType;
          canisterId = manager.canisterId;
        };
        managerBuffer.add(updatedManager);
      };

      switch (managerGroup) {
        case 0 {
          managerGroup1 := Buffer.toArray(managerBuffer);
        };
        case 1 {
          managerGroup2 := Buffer.toArray(managerBuffer);
        };
        case 2 {
          managerGroup3 := Buffer.toArray(managerBuffer);
        };
        case 3 {
          managerGroup4 := Buffer.toArray(managerBuffer);
        };
        case 4 {
          managerGroup5 := Buffer.toArray(managerBuffer);
        };
        case 5 {
          managerGroup6 := Buffer.toArray(managerBuffer);
        };
        case 6 {
          managerGroup7 := Buffer.toArray(managerBuffer);
        };
        case 7 {
          managerGroup8 := Buffer.toArray(managerBuffer);
        };
        case 8 {
          managerGroup9 := Buffer.toArray(managerBuffer);
        };
        case 9 {
          managerGroup10 := Buffer.toArray(managerBuffer);
        };
        case 10 {
          managerGroup11 := Buffer.toArray(managerBuffer);
        };
        case 11 {
          managerGroup12 := Buffer.toArray(managerBuffer);
        };
        case _ {

        };
      };
    } catch (err) {
      let _ = await logsManager.addApplicationLog({
        logType = #Error;
        title = "Error snapshotting managers";
        error = ?#IncorrectSetup;
        detail = message(err);
        app = #OpenFPL;
      });
    };
  };

  private func updateSnapshotPoints(principalId : Text, seasonId : Nat16, gameweek : FootballDefinitions.GameweekNumber, month : BaseDefinitions.CalendarMonth, teamPoints : Int16, teamValueQuarterMillions : Nat16) : () {

    let managerBuffer = Buffer.fromArray<AppTypes.Manager>([]);
    let managerGroupIndex = managerGroupIndexes.get(principalId);

    var managers : [AppTypes.Manager] = [];

    switch (managerGroupIndex) {
      case (null) {};
      case (?foundGroupIndex) {

        switch (foundGroupIndex) {
          case 0 {
            managers := managerGroup1;
          };
          case 1 {
            managers := managerGroup2;
          };
          case 2 {
            managers := managerGroup3;
          };
          case 3 {
            managers := managerGroup4;
          };
          case 4 {
            managers := managerGroup5;
          };
          case 5 {
            managers := managerGroup6;
          };
          case 6 {
            managers := managerGroup7;
          };
          case 7 {
            managers := managerGroup8;
          };
          case 8 {
            managers := managerGroup9;
          };
          case 9 {
            managers := managerGroup10;
          };
          case 10 {
            managers := managerGroup11;
          };
          case 11 {
            managers := managerGroup12;
          };
          case _ {

          };
        };

        for (manager in Iter.fromArray(managers)) {
          if (manager.principalId == principalId) {
            let teamHistoryBuffer = Buffer.fromArray<AppTypes.FantasyTeamSeason>([]);

            switch (manager.history) {
              case (null) {
                teamHistoryBuffer.add({
                  seasonId = seasonId;
                  totalPoints = teamPoints;
                  gameweeks = List.fromArray([mergeManagerSnapshot(manager, seasonId, gameweek, month, teamPoints, teamPoints, teamPoints, teamValueQuarterMillions)]);
                });
                managerBuffer.add(mergeManagerHistory(manager, List.fromArray(Buffer.toArray(teamHistoryBuffer))));
              };
              case (existingHistory) {

                var seasonPoints : Int16 = 0;
                var monthlyPoints : Int16 = 0;
                for (season in Iter.fromList(existingHistory)) {
                  if (season.seasonId == seasonId) {
                    for (seasonGameweek in Iter.fromList(season.gameweeks)) {
                      seasonPoints := seasonPoints + seasonGameweek.points;
                      if (seasonGameweek.month == month) {
                        monthlyPoints := monthlyPoints + seasonGameweek.points;
                      };
                    };
                  };
                };
                monthlyPoints := monthlyPoints + teamPoints;
                seasonPoints := seasonPoints + teamPoints;

                let newSnapshot = mergeManagerSnapshot(manager, seasonId, gameweek, month, teamPoints, monthlyPoints, seasonPoints, teamValueQuarterMillions);
                let updatedHistory = mergeExistingHistory(existingHistory, newSnapshot, seasonId, gameweek);

                let updatedManager = mergeManagerHistory(manager, updatedHistory);
                managerBuffer.add(updatedManager);
              };
            };

          } else {
            managerBuffer.add(manager);
          };
        };

        switch (foundGroupIndex) {
          case 0 {
            managerGroup1 := Buffer.toArray(managerBuffer);
          };
          case 1 {
            managerGroup2 := Buffer.toArray(managerBuffer);
          };
          case 2 {
            managerGroup3 := Buffer.toArray(managerBuffer);
          };
          case 3 {
            managerGroup4 := Buffer.toArray(managerBuffer);
          };
          case 4 {
            managerGroup5 := Buffer.toArray(managerBuffer);
          };
          case 5 {
            managerGroup6 := Buffer.toArray(managerBuffer);
          };
          case 6 {
            managerGroup7 := Buffer.toArray(managerBuffer);
          };
          case 7 {
            managerGroup8 := Buffer.toArray(managerBuffer);
          };
          case 8 {
            managerGroup9 := Buffer.toArray(managerBuffer);
          };
          case 9 {
            managerGroup10 := Buffer.toArray(managerBuffer);
          };
          case 10 {
            managerGroup11 := Buffer.toArray(managerBuffer);
          };
          case 11 {
            managerGroup12 := Buffer.toArray(managerBuffer);
          };
          case _ {

          };
        };
      };
    };
  };

  private func mergeManagerSnapshot(manager : AppTypes.Manager, seasonId : FootballIds.SeasonId, gameweek : FootballDefinitions.GameweekNumber, month : BaseDefinitions.CalendarMonth, weeklyPoints : Int16, monthlyPoints : Int16, seasonPoints : Int16, teamValueQuarterMillions : Nat16) : UserQueries.FantasyTeamSnapshot {

    return {
      principalId = manager.principalId;
      username = manager.username;
      favouriteClubId = manager.favouriteClubId;
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
      oneNationGameweek = manager.oneNationGameweek;
      oneNationCountryId = manager.oneNationCountryId;
      prospectsGameweek = manager.prospectsGameweek;
      braceBonusGameweek = manager.braceBonusGameweek;
      hatTrickHeroGameweek = manager.hatTrickHeroGameweek;
      transferWindowGameweek = manager.transferWindowGameweek;
      gameweek = gameweek;
      points = weeklyPoints;
      monthlyPoints = monthlyPoints;
      seasonPoints = seasonPoints;
      teamValueQuarterMillions = teamValueQuarterMillions;
      month = month;
      seasonId = seasonId;
    };
  };

  private func mergeManagerHistory(manager : AppTypes.Manager, history : List.List<AppTypes.FantasyTeamSeason>) : AppTypes.Manager {
    return {
      principalId = manager.principalId;
      username = manager.username;
      termsAccepted = manager.termsAccepted;
      favouriteClubId = manager.favouriteClubId;
      createDate = manager.createDate;
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
      oneNationGameweek = manager.oneNationGameweek;
      oneNationCountryId = manager.oneNationCountryId;
      prospectsGameweek = manager.prospectsGameweek;
      braceBonusGameweek = manager.braceBonusGameweek;
      hatTrickHeroGameweek = manager.hatTrickHeroGameweek;
      transferWindowGameweek = manager.transferWindowGameweek;
      history = history;
      profilePicture = manager.profilePicture;
      profilePictureType = manager.profilePictureType;
      canisterId = manager.canisterId;
    };
  };

  private func mergeExistingHistory(existingHistory : List.List<AppTypes.FantasyTeamSeason>, fantasyTeamSnapshot : UserQueries.FantasyTeamSnapshot, seasonId : FootballIds.SeasonId, gameweek : FootballDefinitions.GameweekNumber) : List.List<AppTypes.FantasyTeamSeason> {

    let teamHistoryBuffer = Buffer.fromArray<AppTypes.FantasyTeamSeason>([]);

    for (season in List.toIter<AppTypes.FantasyTeamSeason>(existingHistory)) {
      if (season.seasonId == seasonId) {
        let snapshotBuffer = Buffer.fromArray<UserQueries.FantasyTeamSnapshot>([]);

        for (snapshot in List.toIter<UserQueries.FantasyTeamSnapshot>(season.gameweeks)) {
          if (snapshot.gameweek != gameweek) {
            snapshotBuffer.add(snapshot);
          };
        };

        snapshotBuffer.add(fantasyTeamSnapshot);

        let gameweekSnapshots = Buffer.toArray<UserQueries.FantasyTeamSnapshot>(snapshotBuffer);

        let totalSeasonPoints = Array.foldLeft<UserQueries.FantasyTeamSnapshot, Int16>(gameweekSnapshots, 0, func(sumSoFar, x) = sumSoFar + x.points);

        let updatedSeason : AppTypes.FantasyTeamSeason = {
          gameweeks = List.fromArray(gameweekSnapshots);
          seasonId = season.seasonId;
          totalPoints = totalSeasonPoints;
        };

        teamHistoryBuffer.add(updatedSeason);

      } else { teamHistoryBuffer.add(season) };
    };

    return List.fromArray(Buffer.toArray(teamHistoryBuffer));
  };

  public shared ({ caller }) func calculateFantasyTeamScores(seasonId : FootballIds.SeasonId, gameweek : FootballDefinitions.GameweekNumber, month : BaseDefinitions.CalendarMonth) : async () {
    try {
      assert not Principal.isAnonymous(caller);
      let backendPrincipalId = Principal.toText(caller);
      assert backendPrincipalId == Environment.BACKEND_CANISTER_ID;

      let backend_canister = actor (Environment.BACKEND_CANISTER_ID) : actor {
        getPlayersMap : (dto : PlayerQueries.GetPlayersMap) -> async Result.Result<PlayerQueries.PlayersMap, Enums.Error>;
        getPlayersSnapshot : shared query (dto : AppQueries.GetPlayersSnapshot) -> async Result.Result<AppQueries.PlayersSnapshot, Enums.Error>;
      };

      let allPlayersListResult = await backend_canister.getPlayersMap({
        leagueId = Environment.LEAGUE_ID;
        seasonId;
        gameweek;
      });

      var snapshotPlayers : AppQueries.PlayersSnapshot = {
        players = [];
      };
      let res = await backend_canister.getPlayersSnapshot({
        seasonId;
        gameweek;
      });
      switch (res) {
        case (#ok allPlayersList) {
          snapshotPlayers := allPlayersList;
        };
        case (#err err) {
          let _ = await logsManager.addApplicationLog({
            logType = #Error;
            title = "Error getting players snapshot";
            error = ?err;
            detail = "Error getting players snapshot";
            app = #OpenFPL;
          });
        };
      };

      let playerIdTrie : TrieMap.TrieMap<FootballIds.PlayerId, PlayerQueries.PlayerScore> = TrieMap.TrieMap<FootballIds.PlayerId, PlayerQueries.PlayerScore>(BaseUtilities.eqNat16, BaseUtilities.hashNat16);

      switch (allPlayersListResult) {
        case (#ok allPlayersList) {

          for (player in Iter.fromArray(allPlayersList.playersMap)) {
            playerIdTrie.put(player.0, player.1);
          };

          for (index in Iter.range(0, 11)) {
            var managers : [AppTypes.Manager] = [];
            switch (index) {
              case 0 {
                managers := managerGroup1;
              };
              case 1 {
                managers := managerGroup2;
              };
              case 2 {
                managers := managerGroup3;
              };
              case 3 {
                managers := managerGroup4;
              };
              case 4 {
                managers := managerGroup5;
              };
              case 5 {
                managers := managerGroup6;
              };
              case 6 {
                managers := managerGroup7;
              };
              case 7 {
                managers := managerGroup8;
              };
              case 8 {
                managers := managerGroup9;
              };
              case 9 {
                managers := managerGroup10;
              };
              case 10 {
                managers := managerGroup11;
              };
              case 11 {
                managers := managerGroup12;
              };
              case _ {};
            };
            for (value in Iter.fromArray(managers)) {

              let currentSeason = List.find<AppTypes.FantasyTeamSeason>(
                value.history,
                func(teamSeason : AppTypes.FantasyTeamSeason) : Bool {
                  return teamSeason.seasonId == seasonId;
                },
              );

              switch (currentSeason) {
                case (null) {};
                case (?foundSeason) {
                  let currentSnapshot = List.find<UserQueries.FantasyTeamSnapshot>(
                    foundSeason.gameweeks,
                    func(snapshot : UserQueries.FantasyTeamSnapshot) : Bool {
                      return snapshot.gameweek == gameweek;
                    },
                  );
                  switch (currentSnapshot) {
                    case (null) {};
                    case (?foundSnapshot) {

                      var totalTeamPoints : Int16 = 0;
                      let fantasyTeamPlayersBuffer = Buffer.fromArray<AppTypes.SnapshotPlayer>([]);
                      for (playerId in Iter.fromArray(foundSnapshot.playerIds)) {
                        let playerData = playerIdTrie.get(playerId);
                        switch (playerData) {
                          case (null) {};
                          case (?player) {

                            let snapshotPlayer = Array.find(
                              snapshotPlayers.players,
                              func(foundSnapshotPlayer : AppTypes.SnapshotPlayer) : Bool {
                                foundSnapshotPlayer.id == player.id;
                              },
                            );
                            switch (snapshotPlayer) {
                              case (?foundSnapshotPlayer) {
                                fantasyTeamPlayersBuffer.add(foundSnapshotPlayer);
                              };
                              case (null) {};
                            };

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

                            // oneNation
                            if (foundSnapshot.oneNationGameweek == gameweek and foundSnapshot.oneNationCountryId == player.nationality) {
                              totalScore := totalScore * 2;
                            };

                            // Prospects
                            if (foundSnapshot.prospectsGameweek == gameweek and DateTimeUtilities.calculateAgeFromUnix(player.dateOfBirth) < 21) {
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

                      let thisTeamsPlayers : [AppTypes.SnapshotPlayer] = Buffer.toArray(fantasyTeamPlayersBuffer);
                      let allPlayerValues = Array.map<AppTypes.SnapshotPlayer, Nat16>(thisTeamsPlayers, func(player : AppTypes.SnapshotPlayer) : Nat16 { return player.valueQuarterMillions });

                      let totalTeamValue = Array.foldLeft<Nat16, Nat16>(allPlayerValues, 0, func(sumSoFar, x) = sumSoFar + x);

                      updateSnapshotPoints(value.principalId, seasonId, gameweek, month, totalTeamPoints, totalTeamValue);
                    };
                  };
                };
              };
            };
          };

        };
        case (#err _) {};
      };
    } catch (err) {
      let _ = await logsManager.addApplicationLog({
        logType = #Error;
        title = "Error calculating fantasy team scores";
        error = ?#IncorrectSetup;
        detail = message(err);
        app = #OpenFPL;
      });
    };
  };

  private func calculateGoalPoints(position : FootballEnums.PlayerPosition, goalsScored : Int16) : Int16 {
    switch (position) {
      case (#Goalkeeper) { return 40 * goalsScored };
      case (#Defender) { return 40 * goalsScored };
      case (#Midfielder) { return 30 * goalsScored };
      case (#Forward) { return 20 * goalsScored };
    };
  };

  private func calculateAssistPoints(position : FootballEnums.PlayerPosition, assists : Int16) : Int16 {
    switch (position) {
      case (#Goalkeeper) { return 30 * assists };
      case (#Defender) { return 30 * assists };
      case (#Midfielder) { return 20 * assists };
      case (#Forward) { return 20 * assists };
    };
  };

  //Remove player from teams

  public shared ({ caller }) func removePlayerFromTeams(leagueId : FootballIds.LeagueId, playerId : FootballIds.PlayerId, parentCanisterId : Ids.CanisterId) : async () {
    assert not Principal.isAnonymous(caller);
    let backendPrincipalId = Principal.toText(caller);
    assert backendPrincipalId == Environment.BACKEND_CANISTER_ID;
    for (index in Iter.range(0, 11)) {
      await removePlayerFromGroup(leagueId, playerId, index, parentCanisterId);
    };
  };

  private func removePlayerFromGroup(leagueId : FootballIds.LeagueId, removePlayerId : FootballIds.PlayerId, managerGroup : Int, parentCanisterId : Ids.CanisterId) : async () {
    try {
      let backend_canister = actor (parentCanisterId) : actor {
        getPlayers : (dto : PlayerQueries.GetPlayers) -> async Result.Result<PlayerQueries.Players, Enums.Error>;
      };

      let allPlayersResult = await backend_canister.getPlayers({
        leagueId = leagueId;
      });

      switch (allPlayersResult) {
        case (#ok allPlayers) {
          let removedPlayer = Array.find<PlayerQueries.Player>(allPlayers.players, func(p) { p.id == removePlayerId });

          switch (removedPlayer) {
            case (null) {
              //removeMissingPlayer(playerId); TODO NEED TO FIX
            };
            case (?foundRemovedPlayer) {
              let playerValue = foundRemovedPlayer.valueQuarterMillions;
              let managerBuffer = Buffer.fromArray<AppTypes.Manager>([]);

              var managers : [AppTypes.Manager] = [];

              switch (managerGroup) {
                case 0 {
                  managers := managerGroup1;
                };
                case 1 {
                  managers := managerGroup2;
                };
                case 2 {
                  managers := managerGroup3;
                };
                case 3 {
                  managers := managerGroup4;
                };
                case 4 {
                  managers := managerGroup5;
                };
                case 5 {
                  managers := managerGroup6;
                };
                case 6 {
                  managers := managerGroup7;
                };
                case 7 {
                  managers := managerGroup8;
                };
                case 8 {
                  managers := managerGroup9;
                };
                case 9 {
                  managers := managerGroup10;
                };
                case 10 {
                  managers := managerGroup11;
                };
                case 11 {
                  managers := managerGroup12;
                };
                case _ {

                };
              };

              for (manager in Iter.fromArray(managers)) {
                let playerIdBuffer = Buffer.fromArray<FootballIds.PlayerId>([]);
                var playerRemoved = false;
                for (playerId in Iter.fromArray(manager.playerIds)) {
                  if (playerId == removePlayerId) {
                    playerIdBuffer.add(0);
                    playerRemoved := true;
                  } else {
                    playerIdBuffer.add(playerId);
                  };
                };
                if (playerRemoved) {
                  var captainId = manager.captainId;
                  if (captainId == removePlayerId) {
                    let highestValuedPlayer = Array.foldLeft<FootballIds.PlayerId, ?PlayerQueries.Player>(
                      manager.playerIds,
                      null,
                      func(highest, id) : ?PlayerQueries.Player {
                        if (id == removePlayerId or id == 0) { return highest };
                        let player = Array.find<PlayerQueries.Player>(allPlayers.players, func(p) { p.id == id });
                        switch (highest, player) {
                          case (null, ?p) {
                            ?p;
                          };
                          case (?h, ?p) {
                            if (p.valueQuarterMillions > h.valueQuarterMillions) {
                              ?p;
                            } else {
                              ?h;
                            };
                          };
                          case (_, null) {
                            highest;
                          };
                        };
                      },
                    );
                    switch (highestValuedPlayer) {
                      case (?player) {
                        captainId := player.id;
                      };
                      case null {};
                    };
                  };
                  let newManager : AppTypes.Manager = {
                    principalId = manager.principalId;
                    username = manager.username;
                    termsAccepted = manager.termsAccepted;
                    favouriteClubId = manager.favouriteClubId;
                    bankQuarterMillions = manager.bankQuarterMillions + playerValue;
                    playerIds = Buffer.toArray(playerIdBuffer);
                    captainId = captainId;
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
                    oneNationGameweek = manager.oneNationGameweek;
                    oneNationCountryId = manager.oneNationCountryId;
                    prospectsGameweek = manager.prospectsGameweek;
                    braceBonusGameweek = manager.braceBonusGameweek;
                    hatTrickHeroGameweek = manager.hatTrickHeroGameweek;
                    transferWindowGameweek = manager.transferWindowGameweek;
                    createDate = manager.createDate;
                    history = manager.history;
                    monthlyBonusesAvailable = manager.monthlyBonusesAvailable;
                    profilePicture = manager.profilePicture;
                    transfersAvailable = manager.transfersAvailable + 1;
                    profilePictureType = manager.profilePictureType;
                    canisterId = manager.canisterId;
                  };

                  managerBuffer.add(newManager);
                } else {
                  managerBuffer.add(manager);
                };
              };

              switch (managerGroup) {
                case 0 {
                  managerGroup1 := Buffer.toArray(managerBuffer);
                };
                case 1 {
                  managerGroup2 := Buffer.toArray(managerBuffer);
                };
                case 2 {
                  managerGroup3 := Buffer.toArray(managerBuffer);
                };
                case 3 {
                  managerGroup4 := Buffer.toArray(managerBuffer);
                };
                case 4 {
                  managerGroup5 := Buffer.toArray(managerBuffer);
                };
                case 5 {
                  managerGroup6 := Buffer.toArray(managerBuffer);
                };
                case 6 {
                  managerGroup7 := Buffer.toArray(managerBuffer);
                };
                case 7 {
                  managerGroup8 := Buffer.toArray(managerBuffer);
                };
                case 8 {
                  managerGroup9 := Buffer.toArray(managerBuffer);
                };
                case 9 {
                  managerGroup10 := Buffer.toArray(managerBuffer);
                };
                case 10 {
                  managerGroup11 := Buffer.toArray(managerBuffer);
                };
                case 11 {
                  managerGroup12 := Buffer.toArray(managerBuffer);
                };
                case _ {

                };
              };
            };
          };

        };
        case (#err _) {

        };
      };
    } catch (err) {
      let _ = await logsManager.addApplicationLog({
        logType = #Error;
        title = "Error removing player from teams";
        error = ?#IncorrectSetup;
        detail = message(err);
        app = #OpenFPL;
      });
    };
  };

  //Team reset callback functions

  public shared ({ caller }) func resetBonusesAvailable() : async () {
    assert not Principal.isAnonymous(caller);
    let backendPrincipalId = Principal.toText(caller);
    assert backendPrincipalId == Environment.BACKEND_CANISTER_ID;

    for (index in Iter.range(0, 11)) {
      var managers : [AppTypes.Manager] = [];

      switch (index) {
        case 0 {
          managers := managerGroup1;
        };
        case 1 {
          managers := managerGroup2;
        };
        case 2 {
          managers := managerGroup3;
        };
        case 3 {
          managers := managerGroup4;
        };
        case 4 {
          managers := managerGroup5;
        };
        case 5 {
          managers := managerGroup6;
        };
        case 6 {
          managers := managerGroup7;
        };
        case 7 {
          managers := managerGroup8;
        };
        case 8 {
          managers := managerGroup9;
        };
        case 9 {
          managers := managerGroup10;
        };
        case 10 {
          managers := managerGroup11;
        };
        case 11 {
          managers := managerGroup12;
        };
        case _ {

        };
      };

      let managerBuffer = Buffer.fromArray<AppTypes.Manager>([]);
      for (manager in Iter.fromArray(managers)) {

        let updatedManager : AppTypes.Manager = {
          principalId = manager.principalId;
          username = manager.username;
          termsAccepted = manager.termsAccepted;
          favouriteClubId = manager.favouriteClubId;
          createDate = manager.createDate;
          history = manager.history;
          profilePicture = manager.profilePicture;
          profilePictureType = manager.profilePictureType;
          transfersAvailable = manager.transfersAvailable;
          monthlyBonusesAvailable = 2;
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
          oneNationGameweek = manager.oneNationGameweek;
          oneNationCountryId = manager.oneNationCountryId;
          prospectsGameweek = manager.prospectsGameweek;
          braceBonusGameweek = manager.braceBonusGameweek;
          hatTrickHeroGameweek = manager.hatTrickHeroGameweek;
          transferWindowGameweek = manager.transferWindowGameweek;
          canisterId = manager.canisterId;
        };
        managerBuffer.add(updatedManager);
      };

      switch (index) {
        case 0 {
          managerGroup1 := Buffer.toArray(managerBuffer);
        };
        case 1 {
          managerGroup2 := Buffer.toArray(managerBuffer);
        };
        case 2 {
          managerGroup3 := Buffer.toArray(managerBuffer);
        };
        case 3 {
          managerGroup4 := Buffer.toArray(managerBuffer);
        };
        case 4 {
          managerGroup5 := Buffer.toArray(managerBuffer);
        };
        case 5 {
          managerGroup6 := Buffer.toArray(managerBuffer);
        };
        case 6 {
          managerGroup7 := Buffer.toArray(managerBuffer);
        };
        case 7 {
          managerGroup8 := Buffer.toArray(managerBuffer);
        };
        case 8 {
          managerGroup9 := Buffer.toArray(managerBuffer);
        };
        case 9 {
          managerGroup10 := Buffer.toArray(managerBuffer);
        };
        case 10 {
          managerGroup11 := Buffer.toArray(managerBuffer);
        };
        case 11 {
          managerGroup12 := Buffer.toArray(managerBuffer);
        };
        case _ {

        };
      };

    };
  };

  public shared ({ caller }) func resetWeeklyTransfers() : async () {
    assert not Principal.isAnonymous(caller);
    let backendPrincipalId = Principal.toText(caller);
    assert backendPrincipalId == Environment.BACKEND_CANISTER_ID;

    for (index in Iter.range(0, 11)) {
      var managers : [AppTypes.Manager] = [];
      switch (index) {
        case 0 {
          managers := managerGroup1;
        };
        case 1 {
          managers := managerGroup2;
        };
        case 2 {
          managers := managerGroup3;
        };
        case 3 {
          managers := managerGroup4;
        };
        case 4 {
          managers := managerGroup5;
        };
        case 5 {
          managers := managerGroup6;
        };
        case 6 {
          managers := managerGroup7;
        };
        case 7 {
          managers := managerGroup8;
        };
        case 8 {
          managers := managerGroup9;
        };
        case 9 {
          managers := managerGroup10;
        };
        case 10 {
          managers := managerGroup11;
        };
        case 11 {
          managers := managerGroup12;
        };
        case _ {

        };
      };

      let managerBuffer = Buffer.fromArray<AppTypes.Manager>([]);
      for (manager in Iter.fromArray(managers)) {
        let updatedManager : AppTypes.Manager = {
          principalId = manager.principalId;
          username = manager.username;
          termsAccepted = manager.termsAccepted;
          favouriteClubId = manager.favouriteClubId;
          createDate = manager.createDate;
          history = manager.history;
          profilePicture = manager.profilePicture;
          profilePictureType = manager.profilePictureType;
          transfersAvailable = 3;
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
          oneNationGameweek = manager.oneNationGameweek;
          oneNationCountryId = manager.oneNationCountryId;
          prospectsGameweek = manager.prospectsGameweek;
          braceBonusGameweek = manager.braceBonusGameweek;
          hatTrickHeroGameweek = manager.hatTrickHeroGameweek;
          transferWindowGameweek = manager.transferWindowGameweek;
          canisterId = manager.canisterId;
        };
        managerBuffer.add(updatedManager);
      };

      switch (index) {
        case 0 {
          managerGroup1 := Buffer.toArray(managerBuffer);
        };
        case 1 {
          managerGroup2 := Buffer.toArray(managerBuffer);
        };
        case 2 {
          managerGroup3 := Buffer.toArray(managerBuffer);
        };
        case 3 {
          managerGroup4 := Buffer.toArray(managerBuffer);
        };
        case 4 {
          managerGroup5 := Buffer.toArray(managerBuffer);
        };
        case 5 {
          managerGroup6 := Buffer.toArray(managerBuffer);
        };
        case 6 {
          managerGroup7 := Buffer.toArray(managerBuffer);
        };
        case 7 {
          managerGroup8 := Buffer.toArray(managerBuffer);
        };
        case 8 {
          managerGroup9 := Buffer.toArray(managerBuffer);
        };
        case 9 {
          managerGroup10 := Buffer.toArray(managerBuffer);
        };
        case 10 {
          managerGroup11 := Buffer.toArray(managerBuffer);
        };
        case 11 {
          managerGroup12 := Buffer.toArray(managerBuffer);
        };
        case _ {

        };
      };

    };

  };

  public shared ({ caller }) func resetFantasyTeams() : async () {
    assert not Principal.isAnonymous(caller);
    let backendPrincipalId = Principal.toText(caller);
    assert backendPrincipalId == Environment.BACKEND_CANISTER_ID;

    managerGroup1 := Array.map<AppTypes.Manager, AppTypes.Manager>(
      managerGroup1,
      func(manager : AppTypes.Manager) {
        return {
          bankQuarterMillions = 1400;
          braceBonusGameweek = 0;
          canisterId = manager.canisterId;
          captainFantasticGameweek = 0;
          captainFantasticPlayerId = 0;
          captainId = 0;
          createDate = manager.createDate;
          favouriteClubId = manager.favouriteClubId;
          goalGetterGameweek = 0;
          goalGetterPlayerId = 0;
          hatTrickHeroGameweek = 0;
          history = List.nil();
          monthlyBonusesAvailable = 2;
          noEntryGameweek = 0;
          noEntryPlayerId = 0;
          oneNationCountryId = 0;
          oneNationGameweek = 0;
          passMasterGameweek = 0;
          passMasterPlayerId = 0;
          playerIds = [];
          principalId = manager.principalId;
          profilePicture = manager.profilePicture;
          profilePictureType = manager.profilePictureType;
          prospectsGameweek = 0;
          safeHandsGameweek = 0;
          safeHandsPlayerId = 0;
          teamBoostClubId = 0;
          teamBoostGameweek = 0;
          termsAccepted = manager.termsAccepted;
          transferWindowGameweek = 0;
          transfersAvailable = 3;
          username = manager.username;
        };
      },
    );

    managerGroup2 := Array.map<AppTypes.Manager, AppTypes.Manager>(
      managerGroup2,
      func(manager : AppTypes.Manager) {
        return {
          bankQuarterMillions = 1400;
          braceBonusGameweek = 0;
          canisterId = manager.canisterId;
          captainFantasticGameweek = 0;
          captainFantasticPlayerId = 0;
          captainId = 0;
          createDate = manager.createDate;
          favouriteClubId = manager.favouriteClubId;
          goalGetterGameweek = 0;
          goalGetterPlayerId = 0;
          hatTrickHeroGameweek = 0;
          history = List.nil();
          monthlyBonusesAvailable = 2;
          noEntryGameweek = 0;
          noEntryPlayerId = 0;
          oneNationCountryId = 0;
          oneNationGameweek = 0;
          passMasterGameweek = 0;
          passMasterPlayerId = 0;
          playerIds = [];
          principalId = manager.principalId;
          profilePicture = manager.profilePicture;
          profilePictureType = manager.profilePictureType;
          prospectsGameweek = 0;
          safeHandsGameweek = 0;
          safeHandsPlayerId = 0;
          teamBoostClubId = 0;
          teamBoostGameweek = 0;
          termsAccepted = manager.termsAccepted;
          transferWindowGameweek = 0;
          transfersAvailable = 3;
          username = manager.username;
        };
      },
    );

    managerGroup3 := Array.map<AppTypes.Manager, AppTypes.Manager>(
      managerGroup3,
      func(manager : AppTypes.Manager) {
        return {
          bankQuarterMillions = 1400;
          braceBonusGameweek = 0;
          canisterId = manager.canisterId;
          captainFantasticGameweek = 0;
          captainFantasticPlayerId = 0;
          captainId = 0;
          createDate = manager.createDate;
          favouriteClubId = manager.favouriteClubId;
          goalGetterGameweek = 0;
          goalGetterPlayerId = 0;
          hatTrickHeroGameweek = 0;
          history = List.nil();
          monthlyBonusesAvailable = 2;
          noEntryGameweek = 0;
          noEntryPlayerId = 0;
          oneNationCountryId = 0;
          oneNationGameweek = 0;
          passMasterGameweek = 0;
          passMasterPlayerId = 0;
          playerIds = [];
          principalId = manager.principalId;
          profilePicture = manager.profilePicture;
          profilePictureType = manager.profilePictureType;
          prospectsGameweek = 0;
          safeHandsGameweek = 0;
          safeHandsPlayerId = 0;
          teamBoostClubId = 0;
          teamBoostGameweek = 0;
          termsAccepted = manager.termsAccepted;
          transferWindowGameweek = 0;
          transfersAvailable = 3;
          username = manager.username;
        };
      },
    );

    managerGroup4 := Array.map<AppTypes.Manager, AppTypes.Manager>(
      managerGroup4,
      func(manager : AppTypes.Manager) {
        return {
          bankQuarterMillions = 1400;
          braceBonusGameweek = 0;
          canisterId = manager.canisterId;
          captainFantasticGameweek = 0;
          captainFantasticPlayerId = 0;
          captainId = 0;
          createDate = manager.createDate;
          favouriteClubId = manager.favouriteClubId;
          goalGetterGameweek = 0;
          goalGetterPlayerId = 0;
          hatTrickHeroGameweek = 0;
          history = List.nil();
          monthlyBonusesAvailable = 2;
          noEntryGameweek = 0;
          noEntryPlayerId = 0;
          oneNationCountryId = 0;
          oneNationGameweek = 0;
          passMasterGameweek = 0;
          passMasterPlayerId = 0;
          playerIds = [];
          principalId = manager.principalId;
          profilePicture = manager.profilePicture;
          profilePictureType = manager.profilePictureType;
          prospectsGameweek = 0;
          safeHandsGameweek = 0;
          safeHandsPlayerId = 0;
          teamBoostClubId = 0;
          teamBoostGameweek = 0;
          termsAccepted = manager.termsAccepted;
          transferWindowGameweek = 0;
          transfersAvailable = 3;
          username = manager.username;
        };
      },
    );

    managerGroup5 := Array.map<AppTypes.Manager, AppTypes.Manager>(
      managerGroup5,
      func(manager : AppTypes.Manager) {
        return {
          bankQuarterMillions = 1400;
          braceBonusGameweek = 0;
          canisterId = manager.canisterId;
          captainFantasticGameweek = 0;
          captainFantasticPlayerId = 0;
          captainId = 0;
          createDate = manager.createDate;
          favouriteClubId = manager.favouriteClubId;
          goalGetterGameweek = 0;
          goalGetterPlayerId = 0;
          hatTrickHeroGameweek = 0;
          history = List.nil();
          monthlyBonusesAvailable = 2;
          noEntryGameweek = 0;
          noEntryPlayerId = 0;
          oneNationCountryId = 0;
          oneNationGameweek = 0;
          passMasterGameweek = 0;
          passMasterPlayerId = 0;
          playerIds = [];
          principalId = manager.principalId;
          profilePicture = manager.profilePicture;
          profilePictureType = manager.profilePictureType;
          prospectsGameweek = 0;
          safeHandsGameweek = 0;
          safeHandsPlayerId = 0;
          teamBoostClubId = 0;
          teamBoostGameweek = 0;
          termsAccepted = manager.termsAccepted;
          transferWindowGameweek = 0;
          transfersAvailable = 3;
          username = manager.username;
        };
      },
    );

    managerGroup6 := Array.map<AppTypes.Manager, AppTypes.Manager>(
      managerGroup6,
      func(manager : AppTypes.Manager) {
        return {
          bankQuarterMillions = 1400;
          braceBonusGameweek = 0;
          canisterId = manager.canisterId;
          captainFantasticGameweek = 0;
          captainFantasticPlayerId = 0;
          captainId = 0;
          createDate = manager.createDate;
          favouriteClubId = manager.favouriteClubId;
          goalGetterGameweek = 0;
          goalGetterPlayerId = 0;
          hatTrickHeroGameweek = 0;
          history = List.nil();
          monthlyBonusesAvailable = 2;
          noEntryGameweek = 0;
          noEntryPlayerId = 0;
          oneNationCountryId = 0;
          oneNationGameweek = 0;
          passMasterGameweek = 0;
          passMasterPlayerId = 0;
          playerIds = [];
          principalId = manager.principalId;
          profilePicture = manager.profilePicture;
          profilePictureType = manager.profilePictureType;
          prospectsGameweek = 0;
          safeHandsGameweek = 0;
          safeHandsPlayerId = 0;
          teamBoostClubId = 0;
          teamBoostGameweek = 0;
          termsAccepted = manager.termsAccepted;
          transferWindowGameweek = 0;
          transfersAvailable = 3;
          username = manager.username;
        };
      },
    );

    managerGroup7 := Array.map<AppTypes.Manager, AppTypes.Manager>(
      managerGroup7,
      func(manager : AppTypes.Manager) {
        return {
          bankQuarterMillions = 1400;
          braceBonusGameweek = 0;
          canisterId = manager.canisterId;
          captainFantasticGameweek = 0;
          captainFantasticPlayerId = 0;
          captainId = 0;
          createDate = manager.createDate;
          favouriteClubId = manager.favouriteClubId;
          goalGetterGameweek = 0;
          goalGetterPlayerId = 0;
          hatTrickHeroGameweek = 0;
          history = List.nil();
          monthlyBonusesAvailable = 2;
          noEntryGameweek = 0;
          noEntryPlayerId = 0;
          oneNationCountryId = 0;
          oneNationGameweek = 0;
          passMasterGameweek = 0;
          passMasterPlayerId = 0;
          playerIds = [];
          principalId = manager.principalId;
          profilePicture = manager.profilePicture;
          profilePictureType = manager.profilePictureType;
          prospectsGameweek = 0;
          safeHandsGameweek = 0;
          safeHandsPlayerId = 0;
          teamBoostClubId = 0;
          teamBoostGameweek = 0;
          termsAccepted = manager.termsAccepted;
          transferWindowGameweek = 0;
          transfersAvailable = 3;
          username = manager.username;
        };
      },
    );

    managerGroup8 := Array.map<AppTypes.Manager, AppTypes.Manager>(
      managerGroup8,
      func(manager : AppTypes.Manager) {
        return {
          bankQuarterMillions = 1400;
          braceBonusGameweek = 0;
          canisterId = manager.canisterId;
          captainFantasticGameweek = 0;
          captainFantasticPlayerId = 0;
          captainId = 0;
          createDate = manager.createDate;
          favouriteClubId = manager.favouriteClubId;
          goalGetterGameweek = 0;
          goalGetterPlayerId = 0;
          hatTrickHeroGameweek = 0;
          history = List.nil();
          monthlyBonusesAvailable = 2;
          noEntryGameweek = 0;
          noEntryPlayerId = 0;
          oneNationCountryId = 0;
          oneNationGameweek = 0;
          passMasterGameweek = 0;
          passMasterPlayerId = 0;
          playerIds = [];
          principalId = manager.principalId;
          profilePicture = manager.profilePicture;
          profilePictureType = manager.profilePictureType;
          prospectsGameweek = 0;
          safeHandsGameweek = 0;
          safeHandsPlayerId = 0;
          teamBoostClubId = 0;
          teamBoostGameweek = 0;
          termsAccepted = manager.termsAccepted;
          transferWindowGameweek = 0;
          transfersAvailable = 3;
          username = manager.username;
        };
      },
    );

    managerGroup9 := Array.map<AppTypes.Manager, AppTypes.Manager>(
      managerGroup9,
      func(manager : AppTypes.Manager) {
        return {
          bankQuarterMillions = 1400;
          braceBonusGameweek = 0;
          canisterId = manager.canisterId;
          captainFantasticGameweek = 0;
          captainFantasticPlayerId = 0;
          captainId = 0;
          createDate = manager.createDate;
          favouriteClubId = manager.favouriteClubId;
          goalGetterGameweek = 0;
          goalGetterPlayerId = 0;
          hatTrickHeroGameweek = 0;
          history = List.nil();
          monthlyBonusesAvailable = 2;
          noEntryGameweek = 0;
          noEntryPlayerId = 0;
          oneNationCountryId = 0;
          oneNationGameweek = 0;
          passMasterGameweek = 0;
          passMasterPlayerId = 0;
          playerIds = [];
          principalId = manager.principalId;
          profilePicture = manager.profilePicture;
          profilePictureType = manager.profilePictureType;
          prospectsGameweek = 0;
          safeHandsGameweek = 0;
          safeHandsPlayerId = 0;
          teamBoostClubId = 0;
          teamBoostGameweek = 0;
          termsAccepted = manager.termsAccepted;
          transferWindowGameweek = 0;
          transfersAvailable = 3;
          username = manager.username;
        };
      },
    );

    managerGroup10 := Array.map<AppTypes.Manager, AppTypes.Manager>(
      managerGroup10,
      func(manager : AppTypes.Manager) {
        return {
          bankQuarterMillions = 1400;
          braceBonusGameweek = 0;
          canisterId = manager.canisterId;
          captainFantasticGameweek = 0;
          captainFantasticPlayerId = 0;
          captainId = 0;
          createDate = manager.createDate;
          favouriteClubId = manager.favouriteClubId;
          goalGetterGameweek = 0;
          goalGetterPlayerId = 0;
          hatTrickHeroGameweek = 0;
          history = List.nil();
          monthlyBonusesAvailable = 2;
          noEntryGameweek = 0;
          noEntryPlayerId = 0;
          oneNationCountryId = 0;
          oneNationGameweek = 0;
          passMasterGameweek = 0;
          passMasterPlayerId = 0;
          playerIds = [];
          principalId = manager.principalId;
          profilePicture = manager.profilePicture;
          profilePictureType = manager.profilePictureType;
          prospectsGameweek = 0;
          safeHandsGameweek = 0;
          safeHandsPlayerId = 0;
          teamBoostClubId = 0;
          teamBoostGameweek = 0;
          termsAccepted = manager.termsAccepted;
          transferWindowGameweek = 0;
          transfersAvailable = 3;
          username = manager.username;
        };
      },
    );

    managerGroup11 := Array.map<AppTypes.Manager, AppTypes.Manager>(
      managerGroup11,
      func(manager : AppTypes.Manager) {
        return {
          bankQuarterMillions = 1400;
          braceBonusGameweek = 0;
          canisterId = manager.canisterId;
          captainFantasticGameweek = 0;
          captainFantasticPlayerId = 0;
          captainId = 0;
          createDate = manager.createDate;
          favouriteClubId = manager.favouriteClubId;
          goalGetterGameweek = 0;
          goalGetterPlayerId = 0;
          hatTrickHeroGameweek = 0;
          history = List.nil();
          monthlyBonusesAvailable = 2;
          noEntryGameweek = 0;
          noEntryPlayerId = 0;
          oneNationCountryId = 0;
          oneNationGameweek = 0;
          passMasterGameweek = 0;
          passMasterPlayerId = 0;
          playerIds = [];
          principalId = manager.principalId;
          profilePicture = manager.profilePicture;
          profilePictureType = manager.profilePictureType;
          prospectsGameweek = 0;
          safeHandsGameweek = 0;
          safeHandsPlayerId = 0;
          teamBoostClubId = 0;
          teamBoostGameweek = 0;
          termsAccepted = manager.termsAccepted;
          transferWindowGameweek = 0;
          transfersAvailable = 3;
          username = manager.username;
        };
      },
    );

    managerGroup12 := Array.map<AppTypes.Manager, AppTypes.Manager>(
      managerGroup12,
      func(manager : AppTypes.Manager) {
        return {
          bankQuarterMillions = 1400;
          braceBonusGameweek = 0;
          canisterId = manager.canisterId;
          captainFantasticGameweek = 0;
          captainFantasticPlayerId = 0;
          captainId = 0;
          createDate = manager.createDate;
          favouriteClubId = manager.favouriteClubId;
          goalGetterGameweek = 0;
          goalGetterPlayerId = 0;
          hatTrickHeroGameweek = 0;
          history = List.nil();
          monthlyBonusesAvailable = 2;
          noEntryGameweek = 0;
          noEntryPlayerId = 0;
          oneNationCountryId = 0;
          oneNationGameweek = 0;
          passMasterGameweek = 0;
          passMasterPlayerId = 0;
          playerIds = [];
          principalId = manager.principalId;
          profilePicture = manager.profilePicture;
          profilePictureType = manager.profilePictureType;
          prospectsGameweek = 0;
          safeHandsGameweek = 0;
          safeHandsPlayerId = 0;
          teamBoostClubId = 0;
          teamBoostGameweek = 0;
          termsAccepted = manager.termsAccepted;
          transferWindowGameweek = 0;
          transfersAvailable = 3;
          username = manager.username;
        };
      },
    );

  };

  system func preupgrade() {
    stable_manager_group_indexes := Iter.toArray(managerGroupIndexes.entries());
  };

  system func postupgrade() {
    let indexMap : TrieMap.TrieMap<Ids.PrincipalId, Nat8> = TrieMap.TrieMap<Ids.PrincipalId, Nat8>(Text.equal, Text.hash);

    for (link in Iter.fromArray(stable_manager_group_indexes)) {
      indexMap.put(link);
    };
    managerGroupIndexes := indexMap;
    ignore Timer.setTimer<system>(#nanoseconds(Int.abs(1)), postUpgradeCallback);
  };

  private func postUpgradeCallback() : async () {};

};

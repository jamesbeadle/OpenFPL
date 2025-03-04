import Array "mo:base/Array";
import Bool "mo:base/Bool";
import Buffer "mo:base/Buffer";
import Environment "../network_environment_variables";
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

import Base "mo:waterway-mops/BaseTypes";
import DTOs "../../shared/dtos/dtos";
import FootballTypes "mo:waterway-mops/FootballTypes";
import T "../../shared/types/app_types";
import Commands "../cqrs/commands";
import Queries "../cqrs/queries";
import DateTimeUtilities "../utils/date_time_utilities";
import ComparisonUtilities "../utils/type_comparison_utilities";
import PickTeamUtilities "../utils/pick_team_utilities";

actor class _ManagerCanister() {

  private var managerGroupIndexes : TrieMap.TrieMap<Base.PrincipalId, Nat8> = TrieMap.TrieMap<Base.PrincipalId, Nat8>(Text.equal, Text.hash);

  private stable var stable_manager_group_indexes : [(Base.PrincipalId, Nat8)] = [];
  private stable var managerGroup1 : [T.Manager] = [];
  private stable var managerGroup2 : [T.Manager] = [];
  private stable var managerGroup3 : [T.Manager] = [];
  private stable var managerGroup4 : [T.Manager] = [];
  private stable var managerGroup5 : [T.Manager] = [];
  private stable var managerGroup6 : [T.Manager] = [];
  private stable var managerGroup7 : [T.Manager] = [];
  private stable var managerGroup8 : [T.Manager] = [];
  private stable var managerGroup9 : [T.Manager] = [];
  private stable var managerGroup10 : [T.Manager] = [];
  private stable var managerGroup11 : [T.Manager] = [];
  private stable var managerGroup12 : [T.Manager] = [];

  private stable var cyclesCheckTimerId : ?Timer.TimerId = null;
  private stable var activeGroupIndex : Nat8 = 0;
  private stable var totalManagers = 0;

  private stable var initialised = false;
  private stable var controllerPrincipalId = "";

  public shared ({ caller }) func initialise(_controllerPrincipalId : Text) : async () {
    if (initialised) {
      return;
    };

    //TODO: Environment variable should be set to openfpl not both - needs to be more abstract
    let callerInArray = Array.find<Base.CanisterId>(
      [Environment.OPENFPL_BACKEND_CANISTER_ID, Environment.OPENWSL_BACKEND_CANISTER_ID],
      func(canisterId : Base.CanisterId) : Bool {
        canisterId == Principal.toText(caller);
      },
    );

    if (Option.isSome(callerInArray)) {
      controllerPrincipalId := _controllerPrincipalId;
    };
    initialised := true;
  };

  public shared ({ caller }) func updateTeamSelection(dto : Commands.SaveTeamDTO, managerPrincipalId : Base.PrincipalId, transfersAvailable : Nat8, newBankBalance : Nat16) : async Result.Result<(), T.Error> {
    assert not Principal.isAnonymous(caller);
    let backendPrincipalId = Principal.toText(caller);
    assert backendPrincipalId == controllerPrincipalId;

    let managerBuffer = Buffer.fromArray<T.Manager>([]);
    let managerGroupIndex = managerGroupIndexes.get(managerPrincipalId);
    switch (managerGroupIndex) {
      case (null) {};
      case (?foundGroupIndex) {
        switch (foundGroupIndex) {
          case 0 {
            for (manager in Iter.fromArray(managerGroup1)) {
              if (manager.principalId == managerPrincipalId) {
                managerBuffer.add(mergeTeamSelection(dto, manager, transfersAvailable, newBankBalance));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup1 := Buffer.toArray(managerBuffer);
          };
          case 1 {
            for (manager in Iter.fromArray(managerGroup2)) {
              if (manager.principalId == managerPrincipalId) {
                managerBuffer.add(mergeTeamSelection(dto, manager, transfersAvailable, newBankBalance));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup2 := Buffer.toArray(managerBuffer);
          };
          case 2 {
            for (manager in Iter.fromArray(managerGroup3)) {
              if (manager.principalId == managerPrincipalId) {
                managerBuffer.add(mergeTeamSelection(dto, manager, transfersAvailable, newBankBalance));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup3 := Buffer.toArray(managerBuffer);
          };
          case 3 {
            for (manager in Iter.fromArray(managerGroup4)) {
              if (manager.principalId == managerPrincipalId) {
                managerBuffer.add(mergeTeamSelection(dto, manager, transfersAvailable, newBankBalance));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup4 := Buffer.toArray(managerBuffer);
          };
          case 4 {
            for (manager in Iter.fromArray(managerGroup5)) {
              if (manager.principalId == managerPrincipalId) {
                managerBuffer.add(mergeTeamSelection(dto, manager, transfersAvailable, newBankBalance));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup5 := Buffer.toArray(managerBuffer);
          };
          case 5 {
            for (manager in Iter.fromArray(managerGroup6)) {
              if (manager.principalId == managerPrincipalId) {
                managerBuffer.add(mergeTeamSelection(dto, manager, transfersAvailable, newBankBalance));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup6 := Buffer.toArray(managerBuffer);
          };
          case 6 {
            for (manager in Iter.fromArray(managerGroup7)) {
              if (manager.principalId == managerPrincipalId) {
                managerBuffer.add(mergeTeamSelection(dto, manager, transfersAvailable, newBankBalance));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup7 := Buffer.toArray(managerBuffer);
          };
          case 7 {
            for (manager in Iter.fromArray(managerGroup8)) {
              if (manager.principalId == managerPrincipalId) {
                managerBuffer.add(mergeTeamSelection(dto, manager, transfersAvailable, newBankBalance));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup8 := Buffer.toArray(managerBuffer);
          };
          case 8 {
            for (manager in Iter.fromArray(managerGroup9)) {
              if (manager.principalId == managerPrincipalId) {
                managerBuffer.add(mergeTeamSelection(dto, manager, transfersAvailable, newBankBalance));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup9 := Buffer.toArray(managerBuffer);
          };
          case 9 {
            for (manager in Iter.fromArray(managerGroup10)) {
              if (manager.principalId == managerPrincipalId) {
                managerBuffer.add(mergeTeamSelection(dto, manager, transfersAvailable, newBankBalance));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup10 := Buffer.toArray(managerBuffer);
          };
          case 10 {
            for (manager in Iter.fromArray(managerGroup11)) {
              if (manager.principalId == managerPrincipalId) {
                managerBuffer.add(mergeTeamSelection(dto, manager, transfersAvailable, newBankBalance));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup11 := Buffer.toArray(managerBuffer);
          };
          case 11 {
            for (manager in Iter.fromArray(managerGroup12)) {
              if (manager.principalId == managerPrincipalId) {
                managerBuffer.add(mergeTeamSelection(dto, manager, transfersAvailable, newBankBalance));
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

  private func mergeTeamSelection(dto : Commands.SaveTeamDTO, manager : T.Manager, transfersAvailable : Nat8, newBankBalance : Nat16) : T.Manager {
    var updatedTransferWindowGameweek = manager.transferWindowGameweek;
    switch (dto.transferWindowGameweek) {
      case (?foundGameweek) {
        updatedTransferWindowGameweek := foundGameweek;
      };
      case (null) {};
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
      transferWindowGameweek = updatedTransferWindowGameweek;
      history = manager.history;
      profilePictureType = manager.profilePictureType;
      canisterId = manager.canisterId;
    };
  };

  public shared ({ caller }) func useBonus(dto : Commands.SaveBonusDTO, managerPrincipalId : Base.PrincipalId, transfersAvailable : Nat8, monthlyBonuses : Nat8, newBankBalance : Nat16) : async Result.Result<(), T.Error> {
    assert not Principal.isAnonymous(caller);
    let backendPrincipalId = Principal.toText(caller);
    assert backendPrincipalId == controllerPrincipalId;

    let managerBuffer = Buffer.fromArray<T.Manager>([]);
    let managerGroupIndex = managerGroupIndexes.get(managerPrincipalId);
    switch (managerGroupIndex) {
      case (null) {};
      case (?foundGroupIndex) {
        switch (foundGroupIndex) {
          case 0 {
            for (manager in Iter.fromArray(managerGroup1)) {
              if (manager.principalId == managerPrincipalId) {
                managerBuffer.add(mergeBonus(dto, manager, transfersAvailable, monthlyBonuses, newBankBalance));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup1 := Buffer.toArray(managerBuffer);
          };
          case 1 {
            for (manager in Iter.fromArray(managerGroup2)) {
              if (manager.principalId == managerPrincipalId) {
                managerBuffer.add(mergeBonus(dto, manager, transfersAvailable, monthlyBonuses, newBankBalance));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup2 := Buffer.toArray(managerBuffer);
          };
          case 2 {
            for (manager in Iter.fromArray(managerGroup3)) {
              if (manager.principalId == managerPrincipalId) {
                managerBuffer.add(mergeBonus(dto, manager, transfersAvailable, monthlyBonuses, newBankBalance));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup3 := Buffer.toArray(managerBuffer);
          };
          case 3 {
            for (manager in Iter.fromArray(managerGroup4)) {
              if (manager.principalId == managerPrincipalId) {
                managerBuffer.add(mergeBonus(dto, manager, transfersAvailable, monthlyBonuses, newBankBalance));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup4 := Buffer.toArray(managerBuffer);
          };
          case 4 {
            for (manager in Iter.fromArray(managerGroup5)) {
              if (manager.principalId == managerPrincipalId) {
                managerBuffer.add(mergeBonus(dto, manager, transfersAvailable, monthlyBonuses, newBankBalance));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup5 := Buffer.toArray(managerBuffer);
          };
          case 5 {
            for (manager in Iter.fromArray(managerGroup6)) {
              if (manager.principalId == managerPrincipalId) {
                managerBuffer.add(mergeBonus(dto, manager, transfersAvailable, monthlyBonuses, newBankBalance));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup6 := Buffer.toArray(managerBuffer);
          };
          case 6 {
            for (manager in Iter.fromArray(managerGroup7)) {
              if (manager.principalId == managerPrincipalId) {
                managerBuffer.add(mergeBonus(dto, manager, transfersAvailable, monthlyBonuses, newBankBalance));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup7 := Buffer.toArray(managerBuffer);
          };
          case 7 {
            for (manager in Iter.fromArray(managerGroup8)) {
              if (manager.principalId == managerPrincipalId) {
                managerBuffer.add(mergeBonus(dto, manager, transfersAvailable, monthlyBonuses, newBankBalance));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup8 := Buffer.toArray(managerBuffer);
          };
          case 8 {
            for (manager in Iter.fromArray(managerGroup9)) {
              if (manager.principalId == managerPrincipalId) {
                managerBuffer.add(mergeBonus(dto, manager, transfersAvailable, monthlyBonuses, newBankBalance));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup9 := Buffer.toArray(managerBuffer);
          };
          case 9 {
            for (manager in Iter.fromArray(managerGroup10)) {
              if (manager.principalId == managerPrincipalId) {
                managerBuffer.add(mergeBonus(dto, manager, transfersAvailable, monthlyBonuses, newBankBalance));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup10 := Buffer.toArray(managerBuffer);
          };
          case 10 {
            for (manager in Iter.fromArray(managerGroup11)) {
              if (manager.principalId == managerPrincipalId) {
                managerBuffer.add(mergeBonus(dto, manager, transfersAvailable, monthlyBonuses, newBankBalance));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup11 := Buffer.toArray(managerBuffer);
          };
          case 11 {
            for (manager in Iter.fromArray(managerGroup12)) {
              if (manager.principalId == managerPrincipalId) {
                managerBuffer.add(mergeBonus(dto, manager, transfersAvailable, monthlyBonuses, newBankBalance));
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

  private func mergeBonus(dto : Commands.SaveBonusDTO, manager : T.Manager, transfersAvailable : Nat8, monthlyBonusesAvailable : Nat8, newBankBalance : Nat16) : T.Manager {

    var updatedGoalGetterGameweek = PickTeamUtilities.valueOrDefaultGameweek(dto.goalGetterGameweek, manager.goalGetterGameweek);
    var updatedGoalGetterPlayerId = PickTeamUtilities.valueOrDefaultPlayerId(dto.goalGetterPlayerId, manager.goalGetterPlayerId);
    var updatedPassMasterGameweek = PickTeamUtilities.valueOrDefaultGameweek(dto.passMasterGameweek, manager.passMasterGameweek);
    var updatedPassMasterPlayerId = PickTeamUtilities.valueOrDefaultPlayerId(dto.passMasterPlayerId, manager.passMasterPlayerId);
    var updatedNoEntryGameweek = PickTeamUtilities.valueOrDefaultGameweek(dto.noEntryGameweek, manager.noEntryGameweek);
    var updatedNoEntryPlayerId = PickTeamUtilities.valueOrDefaultPlayerId(dto.noEntryPlayerId, manager.noEntryPlayerId);
    var updatedTeamBoostGameweek = PickTeamUtilities.valueOrDefaultGameweek(dto.teamBoostGameweek, manager.teamBoostGameweek);
    var updatedTeamBoostClubId = PickTeamUtilities.valueOrDefaultClubId(dto.teamBoostClubId, manager.teamBoostClubId);
    var updatedSafeHandsGameweek = PickTeamUtilities.valueOrDefaultGameweek(dto.safeHandsGameweek, manager.safeHandsGameweek);
    var updatedSafeHandsPlayerId = PickTeamUtilities.valueOrDefaultPlayerId(dto.safeHandsPlayerId, manager.safeHandsPlayerId);
    var updatedCaptainFantasticGameweek = PickTeamUtilities.valueOrDefaultGameweek(dto.captainFantasticGameweek, manager.captainFantasticGameweek);
    var updatedCaptainFantasticPlayerId = PickTeamUtilities.valueOrDefaultPlayerId(dto.captainFantasticPlayerId, manager.captainFantasticPlayerId);
    var updatedOneNationGameweek = PickTeamUtilities.valueOrDefaultGameweek(dto.oneNationGameweek, manager.oneNationGameweek);
    var updatedOneNationCountryId = PickTeamUtilities.valueOrDefaultCountryId(dto.oneNationCountryId, manager.oneNationCountryId);
    var updatedProspectsGameweek = PickTeamUtilities.valueOrDefaultGameweek(dto.prospectsGameweek, manager.prospectsGameweek);
    var updatedBraceBonusGameweek = PickTeamUtilities.valueOrDefaultGameweek(dto.braceBonusGameweek, manager.braceBonusGameweek);
    var updatedHatTrickHeroGameweek = PickTeamUtilities.valueOrDefaultGameweek(dto.hatTrickHeroGameweek, manager.hatTrickHeroGameweek);

    return {
      principalId = manager.principalId;
      username = manager.username;
      favouriteClubId = manager.favouriteClubId;
      createDate = manager.createDate;
      termsAccepted = manager.termsAccepted;
      profilePicture = manager.profilePicture;
      transfersAvailable = transfersAvailable;
      monthlyBonusesAvailable = monthlyBonusesAvailable;
      bankQuarterMillions = newBankBalance;
      playerIds = manager.playerIds;
      captainId = manager.captainId;
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
      transferWindowGameweek = manager.transferWindowGameweek;
      history = manager.history;
      profilePictureType = manager.profilePictureType;
      canisterId = manager.canisterId;
    };
  };

  public shared ({ caller }) func updateUsername(managerPrincipalId : Base.PrincipalId, dto : Commands.UpdateUsernameDTO) : async Result.Result<(), T.Error> {
    assert not Principal.isAnonymous(caller);
    let backendPrincipalId = Principal.toText(caller);
    assert backendPrincipalId == controllerPrincipalId;

    let managerBuffer = Buffer.fromArray<T.Manager>([]);
    let managerGroupIndex = managerGroupIndexes.get(managerPrincipalId);
    switch (managerGroupIndex) {
      case (null) {};
      case (?foundGroupIndex) {
        switch (foundGroupIndex) {
          case 0 {
            for (manager in Iter.fromArray(managerGroup1)) {
              if (manager.principalId == managerPrincipalId) {
                managerBuffer.add(mergeManagerUsername(manager, dto.username));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup1 := Buffer.toArray(managerBuffer);
          };
          case 1 {
            for (manager in Iter.fromArray(managerGroup2)) {
              if (manager.principalId == managerPrincipalId) {
                managerBuffer.add(mergeManagerUsername(manager, dto.username));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup2 := Buffer.toArray(managerBuffer);
          };
          case 2 {
            for (manager in Iter.fromArray(managerGroup3)) {
              if (manager.principalId == managerPrincipalId) {
                managerBuffer.add(mergeManagerUsername(manager, dto.username));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup3 := Buffer.toArray(managerBuffer);
          };
          case 3 {
            for (manager in Iter.fromArray(managerGroup4)) {
              if (manager.principalId == managerPrincipalId) {
                managerBuffer.add(mergeManagerUsername(manager, dto.username));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup4 := Buffer.toArray(managerBuffer);
          };
          case 4 {
            for (manager in Iter.fromArray(managerGroup5)) {
              if (manager.principalId == managerPrincipalId) {
                managerBuffer.add(mergeManagerUsername(manager, dto.username));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup5 := Buffer.toArray(managerBuffer);
          };
          case 5 {
            for (manager in Iter.fromArray(managerGroup6)) {
              if (manager.principalId == managerPrincipalId) {
                managerBuffer.add(mergeManagerUsername(manager, dto.username));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup6 := Buffer.toArray(managerBuffer);
          };
          case 6 {
            for (manager in Iter.fromArray(managerGroup7)) {
              if (manager.principalId == managerPrincipalId) {
                managerBuffer.add(mergeManagerUsername(manager, dto.username));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup7 := Buffer.toArray(managerBuffer);
          };
          case 7 {
            for (manager in Iter.fromArray(managerGroup8)) {
              if (manager.principalId == managerPrincipalId) {
                managerBuffer.add(mergeManagerUsername(manager, dto.username));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup8 := Buffer.toArray(managerBuffer);
          };
          case 8 {
            for (manager in Iter.fromArray(managerGroup9)) {
              if (manager.principalId == managerPrincipalId) {
                managerBuffer.add(mergeManagerUsername(manager, dto.username));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup9 := Buffer.toArray(managerBuffer);
          };
          case 9 {
            for (manager in Iter.fromArray(managerGroup10)) {
              if (manager.principalId == managerPrincipalId) {
                managerBuffer.add(mergeManagerUsername(manager, dto.username));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup10 := Buffer.toArray(managerBuffer);
          };
          case 10 {
            for (manager in Iter.fromArray(managerGroup11)) {
              if (manager.principalId == managerPrincipalId) {
                managerBuffer.add(mergeManagerUsername(manager, dto.username));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup11 := Buffer.toArray(managerBuffer);
          };
          case 11 {
            for (manager in Iter.fromArray(managerGroup12)) {
              if (manager.principalId == managerPrincipalId) {
                managerBuffer.add(mergeManagerUsername(manager, dto.username));
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

  private func mergeManagerUsername(manager : T.Manager, username : Text) : T.Manager {
    return {
      principalId = manager.principalId;
      username = username;
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
      history = manager.history;
      profilePicture = manager.profilePicture;
      profilePictureType = manager.profilePictureType;
      canisterId = manager.canisterId;
    };
  };

  public shared ({ caller }) func updateProfilePicture(managerPrincipalId : Base.PrincipalId, dto : Commands.UpdateProfilePictureDTO) : async Result.Result<(), T.Error> {
    assert not Principal.isAnonymous(caller);
    let backendPrincipalId = Principal.toText(caller);
    assert backendPrincipalId == controllerPrincipalId;

    let managerBuffer = Buffer.fromArray<T.Manager>([]);
    let managerGroupIndex = managerGroupIndexes.get(managerPrincipalId);
    switch (managerGroupIndex) {
      case (null) {};
      case (?foundGroupIndex) {
        switch (foundGroupIndex) {
          case 0 {
            for (manager in Iter.fromArray(managerGroup1)) {
              if (manager.principalId == managerPrincipalId) {
                managerBuffer.add(mergeManagerProfilePicture(manager, dto.profilePicture, dto.extension));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup1 := Buffer.toArray(managerBuffer);
          };
          case 1 {
            for (manager in Iter.fromArray(managerGroup2)) {
              if (manager.principalId == managerPrincipalId) {
                managerBuffer.add(mergeManagerProfilePicture(manager, dto.profilePicture, dto.extension));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup2 := Buffer.toArray(managerBuffer);
          };
          case 2 {
            for (manager in Iter.fromArray(managerGroup3)) {
              if (manager.principalId == managerPrincipalId) {
                managerBuffer.add(mergeManagerProfilePicture(manager, dto.profilePicture, dto.extension));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup3 := Buffer.toArray(managerBuffer);
          };
          case 3 {
            for (manager in Iter.fromArray(managerGroup4)) {
              if (manager.principalId == managerPrincipalId) {
                managerBuffer.add(mergeManagerProfilePicture(manager, dto.profilePicture, dto.extension));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup4 := Buffer.toArray(managerBuffer);
          };
          case 4 {
            for (manager in Iter.fromArray(managerGroup5)) {
              if (manager.principalId == managerPrincipalId) {
                managerBuffer.add(mergeManagerProfilePicture(manager, dto.profilePicture, dto.extension));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup5 := Buffer.toArray(managerBuffer);
          };
          case 5 {
            for (manager in Iter.fromArray(managerGroup6)) {
              if (manager.principalId == managerPrincipalId) {
                managerBuffer.add(mergeManagerProfilePicture(manager, dto.profilePicture, dto.extension));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup6 := Buffer.toArray(managerBuffer);
          };
          case 6 {
            for (manager in Iter.fromArray(managerGroup7)) {
              if (manager.principalId == managerPrincipalId) {
                managerBuffer.add(mergeManagerProfilePicture(manager, dto.profilePicture, dto.extension));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup7 := Buffer.toArray(managerBuffer);
          };
          case 7 {
            for (manager in Iter.fromArray(managerGroup8)) {
              if (manager.principalId == managerPrincipalId) {
                managerBuffer.add(mergeManagerProfilePicture(manager, dto.profilePicture, dto.extension));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup8 := Buffer.toArray(managerBuffer);
          };
          case 8 {
            for (manager in Iter.fromArray(managerGroup9)) {
              if (manager.principalId == managerPrincipalId) {
                managerBuffer.add(mergeManagerProfilePicture(manager, dto.profilePicture, dto.extension));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup9 := Buffer.toArray(managerBuffer);
          };
          case 9 {
            for (manager in Iter.fromArray(managerGroup10)) {
              if (manager.principalId == managerPrincipalId) {
                managerBuffer.add(mergeManagerProfilePicture(manager, dto.profilePicture, dto.extension));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup10 := Buffer.toArray(managerBuffer);
          };
          case 10 {
            for (manager in Iter.fromArray(managerGroup11)) {
              if (manager.principalId == managerPrincipalId) {
                managerBuffer.add(mergeManagerProfilePicture(manager, dto.profilePicture, dto.extension));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup11 := Buffer.toArray(managerBuffer);
          };
          case 11 {
            for (manager in Iter.fromArray(managerGroup12)) {
              if (manager.principalId == managerPrincipalId) {
                managerBuffer.add(mergeManagerProfilePicture(manager, dto.profilePicture, dto.extension));
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

  private func mergeManagerProfilePicture(manager : T.Manager, profilePicture : Blob, extension : Text) : T.Manager {
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
      history = manager.history;
      profilePicture = ?profilePicture;
      profilePictureType = extension;
      canisterId = manager.canisterId;
    };
  };

  public shared ({ caller }) func updateFavouriteClub(managerPrincipalId : Base.PrincipalId, dto : Commands.UpdateFavouriteClubDTO) : async Result.Result<(), T.Error> {
    assert not Principal.isAnonymous(caller);
    let backendPrincipalId = Principal.toText(caller);
    assert backendPrincipalId == controllerPrincipalId;

    let managerBuffer = Buffer.fromArray<T.Manager>([]);
    let managerGroupIndex = managerGroupIndexes.get(managerPrincipalId);
    switch (managerGroupIndex) {
      case (null) {};
      case (?foundGroupIndex) {
        switch (foundGroupIndex) {
          case 0 {
            for (manager in Iter.fromArray(managerGroup1)) {
              if (manager.principalId == managerPrincipalId) {
                managerBuffer.add(mergeManagerFavouriteClub(manager, dto.favouriteClubId));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup1 := Buffer.toArray(managerBuffer);
          };
          case 1 {
            for (manager in Iter.fromArray(managerGroup2)) {
              if (manager.principalId == managerPrincipalId) {
                managerBuffer.add(mergeManagerFavouriteClub(manager, dto.favouriteClubId));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup2 := Buffer.toArray(managerBuffer);
          };
          case 2 {
            for (manager in Iter.fromArray(managerGroup3)) {
              if (manager.principalId == managerPrincipalId) {
                managerBuffer.add(mergeManagerFavouriteClub(manager, dto.favouriteClubId));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup3 := Buffer.toArray(managerBuffer);
          };
          case 3 {
            for (manager in Iter.fromArray(managerGroup4)) {
              if (manager.principalId == managerPrincipalId) {
                managerBuffer.add(mergeManagerFavouriteClub(manager, dto.favouriteClubId));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup4 := Buffer.toArray(managerBuffer);
          };
          case 4 {
            for (manager in Iter.fromArray(managerGroup5)) {
              if (manager.principalId == managerPrincipalId) {
                managerBuffer.add(mergeManagerFavouriteClub(manager, dto.favouriteClubId));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup5 := Buffer.toArray(managerBuffer);
          };
          case 5 {
            for (manager in Iter.fromArray(managerGroup6)) {
              if (manager.principalId == managerPrincipalId) {
                managerBuffer.add(mergeManagerFavouriteClub(manager, dto.favouriteClubId));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup6 := Buffer.toArray(managerBuffer);
          };
          case 6 {
            for (manager in Iter.fromArray(managerGroup7)) {
              if (manager.principalId == managerPrincipalId) {
                managerBuffer.add(mergeManagerFavouriteClub(manager, dto.favouriteClubId));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup7 := Buffer.toArray(managerBuffer);
          };
          case 7 {
            for (manager in Iter.fromArray(managerGroup8)) {
              if (manager.principalId == managerPrincipalId) {
                managerBuffer.add(mergeManagerFavouriteClub(manager, dto.favouriteClubId));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup8 := Buffer.toArray(managerBuffer);
          };
          case 8 {
            for (manager in Iter.fromArray(managerGroup9)) {
              if (manager.principalId == managerPrincipalId) {
                managerBuffer.add(mergeManagerFavouriteClub(manager, dto.favouriteClubId));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup9 := Buffer.toArray(managerBuffer);
          };
          case 9 {
            for (manager in Iter.fromArray(managerGroup10)) {
              if (manager.principalId == managerPrincipalId) {
                managerBuffer.add(mergeManagerFavouriteClub(manager, dto.favouriteClubId));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup10 := Buffer.toArray(managerBuffer);
          };
          case 10 {
            for (manager in Iter.fromArray(managerGroup11)) {
              if (manager.principalId == managerPrincipalId) {
                managerBuffer.add(mergeManagerFavouriteClub(manager, dto.favouriteClubId));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup11 := Buffer.toArray(managerBuffer);
          };
          case 11 {
            for (manager in Iter.fromArray(managerGroup12)) {
              if (manager.principalId == managerPrincipalId) {
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

  private func mergeManagerFavouriteClub(manager : T.Manager, favouriteClubId : FootballTypes.ClubId) : T.Manager {
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

  public shared ({ caller }) func getManager(managerPrincipal : Text) : async ?T.Manager {
    assert not Principal.isAnonymous(caller);
    let backendPrincipalId = Principal.toText(caller);
    assert backendPrincipalId == controllerPrincipalId;

    let managerGroupIndex = managerGroupIndexes.get(managerPrincipal);
    switch (managerGroupIndex) {
      case (null) {
        return null;
      };
      case (?foundIndex) {
        switch (foundIndex) {
          case (0) {
            for (manager in Iter.fromArray<T.Manager>(managerGroup1)) {
              if (manager.principalId == managerPrincipal) {
                return ?manager;
              };
            };
          };
          case (1) {
            for (manager in Iter.fromArray<T.Manager>(managerGroup2)) {
              if (manager.principalId == managerPrincipal) {
                return ?manager;
              };
            };
          };
          case (2) {
            for (manager in Iter.fromArray<T.Manager>(managerGroup3)) {
              if (manager.principalId == managerPrincipal) {
                return ?manager;
              };
            };
          };
          case (3) {
            for (manager in Iter.fromArray<T.Manager>(managerGroup4)) {
              if (manager.principalId == managerPrincipal) {
                return ?manager;
              };
            };
          };
          case (4) {
            for (manager in Iter.fromArray<T.Manager>(managerGroup5)) {
              if (manager.principalId == managerPrincipal) {
                return ?manager;
              };
            };
          };
          case (5) {
            for (manager in Iter.fromArray<T.Manager>(managerGroup6)) {
              if (manager.principalId == managerPrincipal) {
                return ?manager;
              };
            };
          };
          case (6) {
            for (manager in Iter.fromArray<T.Manager>(managerGroup7)) {
              if (manager.principalId == managerPrincipal) {
                return ?manager;
              };
            };
          };
          case (7) {
            for (manager in Iter.fromArray<T.Manager>(managerGroup8)) {
              if (manager.principalId == managerPrincipal) {
                return ?manager;
              };
            };
          };
          case (8) {
            for (manager in Iter.fromArray<T.Manager>(managerGroup9)) {
              if (manager.principalId == managerPrincipal) {
                return ?manager;
              };
            };
          };
          case (9) {
            for (manager in Iter.fromArray<T.Manager>(managerGroup10)) {
              if (manager.principalId == managerPrincipal) {
                return ?manager;
              };
            };
          };
          case (10) {
            for (manager in Iter.fromArray<T.Manager>(managerGroup11)) {
              if (manager.principalId == managerPrincipal) {
                return ?manager;
              };
            };
          };
          case (11) {
            for (manager in Iter.fromArray<T.Manager>(managerGroup12)) {
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

  public shared ({ caller }) func getManagersWithPlayer(playerId : FootballTypes.PlayerId) : async [Base.PrincipalId] {
    assert not Principal.isAnonymous(caller);
    let backendPrincipalId = Principal.toText(caller);
    assert backendPrincipalId == controllerPrincipalId;

    let allManagersBuffer = Buffer.fromArray<Base.PrincipalId>([]);
    for (index in Iter.range(0, 11)) {
      switch (index) {
        case 0 {
          for (manager in Iter.fromArray(managerGroup1)) {
            let isPlayerInTeam = Array.find(
              manager.playerIds,
              func(pId : FootballTypes.PlayerId) : Bool {
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
              func(pId : FootballTypes.PlayerId) : Bool {
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
              func(pId : FootballTypes.PlayerId) : Bool {
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
              func(pId : FootballTypes.PlayerId) : Bool {
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
              func(pId : FootballTypes.PlayerId) : Bool {
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
              func(pId : FootballTypes.PlayerId) : Bool {
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
              func(pId : FootballTypes.PlayerId) : Bool {
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
              func(pId : FootballTypes.PlayerId) : Bool {
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
              func(pId : FootballTypes.PlayerId) : Bool {
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
              func(pId : FootballTypes.PlayerId) : Bool {
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
              func(pId : FootballTypes.PlayerId) : Bool {
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
              func(pId : FootballTypes.PlayerId) : Bool {
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

  public shared ({ caller }) func getFantasyTeamSnapshot(managerPrincipalId : Base.PrincipalId, dto : Queries.GetManagerGameweekDTO) : async ?T.FantasyTeamSnapshot {
    assert not Principal.isAnonymous(caller);
    let backendPrincipalId = Principal.toText(caller);
    assert backendPrincipalId == controllerPrincipalId;

    let managerGroupIndex = managerGroupIndexes.get(dto.principalId);

    var managers : [T.Manager] = [];

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
          if (manager.principalId == managerPrincipalId) {
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

  public shared ({ caller }) func getOrderedSnapshots(seasonId : FootballTypes.SeasonId, gameweek : FootballTypes.GameweekNumber) : async [T.FantasyTeamSnapshot] {

    assert not Principal.isAnonymous(caller);
    let backendPrincipalId = Principal.toText(caller);
    assert backendPrincipalId == controllerPrincipalId;

    let allManagersBuffer = Buffer.fromArray<T.FantasyTeamSnapshot>([]);
    for (index in Iter.range(0, 11)) {

      var managers : [T.Manager] = [];
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
        let currentSeason = List.find<T.FantasyTeamSeason>(
          manager.history,
          func(season : T.FantasyTeamSeason) : Bool {
            return season.seasonId == seasonId;
          },
        );
        switch (currentSeason) {
          case (null) {};
          case (?foundSeason) {
            let foundSnapshot = List.find<T.FantasyTeamSnapshot>(
              foundSeason.gameweeks,
              func(foundGameweek : T.FantasyTeamSnapshot) : Bool {
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
      func(a : T.FantasyTeamSnapshot, b : T.FantasyTeamSnapshot) : Order.Order {
        if (a.points < b.points) { return #greater };
        if (a.points == b.points) { return #equal };
        return #less;
      },
    );

    return sortedManagerSnapshots;
  };

  public shared ({ caller }) func addNewManager(newManager : T.Manager) : async Result.Result<(), T.Error> {
    assert not Principal.isAnonymous(caller);
    let backendPrincipalId = Principal.toText(caller);
    assert backendPrincipalId == controllerPrincipalId;

    var managerBuffer = Buffer.fromArray<T.Manager>([]);
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
    assert backendPrincipalId == controllerPrincipalId;
    return totalManagers;
  };

  public shared ({ caller }) func getClubManagers(clubId : FootballTypes.ClubId) : async [Base.PrincipalId] {
    assert not Principal.isAnonymous(caller);
    let backendPrincipalId = Principal.toText(caller);
    assert backendPrincipalId == controllerPrincipalId;

    let clubManagerIdBuffer = Buffer.fromArray<Base.PrincipalId>([]);

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

  private func getGroupClubManagerIds(managers : [T.Manager], clubId : FootballTypes.ClubId) : [Base.PrincipalId] {
    let managerIdBuffer = Buffer.fromArray<Base.PrincipalId>([]);
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

  public shared ({ caller }) func snapshotFantasyTeams(seasonId : FootballTypes.SeasonId, gameweek : FootballTypes.GameweekNumber, month : Base.CalendarMonth) : async () {
    assert not Principal.isAnonymous(caller);
    let backendPrincipalId = Principal.toText(caller);
    assert backendPrincipalId == controllerPrincipalId;

    for (index in Iter.range(0, 11)) {
      await snapshotManagers(index, seasonId, gameweek, month);
    };
  };

  private func snapshotManagers(managerGroup : Int, seasonId : FootballTypes.SeasonId, gameweek : FootballTypes.GameweekNumber, month : Base.CalendarMonth) : async () {

    let backend_canister = actor (controllerPrincipalId) : actor {
      getPlayersSnapshot : shared query (dto : Queries.GetSnapshotPlayersDTO) -> async [DTOs.PlayerDTO];
    };

    let players = await backend_canister.getPlayersSnapshot({
      gameweek;
      seasonId;
    });

    let managerBuffer = Buffer.fromArray<T.Manager>([]);

    var managers : [T.Manager] = [];

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

            let managerPlayers = Array.filter<DTOs.PlayerDTO>(
              players,
              func(player) {
                Option.isSome(
                  Array.find<FootballTypes.PlayerId>(
                    manager.playerIds,
                    func(playerId) : Bool {
                      playerId == player.id;
                    },
                  )
                );
              },
            );

            let allPlayerValues = Array.map<DTOs.PlayerDTO, Nat16>(managerPlayers, func(player : DTOs.PlayerDTO) : Nat16 { return player.valueQuarterMillions });
            let totalTeamValue = Array.foldLeft<Nat16, Nat16>(allPlayerValues, 0, func(sumSoFar, x) = sumSoFar + x);

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

      let updatedSeasonsBuffer = Buffer.fromArray<T.FantasyTeamSeason>(List.toArray(updatedSeasons));

      if (not seasonFound) {

        let managerPlayers = Array.filter<DTOs.PlayerDTO>(
          players,
          func(player) {
            Option.isSome(
              Array.find<FootballTypes.PlayerId>(
                manager.playerIds,
                func(playerId) : Bool {
                  playerId == player.id;
                },
              )
            );
          },
        );

        let allPlayerValues = Array.map<DTOs.PlayerDTO, Nat16>(managerPlayers, func(player : DTOs.PlayerDTO) : Nat16 { return player.valueQuarterMillions });
        let totalTeamValue = Array.foldLeft<Nat16, Nat16>(allPlayerValues, 0, func(sumSoFar, x) = sumSoFar + x);

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

      let updatedManager : T.Manager = {

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
  };

  private func updateSnapshotPoints(principalId : Text, seasonId : Nat16, gameweek : FootballTypes.GameweekNumber, month : Base.CalendarMonth, teamPoints : Int16, teamValueQuarterMillions : Nat16) : () {

    let managerBuffer = Buffer.fromArray<T.Manager>([]);
    let managerGroupIndex = managerGroupIndexes.get(principalId);

    var managers : [T.Manager] = [];

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
            let teamHistoryBuffer = Buffer.fromArray<T.FantasyTeamSeason>([]);

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

  private func mergeManagerSnapshot(manager : T.Manager, seasonId : FootballTypes.SeasonId, gameweek : FootballTypes.GameweekNumber, month : Base.CalendarMonth, weeklyPoints : Int16, monthlyPoints : Int16, seasonPoints : Int16, teamValueQuarterMillions : Nat16) : T.FantasyTeamSnapshot {

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
      profilePicture = manager.profilePicture;
      gameweek = gameweek;
      points = weeklyPoints;
      monthlyPoints = monthlyPoints;
      seasonPoints = seasonPoints;
      teamValueQuarterMillions = teamValueQuarterMillions;
      month = month;
      seasonId = seasonId;
    };
  };

  private func mergeManagerHistory(manager : T.Manager, history : List.List<T.FantasyTeamSeason>) : T.Manager {
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

  private func mergeExistingHistory(existingHistory : List.List<T.FantasyTeamSeason>, fantasyTeamSnapshot : T.FantasyTeamSnapshot, seasonId : FootballTypes.SeasonId, gameweek : FootballTypes.GameweekNumber) : List.List<T.FantasyTeamSeason> {

    let teamHistoryBuffer = Buffer.fromArray<T.FantasyTeamSeason>([]);

    for (season in List.toIter<T.FantasyTeamSeason>(existingHistory)) {
      if (season.seasonId == seasonId) {
        let snapshotBuffer = Buffer.fromArray<T.FantasyTeamSnapshot>([]);

        for (snapshot in List.toIter<T.FantasyTeamSnapshot>(season.gameweeks)) {
          if (snapshot.gameweek != gameweek) {
            snapshotBuffer.add(snapshot);
          };
        };

        snapshotBuffer.add(fantasyTeamSnapshot);

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

    return List.fromArray(Buffer.toArray(teamHistoryBuffer));
  };

  //Calculate teams scores

  public shared ({ caller }) func calculateFantasyTeamScores(leagueId : FootballTypes.LeagueId, seasonId : FootballTypes.SeasonId, gameweek : FootballTypes.GameweekNumber, month : Base.CalendarMonth) : async () {
    assert not Principal.isAnonymous(caller);
    let backendPrincipalId = Principal.toText(caller);
    assert backendPrincipalId == controllerPrincipalId;

    let backend_canister = actor (controllerPrincipalId) : actor {
      getPlayersMap : (dto : Queries.GetPlayersMapDTO) -> async Result.Result<[(Nat16, DTOs.PlayerScoreDTO)], T.Error>;
      getPlayersSnapshot : shared query (dto : Queries.GetSnapshotPlayersDTO) -> async [DTOs.PlayerDTO];
    };

    let allPlayersListResult = await backend_canister.getPlayersMap({
      seasonId;
      gameweek;
    });

    let allPlayers : [DTOs.PlayerDTO] = await backend_canister.getPlayersSnapshot({
      gameweek;
      leagueId;
      seasonId;
    });

    let playerIdTrie : TrieMap.TrieMap<FootballTypes.PlayerId, DTOs.PlayerScoreDTO> = TrieMap.TrieMap<FootballTypes.PlayerId, DTOs.PlayerScoreDTO>(ComparisonUtilities.eqNat16, ComparisonUtilities.hashNat16);

    switch (allPlayersListResult) {
      case (#ok allPlayersList) {

        for (player in Iter.fromArray(allPlayersList)) {
          playerIdTrie.put(player.0, player.1);
        };

        for (index in Iter.range(0, 11)) {
          var managers : [T.Manager] = [];
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
                    let fantasyTeamPlayersBuffer = Buffer.fromArray<DTOs.PlayerDTO>([]);
                    for (playerId in Iter.fromArray(foundSnapshot.playerIds)) {
                      let playerData = playerIdTrie.get(playerId);
                      switch (playerData) {
                        case (null) {};
                        case (?player) {

                          let playerDTO = Array.find(
                            allPlayers,
                            func(foundPlayerDTO : DTOs.PlayerDTO) : Bool {
                              foundPlayerDTO.id == player.id;
                            },
                          );
                          switch (playerDTO) {
                            case (?foundPlayerDTO) {
                              fantasyTeamPlayersBuffer.add(foundPlayerDTO);
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

                    let thisTeamsPlayers : [DTOs.PlayerDTO] = Buffer.toArray(fantasyTeamPlayersBuffer);
                    let allPlayerValues = Array.map<DTOs.PlayerDTO, Nat16>(thisTeamsPlayers, func(player : DTOs.PlayerDTO) : Nat16 { return player.valueQuarterMillions });

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
  };

  private func calculateGoalPoints(position : FootballTypes.PlayerPosition, goalsScored : Int16) : Int16 {
    switch (position) {
      case (#Goalkeeper) { return 40 * goalsScored };
      case (#Defender) { return 40 * goalsScored };
      case (#Midfielder) { return 30 * goalsScored };
      case (#Forward) { return 20 * goalsScored };
    };
  };

  private func calculateAssistPoints(position : FootballTypes.PlayerPosition, assists : Int16) : Int16 {
    switch (position) {
      case (#Goalkeeper) { return 30 * assists };
      case (#Defender) { return 30 * assists };
      case (#Midfielder) { return 20 * assists };
      case (#Forward) { return 20 * assists };
    };
  };

  //Remove player from teams

  public shared ({ caller }) func removePlayerFromTeams(leagueId : FootballTypes.LeagueId, playerId : FootballTypes.PlayerId, parentCanisterId : Base.CanisterId) : async () {
    assert not Principal.isAnonymous(caller);
    let backendPrincipalId = Principal.toText(caller);
    assert backendPrincipalId == controllerPrincipalId;
    for (index in Iter.range(0, 11)) {
      await removePlayerFromGroup(leagueId, playerId, index, parentCanisterId);
    };
  };

  private func removePlayerFromGroup(leagueId : FootballTypes.LeagueId, removePlayerId : FootballTypes.PlayerId, managerGroup : Int, parentCanisterId : Base.CanisterId) : async () {
    let backend_canister = actor (parentCanisterId) : actor {
      getVerifiedPlayers : (leagueId : FootballTypes.LeagueId) -> async Result.Result<[DTOs.PlayerDTO], T.Error>;
    };

    let allPlayersResult = await backend_canister.getVerifiedPlayers(leagueId);
    switch (allPlayersResult) {
      case (#ok allPlayers) {
        let removedPlayer = Array.find<DTOs.PlayerDTO>(allPlayers, func(p) { p.id == removePlayerId });

        switch (removedPlayer) {
          case (null) {
            //removeMissingPlayer(playerId); TODO NEED TO FIX
          };
          case (?foundRemovedPlayer) {
            let playerValue = foundRemovedPlayer.valueQuarterMillions;
            let managerBuffer = Buffer.fromArray<T.Manager>([]);

            var managers : [T.Manager] = [];

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
              let playerIdBuffer = Buffer.fromArray<FootballTypes.PlayerId>([]);
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
                  let highestValuedPlayer = Array.foldLeft<FootballTypes.PlayerId, ?DTOs.PlayerDTO>(
                    manager.playerIds,
                    null,
                    func(highest, id) : ?DTOs.PlayerDTO {
                      if (id == removePlayerId or id == 0) { return highest };
                      let player = Array.find<DTOs.PlayerDTO>(allPlayers, func(p) { p.id == id });
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
                let newManager : T.Manager = {
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
  };

  //Team reset callback functions

  public shared ({ caller }) func resetBonusesAvailable() : async () {
    assert not Principal.isAnonymous(caller);
    let backendPrincipalId = Principal.toText(caller);
    assert backendPrincipalId == controllerPrincipalId;

    for (index in Iter.range(0, 11)) {
      var managers : [T.Manager] = [];

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

      let managerBuffer = Buffer.fromArray<T.Manager>([]);
      for (manager in Iter.fromArray(managers)) {

        let updatedManager : T.Manager = {
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
    assert backendPrincipalId == controllerPrincipalId;

    for (index in Iter.range(0, 11)) {
      var managers : [T.Manager] = [];
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

      let managerBuffer = Buffer.fromArray<T.Manager>([]);
      for (manager in Iter.fromArray(managers)) {
        let updatedManager : T.Manager = {
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
    assert backendPrincipalId == controllerPrincipalId;

    managerGroup1 := Array.map<T.Manager, T.Manager>(
      managerGroup1,
      func(manager : T.Manager) {
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

    managerGroup2 := Array.map<T.Manager, T.Manager>(
      managerGroup2,
      func(manager : T.Manager) {
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

    managerGroup3 := Array.map<T.Manager, T.Manager>(
      managerGroup3,
      func(manager : T.Manager) {
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

    managerGroup4 := Array.map<T.Manager, T.Manager>(
      managerGroup4,
      func(manager : T.Manager) {
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

    managerGroup5 := Array.map<T.Manager, T.Manager>(
      managerGroup5,
      func(manager : T.Manager) {
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

    managerGroup6 := Array.map<T.Manager, T.Manager>(
      managerGroup6,
      func(manager : T.Manager) {
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

    managerGroup7 := Array.map<T.Manager, T.Manager>(
      managerGroup7,
      func(manager : T.Manager) {
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

    managerGroup8 := Array.map<T.Manager, T.Manager>(
      managerGroup8,
      func(manager : T.Manager) {
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

    managerGroup9 := Array.map<T.Manager, T.Manager>(
      managerGroup9,
      func(manager : T.Manager) {
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

    managerGroup10 := Array.map<T.Manager, T.Manager>(
      managerGroup10,
      func(manager : T.Manager) {
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

    managerGroup11 := Array.map<T.Manager, T.Manager>(
      managerGroup11,
      func(manager : T.Manager) {
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

    managerGroup12 := Array.map<T.Manager, T.Manager>(
      managerGroup12,
      func(manager : T.Manager) {
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
    for (index in Iter.fromArray(stable_manager_group_indexes)) {
      managerGroupIndexes.put(index.0, index.1);
    };
    switch (cyclesCheckTimerId) {
      case (null) {};
      case (?id) {
        Timer.cancelTimer(id);
        cyclesCheckTimerId := null;
      };
    };
    ignore Timer.setTimer<system>(#nanoseconds(Int.abs(1)), postUpgradeCallback);
  };

  private func postUpgradeCallback() : async () {
    //await systemReset();
  };
/*
    public func systemReset() : async (){

      for (managerGroup in Iter.range(0, 11)) {

        let managerBuffer = Buffer.fromArray<T.Manager>([]);

        var managers : [T.Manager] = [];

        let seasonId: FootballTypes.SeasonId = 1;

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

          let updatedManager : T.Manager = {

            principalId = manager.principalId;
            username = manager.username;
            termsAccepted = manager.termsAccepted;
            favouriteClubId = manager.favouriteClubId;
            createDate = manager.createDate;
            transfersAvailable = 3;
            monthlyBonusesAvailable = 2;
            bankQuarterMillions = 1400;
            playerIds = [0,0,0,0,0,0,0,0,0,0,0];
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
            history = manager.history;
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
      };
    }
    */

};

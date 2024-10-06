import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import Cycles "mo:base/ExperimentalCycles";
import Iter "mo:base/Iter";
import List "mo:base/List";
import Nat8 "mo:base/Nat8";
import Option "mo:base/Option";
import Order "mo:base/Order";
import Principal "mo:base/Principal";
import Result "mo:base/Result";
import Text "mo:base/Text";
import Timer "mo:base/Timer";
import TrieMap "mo:base/TrieMap";
import Nat "mo:base/Nat";
import Debug "mo:base/Debug";
import Int16 "mo:base/Int16";
import Nat16 "mo:base/Nat16";
import Environment "../network_environment_variables";

import DTOs "../../shared/DTOs";
import T "../../shared/types";
import Utilities "../../shared/utils/utilities";

actor class _ManagerCanister() {

  private var managerGroupIndexes : TrieMap.TrieMap<T.PrincipalId, Nat8> = TrieMap.TrieMap<T.PrincipalId, Nat8>(Text.equal, Text.hash);

  private stable var stable_manager_group_indexes : [(T.PrincipalId, Nat8)] = [];
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
  private stable let cyclesCheckInterval : Nat = Utilities.getHour() * 24;
  private stable var cyclesCheckTimerId : ?Timer.TimerId = null;
  private stable var activeGroupIndex : Nat8 = 0;
  private stable var totalManagers = 0;

  private stable var playersSnapshots: [(T.SeasonId, [(T.GameweekNumber, [T.Player])])] = [];

  private stable var initialised = false;
  private stable var controllerPrincipalId = "";
  private stable var fixturesPerClub: Nat8 = 0;

  public shared ({caller}) func initialise(_controllerPrincipalId: Text, _fixturesPerClub: Nat8) : async (){
    if(initialised){
      return;
    };

    let callerInArray = Array.find<T.CanisterId>([Environment.OPENFPL_BACKEND_CANISTER_ID, Environment.OPENWSL_BACKEND_CANISTER_ID], func(canisterId: T.CanisterId) : Bool{
      canisterId == Principal.toText(caller);
    });

    if(Option.isSome(callerInArray)){
      controllerPrincipalId := _controllerPrincipalId;
      fixturesPerClub := _fixturesPerClub;
    };

  };

  public shared ({ caller }) func updateTeamSelection(teamUpdateDTO : DTOs.TeamUpdateDTO, transfersAvailable : Nat8, monthlyBonuses : Nat8, newBankBalance : Nat16) : async Result.Result<(), T.Error> {
    assert not Principal.isAnonymous(caller);
    let backendPrincipalId = Principal.toText(caller);
    assert backendPrincipalId == controllerPrincipalId;

    let managerBuffer = Buffer.fromArray<T.Manager>([]);
    let managerGroupIndex = managerGroupIndexes.get(teamUpdateDTO.principalId);
    switch (managerGroupIndex) {
      case (null) {};
      case (?foundGroupIndex) {
        switch (foundGroupIndex) {
          case 0 {
            for (manager in Iter.fromArray(managerGroup1)) {
              if (manager.principalId == teamUpdateDTO.principalId) {
                managerBuffer.add(mergeTeamSelection(teamUpdateDTO.updatedTeamSelection, manager, transfersAvailable, monthlyBonuses, newBankBalance));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup1 := Buffer.toArray(managerBuffer);
          };
          case 1 {
            for (manager in Iter.fromArray(managerGroup2)) {
              if (manager.principalId == teamUpdateDTO.principalId) {
                managerBuffer.add(mergeTeamSelection(teamUpdateDTO.updatedTeamSelection, manager, transfersAvailable, monthlyBonuses, newBankBalance));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup2 := Buffer.toArray(managerBuffer);
          };
          case 2 {
            for (manager in Iter.fromArray(managerGroup3)) {
              if (manager.principalId == teamUpdateDTO.principalId) {
                managerBuffer.add(mergeTeamSelection(teamUpdateDTO.updatedTeamSelection, manager, transfersAvailable, monthlyBonuses, newBankBalance));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup3 := Buffer.toArray(managerBuffer);
          };
          case 3 {
            for (manager in Iter.fromArray(managerGroup4)) {
              if (manager.principalId == teamUpdateDTO.principalId) {
                managerBuffer.add(mergeTeamSelection(teamUpdateDTO.updatedTeamSelection, manager, transfersAvailable, monthlyBonuses, newBankBalance));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup4 := Buffer.toArray(managerBuffer);
          };
          case 4 {
            for (manager in Iter.fromArray(managerGroup5)) {
              if (manager.principalId == teamUpdateDTO.principalId) {
                managerBuffer.add(mergeTeamSelection(teamUpdateDTO.updatedTeamSelection, manager, transfersAvailable, monthlyBonuses, newBankBalance));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup5 := Buffer.toArray(managerBuffer);
          };
          case 5 {
            for (manager in Iter.fromArray(managerGroup6)) {
              if (manager.principalId == teamUpdateDTO.principalId) {
                managerBuffer.add(mergeTeamSelection(teamUpdateDTO.updatedTeamSelection, manager, transfersAvailable, monthlyBonuses, newBankBalance));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup6 := Buffer.toArray(managerBuffer);
          };
          case 6 {
            for (manager in Iter.fromArray(managerGroup7)) {
              if (manager.principalId == teamUpdateDTO.principalId) {
                managerBuffer.add(mergeTeamSelection(teamUpdateDTO.updatedTeamSelection, manager, transfersAvailable, monthlyBonuses, newBankBalance));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup7 := Buffer.toArray(managerBuffer);
          };
          case 7 {
            for (manager in Iter.fromArray(managerGroup8)) {
              if (manager.principalId == teamUpdateDTO.principalId) {
                managerBuffer.add(mergeTeamSelection(teamUpdateDTO.updatedTeamSelection, manager, transfersAvailable, monthlyBonuses, newBankBalance));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup8 := Buffer.toArray(managerBuffer);
          };
          case 8 {
            for (manager in Iter.fromArray(managerGroup9)) {
              if (manager.principalId == teamUpdateDTO.principalId) {
                managerBuffer.add(mergeTeamSelection(teamUpdateDTO.updatedTeamSelection, manager, transfersAvailable, monthlyBonuses, newBankBalance));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup9 := Buffer.toArray(managerBuffer);
          };
          case 9 {
            for (manager in Iter.fromArray(managerGroup10)) {
              if (manager.principalId == teamUpdateDTO.principalId) {
                managerBuffer.add(mergeTeamSelection(teamUpdateDTO.updatedTeamSelection, manager, transfersAvailable, monthlyBonuses, newBankBalance));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup10 := Buffer.toArray(managerBuffer);
          };
          case 10 {
            for (manager in Iter.fromArray(managerGroup11)) {
              if (manager.principalId == teamUpdateDTO.principalId) {
                managerBuffer.add(mergeTeamSelection(teamUpdateDTO.updatedTeamSelection, manager, transfersAvailable, monthlyBonuses, newBankBalance));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup11 := Buffer.toArray(managerBuffer);
          };
          case 11 {
            for (manager in Iter.fromArray(managerGroup12)) {
              if (manager.principalId == teamUpdateDTO.principalId) {
                managerBuffer.add(mergeTeamSelection(teamUpdateDTO.updatedTeamSelection, manager, transfersAvailable, monthlyBonuses, newBankBalance));
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

  private func mergeTeamSelection(dto : DTOs.UpdateTeamSelectionDTO, manager : T.Manager, transfersAvailable : Nat8, monthlyBonusesAvailable : Nat8, newBankBalance : Nat16) : T.Manager {
    
    var username = manager.username;
    if(dto.username != ""){
      username := dto.username;
    };

    return {
      principalId = manager.principalId;
      username = username;
      favouriteClubId = manager.favouriteClubId;
      createDate = manager.createDate;
      termsAccepted = manager.termsAccepted;
      profilePicture = manager.profilePicture;
      transfersAvailable = transfersAvailable;
      monthlyBonusesAvailable = monthlyBonusesAvailable;
      bankQuarterMillions = newBankBalance;
      playerIds = dto.playerIds;
      captainId = dto.captainId;
      goalGetterGameweek = dto.goalGetterGameweek;
      goalGetterPlayerId = dto.goalGetterPlayerId;
      passMasterGameweek = dto.passMasterGameweek;
      passMasterPlayerId = dto.passMasterPlayerId;
      noEntryGameweek = dto.noEntryGameweek;
      noEntryPlayerId = dto.noEntryPlayerId;
      teamBoostGameweek = dto.teamBoostGameweek;
      teamBoostClubId = dto.teamBoostClubId;
      safeHandsGameweek = dto.safeHandsGameweek;
      safeHandsPlayerId = dto.safeHandsPlayerId;
      captainFantasticGameweek = dto.captainFantasticGameweek;
      captainFantasticPlayerId = dto.captainFantasticPlayerId;
      countrymenGameweek = dto.countrymenGameweek;
      countrymenCountryId = dto.countrymenCountryId;
      prospectsGameweek = dto.prospectsGameweek;
      braceBonusGameweek = dto.braceBonusGameweek;
      hatTrickHeroGameweek = dto.hatTrickHeroGameweek;
      transferWindowGameweek = dto.transferWindowGameweek;
      history = manager.history;
      profilePictureType = manager.profilePictureType;
      canisterId = manager.canisterId;
    };
  };

  public shared ({ caller }) func updateUsername(dto : DTOs.UsernameUpdateDTO) : async Result.Result<(), T.Error> {
    assert not Principal.isAnonymous(caller);
    let backendPrincipalId = Principal.toText(caller);
    assert backendPrincipalId == controllerPrincipalId;

    let managerBuffer = Buffer.fromArray<T.Manager>([]);
    let managerGroupIndex = managerGroupIndexes.get(dto.principalId);
    switch (managerGroupIndex) {
      case (null) {};
      case (?foundGroupIndex) {
        switch (foundGroupIndex) {
          case 0 {
            for (manager in Iter.fromArray(managerGroup1)) {
              if (manager.principalId == dto.principalId) {
                managerBuffer.add(mergeManagerUsername(manager, dto.updatedUsername.username));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup1 := Buffer.toArray(managerBuffer);
          };
          case 1 {
            for (manager in Iter.fromArray(managerGroup2)) {
              if (manager.principalId == dto.principalId) {
                managerBuffer.add(mergeManagerUsername(manager, dto.updatedUsername.username));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup2 := Buffer.toArray(managerBuffer);
          };
          case 2 {
            for (manager in Iter.fromArray(managerGroup3)) {
              if (manager.principalId == dto.principalId) {
                managerBuffer.add(mergeManagerUsername(manager, dto.updatedUsername.username));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup3 := Buffer.toArray(managerBuffer);
          };
          case 3 {
            for (manager in Iter.fromArray(managerGroup4)) {
              if (manager.principalId == dto.principalId) {
                managerBuffer.add(mergeManagerUsername(manager, dto.updatedUsername.username));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup4 := Buffer.toArray(managerBuffer);
          };
          case 4 {
            for (manager in Iter.fromArray(managerGroup5)) {
              if (manager.principalId == dto.principalId) {
                managerBuffer.add(mergeManagerUsername(manager, dto.updatedUsername.username));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup5 := Buffer.toArray(managerBuffer);
          };
          case 5 {
            for (manager in Iter.fromArray(managerGroup6)) {
              if (manager.principalId == dto.principalId) {
                managerBuffer.add(mergeManagerUsername(manager, dto.updatedUsername.username));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup6 := Buffer.toArray(managerBuffer);
          };
          case 6 {
            for (manager in Iter.fromArray(managerGroup7)) {
              if (manager.principalId == dto.principalId) {
                managerBuffer.add(mergeManagerUsername(manager, dto.updatedUsername.username));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup7 := Buffer.toArray(managerBuffer);
          };
          case 7 {
            for (manager in Iter.fromArray(managerGroup8)) {
              if (manager.principalId == dto.principalId) {
                managerBuffer.add(mergeManagerUsername(manager, dto.updatedUsername.username));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup8 := Buffer.toArray(managerBuffer);
          };
          case 8 {
            for (manager in Iter.fromArray(managerGroup9)) {
              if (manager.principalId == dto.principalId) {
                managerBuffer.add(mergeManagerUsername(manager, dto.updatedUsername.username));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup9 := Buffer.toArray(managerBuffer);
          };
          case 9 {
            for (manager in Iter.fromArray(managerGroup10)) {
              if (manager.principalId == dto.principalId) {
                managerBuffer.add(mergeManagerUsername(manager, dto.updatedUsername.username));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup10 := Buffer.toArray(managerBuffer);
          };
          case 10 {
            for (manager in Iter.fromArray(managerGroup11)) {
              if (manager.principalId == dto.principalId) {
                managerBuffer.add(mergeManagerUsername(manager, dto.updatedUsername.username));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup11 := Buffer.toArray(managerBuffer);
          };
          case 11 {
            for (manager in Iter.fromArray(managerGroup12)) {
              if (manager.principalId == dto.principalId) {
                managerBuffer.add(mergeManagerUsername(manager, dto.updatedUsername.username));
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
      countrymenGameweek = manager.countrymenGameweek;
      countrymenCountryId = manager.countrymenCountryId;
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

  public shared ({ caller }) func updateProfilePicture(dto : DTOs.ProfilePictureUpdateDTO) : async Result.Result<(), T.Error> {
    assert not Principal.isAnonymous(caller);
    let backendPrincipalId = Principal.toText(caller);
    assert backendPrincipalId == controllerPrincipalId;

    let managerBuffer = Buffer.fromArray<T.Manager>([]);
    let managerGroupIndex = managerGroupIndexes.get(dto.principalId);
    switch (managerGroupIndex) {
      case (null) {};
      case (?foundGroupIndex) {
        switch (foundGroupIndex) {
          case 0 {
            for (manager in Iter.fromArray(managerGroup1)) {
              if (manager.principalId == dto.principalId) {
                managerBuffer.add(mergeManagerProfilePicture(manager, dto.updatedProfilePicture.profilePicture, dto.updatedProfilePicture.extension));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup1 := Buffer.toArray(managerBuffer);
          };
          case 1 {
            for (manager in Iter.fromArray(managerGroup2)) {
              if (manager.principalId == dto.principalId) {
                managerBuffer.add(mergeManagerProfilePicture(manager, dto.updatedProfilePicture.profilePicture, dto.updatedProfilePicture.extension));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup2 := Buffer.toArray(managerBuffer);
          };
          case 2 {
            for (manager in Iter.fromArray(managerGroup3)) {
              if (manager.principalId == dto.principalId) {
                managerBuffer.add(mergeManagerProfilePicture(manager, dto.updatedProfilePicture.profilePicture, dto.updatedProfilePicture.extension));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup3 := Buffer.toArray(managerBuffer);
          };
          case 3 {
            for (manager in Iter.fromArray(managerGroup4)) {
              if (manager.principalId == dto.principalId) {
                managerBuffer.add(mergeManagerProfilePicture(manager, dto.updatedProfilePicture.profilePicture, dto.updatedProfilePicture.extension));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup4 := Buffer.toArray(managerBuffer);
          };
          case 4 {
            for (manager in Iter.fromArray(managerGroup5)) {
              if (manager.principalId == dto.principalId) {
                managerBuffer.add(mergeManagerProfilePicture(manager, dto.updatedProfilePicture.profilePicture, dto.updatedProfilePicture.extension));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup5 := Buffer.toArray(managerBuffer);
          };
          case 5 {
            for (manager in Iter.fromArray(managerGroup6)) {
              if (manager.principalId == dto.principalId) {
                managerBuffer.add(mergeManagerProfilePicture(manager, dto.updatedProfilePicture.profilePicture, dto.updatedProfilePicture.extension));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup6 := Buffer.toArray(managerBuffer);
          };
          case 6 {
            for (manager in Iter.fromArray(managerGroup7)) {
              if (manager.principalId == dto.principalId) {
                managerBuffer.add(mergeManagerProfilePicture(manager, dto.updatedProfilePicture.profilePicture, dto.updatedProfilePicture.extension));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup7 := Buffer.toArray(managerBuffer);
          };
          case 7 {
            for (manager in Iter.fromArray(managerGroup8)) {
              if (manager.principalId == dto.principalId) {
                managerBuffer.add(mergeManagerProfilePicture(manager, dto.updatedProfilePicture.profilePicture, dto.updatedProfilePicture.extension));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup8 := Buffer.toArray(managerBuffer);
          };
          case 8 {
            for (manager in Iter.fromArray(managerGroup9)) {
              if (manager.principalId == dto.principalId) {
                managerBuffer.add(mergeManagerProfilePicture(manager, dto.updatedProfilePicture.profilePicture, dto.updatedProfilePicture.extension));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup9 := Buffer.toArray(managerBuffer);
          };
          case 9 {
            for (manager in Iter.fromArray(managerGroup10)) {
              if (manager.principalId == dto.principalId) {
                managerBuffer.add(mergeManagerProfilePicture(manager, dto.updatedProfilePicture.profilePicture, dto.updatedProfilePicture.extension));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup10 := Buffer.toArray(managerBuffer);
          };
          case 10 {
            for (manager in Iter.fromArray(managerGroup11)) {
              if (manager.principalId == dto.principalId) {
                managerBuffer.add(mergeManagerProfilePicture(manager, dto.updatedProfilePicture.profilePicture, dto.updatedProfilePicture.extension));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup11 := Buffer.toArray(managerBuffer);
          };
          case 11 {
            for (manager in Iter.fromArray(managerGroup12)) {
              if (manager.principalId == dto.principalId) {
                managerBuffer.add(mergeManagerProfilePicture(manager, dto.updatedProfilePicture.profilePicture, dto.updatedProfilePicture.extension));
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
      countrymenGameweek = manager.countrymenGameweek;
      countrymenCountryId = manager.countrymenCountryId;
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

  public shared ({ caller }) func updateFavouriteClub(dto : DTOs.FavouriteClubUpdateDTO) : async Result.Result<(), T.Error> {
    assert not Principal.isAnonymous(caller);
    let backendPrincipalId = Principal.toText(caller);
    assert backendPrincipalId == controllerPrincipalId;

    let managerBuffer = Buffer.fromArray<T.Manager>([]);
    let managerGroupIndex = managerGroupIndexes.get(dto.principalId);
    switch (managerGroupIndex) {
      case (null) {};
      case (?foundGroupIndex) {
        switch (foundGroupIndex) {
          case 0 {
            for (manager in Iter.fromArray(managerGroup1)) {
              if (manager.principalId == dto.principalId) {
                managerBuffer.add(mergeManagerFavouriteClub(manager,dto.favouriteClubId));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup1 := Buffer.toArray(managerBuffer);
          };
          case 1 {
            for (manager in Iter.fromArray(managerGroup2)) {
              if (manager.principalId == dto.principalId) {
                managerBuffer.add(mergeManagerFavouriteClub(manager,dto.favouriteClubId));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup2 := Buffer.toArray(managerBuffer);
          };
          case 2 {
            for (manager in Iter.fromArray(managerGroup3)) {
              if (manager.principalId == dto.principalId) {
                managerBuffer.add(mergeManagerFavouriteClub(manager,dto.favouriteClubId));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup3 := Buffer.toArray(managerBuffer);
          };
          case 3 {
            for (manager in Iter.fromArray(managerGroup4)) {
              if (manager.principalId == dto.principalId) {
                managerBuffer.add(mergeManagerFavouriteClub(manager,dto.favouriteClubId));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup4 := Buffer.toArray(managerBuffer);
          };
          case 4 {
            for (manager in Iter.fromArray(managerGroup5)) {
              if (manager.principalId == dto.principalId) {
                managerBuffer.add(mergeManagerFavouriteClub(manager,dto.favouriteClubId));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup5 := Buffer.toArray(managerBuffer);
          };
          case 5 {
            for (manager in Iter.fromArray(managerGroup6)) {
              if (manager.principalId == dto.principalId) {
                managerBuffer.add(mergeManagerFavouriteClub(manager,dto.favouriteClubId));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup6 := Buffer.toArray(managerBuffer);
          };
          case 6 {
            for (manager in Iter.fromArray(managerGroup7)) {
              if (manager.principalId == dto.principalId) {
                managerBuffer.add(mergeManagerFavouriteClub(manager,dto.favouriteClubId));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup7 := Buffer.toArray(managerBuffer);
          };
          case 7 {
            for (manager in Iter.fromArray(managerGroup8)) {
              if (manager.principalId == dto.principalId) {
                managerBuffer.add(mergeManagerFavouriteClub(manager,dto.favouriteClubId));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup8 := Buffer.toArray(managerBuffer);
          };
          case 8 {
            for (manager in Iter.fromArray(managerGroup9)) {
              if (manager.principalId == dto.principalId) {
                managerBuffer.add(mergeManagerFavouriteClub(manager,dto.favouriteClubId));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup9 := Buffer.toArray(managerBuffer);
          };
          case 9 {
            for (manager in Iter.fromArray(managerGroup10)) {
              if (manager.principalId == dto.principalId) {
                managerBuffer.add(mergeManagerFavouriteClub(manager,dto.favouriteClubId));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup10 := Buffer.toArray(managerBuffer);
          };
          case 10 {
            for (manager in Iter.fromArray(managerGroup11)) {
              if (manager.principalId == dto.principalId) {
                managerBuffer.add(mergeManagerFavouriteClub(manager,dto.favouriteClubId));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup11 := Buffer.toArray(managerBuffer);
          };
          case 11 {
            for (manager in Iter.fromArray(managerGroup12)) {
              if (manager.principalId == dto.principalId) {
                managerBuffer.add(mergeManagerFavouriteClub(manager,dto.favouriteClubId));
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

  private func mergeManagerFavouriteClub(manager : T.Manager, favouriteClubId : T.ClubId) : T.Manager {
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
      countrymenGameweek = manager.countrymenGameweek;
      countrymenCountryId = manager.countrymenCountryId;
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

  public shared ({ caller }) func getManagersWithPlayer(playerId : T.PlayerId) : async [T.PrincipalId] {
    assert not Principal.isAnonymous(caller);
    let backendPrincipalId = Principal.toText(caller);
    assert backendPrincipalId == controllerPrincipalId;

    let allManagersBuffer = Buffer.fromArray<T.PrincipalId>([]);
    for (index in Iter.range(0, 11)) {
      switch (index) {
        case 0 {
          for (manager in Iter.fromArray(managerGroup1)) {
            let isPlayerInTeam = Array.find(
              manager.playerIds,
              func(pId : T.PlayerId) : Bool {
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
              func(pId : T.PlayerId) : Bool {
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
              func(pId : T.PlayerId) : Bool {
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
              func(pId : T.PlayerId) : Bool {
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
              func(pId : T.PlayerId) : Bool {
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
              func(pId : T.PlayerId) : Bool {
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
              func(pId : T.PlayerId) : Bool {
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
              func(pId : T.PlayerId) : Bool {
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
              func(pId : T.PlayerId) : Bool {
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
              func(pId : T.PlayerId) : Bool {
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
              func(pId : T.PlayerId) : Bool {
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
              func(pId : T.PlayerId) : Bool {
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

  public shared ({ caller }) func getFantasyTeamSnapshot(dto: DTOs.GetFantasyTeamSnapshotDTO) : async ?T.FantasyTeamSnapshot {
    assert not Principal.isAnonymous(caller);
    let backendPrincipalId = Principal.toText(caller);
    assert backendPrincipalId == controllerPrincipalId;

    let managerGroupIndex = managerGroupIndexes.get(dto.managerPrincipalId);

    var managers: [T.Manager] = [];


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
          if (manager.principalId == dto.managerPrincipalId) {
            switch (manager.history) {
              case (null) {    };
              case (history) {
                for(season in Iter.fromList(history)){
                  if(season.seasonId == dto.seasonId){
                    for(gameweek in Iter.fromList(season.gameweeks)){
                      if(gameweek.gameweek == dto.gameweek){
                        return ?gameweek;
                      };  
                    };
                  };
                };  
              };
            };

          }
        };
      };
    };
    return null;
  };

  public shared ({ caller }) func getOrderedSnapshots(seasonId : T.SeasonId, gameweek : T.GameweekNumber) : async [T.FantasyTeamSnapshot] {
    
    assert not Principal.isAnonymous(caller);
    let backendPrincipalId = Principal.toText(caller);
    assert backendPrincipalId == controllerPrincipalId;

    let allManagersBuffer = Buffer.fromArray<T.FantasyTeamSnapshot>([]);
    for (index in Iter.range(0, 11)) {

      var managers: [T.Manager] = [];
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
        case _{};
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

  public shared ({ caller }) func getFinalGameweekSnapshots(seasonId : T.SeasonId) : async [T.FantasyTeamSnapshot] {
    assert not Principal.isAnonymous(caller);
    let backendPrincipalId = Principal.toText(caller);
    assert backendPrincipalId == controllerPrincipalId;

    let allManagersBuffer = Buffer.fromArray<T.FantasyTeamSnapshot>([]);
    for (index in Iter.range(0, 11)) {
      switch (index) {
        case 0 {
          for (manager in Iter.fromArray(managerGroup1)) {
            let currentSeason = List.find<T.FantasyTeamSeason>(
              manager.history,
              func(season : T.FantasyTeamSeason) : Bool {
                return season.seasonId == seasonId;
              },
            );
            switch (currentSeason) {
              case (null) {};
              case (?foundSeason) {
                let currentGameweek = List.find<T.FantasyTeamSnapshot>(foundSeason.gameweeks, func(snapshot: T.FantasyTeamSnapshot) : Bool{
                  snapshot.gameweek == fixturesPerClub
                });
                switch(currentGameweek){
                  case (?foundGameweek){
                    allManagersBuffer.add(foundGameweek);
                  };
                  case (null){ }
                }
              };
            };
          };
        };
        case 1 {
          for (manager in Iter.fromArray(managerGroup2)) {
            let currentSeason = List.find<T.FantasyTeamSeason>(
              manager.history,
              func(season : T.FantasyTeamSeason) : Bool {
                return season.seasonId == seasonId;
              },
            );
            switch (currentSeason) {
              case (null) {};
              case (?foundSeason) {
                let currentGameweek = List.find<T.FantasyTeamSnapshot>(foundSeason.gameweeks, func(snapshot: T.FantasyTeamSnapshot) : Bool{
                  snapshot.gameweek == fixturesPerClub
                });
                switch(currentGameweek){
                  case (?foundGameweek){
                    allManagersBuffer.add(foundGameweek);
                  };
                  case (null){ }
                }
              };
            };
          };
        };
        case 2 {
          for (manager in Iter.fromArray(managerGroup3)) {
            let currentSeason = List.find<T.FantasyTeamSeason>(
              manager.history,
              func(season : T.FantasyTeamSeason) : Bool {
                return season.seasonId == seasonId;
              },
            );
            switch (currentSeason) {
              case (null) {};
              case (?foundSeason) {
                let currentGameweek = List.find<T.FantasyTeamSnapshot>(foundSeason.gameweeks, func(snapshot: T.FantasyTeamSnapshot) : Bool{
                  snapshot.gameweek == fixturesPerClub
                });
                switch(currentGameweek){
                  case (?foundGameweek){
                    allManagersBuffer.add(foundGameweek);
                  };
                  case (null){ }
                }
              };
            };
          };
        };
        case 3 {
          for (manager in Iter.fromArray(managerGroup4)) {
            let currentSeason = List.find<T.FantasyTeamSeason>(
              manager.history,
              func(season : T.FantasyTeamSeason) : Bool {
                return season.seasonId == seasonId;
              },
            );
            switch (currentSeason) {
              case (null) {};
              case (?foundSeason) {
                let currentGameweek = List.find<T.FantasyTeamSnapshot>(foundSeason.gameweeks, func(snapshot: T.FantasyTeamSnapshot) : Bool{
                  snapshot.gameweek == fixturesPerClub
                });
                switch(currentGameweek){
                  case (?foundGameweek){
                    allManagersBuffer.add(foundGameweek);
                  };
                  case (null){ }
                }
              };
            };
          };
        };
        case 4 {
          for (manager in Iter.fromArray(managerGroup5)) {
            let currentSeason = List.find<T.FantasyTeamSeason>(
              manager.history,
              func(season : T.FantasyTeamSeason) : Bool {
                return season.seasonId == seasonId;
              },
            );
            switch (currentSeason) {
              case (null) {};
              case (?foundSeason) {
                let currentGameweek = List.find<T.FantasyTeamSnapshot>(foundSeason.gameweeks, func(snapshot: T.FantasyTeamSnapshot) : Bool{
                  snapshot.gameweek == fixturesPerClub
                });
                switch(currentGameweek){
                  case (?foundGameweek){
                    allManagersBuffer.add(foundGameweek);
                  };
                  case (null){ }
                }
              };
            };
          };
        };
        case 5 {
          for (manager in Iter.fromArray(managerGroup6)) {
            let currentSeason = List.find<T.FantasyTeamSeason>(
              manager.history,
              func(season : T.FantasyTeamSeason) : Bool {
                return season.seasonId == seasonId;
              },
            );
            switch (currentSeason) {
              case (null) {};
              case (?foundSeason) {
                let currentGameweek = List.find<T.FantasyTeamSnapshot>(foundSeason.gameweeks, func(snapshot: T.FantasyTeamSnapshot) : Bool{
                  snapshot.gameweek == fixturesPerClub
                });
                switch(currentGameweek){
                  case (?foundGameweek){
                    allManagersBuffer.add(foundGameweek);
                  };
                  case (null){ }
                }
              };
            };
          };
        };
        case 6 {
          for (manager in Iter.fromArray(managerGroup7)) {
            let currentSeason = List.find<T.FantasyTeamSeason>(
              manager.history,
              func(season : T.FantasyTeamSeason) : Bool {
                return season.seasonId == seasonId;
              },
            );
            switch (currentSeason) {
              case (null) {};
              case (?foundSeason) {
                let currentGameweek = List.find<T.FantasyTeamSnapshot>(foundSeason.gameweeks, func(snapshot: T.FantasyTeamSnapshot) : Bool {
                  snapshot.gameweek == fixturesPerClub
                });
                switch(currentGameweek){
                  case (?foundGameweek){
                    allManagersBuffer.add(foundGameweek);
                  };
                  case (null){ }
                }
              };
            };
          };
        };
        case 7 {
          for (manager in Iter.fromArray(managerGroup8)) {
            let currentSeason = List.find<T.FantasyTeamSeason>(
              manager.history,
              func(season : T.FantasyTeamSeason) : Bool {
                return season.seasonId == seasonId;
              },
            );
            switch (currentSeason) {
              case (null) {};
              case (?foundSeason) {
                let currentGameweek = List.find<T.FantasyTeamSnapshot>(foundSeason.gameweeks, func(snapshot: T.FantasyTeamSnapshot) : Bool {
                  snapshot.gameweek == fixturesPerClub
                });
                switch(currentGameweek){
                  case (?foundGameweek){
                    allManagersBuffer.add(foundGameweek);
                  };
                  case (null){ }
                }
              };
            };
          };
        };
        case 8 {
          for (manager in Iter.fromArray(managerGroup9)) {
            let currentSeason = List.find<T.FantasyTeamSeason>(
              manager.history,
              func(season : T.FantasyTeamSeason) : Bool {
                return season.seasonId == seasonId;
              },
            );
            switch (currentSeason) {
              case (null) {};
              case (?foundSeason) {
                let currentGameweek = List.find<T.FantasyTeamSnapshot>(foundSeason.gameweeks, func(snapshot: T.FantasyTeamSnapshot) : Bool {
                  snapshot.gameweek == fixturesPerClub
                });
                switch(currentGameweek){
                  case (?foundGameweek){
                    allManagersBuffer.add(foundGameweek);
                  };
                  case (null){ }
                }
              };
            };
          };
        };
        case 9 {
          for (manager in Iter.fromArray(managerGroup10)) {
            let currentSeason = List.find<T.FantasyTeamSeason>(
              manager.history,
              func(season : T.FantasyTeamSeason) : Bool {
                return season.seasonId == seasonId;
              },
            );
            switch (currentSeason) {
              case (null) {};
              case (?foundSeason) {
                let currentGameweek = List.find<T.FantasyTeamSnapshot>(foundSeason.gameweeks, func(snapshot: T.FantasyTeamSnapshot) : Bool {
                  snapshot.gameweek == fixturesPerClub
                });
                switch(currentGameweek){
                  case (?foundGameweek){
                    allManagersBuffer.add(foundGameweek);
                  };
                  case (null){ }
                }
              };
            };
          };
        };
        case 10 {
          for (manager in Iter.fromArray(managerGroup11)) {
            let currentSeason = List.find<T.FantasyTeamSeason>(
              manager.history,
              func(season : T.FantasyTeamSeason) : Bool {
                return season.seasonId == seasonId;
              },
            );
            switch (currentSeason) {
              case (null) {};
              case (?foundSeason) {
                let currentGameweek = List.find<T.FantasyTeamSnapshot>(foundSeason.gameweeks, func(snapshot: T.FantasyTeamSnapshot) : Bool {
                  snapshot.gameweek == fixturesPerClub
                });
                switch(currentGameweek){
                  case (?foundGameweek){
                    allManagersBuffer.add(foundGameweek);
                  };
                  case (null){ }
                }
              };
            };
          };
        };
        case 11 {
          for (manager in Iter.fromArray(managerGroup12)) {
            let currentSeason = List.find<T.FantasyTeamSeason>(
              manager.history,
              func(season : T.FantasyTeamSeason) : Bool {
                return season.seasonId == seasonId;
              },
            );
            switch (currentSeason) {
              case (null) {};
              case (?foundSeason) {
                let currentGameweek = List.find<T.FantasyTeamSnapshot>(foundSeason.gameweeks, func(snapshot: T.FantasyTeamSnapshot) : Bool {
                  snapshot.gameweek == fixturesPerClub
                });
                switch(currentGameweek){
                  case (?foundGameweek){
                    allManagersBuffer.add(foundGameweek);
                  };
                  case (null){ }
                }
              };
            };
          };
        };
        case _ {};
      };
    };
    return Buffer.toArray(allManagersBuffer);
  };

  public shared ({ caller }) func addNewManager(newManager : T.Manager) : async Result.Result<(), T.Error> {
    assert not Principal.isAnonymous(caller);
    let backendPrincipalId = Principal.toText(caller);
    assert backendPrincipalId == controllerPrincipalId;

    var managerBuffer = Buffer.fromArray<T.Manager>([]);
    //for the current manager group with space
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

   private func updateSnapshotPoints(principalId : Text, seasonId : Nat16, gameweek : T.GameweekNumber, month : T.CalendarMonth, teamPoints : Int16, teamValueQuarterMillions : Nat16) : () {

    let managerBuffer = Buffer.fromArray<T.Manager>([]);
    let managerGroupIndex = managerGroupIndexes.get(principalId);

    var managers: [T.Manager] = [];

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

  private func mergeManagerSnapshot(manager : T.Manager, seasonId: T.SeasonId, gameweek : T.GameweekNumber, month : T.CalendarMonth, weeklyPoints : Int16, monthlyPoints : Int16, seasonPoints : Int16, teamValueQuarterMillions : Nat16) : T.FantasyTeamSnapshot {
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
      countrymenGameweek = manager.countrymenGameweek;
      countrymenCountryId = manager.countrymenCountryId;
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
      countrymenGameweek = manager.countrymenGameweek;
      countrymenCountryId = manager.countrymenCountryId;
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

   private func mergeExistingHistory(existingHistory : List.List<T.FantasyTeamSeason>, fantasyTeamSnapshot : T.FantasyTeamSnapshot, seasonId : T.SeasonId, gameweek : T.GameweekNumber) : List.List<T.FantasyTeamSeason> {

    let teamHistoryBuffer = Buffer.fromArray<T.FantasyTeamSeason>([]);

    for (season in List.toIter<T.FantasyTeamSeason>(existingHistory)) {
      if (season.seasonId == seasonId) {
        let snapshotBuffer = Buffer.fromArray<T.FantasyTeamSnapshot>([]);

        for (snapshot in List.toIter<T.FantasyTeamSnapshot>(season.gameweeks)) {
          if (snapshot.gameweek != gameweek) {
            snapshotBuffer.add(snapshot)
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

  public shared ({ caller }) func calculateFantasyTeamScores(seasonId : T.SeasonId, gameweek : T.GameweekNumber, month : T.CalendarMonth) : async Nat {
    /*
    assert not Principal.isAnonymous(caller);
    let backendPrincipalId = Principal.toText(caller);
    assert backendPrincipalId == controllerPrincipalId;

    let allPlayersList = getPlayers(seasonId, gameweek);

    let playerIdTrie : TrieMap.TrieMap<T.PlayerId, DTOs.PlayerScoreDTO> = TrieMap.TrieMap<T.PlayerId, DTOs.PlayerScoreDTO>(Utilities.eqNat16, Utilities.hashNat16);
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
                for (playerId in Iter.fromArray(foundSnapshot.playerIds)) {
                  let playerData = playerIdTrie.get(playerId);
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

                let allPlayerValues = Array.map<DTOs.PlayerDTO, Nat16>(allPlayers, func(player : DTOs.PlayerDTO) : Nat16 { return player.valueQuarterMillions });

                let totalTeamValue = Array.foldLeft<Nat16, Nat16>(allPlayerValues, 0, func(sumSoFar, x) = sumSoFar + x);

                updateSnapshotPoints(value.principalId, seasonId, gameweek, month, totalTeamPoints, totalTeamValue);
              };
            };
          };
        };
      };
    };
    */
    return 0;
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

  public shared ({ caller }) func getTotalManagers() : async Nat {
    Debug.print("Get total managers");
    assert not Principal.isAnonymous(caller);
    let backendPrincipalId = Principal.toText(caller);
    assert backendPrincipalId == controllerPrincipalId;
    return totalManagers;
  };

  public shared ({ caller }) func snapshotFantasyTeams(seasonId : T.SeasonId, gameweek : T.GameweekNumber, month : T.CalendarMonth) : async () {
    assert not Principal.isAnonymous(caller);
    let backendPrincipalId = Principal.toText(caller);
    assert backendPrincipalId == controllerPrincipalId;


    for (index in Iter.range(0, 11)) {
      await snapshotPlayers();
      await snapshotManagers(index, seasonId, gameweek, month); 
    };
  };

  private func snapshotManagers(managerGroup: Int, seasonId : T.SeasonId, gameweek : T.GameweekNumber, month : T.CalendarMonth) : async () {
    
    /*

    let managerBuffer = Buffer.fromArray<T.Manager>([]);


    var managers: [T.Manager] = [];

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

            let managerPlayers = Array.filter<DTOs.PlayerDTO>(players, func(player){
              Option.isSome(Array.find<T.PlayerId>(manager.playerIds, func(playerId) : Bool{
                playerId == player.id
              }))
            });
            
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
          };
          return season;
        },
      );
      
      let updatedSeasonsBuffer = Buffer.fromArray<T.FantasyTeamSeason>(List.toArray(updatedSeasons));
      
      if(not seasonFound){

        let managerPlayers = Array.filter<DTOs.PlayerDTO>(players, func(player){
          Option.isSome(Array.find<T.PlayerId>(manager.playerIds, func(playerId) : Bool{
            playerId == player.id
          }))
        });

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
          month = month;
          monthlyPoints = 0;
          seasonPoints = 0;
          seasonId = seasonId;
        };

        updatedSeasonsBuffer.add({
          gameweeks = List.fromArray([newSnapshot]);
          seasonId = seasonId;
          totalPoints = 0
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
        countrymenGameweek = manager.countrymenGameweek;
        countrymenCountryId = manager.countrymenCountryId;
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
    */
  };
  public shared ({ caller }) func resetFantasyTeams() : async () {
    //todo: implement
  };

  public shared ({ caller }) func resetBonusesAvailable() : async () {
    assert not Principal.isAnonymous(caller);
    let backendPrincipalId = Principal.toText(caller);
    assert backendPrincipalId == controllerPrincipalId;

    for (index in Iter.range(0, 11)) {
      switch (index) {
        case 0 {
          managerGroup1 := resetManagerBonuses(managerGroup1);
        };
        case 1 {
          managerGroup2 := resetManagerBonuses(managerGroup2);
        };
        case 2 {
          managerGroup3 := resetManagerBonuses(managerGroup3);
        };
        case 3 {
          managerGroup4 := resetManagerBonuses(managerGroup4);
        };
        case 4 {
          managerGroup5 := resetManagerBonuses(managerGroup5);
        };
        case 5 {
          managerGroup6 := resetManagerBonuses(managerGroup6);
        };
        case 6 {
          managerGroup7 := resetManagerBonuses(managerGroup7);
        };
        case 7 {
          managerGroup8 := resetManagerBonuses(managerGroup8);
        };
        case 8 {
          managerGroup9 := resetManagerBonuses(managerGroup9);
        };
        case 9 {
          managerGroup10 := resetManagerBonuses(managerGroup10);
        };
        case 10 {
          managerGroup11 := resetManagerBonuses(managerGroup11);
        };
        case 11 {
          managerGroup12 := resetManagerBonuses(managerGroup12);
        };
        case _ {

        };
      };
    };
  };

  private func snapshotPlayers() : async (){
    /*
    let openfpl_backend_canister = actor (controllerPrincipalId) : actor {
      getPlayers : () -> async [DTOs.PlayerDTO];
    };
      
    let players : [DTOs.PlayerDTO] = await openfpl_backend_canister.getPlayers();

    let updatedSeasonsBuffer = Buffer.fromArray<(T.Season, [(T.GameweekNumber, [T.Player])])>([]);
   
    let playersSeason = Array.find<(T.SeasonId, [(T.GameweekNumber, [T.Player])])>(playersSnapshots, func(playersSeasonSnapshot: (T.SeasonId, [(T.GameweekNumber, [T.Player])])) : Bool{
      playersSeasonSnapshot.0 == seasonId;
    });

    switch(playersSeason){
      case (?foundSeason){
        
        let foundGameweek = Array.find<(T.GameweekNumber, [T.Player])>(foundSeason.1, func(currentGameweek: (T.GameweekNumber, [T.Player])) : Bool{
          currentGameweek.0 == gameweek;
        });

        switch(foundGameweek){
          case (?existingGameweek){

          };
          case (null){
            //add 
          };
        };
        
      };
      case (null){
        //create new one because one doesn't exist
      };
    };

//get from this file
   getSnapshotPlayers : () -> async [DTOs.PlayerDTO];
      //TODO
        //Ensure we only snapshot the first time 
//TODO need to link to openfpl backend then data canister
    let openfpl_backend_canister = actor (controllerPrincipalId) : actor {
        getPlayerPointsMap : (seasonId: T.SeasonId, gameweek: T.GameweekNumber) -> async [(T.PlayerId, DTOs.PlayerScoreDTO)];
     
      };
      
    //TODO: USE 
    //let allPlayersList = await openfpl_backend_canister.getPlayerPointsMap(seasonId, gameweek);
                  
    let allPlayers : [DTOs.PlayerDTO] = await openfpl_backend_canister.getSnapshotPlayers();

    */
  };

  private func resetManagerBonuses(managers : [T.Manager]) : [T.Manager] {
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
        countrymenGameweek = manager.countrymenGameweek;
        countrymenCountryId = manager.countrymenCountryId;
        prospectsGameweek = manager.prospectsGameweek;
        braceBonusGameweek = manager.braceBonusGameweek;
        hatTrickHeroGameweek = manager.hatTrickHeroGameweek;
        transferWindowGameweek = manager.transferWindowGameweek;
        canisterId = manager.canisterId;
      };
      managerBuffer.add(updatedManager);
    };
    return Buffer.toArray(managerBuffer);
  };

  public shared ({ caller }) func resetWeeklyTransfers() : async () {
    assert not Principal.isAnonymous(caller);
    let backendPrincipalId = Principal.toText(caller);
    assert backendPrincipalId == controllerPrincipalId;

    for (index in Iter.range(0, 11)) {
      switch (index) {
        case 0 {
          managerGroup1 := resetManagerWeeklyTransfers(managerGroup1);
        };
        case 1 {
          managerGroup2 := resetManagerWeeklyTransfers(managerGroup2);
        };
        case 2 {
          managerGroup3 := resetManagerWeeklyTransfers(managerGroup3);
        };
        case 3 {
          managerGroup4 := resetManagerWeeklyTransfers(managerGroup4);
        };
        case 4 {
          managerGroup5 := resetManagerWeeklyTransfers(managerGroup5);
        };
        case 5 {
          managerGroup6 := resetManagerWeeklyTransfers(managerGroup6);
        };
        case 6 {
          managerGroup7 := resetManagerWeeklyTransfers(managerGroup7);
        };
        case 7 {
          managerGroup8 := resetManagerWeeklyTransfers(managerGroup8);
        };
        case 8 {
          managerGroup9 := resetManagerWeeklyTransfers(managerGroup9);
        };
        case 9 {
          managerGroup10 := resetManagerWeeklyTransfers(managerGroup10);
        };
        case 10 {
          managerGroup11 := resetManagerWeeklyTransfers(managerGroup11);
        };
        case 11 {
          managerGroup12 := resetManagerWeeklyTransfers(managerGroup12);
        };
        case _ {

        };
      };
    };
  };

  private func resetManagerWeeklyTransfers(managers : [T.Manager]) : [T.Manager] {
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
        countrymenGameweek = manager.countrymenGameweek;
        countrymenCountryId = manager.countrymenCountryId;
        prospectsGameweek = manager.prospectsGameweek;
        braceBonusGameweek = manager.braceBonusGameweek;
        hatTrickHeroGameweek = manager.hatTrickHeroGameweek;
        transferWindowGameweek = manager.transferWindowGameweek;
        canisterId = manager.canisterId;
      };
      managerBuffer.add(updatedManager);
    };
    return Buffer.toArray(managerBuffer);
  };

  public shared ({ caller }) func getClubManagers(clubId : T.ClubId) : async [T.PrincipalId] {
    assert not Principal.isAnonymous(caller);
    let backendPrincipalId = Principal.toText(caller);
    assert backendPrincipalId == controllerPrincipalId;

    let clubManagerIdBuffer = Buffer.fromArray<T.PrincipalId>([]);

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

  private func getGroupClubManagerIds(managers : [T.Manager], clubId : T.ClubId) : [T.PrincipalId] {
    let managerIdBuffer = Buffer.fromArray<T.PrincipalId>([]);
    for (manager in Iter.fromArray(managers)) {
      switch(manager.favouriteClubId){
        case (?foundClubId){ 
          if (foundClubId == clubId) {
            managerIdBuffer.add(manager.principalId);
          };   
        };
        case (null){}
      }
    };
    return Buffer.toArray(managerIdBuffer);
  };

   private func getGroupNonClubManagerIds(managers : [T.Manager], clubId : T.ClubId) : [T.PrincipalId] {
    let managerIdBuffer = Buffer.fromArray<T.PrincipalId>([]);
    for (manager in Iter.fromArray(managers)) {
      switch(manager.favouriteClubId){
        case (?foundClubId){ 
          if (foundClubId != clubId and foundClubId > 0) {
            managerIdBuffer.add(manager.principalId);
          };
        };
        case (null){
          managerIdBuffer.add(manager.principalId);
        }
      }
    };
    return Buffer.toArray(managerIdBuffer);
  };

  public shared ({ caller }) func getMostValuableTeams(seasonId : T.SeasonId) : async [T.FantasyTeamSnapshot] {
    assert not Principal.isAnonymous(caller);
    let backendPrincipalId = Principal.toText(caller);
    assert backendPrincipalId == controllerPrincipalId;


    let players : [DTOs.PlayerDTO] = []; //TODO need to get from snapshot of players stored in this manager canister for the gameweek //await openfpl_backend_canister.getAllSeasonPlayers();

    let allFinalGameweekSnapshots = await getFinalGameweekSnapshots(seasonId);

    var teamValues : TrieMap.TrieMap<T.PrincipalId, T.FantasyTeamSnapshot> = TrieMap.TrieMap<T.PrincipalId, T.FantasyTeamSnapshot>(Text.equal, Text.hash);

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

      let updatedSnapshot : T.FantasyTeamSnapshot = {

        bankQuarterMillions = snapshot.bankQuarterMillions;
        braceBonusGameweek = snapshot.braceBonusGameweek;
        captainFantasticGameweek = snapshot.captainFantasticGameweek;
        captainFantasticPlayerId = snapshot.captainFantasticPlayerId;
        captainId = snapshot.captainId;
        countrymenCountryId = snapshot.countrymenCountryId;
        countrymenGameweek = snapshot.countrymenGameweek;
        favouriteClubId = snapshot.favouriteClubId;
        gameweek = snapshot.gameweek;
        goalGetterGameweek = snapshot.goalGetterGameweek;
        goalGetterPlayerId = snapshot.goalGetterPlayerId;
        hatTrickHeroGameweek = snapshot.hatTrickHeroGameweek;
        monthlyBonusesAvailable = snapshot.monthlyBonusesAvailable;
        noEntryGameweek = snapshot.noEntryGameweek;
        noEntryPlayerId = snapshot.noEntryPlayerId;
        passMasterGameweek = snapshot.passMasterGameweek;
        passMasterPlayerId = snapshot.passMasterPlayerId;
        playerIds = snapshot.playerIds;
        points = snapshot.points;
        principalId = snapshot.principalId;
        prospectsGameweek = snapshot.prospectsGameweek;
        safeHandsGameweek = snapshot.safeHandsGameweek;
        safeHandsPlayerId = snapshot.safeHandsPlayerId;
        teamBoostClubId = snapshot.teamBoostClubId;
        teamBoostGameweek = snapshot.teamBoostGameweek;
        teamValueQuarterMillions = totalTeamValue;
        transferWindowGameweek = snapshot.transferWindowGameweek;
        transfersAvailable = snapshot.transfersAvailable;
        username = snapshot.username;
        month = snapshot.month;
        monthlyPoints = snapshot.monthlyPoints;
        seasonPoints = snapshot.seasonPoints;
        seasonId = seasonId;
      };

      teamValues.put(snapshot.principalId, updatedSnapshot);
    };

    let teamValuesArray : [(T.PrincipalId, T.FantasyTeamSnapshot)] = Iter.toArray(teamValues.entries());

    let compare = func(a : (T.PrincipalId, T.FantasyTeamSnapshot), b : (T.PrincipalId, T.FantasyTeamSnapshot)) : Order.Order {
      if (a.1.points > b.1.points) { return #greater };
      if (a.1.points < b.1.points) { return #less };
      return #equal;
    };

    let sortedTeamValuesArray = Array.sort(teamValuesArray, compare);

    var counter = 0;
    var lastScore : Int16 = 0;

    let snapshotBuffer = Buffer.fromArray<T.FantasyTeamSnapshot>([]);
    label teamLoop for (team in Iter.fromArray(sortedTeamValuesArray)) {
      if (counter >= 100 and team.1.points < lastScore) {
        break teamLoop;
      };
      snapshotBuffer.add(team.1);
      counter := counter + 1;
      lastScore := team.1.points;
    };
    return Buffer.toArray(snapshotBuffer);
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
    cyclesCheckTimerId := ?Timer.setTimer<system>(#nanoseconds(cyclesCheckInterval), checkCanisterCycles);
  };


  //TODO: Do i need if main topping everuthing up
  private func checkCanisterCycles() : async () {

    let balance = Cycles.balance();

    if (balance < 50_000_000_000_000) {
      let openfpl_backend_canister = actor (controllerPrincipalId) : actor {
        requestCanisterTopup : (cycles: Nat) -> async ();
      };
      await openfpl_backend_canister.requestCanisterTopup(25_000_000_000_000);
    };
    await setCheckCyclesTimer();
  };

  private func setCheckCyclesTimer() : async () {
    switch (cyclesCheckTimerId) {
      case (null) {};
      case (?id) {
        Timer.cancelTimer(id);
        cyclesCheckTimerId := null;
      };
    };
    cyclesCheckTimerId := ?Timer.setTimer<system>(#nanoseconds(cyclesCheckInterval), checkCanisterCycles);
  };

  public shared func topupCanister() : async () {
    let amount = Cycles.available();
    let _ = Cycles.accept<system>(amount);
    Cycles.add<system>(amount);
  };

  public shared ({ caller }) func getCyclesBalance() : async Nat {
    assert not Principal.isAnonymous(caller);
    let backendPrincipalId = Principal.toText(caller);
    assert backendPrincipalId == controllerPrincipalId;
    return Cycles.balance();
  };

  public shared ({ caller }) func getCyclesAvailable() : async Nat {
    assert not Principal.isAnonymous(caller);
    let backendPrincipalId = Principal.toText(caller);
    assert backendPrincipalId == controllerPrincipalId;
    return Cycles.available();
  };

};

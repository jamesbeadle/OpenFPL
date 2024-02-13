import T "types";
import DTOs "DTOs";
import List "mo:base/List";
import Cycles "mo:base/ExperimentalCycles";
import Timer "mo:base/Timer";
import Principal "mo:base/Principal";
import Iter "mo:base/Iter";
import Array "mo:base/Array";
import Order "mo:base/Order";
import Text "mo:base/Text";
import TrieMap "mo:base/TrieMap";
import Trie "mo:base/Trie";
import Buffer "mo:base/Buffer";
import Nat8 "mo:base/Nat8";
import Time "mo:base/Time";
import Option "mo:base/Option";
import Int64 "mo:base/Int64";
import Nat64 "mo:base/Nat64";
import Result "mo:base/Result";
import CanisterIds "CanisterIds";
import Utilities "utilities";
import Environment "Environment";

actor class ManagerCanister() {

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
  private let cyclesCheckInterval : Nat = Utilities.getHour() * 24;
  private var cyclesCheckTimerId : ?Timer.TimerId = null;
  private var activeGroupIndex = 0;
  private stable var totalManagers = 0;

  let network = Environment.DFX_NETWORK;
  var main_canister_id = CanisterIds.MAIN_CANISTER_IC_ID;
  if (network == "local") {
    main_canister_id := CanisterIds.MAIN_CANISTER_LOCAL_ID;
  };

  public shared ({ caller }) func updateTeamSelection(updateManagerDTO : DTOs.UpdateTeamSelectionDTO, transfersAvailable : Nat8, monthlyBonuses : Nat8, newBankBalance : Nat16) : async Result.Result<(), T.Error> {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == main_canister_id;

    let managerBuffer = Buffer.fromArray<T.Manager>([]);
    let managerGroupIndex = managerGroupIndexes.get(updateManagerDTO.principalId);
    switch (managerGroupIndex) {
      case (null) {};
      case (?foundGroupIndex) {
        switch (foundGroupIndex) {
          case 0 {
            for (manager in Iter.fromArray(managerGroup1)) {
              if (manager.principalId == principalId) {
                managerBuffer.add(mergeTeamSelection(updateManagerDTO, manager, transfersAvailable, monthlyBonuses, newBankBalance));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup1 := Buffer.toArray(managerBuffer);
          };
          case 1 {
            for (manager in Iter.fromArray(managerGroup2)) {
              if (manager.principalId == principalId) {
                managerBuffer.add(mergeTeamSelection(updateManagerDTO, manager, transfersAvailable, monthlyBonuses, newBankBalance));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup2 := Buffer.toArray(managerBuffer);
          };
          case 2 {
            for (manager in Iter.fromArray(managerGroup3)) {
              if (manager.principalId == principalId) {
                managerBuffer.add(mergeTeamSelection(updateManagerDTO, manager, transfersAvailable, monthlyBonuses, newBankBalance));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup3 := Buffer.toArray(managerBuffer);
          };
          case 3 {
            for (manager in Iter.fromArray(managerGroup4)) {
              if (manager.principalId == principalId) {
                managerBuffer.add(mergeTeamSelection(updateManagerDTO, manager, transfersAvailable, monthlyBonuses, newBankBalance));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup4 := Buffer.toArray(managerBuffer);
          };
          case 4 {
            for (manager in Iter.fromArray(managerGroup5)) {
              if (manager.principalId == principalId) {
                managerBuffer.add(mergeTeamSelection(updateManagerDTO, manager, transfersAvailable, monthlyBonuses, newBankBalance));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup5 := Buffer.toArray(managerBuffer);
          };
          case 5 {
            for (manager in Iter.fromArray(managerGroup6)) {
              if (manager.principalId == principalId) {
                managerBuffer.add(mergeTeamSelection(updateManagerDTO, manager, transfersAvailable, monthlyBonuses, newBankBalance));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup6 := Buffer.toArray(managerBuffer);
          };
          case 6 {
            for (manager in Iter.fromArray(managerGroup7)) {
              if (manager.principalId == principalId) {
                managerBuffer.add(mergeTeamSelection(updateManagerDTO, manager, transfersAvailable, monthlyBonuses, newBankBalance));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup7 := Buffer.toArray(managerBuffer);
          };
          case 7 {
            for (manager in Iter.fromArray(managerGroup8)) {
              if (manager.principalId == principalId) {
                managerBuffer.add(mergeTeamSelection(updateManagerDTO, manager, transfersAvailable, monthlyBonuses, newBankBalance));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup8 := Buffer.toArray(managerBuffer);
          };
          case 8 {
            for (manager in Iter.fromArray(managerGroup9)) {
              if (manager.principalId == principalId) {
                managerBuffer.add(mergeTeamSelection(updateManagerDTO, manager, transfersAvailable, monthlyBonuses, newBankBalance));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup9 := Buffer.toArray(managerBuffer);
          };
          case 9 {
            for (manager in Iter.fromArray(managerGroup10)) {
              if (manager.principalId == principalId) {
                managerBuffer.add(mergeTeamSelection(updateManagerDTO, manager, transfersAvailable, monthlyBonuses, newBankBalance));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup10 := Buffer.toArray(managerBuffer);
          };
          case 10 {
            for (manager in Iter.fromArray(managerGroup11)) {
              if (manager.principalId == principalId) {
                managerBuffer.add(mergeTeamSelection(updateManagerDTO, manager, transfersAvailable, monthlyBonuses, newBankBalance));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup11 := Buffer.toArray(managerBuffer);
          };
          case 11 {
            for (manager in Iter.fromArray(managerGroup12)) {
              if (manager.principalId == principalId) {
                managerBuffer.add(mergeTeamSelection(updateManagerDTO, manager, transfersAvailable, monthlyBonuses, newBankBalance));
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
    return let updatedManager : T.Manager = {
      principalId = manager.principalId;
      username = manager.username;
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
      noEntryGameweek = manager.noEntryGameweek;
      noEntryPlayerId = manager.noEntryPlayerId;
      teamBoostGameweek = manager.teamBoostGameweek;
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
    };
  };

  public shared ({ caller }) func updateUsername(dto : DTOs.UpdateUsernameDTO) : async Result.Result<(), T.Error> {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == main_canister_id;

    let managerBuffer = Buffer.fromArray<T.Manager>([]);
    let managerGroupIndex = managerGroupIndexes.get(dto.principalId);
    switch (managerGroupIndex) {
      case (null) {};
      case (?foundGroupIndex) {
        switch (foundGroupIndex) {
          case 0 {
            for (manager in Iter.fromArray(managerGroup1)) {
              if (manager.principalId == principalId) {
                managerBuffer.add(mergeManagerUsername(manager, dto.username));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup1 := Buffer.toArray(managerBuffer);
          };
          case 1 {
            for (manager in Iter.fromArray(managerGroup2)) {
              if (manager.principalId == principalId) {
                managerBuffer.add(mergeManagerUsername(manager, dto.username));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup2 := Buffer.toArray(managerBuffer);
          };
          case 2 {
            for (manager in Iter.fromArray(managerGroup3)) {
              if (manager.principalId == principalId) {
                managerBuffer.add(mergeManagerUsername(manager, dto.username));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup3 := Buffer.toArray(managerBuffer);
          };
          case 3 {
            for (manager in Iter.fromArray(managerGroup4)) {
              if (manager.principalId == principalId) {
                managerBuffer.add(mergeManagerUsername(manager, dto.username));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup4 := Buffer.toArray(managerBuffer);
          };
          case 4 {
            for (manager in Iter.fromArray(managerGroup5)) {
              if (manager.principalId == principalId) {
                managerBuffer.add(mergeManagerUsername(manager, dto.username));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup5 := Buffer.toArray(managerBuffer);
          };
          case 5 {
            for (manager in Iter.fromArray(managerGroup6)) {
              if (manager.principalId == principalId) {
                managerBuffer.add(mergeManagerUsername(manager, dto.username));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup6 := Buffer.toArray(managerBuffer);
          };
          case 6 {
            for (manager in Iter.fromArray(managerGroup7)) {
              if (manager.principalId == principalId) {
                managerBuffer.add(mergeManagerUsername(manager, dto.username));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup7 := Buffer.toArray(managerBuffer);
          };
          case 7 {
            for (manager in Iter.fromArray(managerGroup8)) {
              if (manager.principalId == principalId) {
                managerBuffer.add(mergeManagerUsername(manager, dto.username));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup8 := Buffer.toArray(managerBuffer);
          };
          case 8 {
            for (manager in Iter.fromArray(managerGroup9)) {
              if (manager.principalId == principalId) {
                managerBuffer.add(mergeManagerUsername(manager, dto.username));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup9 := Buffer.toArray(managerBuffer);
          };
          case 9 {
            for (manager in Iter.fromArray(managerGroup10)) {
              if (manager.principalId == principalId) {
                managerBuffer.add(mergeManagerUsername(manager, dto.username));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup10 := Buffer.toArray(managerBuffer);
          };
          case 10 {
            for (manager in Iter.fromArray(managerGroup11)) {
              if (manager.principalId == principalId) {
                managerBuffer.add(mergeManagerUsername(manager, dto.username));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup11 := Buffer.toArray(managerBuffer);
          };
          case 11 {
            for (manager in Iter.fromArray(managerGroup12)) {
              if (manager.principalId == principalId) {
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
      countrymenGameweek = manager.countrymenGameweek;
      countrymenCountryId = manager.countrymenCountryId;
      prospectsGameweek = manager.prospectsGameweek;
      braceBonusGameweek = manager.braceBonusGameweek;
      hatTrickHeroGameweek = manager.hatTrickHeroGameweek;
      transferWindowGameweek = manager.transferWindowGameweek;
      history = manager.history;
      profilePicture = manager.profilePicture;
    };
  };

  public shared ({ caller }) func updateProfilePicture(dto : DTOs.UpdateProfilePictureDTO) : async Result.Result<(), T.Error> {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == main_canister_id;

    let managerBuffer = Buffer.fromArray<T.Manager>([]);
    let managerGroupIndex = managerGroupIndexes.get(dto.principalId);
    switch (managerGroupIndex) {
      case (null) {};
      case (?foundGroupIndex) {
        switch (foundGroupIndex) {
          case 0 {
            for (manager in Iter.fromArray(managerGroup1)) {
              if (manager.principalId == principalId) {
                managerBuffer.add(mergeManagerProfilePicture(manager, dto.profilePicture));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup1 := Buffer.toArray(managerBuffer);
          };
          case 1 {
            for (manager in Iter.fromArray(managerGroup2)) {
              if (manager.principalId == principalId) {
                managerBuffer.add(mergeManagerProfilePicture(manager, dto.profilePicture));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup2 := Buffer.toArray(managerBuffer);
          };
          case 2 {
            for (manager in Iter.fromArray(managerGroup3)) {
              if (manager.principalId == principalId) {
                managerBuffer.add(mergeManagerProfilePicture(manager, dto.profilePicture));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup3 := Buffer.toArray(managerBuffer);
          };
          case 3 {
            for (manager in Iter.fromArray(managerGroup4)) {
              if (manager.principalId == principalId) {
                managerBuffer.add(mergeManagerProfilePicture(manager, dto.profilePicture));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup4 := Buffer.toArray(managerBuffer);
          };
          case 4 {
            for (manager in Iter.fromArray(managerGroup5)) {
              if (manager.principalId == principalId) {
                managerBuffer.add(mergeManagerProfilePicture(manager, dto.profilePicture));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup5 := Buffer.toArray(managerBuffer);
          };
          case 5 {
            for (manager in Iter.fromArray(managerGroup6)) {
              if (manager.principalId == principalId) {
                managerBuffer.add(mergeManagerProfilePicture(manager, dto.profilePicture));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup6 := Buffer.toArray(managerBuffer);
          };
          case 6 {
            for (manager in Iter.fromArray(managerGroup7)) {
              if (manager.principalId == principalId) {
                managerBuffer.add(mergeManagerProfilePicture(manager, dto.profilePicture));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup7 := Buffer.toArray(managerBuffer);
          };
          case 7 {
            for (manager in Iter.fromArray(managerGroup8)) {
              if (manager.principalId == principalId) {
                managerBuffer.add(mergeManagerProfilePicture(manager, dto.profilePicture));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup8 := Buffer.toArray(managerBuffer);
          };
          case 8 {
            for (manager in Iter.fromArray(managerGroup9)) {
              if (manager.principalId == principalId) {
                managerBuffer.add(mergeManagerProfilePicture(manager, dto.profilePicture));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup9 := Buffer.toArray(managerBuffer);
          };
          case 9 {
            for (manager in Iter.fromArray(managerGroup10)) {
              if (manager.principalId == principalId) {
                managerBuffer.add(mergeManagerProfilePicture(manager, dto.profilePicture));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup10 := Buffer.toArray(managerBuffer);
          };
          case 10 {
            for (manager in Iter.fromArray(managerGroup11)) {
              if (manager.principalId == principalId) {
                managerBuffer.add(mergeManagerProfilePicture(manager, dto.profilePicture));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup11 := Buffer.toArray(managerBuffer);
          };
          case 11 {
            for (manager in Iter.fromArray(managerGroup12)) {
              if (manager.principalId == principalId) {
                managerBuffer.add(mergeManagerProfilePicture(manager, dto.profilePicture));
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

  private func mergeManagerProfilePicture(manager : T.Manager, profilePicture : ?Blob) : T.Manager {
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
      profilePicture = profilePicture;
    };
  };

  public shared ({ caller }) func updateFavouriteClub(dto : DTOs.UpdateFavouriteClubDTO) : async Result.Result<(), T.Error> {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == main_canister_id;

    let managerBuffer = Buffer.fromArray<T.Manager>([]);
    let managerGroupIndex = managerGroupIndexes.get(dto.principalId);
    switch (managerGroupIndex) {
      case (null) {};
      case (?foundGroupIndex) {
        switch (foundGroupIndex) {
          case 0 {
            for (manager in Iter.fromArray(managerGroup1)) {
              if (manager.principalId == principalId) {
                managerBuffer.add(mergeManagerFavouriteClub(manager, dto.favouriteClubId));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup1 := Buffer.toArray(managerBuffer);
          };
          case 1 {
            for (manager in Iter.fromArray(managerGroup2)) {
              if (manager.principalId == principalId) {
                managerBuffer.add(mergeManagerFavouriteClub(manager, dto.favouriteClubId));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup2 := Buffer.toArray(managerBuffer);
          };
          case 2 {
            for (manager in Iter.fromArray(managerGroup3)) {
              if (manager.principalId == principalId) {
                managerBuffer.add(mergeManagerFavouriteClub(manager, dto.favouriteClubId));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup3 := Buffer.toArray(managerBuffer);
          };
          case 3 {
            for (manager in Iter.fromArray(managerGroup4)) {
              if (manager.principalId == principalId) {
                managerBuffer.add(mergeManagerFavouriteClub(manager, dto.favouriteClubId));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup4 := Buffer.toArray(managerBuffer);
          };
          case 4 {
            for (manager in Iter.fromArray(managerGroup5)) {
              if (manager.principalId == principalId) {
                managerBuffer.add(mergeManagerFavouriteClub(manager, dto.favouriteClubId));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup5 := Buffer.toArray(managerBuffer);
          };
          case 5 {
            for (manager in Iter.fromArray(managerGroup6)) {
              if (manager.principalId == principalId) {
                managerBuffer.add(mergeManagerFavouriteClub(manager, dto.favouriteClubId));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup6 := Buffer.toArray(managerBuffer);
          };
          case 6 {
            for (manager in Iter.fromArray(managerGroup7)) {
              if (manager.principalId == principalId) {
                managerBuffer.add(mergeManagerFavouriteClub(manager, dto.favouriteClubId));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup7 := Buffer.toArray(managerBuffer);
          };
          case 7 {
            for (manager in Iter.fromArray(managerGroup8)) {
              if (manager.principalId == principalId) {
                managerBuffer.add(mergeManagerFavouriteClub(manager, dto.favouriteClubId));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup8 := Buffer.toArray(managerBuffer);
          };
          case 8 {
            for (manager in Iter.fromArray(managerGroup9)) {
              if (manager.principalId == principalId) {
                managerBuffer.add(mergeManagerFavouriteClub(manager, dto.favouriteClubId));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup9 := Buffer.toArray(managerBuffer);
          };
          case 9 {
            for (manager in Iter.fromArray(managerGroup10)) {
              if (manager.principalId == principalId) {
                managerBuffer.add(mergeManagerFavouriteClub(manager, dto.favouriteClubId));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup10 := Buffer.toArray(managerBuffer);
          };
          case 10 {
            for (manager in Iter.fromArray(managerGroup11)) {
              if (manager.principalId == principalId) {
                managerBuffer.add(mergeManagerFavouriteClub(manager, dto.favouriteClubId));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup11 := Buffer.toArray(managerBuffer);
          };
          case 11 {
            for (manager in Iter.fromArray(managerGroup12)) {
              if (manager.principalId == principalId) {
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

  private func mergeManagerFavouriteClub(manager : T.Manager, favouriteClubId : T.ClubId) : T.Manager {
    return {
      principalId = manager.principalId;
      username = manager.username;
      termsAccepted = manager.termsAccepted;
      favouriteClubId = favouriteClubId;
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
    };
  };

  public shared ({ caller }) func getManager(managerPrincipal : Text) : async ?T.Manager {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == main_canister_id;

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
    let principalId = Principal.toText(caller);
    assert principalId == main_canister_id;

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

  public shared ({ caller }) func getGameweek38Snapshots(seasonId: T.SeasonId) : async [T.FantasyTeamSnapshot] {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == main_canister_id;

    let allManagersBuffer = Buffer.fromArray<T.FantasyTeamSnapshot>([]);
    for (index in Iter.range(0, 11)) {
      switch (index) {
        case 0 {
          for (manager in Iter.fromArray(managerGroup2)) {
            let currentSeason = List.filter<T.FantasyTeamSeason>(
              manager.history,
              func(season : T.FantasyTeamSeason) : Bool {
                return season.seasonId == seasonId;
              },
            );
            let gameweek38Snapshot = List.foldLeft<T.FantasyTeamSeason, ?T.FantasyTeamSnapshot>(
              currentSeason,
              null,
              getGameweek38,
            );
            switch (gameweek38Snapshot) {
              case (null) {};
              case (?foundSnapshot) {
                allManagersBuffer.add(foundSnapshot);
              };
            };
          };
        };
        case 1 {
          for (manager in Iter.fromArray(managerGroup2)) {
            let gameweek38Snapshot = List.foldLeft<T.FantasyTeamSeason, ?T.FantasyTeamSnapshot>(
              manager.history,
              null,
              getGameweek38,
            );
            switch (gameweek38Snapshot) {
              case (null) {};
              case (?foundSnapshot) {
                allManagersBuffer.add(foundSnapshot);
              };
            };
          };
        };
        case 2 {
          for (manager in Iter.fromArray(managerGroup3)) {
            let gameweek38Snapshot = List.foldLeft<T.FantasyTeamSeason, ?T.FantasyTeamSnapshot>(
              manager.history,
              null,
              getGameweek38,
            );
            switch (gameweek38Snapshot) {
              case (null) {};
              case (?foundSnapshot) {
                allManagersBuffer.add(foundSnapshot);
              };
            };
          };
        };
        case 3 {
          for (manager in Iter.fromArray(managerGroup4)) {
            let gameweek38Snapshot = List.foldLeft<T.FantasyTeamSeason, ?T.FantasyTeamSnapshot>(
              manager.history,
              null,
              getGameweek38,
            );
            switch (gameweek38Snapshot) {
              case (null) {};
              case (?foundSnapshot) {
                allManagersBuffer.add(foundSnapshot);
              };
            };
          };
        };
        case 4 {
          for (manager in Iter.fromArray(managerGroup5)) {
            let gameweek38Snapshot = List.foldLeft<T.FantasyTeamSeason, ?T.FantasyTeamSnapshot>(
              manager.history,
              null,
              getGameweek38,
            );
            switch (gameweek38Snapshot) {
              case (null) {};
              case (?foundSnapshot) {
                allManagersBuffer.add(foundSnapshot);
              };
            };
          };
        };
        case 5 {
          for (manager in Iter.fromArray(managerGroup6)) {
            let gameweek38Snapshot = List.foldLeft<T.FantasyTeamSeason, ?T.FantasyTeamSnapshot>(
              manager.history,
              null,
              getGameweek38,
            );
            switch (gameweek38Snapshot) {
              case (null) {};
              case (?foundSnapshot) {
                allManagersBuffer.add(foundSnapshot);
              };
            };
          };
        };
        case 6 {
          for (manager in Iter.fromArray(managerGroup7)) {
            let gameweek38Snapshot = List.foldLeft<T.FantasyTeamSeason, ?T.FantasyTeamSnapshot>(
              manager.history,
              null,
              getGameweek38,
            );
            switch (gameweek38Snapshot) {
              case (null) {};
              case (?foundSnapshot) {
                allManagersBuffer.add(foundSnapshot);
              };
            };
          };
        };
        case 7 {
          for (manager in Iter.fromArray(managerGroup8)) {
            let gameweek38Snapshot = List.foldLeft<T.FantasyTeamSeason, ?T.FantasyTeamSnapshot>(
              manager.history,
              null,
              getGameweek38,
            );
            switch (gameweek38Snapshot) {
              case (null) {};
              case (?foundSnapshot) {
                allManagersBuffer.add(foundSnapshot);
              };
            };
          };
        };
        case 8 {
          for (manager in Iter.fromArray(managerGroup9)) {
            let gameweek38Snapshot = List.foldLeft<T.FantasyTeamSeason, ?T.FantasyTeamSnapshot>(
              manager.history,
              null,
              getGameweek38,
            );
            switch (gameweek38Snapshot) {
              case (null) {};
              case (?foundSnapshot) {
                allManagersBuffer.add(foundSnapshot);
              };
            };
          };
        };
        case 9 {
          for (manager in Iter.fromArray(managerGroup10)) {
            let gameweek38Snapshot = List.foldLeft<T.FantasyTeamSeason, ?T.FantasyTeamSnapshot>(
              manager.history,
              null,
              getGameweek38,
            );
            switch (gameweek38Snapshot) {
              case (null) {};
              case (?foundSnapshot) {
                allManagersBuffer.add(foundSnapshot);
              };
            };
          };
        };
        case 10 {
          for (manager in Iter.fromArray(managerGroup11)) {
            let gameweek38Snapshot = List.foldLeft<T.FantasyTeamSeason, ?T.FantasyTeamSnapshot>(
              manager.history,
              null,
              getGameweek38,
            );
            switch (gameweek38Snapshot) {
              case (null) {};
              case (?foundSnapshot) {
                allManagersBuffer.add(foundSnapshot);
              };
            };
          };
        };
        case 11 {
          for (manager in Iter.fromArray(managerGroup12)) {
            let gameweek38Snapshot = List.foldLeft<T.FantasyTeamSeason, ?T.FantasyTeamSnapshot>(
              manager.history,
              null,
              getGameweek38,
            );
            switch (gameweek38Snapshot) {
              case (null) {};
              case (?foundSnapshot) {
                allManagersBuffer.add(foundSnapshot);
              };
            };
          };
        };
        case _ {

        };

      };
    };
    return Buffer.toArray(allManagersBuffer);
  };

  let getGameweek38 = func(acc : ?T.FantasyTeamSnapshot, season : T.FantasyTeamSeason) : ?T.FantasyTeamSnapshot {
    switch (acc) {
      case (?_) { acc };
      case null {
        List.find<T.FantasyTeamSnapshot>(
          season.gameweeks,
          func(snapshot) : Bool {
            snapshot.gameweek == 38;
          },
        );
      };
    };
  };

  public shared ({ caller }) func addNewManager(newManager : T.Manager) : async Result.Result<(), T.Error> {

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

    return #ok();
  };

  public shared ({ caller }) func updateSnapshotPoints(principalId : Text, seasonId : Nat16, gameweek : Nat8, teamPoints : Int16, teamValueQuarterMillions : Nat16) : () {

    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == main_canister_id;

    let managerBuffer = Buffer.fromArray<T.Manager>([]);
    let managerGroupIndex = managerGroupIndexes.get(principalId);
    switch (managerGroupIndex) {
      case (null) {};
      case (?foundGroupIndex) {
        switch (foundGroupIndex) {
          case 0 {
            for (manager in Iter.fromArray(managerGroup1)) {
              if (manager.principalId == principalId) {
                let teamHistoryBuffer = Buffer.fromArray<T.FantasyTeamSeason>([]);

                switch (manager.history) {
                  case (null) {
                    teamHistoryBuffer.add({
                      seasonId = seasonId;
                      totalPoints = teamPoints;
                      gameweeks = List.fromArray([mergeManagerSnapshot(manager, gameweek, teamPoints, teamValueQuarterMillions)]);
                    });
                    managerBuffer.add(mergeManagerHistory(manager, List.fromArray(Buffer.toArray(teamHistoryBuffer))));
                  };
                  case (existingHistory) {
                    let updatedHistory = mergeExistingHistory(existingHistory, mergeManagerSnapshot(manager, gameweek, teamPoints, teamValueQuarterMillions), seasonId, gameweek, manager, teamPoints, teamValueQuarterMillions);
                    managerBuffer.add(mergeManagerHistory(manager, updatedHistory));
                  };
                };

              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup1 := Buffer.toArray(managerBuffer);
          };
          case 1 {
            for (manager in Iter.fromArray(managerGroup2)) {
              if (manager.principalId == principalId) {
                let teamHistoryBuffer = Buffer.fromArray<T.FantasyTeamSeason>([]);

                switch (manager.history) {
                  case (null) {
                    teamHistoryBuffer.add({
                      seasonId = seasonId;
                      totalPoints = teamPoints;
                      gameweeks = List.fromArray([mergeManagerSnapshot(manager, gameweek, teamPoints, teamValueQuarterMillions)]);
                    });
                    managerBuffer.add(mergeManagerHistory(manager, List.fromArray(Buffer.toArray(teamHistoryBuffer))));
                  };
                  case (existingHistory) {
                    let updatedHistory = mergeExistingHistory(existingHistory, mergeManagerSnapshot(manager, gameweek, teamPoints, teamValueQuarterMillions), seasonId, gameweek, manager, teamPoints, teamValueQuarterMillions);
                    managerBuffer.add(mergeManagerHistory(manager, updatedHistory));
                  };
                };

              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup2 := Buffer.toArray(managerBuffer);
          };
          case 2 {
            for (manager in Iter.fromArray(managerGroup3)) {
              if (manager.principalId == principalId) {
                let teamHistoryBuffer = Buffer.fromArray<T.FantasyTeamSeason>([]);

                switch (manager.history) {
                  case (null) {
                    teamHistoryBuffer.add({
                      seasonId = seasonId;
                      totalPoints = teamPoints;
                      gameweeks = List.fromArray([mergeManagerSnapshot(manager, gameweek, teamPoints, teamValueQuarterMillions)]);
                    });
                    managerBuffer.add(mergeManagerHistory(manager, List.fromArray(Buffer.toArray(teamHistoryBuffer))));
                  };
                  case (existingHistory) {
                    let updatedHistory = mergeExistingHistory(existingHistory, mergeManagerSnapshot(manager, gameweek, teamPoints, teamValueQuarterMillions), seasonId, gameweek, manager, teamPoints, teamValueQuarterMillions);
                    managerBuffer.add(mergeManagerHistory(manager, updatedHistory));
                  };
                };

              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup3 := Buffer.toArray(managerBuffer);
          };
          case 3 {
            for (manager in Iter.fromArray(managerGroup4)) {
              if (manager.principalId == principalId) {
                let teamHistoryBuffer = Buffer.fromArray<T.FantasyTeamSeason>([]);

                switch (manager.history) {
                  case (null) {
                    teamHistoryBuffer.add({
                      seasonId = seasonId;
                      totalPoints = teamPoints;
                      gameweeks = List.fromArray([mergeManagerSnapshot(manager, gameweek, teamPoints, teamValueQuarterMillions)]);
                    });
                    managerBuffer.add(mergeManagerHistory(manager, List.fromArray(Buffer.toArray(teamHistoryBuffer))));
                  };
                  case (existingHistory) {
                    let updatedHistory = mergeExistingHistory(existingHistory, mergeManagerSnapshot(manager, gameweek, teamPoints, teamValueQuarterMillions), seasonId, gameweek, manager, teamPoints, teamValueQuarterMillions);
                    managerBuffer.add(mergeManagerHistory(manager, updatedHistory));
                  };
                };

              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup4 := Buffer.toArray(managerBuffer);
          };
          case 4 {
            for (manager in Iter.fromArray(managerGroup5)) {
              if (manager.principalId == principalId) {
                let teamHistoryBuffer = Buffer.fromArray<T.FantasyTeamSeason>([]);

                switch (manager.history) {
                  case (null) {
                    teamHistoryBuffer.add({
                      seasonId = seasonId;
                      totalPoints = teamPoints;
                      gameweeks = List.fromArray([mergeManagerSnapshot(manager, gameweek, teamPoints, teamValueQuarterMillions)]);
                    });
                    managerBuffer.add(mergeManagerHistory(manager, List.fromArray(Buffer.toArray(teamHistoryBuffer))));
                  };
                  case (existingHistory) {
                    let updatedHistory = mergeExistingHistory(existingHistory, mergeManagerSnapshot(manager, gameweek, teamPoints, teamValueQuarterMillions), seasonId, gameweek, manager, teamPoints, teamValueQuarterMillions);
                    managerBuffer.add(mergeManagerHistory(manager, updatedHistory));
                  };
                };

              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup5 := Buffer.toArray(managerBuffer);
          };
          case 5 {
            for (manager in Iter.fromArray(managerGroup6)) {
              if (manager.principalId == principalId) {
                let teamHistoryBuffer = Buffer.fromArray<T.FantasyTeamSeason>([]);

                switch (manager.history) {
                  case (null) {
                    teamHistoryBuffer.add({
                      seasonId = seasonId;
                      totalPoints = teamPoints;
                      gameweeks = List.fromArray([mergeManagerSnapshot(manager, gameweek, teamPoints, teamValueQuarterMillions)]);
                    });
                    managerBuffer.add(mergeManagerHistory(manager, List.fromArray(Buffer.toArray(teamHistoryBuffer))));
                  };
                  case (existingHistory) {
                    let updatedHistory = mergeExistingHistory(existingHistory, mergeManagerSnapshot(manager, gameweek, teamPoints, teamValueQuarterMillions), seasonId, gameweek, manager, teamPoints, teamValueQuarterMillions);
                    managerBuffer.add(mergeManagerHistory(manager, updatedHistory));
                  };
                };

              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup6 := Buffer.toArray(managerBuffer);
          };
          case 6 {
            for (manager in Iter.fromArray(managerGroup7)) {
              if (manager.principalId == principalId) {
                let teamHistoryBuffer = Buffer.fromArray<T.FantasyTeamSeason>([]);

                switch (manager.history) {
                  case (null) {
                    teamHistoryBuffer.add({
                      seasonId = seasonId;
                      totalPoints = teamPoints;
                      gameweeks = List.fromArray([mergeManagerSnapshot(manager, gameweek, teamPoints, teamValueQuarterMillions)]);
                    });
                    managerBuffer.add(mergeManagerHistory(manager, List.fromArray(Buffer.toArray(teamHistoryBuffer))));
                  };
                  case (existingHistory) {
                    let updatedHistory = mergeExistingHistory(existingHistory, mergeManagerSnapshot(manager, gameweek, teamPoints, teamValueQuarterMillions), seasonId, gameweek, manager, teamPoints, teamValueQuarterMillions);
                    managerBuffer.add(mergeManagerHistory(manager, updatedHistory));
                  };
                };

              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup7 := Buffer.toArray(managerBuffer);
          };
          case 7 {
            for (manager in Iter.fromArray(managerGroup8)) {
              if (manager.principalId == principalId) {
                let teamHistoryBuffer = Buffer.fromArray<T.FantasyTeamSeason>([]);

                switch (manager.history) {
                  case (null) {
                    teamHistoryBuffer.add({
                      seasonId = seasonId;
                      totalPoints = teamPoints;
                      gameweeks = List.fromArray([mergeManagerSnapshot(manager, gameweek, teamPoints, teamValueQuarterMillions)]);
                    });
                    managerBuffer.add(mergeManagerHistory(manager, List.fromArray(Buffer.toArray(teamHistoryBuffer))));
                  };
                  case (existingHistory) {
                    let updatedHistory = mergeExistingHistory(existingHistory, mergeManagerSnapshot(manager, gameweek, teamPoints, teamValueQuarterMillions), seasonId, gameweek, manager, teamPoints, teamValueQuarterMillions);
                    managerBuffer.add(mergeManagerHistory(manager, updatedHistory));
                  };
                };

              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup8 := Buffer.toArray(managerBuffer);
          };
          case 8 {
            for (manager in Iter.fromArray(managerGroup9)) {
              if (manager.principalId == principalId) {
                let teamHistoryBuffer = Buffer.fromArray<T.FantasyTeamSeason>([]);

                switch (manager.history) {
                  case (null) {
                    teamHistoryBuffer.add({
                      seasonId = seasonId;
                      totalPoints = teamPoints;
                      gameweeks = List.fromArray([mergeManagerSnapshot(manager, gameweek, teamPoints, teamValueQuarterMillions)]);
                    });
                    managerBuffer.add(mergeManagerHistory(manager, List.fromArray(Buffer.toArray(teamHistoryBuffer))));
                  };
                  case (existingHistory) {
                    let updatedHistory = mergeExistingHistory(existingHistory, mergeManagerSnapshot(manager, gameweek, teamPoints, teamValueQuarterMillions), seasonId, gameweek, manager, teamPoints, teamValueQuarterMillions);
                    managerBuffer.add(mergeManagerHistory(manager, updatedHistory));
                  };
                };

              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup9 := Buffer.toArray(managerBuffer);
          };
          case 9 {
            for (manager in Iter.fromArray(managerGroup10)) {
              if (manager.principalId == principalId) {
                let teamHistoryBuffer = Buffer.fromArray<T.FantasyTeamSeason>([]);

                switch (manager.history) {
                  case (null) {
                    teamHistoryBuffer.add({
                      seasonId = seasonId;
                      totalPoints = teamPoints;
                      gameweeks = List.fromArray([mergeManagerSnapshot(manager, gameweek, teamPoints, teamValueQuarterMillions)]);
                    });
                    managerBuffer.add(mergeManagerHistory(manager, List.fromArray(Buffer.toArray(teamHistoryBuffer))));
                  };
                  case (existingHistory) {
                    let updatedHistory = mergeExistingHistory(existingHistory, mergeManagerSnapshot(manager, gameweek, teamPoints, teamValueQuarterMillions), seasonId, gameweek, manager, teamPoints, teamValueQuarterMillions);
                    managerBuffer.add(mergeManagerHistory(manager, updatedHistory));
                  };
                };

              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup10 := Buffer.toArray(managerBuffer);
          };
          case 10 {
            for (manager in Iter.fromArray(managerGroup11)) {
              if (manager.principalId == principalId) {

                let teamHistoryBuffer = Buffer.fromArray<T.FantasyTeamSeason>([]);

                switch (manager.history) {
                  case (null) {
                    teamHistoryBuffer.add({
                      seasonId = seasonId;
                      totalPoints = teamPoints;
                      gameweeks = List.fromArray([mergeManagerSnapshot(manager, gameweek, teamPoints, teamValueQuarterMillions)]);
                    });
                    managerBuffer.add(mergeManagerHistory(manager, List.fromArray(Buffer.toArray(teamHistoryBuffer))));
                  };
                  case (existingHistory) {
                    let updatedHistory = mergeExistingHistory(existingHistory, mergeManagerSnapshot(manager, gameweek, teamPoints, teamValueQuarterMillions), seasonId, gameweek, manager, teamPoints, teamValueQuarterMillions);
                    managerBuffer.add(mergeManagerHistory(manager, updatedHistory));
                  };
                };

              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup11 := Buffer.toArray(managerBuffer);
          };
          case 11 {
            for (manager in Iter.fromArray(managerGroup12)) {
              if (manager.principalId == principalId) {
                let teamHistoryBuffer = Buffer.fromArray<T.FantasyTeamSeason>([]);

                switch (manager.history) {
                  case (null) {
                    teamHistoryBuffer.add({
                      seasonId = seasonId;
                      totalPoints = teamPoints;
                      gameweeks = List.fromArray([mergeManagerSnapshot(manager, gameweek, teamPoints, teamValueQuarterMillions)]);
                    });
                    managerBuffer.add(mergeManagerHistory(manager, List.fromArray(Buffer.toArray(teamHistoryBuffer))));
                  };
                  case (existingHistory) {
                    let updatedHistory = mergeExistingHistory(existingHistory, mergeManagerSnapshot(manager, gameweek, teamPoints, teamValueQuarterMillions), seasonId, gameweek, manager, teamPoints, teamValueQuarterMillions);
                    managerBuffer.add(mergeManagerHistory(manager, updatedHistory));
                  };
                };

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
  };

  private func mergeManagerSnapshot(manager : T.Manager, gameweek : T.GameweekNumber, points : Int16, teamValueQuarterMillions : Nat16) : T.FantasyTeamSnapshot {
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
      profilePicture = manager.profilePicture;
      gameweek = gameweek;
      points = points;
      monthlyPoints = manager.monthlyPoints + points;
      seasonPoints = manager.seasonPoints + points;
      teamValueQuarterMillions = teamValueQuarterMillions;
    };
  };

  private func mergeExistingHistory(existingHistory : List.List<T.FantasyTeamSeason>, fantasyTeamSnapshot : T.FantasyTeamSnapshot, seasonId : T.SeasonId, gameweek : T.GameweekNumber, manager : T.Manager, teamPoints : Int16, teamValueQuarterMillions : Nat16) : List.List<T.FantasyTeamSeason> {

    let teamHistoryBuffer = Buffer.fromArray<T.FantasyTeamSeason>([]);

    for (season in List.toIter<T.FantasyTeamSeason>(existingHistory)) {
      if (season.seasonId == seasonId) {
        let snapshotBuffer = Buffer.fromArray<T.FantasyTeamSnapshot>([]);

        for (snapshot in List.toIter<T.FantasyTeamSnapshot>(season.gameweeks)) {
          if (snapshot.gameweek == gameweek) {
            snapshotBuffer.add(mergeManagerSnapshot(manager, gameweek, teamPoints, teamValueQuarterMillions));
          } else { snapshotBuffer.add(snapshot) };
        };

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
    };
  };

  public func removePlayerFromTeams(playerId : T.PlayerId, allPlayers : [DTOs.PlayerDTO]) : async () {

    for (index in Iter.range(0, 11)) {
      switch (index) {
        case 0 {
          managerGroup1 := removePlayerFromGroup(playerId, managerGroup1, allPlayers);
        };
        case 1 {
          managerGroup2 := removePlayerFromGroup(playerId, managerGroup2, allPlayers);
        };
        case 2 {
          managerGroup3 := removePlayerFromGroup(playerId, managerGroup3, allPlayers);
        };
        case 3 {
          managerGroup4 := removePlayerFromGroup(playerId, managerGroup4, allPlayers);
        };
        case 4 {
          managerGroup5 := removePlayerFromGroup(playerId, managerGroup5, allPlayers);
        };
        case 5 {
          managerGroup6 := removePlayerFromGroup(playerId, managerGroup6, allPlayers);
        };
        case 6 {
          managerGroup7 := removePlayerFromGroup(playerId, managerGroup7, allPlayers);
        };
        case 7 {
          managerGroup8 := removePlayerFromGroup(playerId, managerGroup8, allPlayers);
        };
        case 8 {
          managerGroup9 := removePlayerFromGroup(playerId, managerGroup9, allPlayers);
        };
        case 9 {
          managerGroup10 := removePlayerFromGroup(playerId, managerGroup10, allPlayers);
        };
        case 10 {
          managerGroup11 := removePlayerFromGroup(playerId, managerGroup11, allPlayers);
        };
        case 11 {
          managerGroup12 := removePlayerFromGroup(playerId, managerGroup12, allPlayers);
        };
        case _ {};
      };
    };

  };

  private func removePlayerFromGroup(removePlayerId : T.PlayerId, managers : [T.Manager], allPlayers : [DTOs.PlayerDTO]) : [T.Manager] {

    let removedPlayer = Array.find<DTOs.PlayerDTO>(allPlayers, func(p) { p.id == removePlayerId });

    switch (removedPlayer) {
      case (null) {};
      case (?foundRemovedPlayer) {
        let playerValue = foundRemovedPlayer.valueQuarterMillions;
        let managerBuffer = Buffer.fromArray<T.Manager>([]);
        for (manager in Iter.fromArray(managers)) {
          let playerIdBuffer = Buffer.fromArray<T.PlayerId>([]);
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
            if(captainId == removePlayerId){
              let highestValuedPlayer = Array.foldLeft<T.PlayerId, ?DTOs.PlayerDTO>(
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
              countrymenGameweek = manager.countrymenGameweek;
              countrymenCountryId = manager.countrymenCountryId;
              prospectsGameweek = manager.prospectsGameweek;
              braceBonusGameweek = manager.braceBonusGameweek;
              hatTrickHeroGameweek = manager.hatTrickHeroGameweek;
              transferWindowGameweek = manager.transferWindowGameweek;
              createDate = manager.createDate;
              history = manager.history;
              monthlyBonusesAvailable = manager.monthlyBonusesAvailable;
              profilePicture = manager.profilePicture;
              transfersAvailable = manager.transfersAvailable;
            };

            managerBuffer.add(newManager);
          } else {
            managerBuffer.add(manager);
          };
        };
        return Buffer.toArray(managerBuffer);
      };
    };

    return managers;
  };

  public shared ({caller}) func calculateFantasyTeamScores(allPlayersList : [(T.PlayerId, DTOs.PlayerScoreDTO)], allPlayers: [DTOs.PlayerDTO], seasonId : T.SeasonId, gameweek : T.GameweekNumber) : async (){
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == main_canister_id;

    let playerIdTrie: TrieMap.TrieMap<T.PlayerId, DTOs.PlayerScoreDTO> = TrieMap.TrieMap<T.PlayerId, DTOs.PlayerScoreDTO>(Utilities.eqNat16, Utilities.hashNat16);
    for (player in Iter.fromArray(allPlayersList)){
      playerIdTrie.put(player.0, player.1)
    };

    for(index in Iter.range(0,11)){
      var managers: [T.Manager] = [];
      var managersBuffer = Buffer.fromArray<T.Manager>([]);
      switch(index){
        case 0{
          managers := managerGroup1;
        };
        case 1{
          managers := managerGroup2;
        };
        case 2{
          managers := managerGroup3;
        };
        case 3{
          managers := managerGroup4;
        };
        case 4{
          managers := managerGroup5;
        };
        case 5{
          managers := managerGroup6;
        };
        case 6{
          managers := managerGroup7;
        };
        case 7{
          managers := managerGroup8;
        };
        case 8{
          managers := managerGroup9;
        };
        case 9{
          managers := managerGroup10;
        };
        case 10{
          managers := managerGroup11;
        };
        case 11{
          managers := managerGroup12;
        };
        case _ {}
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
               
                updateSnapshotPoints(value.principalId, seasonId, gameweek, totalTeamPoints, totalTeamValue);
              };
            };
          };
        };
      }; 
    }
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

  public shared ({ caller }) func getTotalManagers() : async Nat{
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == main_canister_id;
    return totalManagers;
  };

  public shared ({ caller }) func snapshotFantasyTeams (seasonId : T.SeasonId, gameweek : T.GameweekNumber, players: [DTOs.PlayerDTO]) : async (){
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == main_canister_id;
    
    for(index in Iter.range(0,11)){
      switch(index){
        case 0{
          managerGroup1 := snapshotManagers(managerGroup1, seasonId, gameweek, players);
        };
        case 1{
          managerGroup2 := snapshotManagers(managerGroup2, seasonId, gameweek, players);
        };
        case 2{
          managerGroup3 := snapshotManagers(managerGroup3, seasonId, gameweek, players);
        };
        case 3{
          managerGroup4 := snapshotManagers(managerGroup4, seasonId, gameweek, players);
        };
        case 4{
          managerGroup5 := snapshotManagers(managerGroup5, seasonId, gameweek, players);
        };
        case 5{
          managerGroup6 := snapshotManagers(managerGroup6, seasonId, gameweek, players);
        };
        case 6{
          managerGroup7 := snapshotManagers(managerGroup7, seasonId, gameweek, players);
        };
        case 7{
          managerGroup8 := snapshotManagers(managerGroup8, seasonId, gameweek, players);
        };
        case 8{
          managerGroup9 := snapshotManagers(managerGroup9, seasonId, gameweek, players);
        };
        case 9{
          managerGroup10 := snapshotManagers(managerGroup10, seasonId, gameweek, players);
        };
        case 10{
          managerGroup11 := snapshotManagers(managerGroup11, seasonId, gameweek, players);
        };
        case 11{
          managerGroup12 := snapshotManagers(managerGroup12, seasonId, gameweek, players);
        };
        case _ {

        }
      }
    };
  };

  private func snapshotManagers(managers: [T.Manager], seasonId : T.SeasonId, gameweek : T.GameweekNumber, players: [DTOs.PlayerDTO]) : [T.Manager]{
    let managerBuffer = Buffer.fromArray<T.Manager>([]);
    for(manager in Iter.fromArray(managers)){

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

            let allPlayers = Array.filter<DTOs.PlayerDTO>(
              players,
              func(player : DTOs.PlayerDTO) : Bool {
                let playerId = player.id;
                let isPlayerIdInNewTeam = Array.find(
                  manager.playerIds,
                  func(id : Nat16) : Bool {
                    return id == playerId;
                  },
                );
                return Option.isSome(isPlayerIdInNewTeam);
              },
            );
            let allPlayerValues = Array.map<DTOs.PlayerDTO, Nat16>(allPlayers, func(player : DTOs.PlayerDTO) : Nat16 { return player.valueQuarterMillions });
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

      let updatedManager: T.Manager = {

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
        history = updatedSeasons;
        profilePicture = manager.profilePicture;
      };
      managerBuffer.add(updatedManager);
    };
    return Buffer.toArray(managerBuffer);
  };

  public shared ({ caller }) func resetBonusesAvailable (seasonId : T.SeasonId) : async (){
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == main_canister_id;
    
    for(index in Iter.range(0,11)){
      switch(index){
        case 0{
          managerGroup1 := resetManagerBonuses(managerGroup1, seasonId);
        };
        case 1{
          managerGroup2 := resetManagerBonuses(managerGroup2, seasonId);
        };
        case 2{
          managerGroup3 := resetManagerBonuses(managerGroup3, seasonId);
        };
        case 3{
          managerGroup4 := resetManagerBonuses(managerGroup4, seasonId);
        };
        case 4{
          managerGroup5 := resetManagerBonuses(managerGroup5, seasonId);
        };
        case 5{
          managerGroup6 := resetManagerBonuses(managerGroup6, seasonId);
        };
        case 6{
          managerGroup7 := resetManagerBonuses(managerGroup7, seasonId);
        };
        case 7{
          managerGroup8 := resetManagerBonuses(managerGroup8, seasonId);
        };
        case 8{
          managerGroup9 := resetManagerBonuses(managerGroup9, seasonId);
        };
        case 9{
          managerGroup10 := resetManagerBonuses(managerGroup10, seasonId);
        };
        case 10{
          managerGroup11 := resetManagerBonuses(managerGroup11, seasonId);
        };
        case 11{
          managerGroup12 := resetManagerBonuses(managerGroup12, seasonId);
        };
        case _ {

        }
      }
    };
  };

  private func resetManagerBonuses(managers: [T.Manager], seasonId : T.SeasonId) : [T.Manager]{
    let managerBuffer = Buffer.fromArray<T.Manager>([]);
    for(manager in Iter.fromArray(managers)){


      let updatedManager: T.Manager = {
        principalId = manager.principalId;
        username = manager.username;
        termsAccepted = manager.termsAccepted;
        favouriteClubId = manager.favouriteClubId;
        createDate = manager.createDate;
        history = manager.history;
        profilePicture = manager.profilePicture;
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
      };
      managerBuffer.add(updatedManager);
    };
    return Buffer.toArray(managerBuffer);
  };

  public shared ({ caller }) func resetFantasyTeams (seasonId : T.SeasonId) : async (){
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == main_canister_id;
    
    for(index in Iter.range(0,11)){
      switch(index){
        case 0{
          managerGroup1 := resetManagers(managerGroup1, seasonId);
        };
        case 1{
          managerGroup2 := resetManagers(managerGroup2, seasonId);
        };
        case 2{
          managerGroup3 := resetManagers(managerGroup3, seasonId);
        };
        case 3{
          managerGroup4 := resetManagers(managerGroup4, seasonId);
        };
        case 4{
          managerGroup5 := resetManagers(managerGroup5, seasonId);
        };
        case 5{
          managerGroup6 := resetManagers(managerGroup6, seasonId);
        };
        case 6{
          managerGroup7 := resetManagers(managerGroup7, seasonId);
        };
        case 7{
          managerGroup8 := resetManagers(managerGroup8, seasonId);
        };
        case 8{
          managerGroup9 := resetManagers(managerGroup9, seasonId);
        };
        case 9{
          managerGroup10 := resetManagers(managerGroup10, seasonId);
        };
        case 10{
          managerGroup11 := resetManagers(managerGroup11, seasonId);
        };
        case 11{
          managerGroup12 := resetManagers(managerGroup12, seasonId);
        };
        case _ {

        }
      }
    };
  };

  private func resetManagers(managers: [T.Manager], seasonId : T.SeasonId) : [T.Manager]{
    let managerBuffer = Buffer.fromArray<T.Manager>([]);
    for(manager in Iter.fromArray(managers)){
      let updatedManager: T.Manager = {
        principalId = manager.principalId;
        username = manager.username;
        termsAccepted = manager.termsAccepted;
        favouriteClubId = manager.favouriteClubId;
        createDate = manager.createDate;
        history = manager.history;
        profilePicture = manager.profilePicture;
        transfersAvailable = 3;
        monthlyBonusesAvailable = 2;
        bankQuarterMillions = 1200;
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
        countrymenGameweek = 0;
        countrymenCountryId = 0;
        prospectsGameweek = 0;
        braceBonusGameweek = 0;
        hatTrickHeroGameweek = 0;
        transferWindowGameweek = 0;
      };
      managerBuffer.add(updatedManager);
    };
    return Buffer.toArray(managerBuffer);
  };

  public shared ({ caller }) func resetWeeklyTransfers () : async (){
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == main_canister_id;
    
    for(index in Iter.range(0,11)){
      switch(index){
        case 0{
          managerGroup1 := resetManagerWeeklyTransfers(managerGroup1);
        };
        case 1{
          managerGroup2 := resetManagerWeeklyTransfers(managerGroup2);
        };
        case 2{
          managerGroup3 := resetManagerWeeklyTransfers(managerGroup3);
        };
        case 3{
          managerGroup4 := resetManagerWeeklyTransfers(managerGroup4);
        };
        case 4{
          managerGroup5 := resetManagerWeeklyTransfers(managerGroup5);
        };
        case 5{
          managerGroup6 := resetManagerWeeklyTransfers(managerGroup6);
        };
        case 6{
          managerGroup7 := resetManagerWeeklyTransfers(managerGroup7);
        };
        case 7{
          managerGroup8 := resetManagerWeeklyTransfers(managerGroup8);
        };
        case 8{
          managerGroup9 := resetManagerWeeklyTransfers(managerGroup9);
        };
        case 9{
          managerGroup10 := resetManagerWeeklyTransfers(managerGroup10);
        };
        case 10{
          managerGroup11 := resetManagerWeeklyTransfers(managerGroup11);
        };
        case 11{
          managerGroup12 := resetManagerWeeklyTransfers(managerGroup12);
        };
        case _ {

        }
      }
    };
  };

  private func resetManagerWeeklyTransfers(managers: [T.Manager]) : [T.Manager]{
    let managerBuffer = Buffer.fromArray<T.Manager>([]);
    for(manager in Iter.fromArray(managers)){
      let updatedManager: T.Manager = {
        principalId = manager.principalId;
        username = manager.username;
        termsAccepted = manager.termsAccepted;
        favouriteClubId = manager.favouriteClubId;
        createDate = manager.createDate;
        history = manager.history;
        profilePicture = manager.profilePicture;
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
      };
      managerBuffer.add(updatedManager);
    };
    return Buffer.toArray(managerBuffer);
  };

  public shared ({ caller }) func getClubManagers (clubId : T.ClubId) : async [T.PrincipalId]{
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == main_canister_id;
    
    let clubManagerIdBuffer = Buffer.fromArray<T.PrincipalId>([]);

    for(index in Iter.range(0,11)){
      switch(index){
        case 0{
          let clubManagerIds = getGroupClubManagerIds(managerGroup1, clubId);
          for(managerId in Iter.fromArray(clubManagerIds)){
            clubManagerIdBuffer.add(managerId);
          }
        };
        case 1{
          let clubManagerIds = getGroupClubManagerIds(managerGroup2, clubId);
          for(managerId in Iter.fromArray(clubManagerIds)){
            clubManagerIdBuffer.add(managerId);
          }
        };
        case 2{
          let clubManagerIds = getGroupClubManagerIds(managerGroup3, clubId);
          for(managerId in Iter.fromArray(clubManagerIds)){
            clubManagerIdBuffer.add(managerId);
          }
        };
        case 3{
          let clubManagerIds = getGroupClubManagerIds(managerGroup4, clubId);
          for(managerId in Iter.fromArray(clubManagerIds)){
            clubManagerIdBuffer.add(managerId);
          }
        };
        case 4{
          let clubManagerIds = getGroupClubManagerIds(managerGroup5, clubId);
          for(managerId in Iter.fromArray(clubManagerIds)){
            clubManagerIdBuffer.add(managerId);
          }
        };
        case 5{
          let clubManagerIds = getGroupClubManagerIds(managerGroup6, clubId);
          for(managerId in Iter.fromArray(clubManagerIds)){
            clubManagerIdBuffer.add(managerId);
          }
        };
        case 6{
          let clubManagerIds = getGroupClubManagerIds(managerGroup7, clubId);
          for(managerId in Iter.fromArray(clubManagerIds)){
            clubManagerIdBuffer.add(managerId);
          }
        };
        case 7{
          let clubManagerIds = getGroupClubManagerIds(managerGroup8, clubId);
          for(managerId in Iter.fromArray(clubManagerIds)){
            clubManagerIdBuffer.add(managerId);
          }
        };
        case 8{
          let clubManagerIds = getGroupClubManagerIds(managerGroup9, clubId);
          for(managerId in Iter.fromArray(clubManagerIds)){
            clubManagerIdBuffer.add(managerId);
          }
        };
        case 9{
          let clubManagerIds = getGroupClubManagerIds(managerGroup10, clubId);
          for(managerId in Iter.fromArray(clubManagerIds)){
            clubManagerIdBuffer.add(managerId);
          }
        };
        case 10{
          let clubManagerIds = getGroupClubManagerIds(managerGroup11, clubId);
          for(managerId in Iter.fromArray(clubManagerIds)){
            clubManagerIdBuffer.add(managerId);
          }
        };
        case 11{
          let clubManagerIds = getGroupClubManagerIds(managerGroup12, clubId);
          for(managerId in Iter.fromArray(clubManagerIds)){
            clubManagerIdBuffer.add(managerId);
          }
        };
        case _ {

        }
      }
    };
    
    return Buffer.toArray(clubManagerIdBuffer);
  };

  private func getGroupClubManagerIds(managers: [T.Manager], clubId : T.ClubId) : [T.PrincipalId]{
    let managerIdBuffer = Buffer.fromArray<T.PrincipalId>([]);
    for(manager in Iter.fromArray(managers)){
      if(manager.favouriteClubId == clubId){
        managerIdBuffer.add(manager.principalId);
      };
    };
    return Buffer.toArray(managerIdBuffer);
  };

  public shared ({ caller }) func getNonClubManagers (clubId : T.ClubId) : async Nat{
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == main_canister_id;
    
    let clubManagerIdBuffer = Buffer.fromArray<T.PrincipalId>([]);

    for(index in Iter.range(0,11)){
      switch(index){
        case 0{
          let clubManagerIds = getGroupNonClubManagerIds(managerGroup1, clubId);
          for(managerId in Iter.fromArray(clubManagerIds)){
            clubManagerIdBuffer.add(managerId);
          }
        };
        case 1{
          let clubManagerIds = getGroupNonClubManagerIds(managerGroup2, clubId);
          for(managerId in Iter.fromArray(clubManagerIds)){
            clubManagerIdBuffer.add(managerId);
          }
        };
        case 2{
          let clubManagerIds = getGroupNonClubManagerIds(managerGroup3, clubId);
          for(managerId in Iter.fromArray(clubManagerIds)){
            clubManagerIdBuffer.add(managerId);
          }
        };
        case 3{
          let clubManagerIds = getGroupNonClubManagerIds(managerGroup4, clubId);
          for(managerId in Iter.fromArray(clubManagerIds)){
            clubManagerIdBuffer.add(managerId);
          }
        };
        case 4{
          let clubManagerIds = getGroupNonClubManagerIds(managerGroup5, clubId);
          for(managerId in Iter.fromArray(clubManagerIds)){
            clubManagerIdBuffer.add(managerId);
          }
        };
        case 5{
          let clubManagerIds = getGroupNonClubManagerIds(managerGroup6, clubId);
          for(managerId in Iter.fromArray(clubManagerIds)){
            clubManagerIdBuffer.add(managerId);
          }
        };
        case 6{
          let clubManagerIds = getGroupNonClubManagerIds(managerGroup7, clubId);
          for(managerId in Iter.fromArray(clubManagerIds)){
            clubManagerIdBuffer.add(managerId);
          }
        };
        case 7{
          let clubManagerIds = getGroupNonClubManagerIds(managerGroup8, clubId);
          for(managerId in Iter.fromArray(clubManagerIds)){
            clubManagerIdBuffer.add(managerId);
          }
        };
        case 8{
          let clubManagerIds = getGroupNonClubManagerIds(managerGroup9, clubId);
          for(managerId in Iter.fromArray(clubManagerIds)){
            clubManagerIdBuffer.add(managerId);
          }
        };
        case 9{
          let clubManagerIds = getGroupNonClubManagerIds(managerGroup10, clubId);
          for(managerId in Iter.fromArray(clubManagerIds)){
            clubManagerIdBuffer.add(managerId);
          }
        };
        case 10{
          let clubManagerIds = getGroupNonClubManagerIds(managerGroup11, clubId);
          for(managerId in Iter.fromArray(clubManagerIds)){
            clubManagerIdBuffer.add(managerId);
          }
        };
        case 11{
          let clubManagerIds = getGroupNonClubManagerIds(managerGroup12, clubId);
          for(managerId in Iter.fromArray(clubManagerIds)){
            clubManagerIdBuffer.add(managerId);
          }
        };
        case _ {

        }
      }
    };
    
    return clubManagerIdBuffer.size();
    
  };

  private func getGroupNonClubManagerIds(managers: [T.Manager], clubId : T.ClubId) : [T.PrincipalId]{
    let managerIdBuffer = Buffer.fromArray<T.PrincipalId>([]);
    for(manager in Iter.fromArray(managers)){
      if(manager.favouriteClubId != clubId and manager.favouriteClubId > 0){
        managerIdBuffer.add(manager.principalId);
      };
    };
    return Buffer.toArray(managerIdBuffer);
  };

  public shared ({ caller }) func getMostValuableTeams (players: [DTOs.PlayerDTO], seasonId: T.SeasonId) : async [T.FantasyTeamSnapshot]{
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == main_canister_id;

    let allFinalGameweekSnapshots = await getGameweek38Snapshots(seasonId);

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

      let updatedSnapshot: T.FantasyTeamSnapshot = {
       
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
    var lastScore: Int16 = 0;

    let snapshotBuffer = Buffer.fromArray<T.FantasyTeamSnapshot>([]);
    label teamLoop for(team in Iter.fromArray(sortedTeamValuesArray)){
      if(counter >= 100 and team.1.points < lastScore){
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
    setCheckCyclesTimer();
  };

  private func checkCanisterCycles() : async () {

    let balance = Cycles.balance();

    if (balance < 2_000_000_000_000) {
      let openfpl_backend_canister = actor (main_canister_id) : actor {
        requestCanisterTopup : () -> async ();
      };
      await openfpl_backend_canister.requestCanisterTopup();
    };
    setCheckCyclesTimer();
  };

  private func setCheckCyclesTimer() {
    switch (cyclesCheckTimerId) {
      case (null) {};
      case (?id) {
        Timer.cancelTimer(id);
        cyclesCheckTimerId := null;
      };
    };
    cyclesCheckTimerId := ?Timer.setTimer(#nanoseconds(cyclesCheckInterval), checkCanisterCycles);
  };

  public func topupCanister() : async () {
    let amount = Cycles.available();
    let accepted = Cycles.accept(amount);
  };

  public func getCyclesBalance() : async Nat {
    return Cycles.balance();
  };

  setCheckCyclesTimer();
};

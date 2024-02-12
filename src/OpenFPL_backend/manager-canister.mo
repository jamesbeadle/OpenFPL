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

  private var managerGroupIndexes: TrieMap.TrieMap<T.PrincipalId, Nat8> = TrieMap.TrieMap<T.PrincipalId, Nat8>(Text.equal, Text.hash);  
  private stable var stable_manager_group_indexes: [(T.PrincipalId, Nat8)] = [];
  private stable var managerGroup1: [T.Manager] = [];
  private stable var managerGroup2: [T.Manager] = [];
  private stable var managerGroup3: [T.Manager] = [];
  private stable var managerGroup4: [T.Manager] = [];
  private stable var managerGroup5: [T.Manager] = [];
  private stable var managerGroup6: [T.Manager] = [];
  private stable var managerGroup7: [T.Manager] = [];
  private stable var managerGroup8: [T.Manager] = [];
  private stable var managerGroup9: [T.Manager] = [];
  private stable var managerGroup10: [T.Manager] = [];
  private stable var managerGroup11: [T.Manager] = [];
  private stable var managerGroup12: [T.Manager] = [];
  private let cyclesCheckInterval : Nat = Utilities.getHour() * 24;
  private var cyclesCheckTimerId : ?Timer.TimerId = null;
  private var activeGroupIndex = 0;

  let network = Environment.DFX_NETWORK;
  var main_canister_id = CanisterIds.MAIN_CANISTER_IC_ID;
  if (network == "local") {
    main_canister_id := CanisterIds.MAIN_CANISTER_LOCAL_ID;
  };

  public shared ({ caller }) func createCanister(_seasonId : T.SeasonId, _totalEntries : Nat) : async () {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == main_canister_id;
  };

  //update team selection
  public shared ({ caller }) func updateTeamSelection(updateManagerDTO: DTOs.UpdateTeamSelectionDTO, players: [DTOs.PlayerDTO], systemState: T.SystemState, transfersAvailable: Nat8, newBankBalance: Nat16) : async Result.Result<(), T.Error> {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == main_canister_id;

    let managerBuffer = Buffer.fromArray<T.Manager>([]);
    let managerGroupIndex = managerGroupIndexes.get(updateManagerDTO.principalId);
    switch(managerGroupIndex){
      case (null){};
      case (?foundGroupIndex){
        switch(foundGroupIndex){
          case 0 {
            for(manager in Iter.fromArray(managerGroup1)){
              if(manager.principalId == principalId){
                managerBuffer.add(mergeTeamSelection(updateManagerDTO, manager, transfersAvailable, newBankBalance));
              }
              else{
                managerBuffer.add(manager);
              }
            };
            managerGroup1 := Buffer.toArray(managerBuffer);
          };
          case 1 {
            for(manager in Iter.fromArray(managerGroup2)){
              if(manager.principalId == principalId){
                managerBuffer.add(mergeTeamSelection(updateManagerDTO, manager, transfersAvailable, newBankBalance));
              }
              else{
                managerBuffer.add(manager);
              }
            };
            managerGroup2 := Buffer.toArray(managerBuffer);
          };
          case 2 {
            for(manager in Iter.fromArray(managerGroup3)){
              if(manager.principalId == principalId){
                managerBuffer.add(mergeTeamSelection(updateManagerDTO, manager, transfersAvailable, newBankBalance));
              }
              else{
                managerBuffer.add(manager);
              }
            };
            managerGroup3 := Buffer.toArray(managerBuffer);
          };
          case 3 {
            for(manager in Iter.fromArray(managerGroup4)){
              if(manager.principalId == principalId){
                managerBuffer.add(mergeTeamSelection(updateManagerDTO, manager, transfersAvailable, newBankBalance));
              }
              else{
                managerBuffer.add(manager);
              }
            };
            managerGroup4 := Buffer.toArray(managerBuffer);
          };
          case 4 {
            for(manager in Iter.fromArray(managerGroup5)){
              if(manager.principalId == principalId){
                managerBuffer.add(mergeTeamSelection(updateManagerDTO, manager, transfersAvailable, newBankBalance));
              }
              else{
                managerBuffer.add(manager);
              }
            };
            managerGroup5 := Buffer.toArray(managerBuffer);
          };
          case 5 {
            for(manager in Iter.fromArray(managerGroup6)){
              if(manager.principalId == principalId){
                managerBuffer.add(mergeTeamSelection(updateManagerDTO, manager, transfersAvailable, newBankBalance));
              }
              else{
                managerBuffer.add(manager);
              }
            };
            managerGroup6 := Buffer.toArray(managerBuffer);
          };
          case 6 {
            for(manager in Iter.fromArray(managerGroup7)){
              if(manager.principalId == principalId){
                managerBuffer.add(mergeTeamSelection(updateManagerDTO, manager, transfersAvailable, newBankBalance));
              }
              else{
                managerBuffer.add(manager);
              }
            };
            managerGroup7 := Buffer.toArray(managerBuffer);
          };
          case 7 {
            for(manager in Iter.fromArray(managerGroup8)){
              if(manager.principalId == principalId){
                managerBuffer.add(mergeTeamSelection(updateManagerDTO, manager, transfersAvailable, newBankBalance));
              }
              else{
                managerBuffer.add(manager);
              }
            };
            managerGroup8 := Buffer.toArray(managerBuffer);
          };
          case 8 {
            for(manager in Iter.fromArray(managerGroup9)){
              if(manager.principalId == principalId){
                managerBuffer.add(mergeTeamSelection(updateManagerDTO, manager, transfersAvailable, newBankBalance));
              }
              else{
                managerBuffer.add(manager);
              }
            };
            managerGroup9 := Buffer.toArray(managerBuffer);
          };
          case 9 {
            for(manager in Iter.fromArray(managerGroup10)){
              if(manager.principalId == principalId){
                managerBuffer.add(mergeTeamSelection(updateManagerDTO, manager, transfersAvailable, newBankBalance));
              }
              else{
                managerBuffer.add(manager);
              }
            };
            managerGroup10 := Buffer.toArray(managerBuffer);
          };
          case 10 {
            for(manager in Iter.fromArray(managerGroup11)){
              if(manager.principalId == principalId){
                managerBuffer.add(mergeTeamSelection(updateManagerDTO, manager, transfersAvailable, newBankBalance));
              }
              else{
                managerBuffer.add(manager);
              }
            };
            managerGroup11 := Buffer.toArray(managerBuffer);
          };
          case 11 {
            for(manager in Iter.fromArray(managerGroup12)){
              if(manager.principalId == principalId){
                managerBuffer.add(mergeTeamSelection(updateManagerDTO, manager, transfersAvailable, newBankBalance));
              }
              else{
                managerBuffer.add(manager);
              }
            };
            managerGroup12 := Buffer.toArray(managerBuffer);
          };
          case _ {};
        }
      };
    };
    return #ok;

  };

  private func mergeTeamSelection(dto: DTOs.UpdateTeamSelectionDTO, manager: T.Manager, transfersAvailable: Nat8, newBankBalance: Nat16) : T.Manager {
    return let updatedManager : T.Manager = {
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

  //update username
  public shared ({ caller }) func updateUsername(dto: DTOs.UpdateUsernameDTO) : async Result.Result<(), T.Error> {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == main_canister_id;

    let managerBuffer = Buffer.fromArray<T.Manager>([]);
    let managerGroupIndex = managerGroupIndexes.get(dto.principalId);
    switch(managerGroupIndex){
      case (null){};
      case (?foundGroupIndex){
        switch(foundGroupIndex){
          case 0 {
            for(manager in Iter.fromArray(managerGroup1)){
              if(manager.principalId == principalId){
                managerBuffer.add(mergeManagerUsername(manager, dto.username));
              }
              else{
                managerBuffer.add(manager);
              }
            };
            managerGroup1 := Buffer.toArray(managerBuffer);
          };
          case 1 {
            for(manager in Iter.fromArray(managerGroup2)){
              if(manager.principalId == principalId){
                managerBuffer.add(mergeManagerUsername(manager, dto.username));
              }
              else{
                managerBuffer.add(manager);
              }
            };
            managerGroup2 := Buffer.toArray(managerBuffer);
          };
          case 2 {
            for(manager in Iter.fromArray(managerGroup3)){
              if(manager.principalId == principalId){
                managerBuffer.add(mergeManagerUsername(manager, dto.username));
              }
              else{
                managerBuffer.add(manager);
              }
            };
            managerGroup3 := Buffer.toArray(managerBuffer);
          };
          case 3 {
            for(manager in Iter.fromArray(managerGroup4)){
              if(manager.principalId == principalId){
                managerBuffer.add(mergeManagerUsername(manager, dto.username));
              }
              else{
                managerBuffer.add(manager);
              }
            };
            managerGroup4 := Buffer.toArray(managerBuffer);
          };
          case 4 {
            for(manager in Iter.fromArray(managerGroup5)){
              if(manager.principalId == principalId){
                managerBuffer.add(mergeManagerUsername(manager, dto.username));
              }
              else{
                managerBuffer.add(manager);
              }
            };
            managerGroup5 := Buffer.toArray(managerBuffer);
          };
          case 5 {
            for(manager in Iter.fromArray(managerGroup6)){
              if(manager.principalId == principalId){
                managerBuffer.add(mergeManagerUsername(manager, dto.username));
              }
              else{
                managerBuffer.add(manager);
              }
            };
            managerGroup6 := Buffer.toArray(managerBuffer);
          };
          case 6 {
            for(manager in Iter.fromArray(managerGroup7)){
              if(manager.principalId == principalId){
                managerBuffer.add(mergeManagerUsername(manager, dto.username));
              }
              else{
                managerBuffer.add(manager);
              }
            };
            managerGroup7 := Buffer.toArray(managerBuffer);
          };
          case 7 {
            for(manager in Iter.fromArray(managerGroup8)){
              if(manager.principalId == principalId){
                managerBuffer.add(mergeManagerUsername(manager, dto.username));
              }
              else{
                managerBuffer.add(manager);
              }
            };
            managerGroup8 := Buffer.toArray(managerBuffer);
          };
          case 8 {
            for(manager in Iter.fromArray(managerGroup9)){
              if(manager.principalId == principalId){
                managerBuffer.add(mergeManagerUsername(manager, dto.username));
              }
              else{
                managerBuffer.add(manager);
              }
            };
            managerGroup9 := Buffer.toArray(managerBuffer);
          };
          case 9 {
            for(manager in Iter.fromArray(managerGroup10)){
              if(manager.principalId == principalId){
                managerBuffer.add(mergeManagerUsername(manager, dto.username));
              }
              else{
                managerBuffer.add(manager);
              }
            };
            managerGroup10 := Buffer.toArray(managerBuffer);
          };
          case 10 {
            for(manager in Iter.fromArray(managerGroup11)){
              if(manager.principalId == principalId){
                managerBuffer.add(mergeManagerUsername(manager, dto.username));
              }
              else{
                managerBuffer.add(manager);
              }
            };
            managerGroup11 := Buffer.toArray(managerBuffer);
          };
          case 11 {
            for(manager in Iter.fromArray(managerGroup12)){
              if(manager.principalId == principalId){
                managerBuffer.add(mergeManagerUsername(manager, dto.username));
              }
              else{
                managerBuffer.add(manager);
              }
            };
            managerGroup12 := Buffer.toArray(managerBuffer);
          };
          case _{};
        }
      }
    };
    
    return #ok();
  };

  private func mergeManagerUsername(manager: T.Manager, username: Text) : T.Manager {
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
    }
  };

  //update profile picture
  public shared ({ caller }) func updateProfilePicture(dto: DTOs.UpdateProfilePictureDTO) : async Result.Result<(), T.Error> {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == main_canister_id;

    let managerBuffer = Buffer.fromArray<T.Manager>([]);
    let managerGroupIndex = managerGroupIndexes.get(dto.principalId);
    switch(managerGroupIndex){
      case (null){};
      case (?foundGroupIndex){
        switch(foundGroupIndex){
          case 0 {
            for(manager in Iter.fromArray(managerGroup1)){
              if(manager.principalId == principalId){
                managerBuffer.add(mergeManagerProfilePicture(manager, dto.profilePicture));
              }
              else{
                managerBuffer.add(manager);
              }
            };
            managerGroup1 := Buffer.toArray(managerBuffer);
          };
          case 1 {
            for(manager in Iter.fromArray(managerGroup2)){
              if(manager.principalId == principalId){
                managerBuffer.add(mergeManagerProfilePicture(manager, dto.profilePicture));
              }
              else{
                managerBuffer.add(manager);
              }
            };
            managerGroup2 := Buffer.toArray(managerBuffer);
          };
          case 2 {
            for(manager in Iter.fromArray(managerGroup3)){
              if(manager.principalId == principalId){
                managerBuffer.add(mergeManagerProfilePicture(manager, dto.profilePicture));
              }
              else{
                managerBuffer.add(manager);
              }
            };
            managerGroup3 := Buffer.toArray(managerBuffer);
          };
          case 3 {
            for(manager in Iter.fromArray(managerGroup4)){
              if(manager.principalId == principalId){
                managerBuffer.add(mergeManagerProfilePicture(manager, dto.profilePicture));
              }
              else{
                managerBuffer.add(manager);
              }
            };
            managerGroup4 := Buffer.toArray(managerBuffer);
          };
          case 4 {
            for(manager in Iter.fromArray(managerGroup5)){
              if(manager.principalId == principalId){
                managerBuffer.add(mergeManagerProfilePicture(manager, dto.profilePicture));
              }
              else{
                managerBuffer.add(manager);
              }
            };
            managerGroup5 := Buffer.toArray(managerBuffer);
          };
          case 5 {
            for(manager in Iter.fromArray(managerGroup6)){
              if(manager.principalId == principalId){
                managerBuffer.add(mergeManagerProfilePicture(manager, dto.profilePicture));
              }
              else{
                managerBuffer.add(manager);
              }
            };
            managerGroup6 := Buffer.toArray(managerBuffer);
          };
          case 6 {
            for(manager in Iter.fromArray(managerGroup7)){
              if(manager.principalId == principalId){
                managerBuffer.add(mergeManagerProfilePicture(manager, dto.profilePicture));
              }
              else{
                managerBuffer.add(manager);
              }
            };
            managerGroup7 := Buffer.toArray(managerBuffer);
          };
          case 7 {
            for(manager in Iter.fromArray(managerGroup8)){
              if(manager.principalId == principalId){
                managerBuffer.add(mergeManagerProfilePicture(manager, dto.profilePicture));
              }
              else{
                managerBuffer.add(manager);
              }
            };
            managerGroup8 := Buffer.toArray(managerBuffer);
          };
          case 8 {
            for(manager in Iter.fromArray(managerGroup9)){
              if(manager.principalId == principalId){
                managerBuffer.add(mergeManagerProfilePicture(manager, dto.profilePicture));
              }
              else{
                managerBuffer.add(manager);
              }
            };
            managerGroup9 := Buffer.toArray(managerBuffer);
          };
          case 9 {
            for(manager in Iter.fromArray(managerGroup10)){
              if(manager.principalId == principalId){
                managerBuffer.add(mergeManagerProfilePicture(manager, dto.profilePicture));
              }
              else{
                managerBuffer.add(manager);
              }
            };
            managerGroup10 := Buffer.toArray(managerBuffer);
          };
          case 10 {
            for(manager in Iter.fromArray(managerGroup11)){
              if(manager.principalId == principalId){
                managerBuffer.add(mergeManagerProfilePicture(manager, dto.profilePicture));
              }
              else{
                managerBuffer.add(manager);
              }
            };
            managerGroup11 := Buffer.toArray(managerBuffer);
          };
          case 11 {
            for(manager in Iter.fromArray(managerGroup12)){
              if(manager.principalId == principalId){
                managerBuffer.add(mergeManagerProfilePicture(manager, dto.profilePicture));
              }
              else{
                managerBuffer.add(manager);
              }
            };
            managerGroup12 := Buffer.toArray(managerBuffer);
          };
          case _{};
        }
      }
    };
    
    return #ok();
  }; 

  private func mergeManagerProfilePicture(manager: T.Manager, profilePicture: ?Blob) : T.Manager {
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
    }
  };

  //update favourite club
  public shared ({ caller }) func updateFavouriteClub(dto: DTOs.UpdateFavouriteClubDTO) : async Result.Result<(), T.Error> {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == main_canister_id;

    let managerBuffer = Buffer.fromArray<T.Manager>([]);
    let managerGroupIndex = managerGroupIndexes.get(dto.principalId);
    switch(managerGroupIndex){
      case (null){};
      case (?foundGroupIndex){
        switch(foundGroupIndex){
          case 0 {
            for(manager in Iter.fromArray(managerGroup1)){
              if(manager.principalId == principalId){
                managerBuffer.add(mergeManagerFavouriteClub(manager, dto.favouriteClubId));
              }
              else{
                managerBuffer.add(manager);
              }
            };
            managerGroup1 := Buffer.toArray(managerBuffer);
          };
          case 1 {
            for(manager in Iter.fromArray(managerGroup2)){
              if(manager.principalId == principalId){
                managerBuffer.add(mergeManagerFavouriteClub(manager, dto.favouriteClubId));
              }
              else{
                managerBuffer.add(manager);
              }
            };
            managerGroup2 := Buffer.toArray(managerBuffer);
          };
          case 2 {
            for(manager in Iter.fromArray(managerGroup3)){
              if(manager.principalId == principalId){
                managerBuffer.add(mergeManagerFavouriteClub(manager, dto.favouriteClubId));
              }
              else{
                managerBuffer.add(manager);
              }
            };
            managerGroup3 := Buffer.toArray(managerBuffer);
          };
          case 3 {
            for(manager in Iter.fromArray(managerGroup4)){
              if(manager.principalId == principalId){
                managerBuffer.add(mergeManagerFavouriteClub(manager, dto.favouriteClubId));
              }
              else{
                managerBuffer.add(manager);
              }
            };
            managerGroup4 := Buffer.toArray(managerBuffer);
          };
          case 4 {
            for(manager in Iter.fromArray(managerGroup5)){
              if(manager.principalId == principalId){
                managerBuffer.add(mergeManagerFavouriteClub(manager, dto.favouriteClubId));
              }
              else{
                managerBuffer.add(manager);
              }
            };
            managerGroup5 := Buffer.toArray(managerBuffer);
          };
          case 5 {
            for(manager in Iter.fromArray(managerGroup6)){
              if(manager.principalId == principalId){
                managerBuffer.add(mergeManagerFavouriteClub(manager, dto.favouriteClubId));
              }
              else{
                managerBuffer.add(manager);
              }
            };
            managerGroup6 := Buffer.toArray(managerBuffer);
          };
          case 6 {
            for(manager in Iter.fromArray(managerGroup7)){
              if(manager.principalId == principalId){
                managerBuffer.add(mergeManagerFavouriteClub(manager, dto.favouriteClubId));
              }
              else{
                managerBuffer.add(manager);
              }
            };
            managerGroup7 := Buffer.toArray(managerBuffer);
          };
          case 7 {
            for(manager in Iter.fromArray(managerGroup8)){
              if(manager.principalId == principalId){
                managerBuffer.add(mergeManagerFavouriteClub(manager, dto.favouriteClubId));
              }
              else{
                managerBuffer.add(manager);
              }
            };
            managerGroup8 := Buffer.toArray(managerBuffer);
          };
          case 8 {
            for(manager in Iter.fromArray(managerGroup9)){
              if(manager.principalId == principalId){
                managerBuffer.add(mergeManagerFavouriteClub(manager, dto.favouriteClubId));
              }
              else{
                managerBuffer.add(manager);
              }
            };
            managerGroup9 := Buffer.toArray(managerBuffer);
          };
          case 9 {
            for(manager in Iter.fromArray(managerGroup10)){
              if(manager.principalId == principalId){
                managerBuffer.add(mergeManagerFavouriteClub(manager, dto.favouriteClubId));
              }
              else{
                managerBuffer.add(manager);
              }
            };
            managerGroup10 := Buffer.toArray(managerBuffer);
          };
          case 10 {
            for(manager in Iter.fromArray(managerGroup11)){
              if(manager.principalId == principalId){
                managerBuffer.add(mergeManagerFavouriteClub(manager, dto.favouriteClubId));
              }
              else{
                managerBuffer.add(manager);
              }
            };
            managerGroup11 := Buffer.toArray(managerBuffer);
          };
          case 11 {
            for(manager in Iter.fromArray(managerGroup12)){
              if(manager.principalId == principalId){
                managerBuffer.add(mergeManagerFavouriteClub(manager, dto.favouriteClubId));
              }
              else{
                managerBuffer.add(manager);
              }
            };
            managerGroup12 := Buffer.toArray(managerBuffer);
          };
          case _{};
        }
      }
    };
    
    return #ok();
  };

  private func mergeManagerFavouriteClub(manager: T.Manager, favouriteClubId: T.ClubId) : T.Manager {
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
    }
  };


  

  //get manager
  public shared ({ caller }) func getManager(managerPrincipal: Text) : async ?T.Manager {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == main_canister_id;

    let managerGroupIndex = managerGroupIndexes.get(managerPrincipal);
    switch(managerGroupIndex){
      case (null){
        return null;
      };
      case (?foundIndex){
        switch(foundIndex){
          case (0) {
            for(manager in Iter.fromArray<T.Manager>(managerGroup1)){
              if(manager.principalId == managerPrincipal){
                return ?manager;
              };
            };
          };
          case (1) {
            for(manager in Iter.fromArray<T.Manager>(managerGroup2)){
              if(manager.principalId == managerPrincipal){
                return ?manager;
              };
            };
          };
          case (2) {
            for(manager in Iter.fromArray<T.Manager>(managerGroup3)){
              if(manager.principalId == managerPrincipal){
                return ?manager;
              };
            };
          };
          case (3) {
            for(manager in Iter.fromArray<T.Manager>(managerGroup4)){
              if(manager.principalId == managerPrincipal){
                return ?manager;
              };
            };
          };
          case (4) {
            for(manager in Iter.fromArray<T.Manager>(managerGroup5)){
              if(manager.principalId == managerPrincipal){
                return ?manager;
              };
            };
          };
          case (5) {
            for(manager in Iter.fromArray<T.Manager>(managerGroup6)){
              if(manager.principalId == managerPrincipal){
                return ?manager;
              };
            };
          };
          case (6) {
            for(manager in Iter.fromArray<T.Manager>(managerGroup7)){
              if(manager.principalId == managerPrincipal){
                return ?manager;
              };
            };
          };
          case (7) {
            for(manager in Iter.fromArray<T.Manager>(managerGroup8)){
              if(manager.principalId == managerPrincipal){
                return ?manager;
              };
            };
          };
          case (8) {
            for(manager in Iter.fromArray<T.Manager>(managerGroup9)){
              if(manager.principalId == managerPrincipal){
                return ?manager;
              };
            };
          };
          case (9) {
            for(manager in Iter.fromArray<T.Manager>(managerGroup10)){
              if(manager.principalId == managerPrincipal){
                return ?manager;
              };
            };
          };
          case (10) {
            for(manager in Iter.fromArray<T.Manager>(managerGroup11)){
              if(manager.principalId == managerPrincipal){
                return ?manager;
              };
            };
          };
          case (11) {
            for(manager in Iter.fromArray<T.Manager>(managerGroup12)){
              if(manager.principalId == managerPrincipal){
                return ?manager;
              };
            };
          };
          case _ {

          }
        };
        return null;
      };
    };
  };

  //get managers
  public shared ({ caller }) func getManagers(managerGroup: Nat8) : async [T.Manager] {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == main_canister_id;
    
    switch(managerGroup){
      case 0{
        return managerGroup1;
      };
      case 1{
        return managerGroup1;
      };
      case 2{
        return managerGroup1;
      };
      case 3{
        return managerGroup1;
      };
      case 4{
        return managerGroup1;
      };
      case 5{
        return managerGroup1;
      };
      case 6{
        return managerGroup1;
      };
      case 7{
        return managerGroup1;
      };
      case 8{
        return managerGroup1;
      };
      case 9{
        return managerGroup1;
      };
      case 10{
        return managerGroup1;
      };
      case 0{
        return managerGroup1;
      };
      case _{

      };
    };
    return [];
  };

  //add new manager


  public shared ({ caller }) func updateSnapshotPoints(principalId : Text, seasonId : Nat16, gameweek : Nat8, teamPoints : Int16, teamValueQuarterMillions: Nat16) : () {
    
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == main_canister_id;

    let managerBuffer = Buffer.fromArray<T.Manager>([]);
    let managerGroupIndex = managerGroupIndexes.get(principalId);
    switch(managerGroupIndex){
      case (null){};
      case (?foundGroupIndex){
        switch(foundGroupIndex){
          case 0 {
            for(manager in Iter.fromArray(managerGroup1)){
              if(manager.principalId == principalId){
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
            for(manager in Iter.fromArray(managerGroup2)){
              if(manager.principalId == principalId){
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
            for(manager in Iter.fromArray(managerGroup3)){
              if(manager.principalId == principalId){
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
            for(manager in Iter.fromArray(managerGroup4)){
              if(manager.principalId == principalId){
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
            for(manager in Iter.fromArray(managerGroup5)){
              if(manager.principalId == principalId){
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
            for(manager in Iter.fromArray(managerGroup6)){
              if(manager.principalId == principalId){
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
            for(manager in Iter.fromArray(managerGroup7)){
              if(manager.principalId == principalId){
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
            for(manager in Iter.fromArray(managerGroup8)){
              if(manager.principalId == principalId){
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
            for(manager in Iter.fromArray(managerGroup9)){
              if(manager.principalId == principalId){
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
            for(manager in Iter.fromArray(managerGroup10)){
              if(manager.principalId == principalId){
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
            for(manager in Iter.fromArray(managerGroup11)){
              if(manager.principalId == principalId){
                
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
            for(manager in Iter.fromArray(managerGroup12)){
              if(manager.principalId == principalId){
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
      }
    }
  };

  private func mergeManagerSnapshot(manager: T.Manager, gameweek: T.GameweekNumber, points: Int16, teamValueQuarterMillions: Nat16) : T.FantasyTeamSnapshot {
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
      teamValueQuarterMillions = teamValueQuarterMillions;
    }
  };

  private func mergeExistingHistory(existingHistory: List.List<T.FantasyTeamSeason>, fantasyTeamSnapshot: T.FantasyTeamSnapshot, seasonId: T.SeasonId, gameweek: T.GameweekNumber, manager: T.Manager, teamPoints: Int16, teamValueQuarterMillions: Nat16) : List.List<T.FantasyTeamSeason> {
    
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

      return List.fromArray(Buffer.toArray(teamHistoryBuffer));
    };

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
    }
  };

  private func mergeManagerHistory(manager: T.Manager, history: List.List<T.FantasyTeamSeason>) : T.Manager {
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
    }
  };

  public func removePlayerFromTeams(playerId : T.PlayerId, allPlayers : [DTOs.PlayerDTO]) : async () {

    let removedPlayer = Array.find<DTOs.PlayerDTO>(allPlayers, func(p) { p.id == playerId });
    switch (removedPlayer) {
      case (null) {
        return;
      };
      case (?foundRemovedPlayer) {

        let playerValue = foundRemovedPlayer.valueQuarterMillions;
        let managersWithPlayer = TrieMap.mapFilter<T.PrincipalId, T.Manager, T.Manager>(
          managers,
          Text.equal,
          Text.hash,
          func(k, v) = if (Array.find<T.PlayerId>(v.playerIds, func(id) { id == playerId }) == null) {
            null;
          } else { ?v },
        );

        for ((principalId, manager) in managersWithPlayer.entries()) {
          let newPlayerIds = Array.map<T.PlayerId, T.PlayerId>(
            manager.playerIds,
            func(id) : T.PlayerId { if (id == playerId) { 0 } else { id } },
          );

          var captainId = manager.captainId;
          if (captainId == playerId) {
            let highestValuedPlayer = Array.foldLeft<T.PlayerId, ?DTOs.PlayerDTO>(
              manager.playerIds,
              null,
              func(highest, id) : ?DTOs.PlayerDTO {
                if (id == playerId or id == 0) { return highest };
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

          let newBankBalance = manager.bankQuarterMillions + playerValue;

          let updatedManager : T.Manager = {
            principalId = manager.principalId;
            username = manager.username;
            favouriteClubId = manager.favouriteClubId;
            createDate = manager.createDate;
            termsAccepted = manager.termsAccepted;
            profilePicture = manager.profilePicture;
            transfersAvailable = manager.transfersAvailable;
            monthlyBonusesAvailable = manager.monthlyBonusesAvailable;
            bankQuarterMillions = newBankBalance;
            playerIds = newPlayerIds;
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
            history = manager.history;
            managerGroupIndex = manager.managerGroupIndex
          };

          managers.put(principalId, updatedManager);
        };

      };
    };
  };

  system func preupgrade() {
    stable_manager_group_indexes := Iter.toArray(managerGroupIndexes.entries());
  };

  system func postupgrade() {
    for(index in Iter.fromArray(stable_manager_group_indexes)){
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

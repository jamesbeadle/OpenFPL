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
import CanisterIds "CanisterIds";
import Utilities "utilities";
import Environment "Environment";

actor class ManagerCanister() {
  
  private stable var managerGroups: [[T.Manager]] = [];
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
  
  public shared ({ caller }) func getManager(managerGroup: Nat8, managerPrincipal: Text) : async ?T.Manager {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == main_canister_id;

    for(managerGroup in Iter.fromArray(managerGroups)){
      for(manager in Iter.fromArray<T.Manager>(managerGroup)){
        if(manager.principalId == managerPrincipal){
          return ?manager;
        };
      };
    };

    let managers = managerGroups[Nat8.toNat(managerGroup)];
    
    return null;
  };

  //getProfile ProfileDTO
  public shared query ({ caller }) func updateManager(updateManagerDTO: DTOs.UpdateManagerDTO) : async () {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == main_canister_id;
    
    let foundManager = null;
    let managerGroupsChunkBuffer = Buffer.fromArray<[T.Manager]>([]);
    var managerFound = false;
      
    label managerGroupLoop for(managerGroup in Iter.fromArray(managerGroups)){
      
      if(managerFound){
        managerGroupsChunkBuffer.add(managerGroup);
        continue managerGroupLoop;
      };
      let managers = managerGroups[Nat8.toNat(updateManagerDTO.managerGroupIndex)];
      
      let managersChunkBuffer = Buffer.fromArray<T.Manager>([]);
      for(manager in Iter.fromArray<T.Manager>(managers)){
        if(manager.principalId == updateManagerDTO.principalId){
          managerFound := true;
          let updatedManager : T.Manager = {
            principalId = updateManagerDTO.principalId;
            managerGroupIndex = updateManagerDTO.managerGroupIndex;
            username = updateManagerDTO.username;
            favouriteClubId = manager.favouriteClubId;
            createDate = manager.createDate;
            termsAccepted = manager.termsAccepted;
            profilePicture = manager.profilePicture;
            transfersAvailable = manager.transfersAvailable;
            monthlyBonusesAvailable = manager.monthlyBonusesAvailable;
            bankQuarterMillions = manager.bankQuarterMillions;
            playerIds = updateManagerDTO.playerIds;
            captainId = updateManagerDTO.captainId;
            goalGetterGameweek = updateManagerDTO.goalGetterGameweek;
            goalGetterPlayerId = updateManagerDTO.goalGetterPlayerId;
            passMasterGameweek = updateManagerDTO.passMasterGameweek;
            passMasterPlayerId = updateManagerDTO.passMasterPlayerId;
            noEntryGameweek = updateManagerDTO.noEntryGameweek;
            noEntryPlayerId = updateManagerDTO.noEntryPlayerId;
            teamBoostGameweek = updateManagerDTO.teamBoostGameweek;
            teamBoostClubId = updateManagerDTO.teamBoostClubId;
            safeHandsGameweek = updateManagerDTO.safeHandsGameweek;
            safeHandsPlayerId = updateManagerDTO.safeHandsPlayerId;
            captainFantasticGameweek = updateManagerDTO.captainFantasticGameweek;
            captainFantasticPlayerId = updateManagerDTO.captainFantasticPlayerId;
            countrymenGameweek = updateManagerDTO.countrymenGameweek;
            countrymenCountryId = updateManagerDTO.countrymenCountryId;
            prospectsGameweek = updateManagerDTO.prospectsGameweek;
            braceBonusGameweek = updateManagerDTO.braceBonusGameweek;
            hatTrickHeroGameweek = updateManagerDTO.hatTrickHeroGameweek;
            transferWindowGameweek = updateManagerDTO.transferWindowGameweek;
            history = manager.history;
          };
          managersChunkBuffer.add(updatedManager);
        }
        else{
          managersChunkBuffer.add(manager);
        };
        managerGroupsChunkBuffer.add(Buffer.toArray(managersChunkBuffer));
      };
    };

    managerGroups := Buffer.toArray<[T.Manager]>(managerGroupsChunkBuffer);

    if(not managerFound){
      addNewManager(updateManagerDTO);
    };
  };

  private func addManager(newManagerDTO: DTOs.UpdateManagerDTO) : () {
    let foundManager = null;
    let managerGroupsChunkBuffer = Buffer.fromArray<[T.Manager]>([]);
    var managerFound = false;

    var counter = 0;
      
    label managerGroupLoop for(managerGroup in Iter.fromArray(managerGroups)){
      
      if(managerFound){
        managerGroupsChunkBuffer.add(managerGroup);
        continue managerGroupLoop;
      };
      if(counter == activeGroupIndex){
        let newManager: T.Manager = {
          managerGroupIndex = newManagerDTO.managerGroupIndex;
          principalId = newManagerDTO.principalId;
          username = newManagerDTO.username;
          termsAccepted = false;
          favouriteClubId = 0;
          createDate = now;
          transfersAvailable = newManagerDTO.transfersAvailable;
          monthlyBonusesAvailable = newManagerDTO.managerGroupIndex;
          bankQuarterMillions = newManagerDTO.managerGroupIndex;
          playerIds = newManagerDTO.managerGroupIndex;
          captainId = newManagerDTO.managerGroupIndex;
          goalGetterGameweek = newManagerDTO.managerGroupIndex;
          goalGetterPlayerId = newManagerDTO.managerGroupIndex;
          passMasterGameweek = newManagerDTO.managerGroupIndex;
          passMasterPlayerId = newManagerDTO.managerGroupIndex;
          noEntryGameweek = newManagerDTO.managerGroupIndex;
          noEntryPlayerId = newManagerDTO.managerGroupIndex;
          teamBoostGameweek = newManagerDTO.managerGroupIndex;
          teamBoostClubId = newManagerDTO.managerGroupIndex;
          safeHandsGameweek = newManagerDTO.managerGroupIndex;
          safeHandsPlayerId = newManagerDTO.managerGroupIndex;
          captainFantasticGameweek = newManagerDTO.managerGroupIndex;
          captainFantasticPlayerId = newManagerDTO.managerGroupIndex;
          countrymenGameweek = newManagerDTO.managerGroupIndex;
          countrymenCountryId = newManagerDTO.managerGroupIndex;
          prospectsGameweek = newManagerDTO.managerGroupIndex;
          braceBonusGameweek = newManagerDTO.managerGroupIndex;
          hatTrickHeroGameweek = newManagerDTO.managerGroupIndex;
          transferWindowGameweek = newManagerDTO.managerGroupIndex;
          history = newManagerDTO.managerGroupIndex;
          profilePicture= newManagerDTO.managerGroupIndex;
        };
        let groupManagers = List.append<T.Manager>(List.fromArray(managerGroup), List.make(newManager));
        managerGroupsChunkBuffer.add(List.toArray<T.Manager>(groupManagers));
      }
      else{
        managerGroupsChunkBuffer.add(managerGroup);
      };
      counter := counter + 1;
    };

    managerGroups := Buffer.toArray<[T.Manager]>(managerGroupsChunkBuffer);
  };










  system func preupgrade() {
  };

  system func postupgrade() {
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

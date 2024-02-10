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

  public shared query ({ caller }) func updateFantasyTeam(updateFantasyTeamDTO: DTOs.UpdateFantasyTeamDTO) : async () {
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
      let managers = managerGroups[Nat8.toNat(updateFantasyTeamDTO.managerGroupIndex)];
      
      let managersChunkBuffer = Buffer.fromArray<T.Manager>([]);
      for(manager in Iter.fromArray<T.Manager>(managers)){
        if(manager.principalId == updateFantasyTeamDTO.principalId){
          managerFound := true;
          let updatedManager : T.Manager = {
            principalId = updateFantasyTeamDTO.principalId;
            managerGroupIndex = updateFantasyTeamDTO.managerGroupIndex;
            username = updateFantasyTeamDTO.username;
            favouriteClubId = manager.favouriteClubId;
            createDate = manager.createDate;
            termsAccepted = manager.termsAccepted;
            profilePicture = manager.profilePicture;
            transfersAvailable = manager.transfersAvailable;
            monthlyBonusesAvailable = manager.monthlyBonusesAvailable;
            bankQuarterMillions = manager.bankQuarterMillions;
            playerIds = updateFantasyTeamDTO.playerIds;
            captainId = updateFantasyTeamDTO.captainId;
            goalGetterGameweek = updateFantasyTeamDTO.goalGetterGameweek;
            goalGetterPlayerId = updateFantasyTeamDTO.goalGetterPlayerId;
            passMasterGameweek = updateFantasyTeamDTO.passMasterGameweek;
            passMasterPlayerId = updateFantasyTeamDTO.passMasterPlayerId;
            noEntryGameweek = updateFantasyTeamDTO.noEntryGameweek;
            noEntryPlayerId = updateFantasyTeamDTO.noEntryPlayerId;
            teamBoostGameweek = updateFantasyTeamDTO.teamBoostGameweek;
            teamBoostClubId = updateFantasyTeamDTO.teamBoostClubId;
            safeHandsGameweek = updateFantasyTeamDTO.safeHandsGameweek;
            safeHandsPlayerId = updateFantasyTeamDTO.safeHandsPlayerId;
            captainFantasticGameweek = updateFantasyTeamDTO.captainFantasticGameweek;
            captainFantasticPlayerId = updateFantasyTeamDTO.captainFantasticPlayerId;
            countrymenGameweek = updateFantasyTeamDTO.countrymenGameweek;
            countrymenCountryId = updateFantasyTeamDTO.countrymenCountryId;
            prospectsGameweek = updateFantasyTeamDTO.prospectsGameweek;
            braceBonusGameweek = updateFantasyTeamDTO.braceBonusGameweek;
            hatTrickHeroGameweek = updateFantasyTeamDTO.hatTrickHeroGameweek;
            transferWindowGameweek = updateFantasyTeamDTO.transferWindowGameweek;
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
      addNewManager(updateFantasyTeamDTO);
    };
  };

  private func addNewManager(updateFantasyTeamDTO: DTOs.UpdateFantasyTeamDTO) : () {
    
  };

  public shared query ({ caller }) func updateManager(managerGroupIndex: Nat8, updatedManager: T.Manager) : async () {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == main_canister_id;

    for (managerGroup in Iter.fromArray<(T.PrincipalId, T.Manager)>(managerGroups)){
      
      let managerGroupsChunkBuffer = Buffer.fromArray<(T.PrincipalId, T.Manager)>([]);
      let managers = managerGroups[Nat8.toNat(managerGroupIndex)];
      
      for(manager in Iter.fromArray<(T.PrincipalId, T.Manager)>(managers)){
        if(manager.0 == updatedManager.principalId){
          managerGroupsChunkBuffer.add((manager.0, updatedManager));
        }
        else{
          managerGroupsChunkBuffer.add((manager.0, manager.1));
        }
      };
    };
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

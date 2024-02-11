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
        let managers = managerGroups[Nat8.toNat(foundIndex)];

        for(manager in Iter.fromArray<T.Manager>(managers)){
          if(manager.principalId == managerPrincipal){
            return ?manager;
          };
        };
        return null;
      };
    };
  };

  public shared query ({ caller }) func updateManager(updateManagerDTO: DTOs.UpdateManagerDTO, players: [DTOs.PlayerDTO], systemState: T.SystemState) : async Result.Result<(), T.Error> {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == main_canister_id;
    
    var foundManager: ?T.Manager = null;
    let managerGroupsChunkBuffer = Buffer.fromArray<[T.Manager]>([]);
    var managerFound = false;
      
    label managerGroupLoop for(managerGroup in Iter.fromArray(managerGroups)){
      
      if(managerFound){
        switch(foundManager){
          case (null){};
          case (?manager){

            let playersAdded = Array.filter<DTOs.PlayerDTO>(
              players,
              func(player : DTOs.PlayerDTO) : Bool {
                let playerId = player.id;
                let isPlayerIdInExistingTeam = Array.find(
                  manager.playerIds,
                  func(id : Nat16) : Bool {
                    return id == playerId;
                  },
                );
                return Option.isNull(isPlayerIdInExistingTeam);
              },
            );

            let playersRemoved = Array.filter<Nat16>(
              manager.playerIds,
              func(playerId : Nat16) : Bool {
                let isPlayerIdInPlayers = Array.find(
                  players,
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
                  return player.id == manager.noEntryPlayerId;
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
            let newBankBalance = manager.bankQuarterMillions - netSpendQMs;

            let transfersAvailable = manager.transfersAvailable - Nat8.fromNat(Array.size(playersAdded));

            if (manager.goalGetterGameweek == systemState.pickTeamGameweek and manager.goalGetterGameweek != 0) {
              return #err(#InvalidTeamError);
            };
            if (manager.passMasterGameweek == systemState.pickTeamGameweek and manager.passMasterGameweek != 0) {
              return #err(#InvalidTeamError);
            };
            if (manager.noEntryGameweek == systemState.pickTeamGameweek and manager.noEntryGameweek != 0) {
              return #err(#InvalidTeamError);
            };
            if (manager.teamBoostGameweek == systemState.pickTeamGameweek and manager.teamBoostGameweek != 0) {
              return #err(#InvalidTeamError);
            };
            if (manager.safeHandsGameweek == systemState.pickTeamGameweek and manager.safeHandsGameweek != 0) {
              return #err(#InvalidTeamError);
            };
            if (manager.captainFantasticGameweek == systemState.pickTeamGameweek and manager.captainFantasticGameweek != 0) {
              return #err(#InvalidTeamError);
            };
            if (manager.countrymenGameweek == systemState.pickTeamGameweek and manager.countrymenGameweek != 0) {
              return #err(#InvalidTeamError);
            };
            if (manager.prospectsGameweek == systemState.pickTeamGameweek and manager.prospectsGameweek != 0) {
              return #err(#InvalidTeamError);
            };
            if (manager.braceBonusGameweek == systemState.pickTeamGameweek and manager.braceBonusGameweek != 0) {
              return #err(#InvalidTeamError);
            };
            if (manager.hatTrickHeroGameweek == systemState.pickTeamGameweek and manager.hatTrickHeroGameweek != 0) {
              return #err(#InvalidTeamError);
            };

            if (Int64.fromNat64(Nat64.fromNat(Nat8.toNat(manager.monthlyBonusesAvailable) - 1)) < 0) {
              return #err(#InvalidTeamError);
            };

            let updatedManager : T.Manager = {
              principalId = manager.principalId;
              username = manager.username;
              favouriteClubId = manager.favouriteClubId;
              createDate = manager.createDate;
              termsAccepted = manager.termsAccepted;
              profilePicture = manager.profilePicture;
              transfersAvailable = transfersAvailable;
              monthlyBonusesAvailable = manager.monthlyBonusesAvailable;
              bankQuarterMillions = newBankBalance;
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
            };
          }
        };
        managerGroupsChunkBuffer.add(managerGroup);
        continue managerGroupLoop;
      };
      let managerGroupIndex = managerGroupIndexes.get(updateManagerDTO.principalId);
      switch(managerGroupIndex){
        case (null){
          return #err(#NotFound);
        };
        case (?foundIndex){
          let managers = managerGroups[Nat8.toNat(foundIndex)];
      
          let managersChunkBuffer = Buffer.fromArray<T.Manager>([]);
          for(manager in Iter.fromArray<T.Manager>(managers)){
            if(manager.principalId == updateManagerDTO.principalId){
              foundManager := ?manager;
              managerFound := true;
              let updatedManager : T.Manager = {
                principalId = updateManagerDTO.principalId;
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
      }
    };

    managerGroups := Buffer.toArray<[T.Manager]>(managerGroupsChunkBuffer);
    return #ok();
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
          principalId = newManagerDTO.principalId;
          username = newManagerDTO.username;
          termsAccepted = false;
          favouriteClubId = newManagerDTO.favouriteClubId;
          bankQuarterMillions = newManagerDTO.bankQuarterMillions;
          playerIds = newManagerDTO.playerIds;
          captainId = newManagerDTO.captainId;
          goalGetterGameweek = newManagerDTO.goalGetterGameweek;
          goalGetterPlayerId = newManagerDTO.goalGetterPlayerId;
          passMasterGameweek = newManagerDTO.passMasterGameweek;
          passMasterPlayerId = newManagerDTO.passMasterPlayerId;
          noEntryGameweek = newManagerDTO.noEntryGameweek;
          noEntryPlayerId = newManagerDTO.noEntryPlayerId;
          teamBoostGameweek = newManagerDTO.teamBoostGameweek;
          teamBoostClubId = newManagerDTO.teamBoostClubId;
          safeHandsGameweek = newManagerDTO.safeHandsGameweek;
          safeHandsPlayerId = newManagerDTO.safeHandsPlayerId;
          captainFantasticGameweek = newManagerDTO.captainFantasticGameweek;
          captainFantasticPlayerId = newManagerDTO.captainFantasticPlayerId;
          countrymenGameweek = newManagerDTO.countrymenGameweek;
          countrymenCountryId = newManagerDTO.countrymenCountryId;
          prospectsGameweek = newManagerDTO.prospectsGameweek;
          braceBonusGameweek = newManagerDTO.braceBonusGameweek;
          hatTrickHeroGameweek = newManagerDTO.hatTrickHeroGameweek;
          transferWindowGameweek = newManagerDTO.transferWindowGameweek;
          createDate = Time.now();
          history = List.nil();
          monthlyBonusesAvailable = 2;
          profilePicture = newManagerDTO.profilePicture;
          transfersAvailable = 2;
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

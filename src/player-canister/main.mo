import T "../OpenFPL_backend/types";
import DTOs "../OpenFPL_backend/DTOs";
import List "mo:base/List";
import Principal "mo:base/Principal";
import GenesisData "../OpenFPL_backend/genesis-data";
import Nat8 "mo:base/Nat8";
import Int "mo:base/Int";
import Nat "mo:base/Nat";
import Nat16 "mo:base/Nat16";
import Array "mo:base/Array";
import HashMap "mo:base/HashMap";
import Hash "mo:base/Hash";
import Nat32 "mo:base/Nat32";
import Iter "mo:base/Iter";

actor Self {

  private var players = List.fromArray<T.Player>(GenesisData.get_genesis_players());
  private var nextPlayerId : Nat = 560;

  private stable var stable_players: [T.Player] = [];
  private stable var stable_next_player_id : Nat = 0;
  
  public shared query ({caller}) func getPlayers(teamId: Nat16, positionId: Int, start: Nat, count: Nat) : async DTOs.PlayerRatingsDTO {
    assert not Principal.isAnonymous(caller);

    func compare(player1: T.Player, player2: T.Player) : Bool {
        return player1.value >= player2.value;
    };

    func mergeSort(entries: List.List<T.Player>) : List.List<T.Player> {
        let len = List.size(entries);
        
        if (len <= 1) {
            return entries;
        } else {
            let (firstHalf, secondHalf) = List.split(len / 2, entries);
            return List.merge(mergeSort(firstHalf), mergeSort(secondHalf), compare);
        };
    };

    let returnPlayers = List.map<T.Player, T.Player>(
      List.filter<T.Player>(players, func (player: T.Player) : Bool {
        return (teamId == 0 or player.teamId == teamId) and (positionId == -1 or Nat8.toNat(player.position) == positionId);
      }), 
      func (player: T.Player) : T.Player {
        return {
          id = player.id;
          teamId = player.teamId;
          position = player.position; //0 = Goalkeeper //1 = Defender //2 = Midfielder //3 = Forward
          firstName = player.firstName;
          lastName = player.lastName;
          shirtNumber = player.shirtNumber;
          value = player.value;
          dateOfBirth = player.dateOfBirth;
          nationality = player.nationality;
          seasons = List.nil<T.PlayerSeason>();
        };
    });

    let sortedPlayers = mergeSort(returnPlayers);

    let paginatedPlayers = List.take(List.drop(sortedPlayers, start), count);
    
    let dto: DTOs.PlayerRatingsDTO = {
      players = List.toArray(paginatedPlayers);
      totalEntries = Nat16.fromNat(List.size<T.Player>(returnPlayers));
    };

    return dto;

  };

  public shared query ({caller}) func getAllPlayers() : async [DTOs.PlayerDTO] {
    assert not Principal.isAnonymous(caller);

    func compare(player1: T.Player, player2: T.Player) : Bool {
        return player1.value >= player2.value;
    };

    func mergeSort(entries: List.List<T.Player>) : List.List<T.Player> {
        let len = List.size(entries);
        
        if (len <= 1) {
            return entries;
        } else {
            let (firstHalf, secondHalf) = List.split(len / 2, entries);
            return List.merge(mergeSort(firstHalf), mergeSort(secondHalf), compare);
        };
    };

    let sortedPlayers = mergeSort(players);
    return Array.map<T.Player, DTOs.PlayerDTO>(List.toArray(sortedPlayers), func (player: T.Player) : DTOs.PlayerDTO { 
      return {
        id = player.id;
        firstName = player.firstName;
        lastName = player.lastName;
        teamId = player.teamId;
        position = player.position;
        shirtNumber = player.shirtNumber;
        value = player.value;
        dateOfBirth = player.dateOfBirth;
        nationality = player.nationality;
        totalPoints = 0;
      }});
  };

  public query ({caller}) func getPlayer() : async [DTOs.PlayerDTO] {
    assert not Principal.isAnonymous(caller);

    func compare(player1: T.Player, player2: T.Player) : Bool {
        return player1.value >= player2.value;
    };

    func mergeSort(entries: List.List<T.Player>) : List.List<T.Player> {
        let len = List.size(entries);
        
        if (len <= 1) {
            return entries;
        } else {
            let (firstHalf, secondHalf) = List.split(len / 2, entries);
            return List.merge(mergeSort(firstHalf), mergeSort(secondHalf), compare);
        };
    };

    let sortedPlayers = mergeSort(players);
    return Array.map<T.Player, DTOs.PlayerDTO>(List.toArray(sortedPlayers), func (player: T.Player) : DTOs.PlayerDTO { 
      return {
        id = player.id;
        firstName = player.firstName;
        lastName = player.lastName;
        teamId = player.teamId;
        position = player.position;
        shirtNumber = player.shirtNumber;
        value = player.value;
        dateOfBirth = player.dateOfBirth;
        nationality = player.nationality;
        totalPoints = 0;
      }});
  };

  public func revaluePlayers(revaluedPlayers: [T.Player]){

    //update the players value in the player canister
    //ensure the prior value is recorded
  };

  public func calculatePlayerScores(gameweek: Nat8, gameweekFixtures: [T.Fixture]) : async [T.Fixture] {
    
    /*
    let eq = func (a: Nat16, b: Nat16) : Bool {
        a == b
    };

    let hashNat16 = func (key: Nat16) : Hash.Hash {
        Nat32.fromNat(Nat16.toNat(key)%(2 ** 32 -1));
    };

    //get map of all player ids and events
    let playerEventsMap: HashMap.HashMap<Nat16, T.PlayerEventData> = HashMap.HashMap<Nat16, T.PlayerEventData >(22, eq, hashNat16);
    for (i in Iter.range(0, Array.size(gameweekFixtures)-1)) {
        let events = List.toArray<T.PlayerEventData>(gameweekFixtures[i].events);
        for (j in Iter.range(0, Array.size(events)-1)) {
            let playerId: Nat16 = events[j].playerId;
            playerEventsMap.put(playerId, events[j]);
        };
    };
    */
    
    //save each players event data
    //record a summary of their gameweek
    //in seasons then gameweeks - use lists
    return [];
  };

  system func heartbeat() : async () {
      
  };
  
  system func preupgrade() {
    stable_players := List.toArray(players);
    stable_next_player_id := nextPlayerId;
  };

  system func postupgrade() {
    players := List.fromArray(stable_players);
    nextPlayerId := stable_next_player_id;
  };

};

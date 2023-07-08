import T "../OpenFPL_backend/types";
import DTOs "../OpenFPL_backend/DTOs";
import List "mo:base/List";
import Principal "mo:base/Principal";
import GenesisData "../OpenFPL_backend/genesis-data";
import Nat8 "mo:base/Nat8";
import Int "mo:base/Int";
import Nat "mo:base/Nat";
import Nat16 "mo:base/Nat16";

actor Self {

  private var players = List.fromArray<T.Player>(GenesisData.genesis_players);
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

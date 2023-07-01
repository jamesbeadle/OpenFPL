import T "../OpenFPL_backend/types";
import List "mo:base/List";
import Principal "mo:base/Principal";
import GenesisData "../OpenFPL_backend/genesis-data";
import Nat8 "mo:base/Nat8";
import Int "mo:base/Int";
import Nat "mo:base/Nat";

actor Self {

  private var players = List.fromArray<T.Player>(GenesisData.genesis_players);
  private var nextPlayerId : Nat = 1;

  private stable var stable_players: [T.Player] = [];
  private stable var stable_next_player_id : Nat = 0;
  
  public shared query ({caller}) func getPlayers(teamId: Nat16, positionId: Int) : async [T.Player] {
    assert not Principal.isAnonymous(caller);

    return List.toArray(List.map<T.Player, T.Player>(
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
    }));

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

import Array "mo:base/Array";
import Iter "mo:base/Iter";
import Int "mo:base/Int";
import Int64 "mo:base/Int64";
import List "mo:base/List";
import Nat "mo:base/Nat";
import Nat8 "mo:base/Nat8";
import Nat16 "mo:base/Nat16";
import Nat64 "mo:base/Nat64";
import Option "mo:base/Option";
import Text "mo:base/Text";
import Result "mo:base/Result";
import TrieMap "mo:base/TrieMap";
import T "../types/app_types";
import FootballTypes "../types/football_types";
import DTOs "../dtos/dtos";
import Commands "../cqrs/commands";
import BaseTypes "../types/base_types";

module {

  public func getTeamValue(playerIds: [FootballTypes.PlayerId], allPlayers: [DTOs.PlayerDTO]) : Nat16 {
      let updatedPlayers = Array.filter<DTOs.PlayerDTO>(
        allPlayers,
        func(player : DTOs.PlayerDTO) : Bool {
          let playerId = player.id;
          let isPlayerIdInNewTeam = Array.find(
            playerIds,
            func(id : Nat16) : Bool {
              return id == playerId;
            },
          );
          return Option.isSome(isPlayerIdInNewTeam);
        },
      );

      return Array.foldLeft<DTOs.PlayerDTO, Nat16>(updatedPlayers, 0, func(sumSoFar, x) = sumSoFar + x.valueQuarterMillions);
  };

  public func selectedBonusPlayedAlready(manager: T.Manager, saveBonusDTO: Commands.SaveBonusDTO) : Bool {
      switch(saveBonusDTO.goalGetterGameweek){
        case (?_){
          return manager.goalGetterGameweek > 0;
        };
        case (null){};
      };

      switch(saveBonusDTO.passMasterGameweek){
        case (?_){
          return manager.passMasterGameweek > 0;
        };
        case (null){};
      };

      switch(saveBonusDTO.noEntryGameweek){
        case (?_){
          return manager.noEntryGameweek > 0;
        };
        case (null){};
      };

      switch(saveBonusDTO.teamBoostGameweek){
        case (?_){
          return manager.teamBoostGameweek > 0;
        };
        case (null){};
      };

      switch(saveBonusDTO.safeHandsGameweek){
        case (?_){
          return manager.safeHandsGameweek > 0;
        };
        case (null){};
      };

      switch(saveBonusDTO.captainFantasticGameweek){
        case (?_){
          return manager.captainFantasticGameweek > 0;
        };
        case (null){};
      };

      switch(saveBonusDTO.prospectsGameweek){
        case (?_){
          return manager.prospectsGameweek > 0;
        };
        case (null){};
      };

      switch(saveBonusDTO.oneNationGameweek){
        case (?_){
          return manager.oneNationGameweek > 0;
        };
        case (null){};
      };

      switch(saveBonusDTO.braceBonusGameweek){
        case (?_){
          return manager.braceBonusGameweek > 0;
        };
        case (null){};
      };

      switch(saveBonusDTO.hatTrickHeroGameweek){
        case (?_){
          return manager.hatTrickHeroGameweek > 0;
        };
        case (null){};
      };

      return false;
  };

  public func overspent(currentBankBalance: Nat16, existingPlayerIds: [FootballTypes.PlayerId], updatedPlayerIds: [FootballTypes.PlayerId], allPlayers: [DTOs.PlayerDTO]) : Bool{
    
    let updatedPlayers = Array.filter<DTOs.PlayerDTO>(
      allPlayers,
      func(player : DTOs.PlayerDTO) : Bool {
        let playerId = player.id;
        let isPlayerIdInNewTeam = Array.find(
          updatedPlayerIds,
          func(id : Nat16) : Bool {
            return id == playerId;
          },
        );
        return Option.isSome(isPlayerIdInNewTeam);
      },
    );

    let playersAdded = Array.filter<DTOs.PlayerDTO>(
      updatedPlayers,
      func(player : DTOs.PlayerDTO) : Bool {
        let playerId = player.id;
        let isPlayerIdInExistingTeam = Array.find(
          existingPlayerIds,
          func(id : Nat16) : Bool {
            return id == playerId;
          },
        );
        return Option.isNull(isPlayerIdInExistingTeam);
      },
    );

    let playersRemoved = Array.filter<Nat16>(
      existingPlayerIds,
      func(playerId : Nat16) : Bool {
        let isPlayerIdInPlayers = Array.find(
          updatedPlayers,
          func(player : DTOs.PlayerDTO) : Bool {
            return player.id == playerId;
          },
        );
        return Option.isNull(isPlayerIdInPlayers);
      },
    );

    let spentNat16 = Array.foldLeft<DTOs.PlayerDTO, Nat16>(playersAdded, 0, func(sumSoFar, x) = sumSoFar + x.valueQuarterMillions);
    var sold : Int = 0;
    
    for (i in Iter.range(0, Array.size(playersRemoved) -1)) {
      let foundPlayer = List.find<DTOs.PlayerDTO>(
        List.fromArray(allPlayers),
        func(player : DTOs.PlayerDTO) : Bool {
          return player.id == playersRemoved[i];
        },
      );
      switch (foundPlayer) {
        case (null) {};
        case (?player) {
          sold := sold + Nat16.toNat(player.valueQuarterMillions);
        };
      };
    };
    
    let netSpendQMs : Int = Int64.toInt(Int64.fromNat64(Nat64.fromNat(Nat16.toNat(spentNat16)))) - sold;
    let newBankBalance: Int = Int64.toInt(Int64.fromNat64(Nat64.fromNat(Nat16.toNat(currentBankBalance)))) - netSpendQMs;
    if (newBankBalance < 0) {
      return true;
    };

    return false;
  };

  public func teamValid(updatedFantasyTeam : Commands.SaveTeamDTO, players : [DTOs.PlayerDTO]) : Result.Result<(), T.Error> {
    
    let newTeamPlayers = Array.filter<DTOs.PlayerDTO>(
      players,
      func(player : DTOs.PlayerDTO) : Bool {
        let isPlayerIdInNewTeam = Array.find(
          updatedFantasyTeam.playerIds,
          func(id : Nat16) : Bool {
            return id == player.id;
          },
        );
        return Option.isSome(isPlayerIdInNewTeam);
      },
    );

    let playerCount = newTeamPlayers.size();

    if (playerCount != 11) {
      return #err(#Not11Players);
    };

    var teamPlayerCounts = TrieMap.TrieMap<Text, Nat8>(Text.equal, Text.hash);
    var playerIdCounts = TrieMap.TrieMap<Text, Nat8>(Text.equal, Text.hash);
    var goalkeeperCount = 0;
    var defenderCount = 0;
    var midfielderCount = 0;
    var forwardCount = 0;
    var captainInTeam = false;
    

    for (i in Iter.range(0, playerCount -1)) {

      let count = teamPlayerCounts.get(Nat16.toText(newTeamPlayers[i].clubId));
      switch (count) {
        case (null) {
          teamPlayerCounts.put(Nat16.toText(newTeamPlayers[i].clubId), 1);
        };
        case (?count) {
          teamPlayerCounts.put(Nat16.toText(newTeamPlayers[i].clubId), count + 1);
        };
      };

      let playerIdCount = playerIdCounts.get(Nat16.toText(newTeamPlayers[i].id));
      switch (playerIdCount) {
        case (null) { playerIdCounts.put(Nat16.toText(newTeamPlayers[i].id), 1) };
        case (?count) {

          return #err(#DuplicatePlayerInTeam);
        };
      };

      if (newTeamPlayers[i].position == #Goalkeeper) {
        goalkeeperCount += 1;
      };

      if (newTeamPlayers[i].position == #Defender) {
        defenderCount += 1;
      };

      if (newTeamPlayers[i].position == #Midfielder) {
        midfielderCount += 1;
      };

      if (newTeamPlayers[i].position == #Forward) {
        forwardCount += 1;
      };

      if (newTeamPlayers[i].id == updatedFantasyTeam.captainId) {
        captainInTeam := true;
      }

    };

    for ((key, value) in teamPlayerCounts.entries()) {
      if (value > 2) {

          return #err(#MoreThan2PlayersFromClub);
      };
    };

    if (
      goalkeeperCount != 1 or defenderCount < 3 or defenderCount > 5 or midfielderCount < 3 or midfielderCount > 5 or forwardCount < 1 or forwardCount > 3,
    ) {

          return #err(#NumberPerPositionError);
    };

    if (not captainInTeam) {
          return #err(#SelectedCaptainNotInTeam);
    };

    return #ok();
  };

  public func getTransfersAvailable(manager: T.Manager, updatedPlayerIds: [FootballTypes.PlayerId], allPlayers: [DTOs.PlayerDTO]) : Nat {
    

    let newPlayers = Array.filter<DTOs.PlayerDTO>(
      allPlayers,
      func(player : DTOs.PlayerDTO) : Bool {
        return Option.isSome(Array.find(
          updatedPlayerIds,
          func(id : Nat16) : Bool {
            return id == player.id;
          },
        ));
      },
    );

    let oldPlayers = Array.filter<DTOs.PlayerDTO>(
      allPlayers,
      func(player : DTOs.PlayerDTO) : Bool {
        return Option.isSome(Array.find(
          manager.playerIds,
          func(id : Nat16) : Bool {
            return id == player.id;
          },
        ));
      },
    );

    let additions = Array.filter<DTOs.PlayerDTO>(
      newPlayers,
      func(newPlayer : DTOs.PlayerDTO) : Bool {
        return Option.isNull(Array.find(
          oldPlayers,
          func(oldPlayer: DTOs.PlayerDTO) : Bool {
            return oldPlayer.id == newPlayer.id;
          },
        ));
      },
    );

    let transfersAvailable: Nat = Nat8.toNat(manager.transfersAvailable) -  Array.size(additions);
    return transfersAvailable;
  };

  public func isGameweekBonusUsed(manager: T.Manager, gameweek: FootballTypes.GameweekNumber) : Bool {
    return (manager.goalGetterGameweek == gameweek) or
    (manager.passMasterGameweek == gameweek) or
    (manager.noEntryGameweek == gameweek) or
    (manager.teamBoostGameweek == gameweek) or
    (manager.safeHandsGameweek == gameweek) or
    (manager.captainFantasticGameweek == gameweek) or
    (manager.prospectsGameweek == gameweek) or
    (manager.oneNationGameweek == gameweek) or
    (manager.braceBonusGameweek == gameweek) or
    (manager.hatTrickHeroGameweek == gameweek)
  };

  public func getNewBankBalance(manager: T.Manager, dto: Commands.SaveTeamDTO, allPlayers: [DTOs.PlayerDTO]) : Result.Result<Nat16, T.Error> {

    let updatedPlayers = Array.filter<DTOs.PlayerDTO>(
      allPlayers,
      func(player : DTOs.PlayerDTO) : Bool {
        let playerId = player.id;
        let isPlayerIdInNewTeam = Array.find(
          dto.playerIds,
          func(id : Nat16) : Bool {
            return id == playerId;
          },
        );
        return Option.isSome(isPlayerIdInNewTeam);
      },
    );

    let playersAdded = Array.filter<DTOs.PlayerDTO>(
      updatedPlayers,
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
          updatedPlayers,
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
        List.fromArray(allPlayers),
        func(player : DTOs.PlayerDTO) : Bool {
          return player.id == playersRemoved[i];
        },
      );
      switch (foundPlayer) {
        case (null) {};
        case (?player) {
          sold := sold + player.valueQuarterMillions;
        };
      };
    };
    
    return #ok(manager.bankQuarterMillions + sold - spent);
  };

  public func valueOrDefaultGameweek(value: ?FootballTypes.GameweekNumber, default: FootballTypes.GameweekNumber) : FootballTypes.GameweekNumber {
    switch(value){
      case (?foundValue){
        return foundValue;
      };
      case (null) {
        return default;
      }
    }
  };

  public func valueOrDefaultPlayerId(value: ?FootballTypes.PlayerId, default: FootballTypes.PlayerId) : FootballTypes.PlayerId {
    switch(value){
      case (?foundValue){
        return foundValue;
      };
      case (null) {
        return default;
      }
    }
  };

  public func valueOrDefaultClubId(value: ?FootballTypes.ClubId, default: FootballTypes.ClubId) : FootballTypes.ClubId {
    switch(value){
      case (?foundValue){
        return foundValue;
      };
      case (null) {
        return default;
      }
    }
  };

  public func valueOrDefaultCountryId(value: ?BaseTypes.CountryId, default: FootballTypes.ClubId) : FootballTypes.ClubId {
    switch(value){
      case (?foundValue){
        return foundValue;
      };
      case (null) {
        return default;
      }
    }
  };

};

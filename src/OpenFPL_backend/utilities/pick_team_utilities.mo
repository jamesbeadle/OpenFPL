import Array "mo:base/Array";
import Enums "mo:waterway-mops/base/enums";
import Ids "mo:waterway-mops/base/ids";
import FootballIds "mo:waterway-mops/domain/football/ids";
import FootballDefinitions "mo:waterway-mops/domain/football/definitions";
import PlayerQueries "mo:waterway-mops/product/icfc/data-canister-queries/player-queries";
import Int "mo:base/Int";
import Int64 "mo:base/Int64";
import Iter "mo:base/Iter";
import List "mo:base/List";
import Nat "mo:base/Nat";
import Nat8 "mo:base/Nat8";
import Nat16 "mo:base/Nat16";
import Nat64 "mo:base/Nat64";
import Option "mo:base/Option";
import Result "mo:base/Result";
import Text "mo:base/Text";
import TrieMap "mo:base/TrieMap";

import UserCommands "../commands/user_commands";
import AppTypes "../types/app_types";

module {

  public func selectedBonusPlayedAlready(manager : AppTypes.Manager, dto : UserCommands.PlayBonus) : Bool {
    switch (dto.bonusType) {
      case (#GoalGetter) {
        return manager.goalGetterGameweek > 0;
      };
      case (#BraceBonus) {
        return manager.braceBonusGameweek > 0;
      };
      case (#CaptainFantastic) {
        return manager.captainFantasticGameweek > 0;
      };
      case (#HatTrickHero) {
        return manager.hatTrickHeroGameweek > 0;
      };
      case (#NoEntry) {
        return manager.noEntryGameweek > 0;
      };
      case (#OneNation) {
        return manager.oneNationGameweek > 0;
      };
      case (#PassMaster) {
        return manager.passMasterGameweek > 0;
      };
      case (#Prospects) {
        return manager.prospectsGameweek > 0;
      };
      case (#SafeHands) {
        return manager.safeHandsGameweek > 0;
      };
      case (#TeamBoost) {
        return manager.teamBoostGameweek > 0;
      };
    };

    return false;
  };
  
  public func overspent(currentBankBalance : Nat16, existingPlayerIds : [FootballIds.PlayerId], updatedPlayerIds : [FootballIds.PlayerId], allPlayers : [PlayerQueries.Player]) : Bool {

    let updatedPlayers = Array.filter<PlayerQueries.Player>(
      allPlayers,
      func(player : PlayerQueries.Player) : Bool {
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

    let playersAdded = Array.filter<PlayerQueries.Player>(
      updatedPlayers,
      func(player : PlayerQueries.Player) : Bool {
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
          func(player : PlayerQueries.Player) : Bool {
            return player.id == playerId;
          },
        );
        return Option.isNull(isPlayerIdInPlayers);
      },
    );

    let spentNat16 = Array.foldLeft<PlayerQueries.Player, Nat16>(playersAdded, 0, func(sumSoFar, x) = sumSoFar + x.valueQuarterMillions);
    var sold : Int = 0;

    for (i in Iter.range(0, Array.size(playersRemoved) -1)) {
      let foundPlayer = List.find<PlayerQueries.Player>(
        List.fromArray(allPlayers),
        func(player : PlayerQueries.Player) : Bool {
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
    let newBankBalance : Int = Int64.toInt(Int64.fromNat64(Nat64.fromNat(Nat16.toNat(currentBankBalance)))) - netSpendQMs;
    if (newBankBalance < 0) {
      return true;
    };

    return false;
  };

  public func teamValid(updatedFantasyTeam : UserCommands.SaveFantasyTeam, players : [PlayerQueries.Player]) : Result.Result<(), Enums.Error> {

    let newTeamPlayers = Array.filter<PlayerQueries.Player>(
      players,
      func(player : PlayerQueries.Player) : Bool {
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
      return #err(#IncorrectSetup);
    };

    var teamPlayerCounts = TrieMap.TrieMap<Text, Nat8>(Text.equal, Text.hash);
    var playerIdCounts = TrieMap.TrieMap<Text, Nat8>(Text.equal, Text.hash);
    var goalkeeperCount = 0;
    var defenderCount = 0;
    var midfielderCount = 0;
    var forwardCount = 0;
    var captainInTeam = false;

    for (i in Iter.range(0, playerCount - 1)) {

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
        case (null) {
          playerIdCounts.put(Nat16.toText(newTeamPlayers[i].id), 1);
        };
        case (?count) {

          return #err(#DuplicateData);
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

        return #err(#MaxDataExceeded);
      };
    };

    if (
      goalkeeperCount != 1 or defenderCount < 3 or defenderCount > 5 or midfielderCount < 3 or midfielderCount > 5 or forwardCount < 1 or forwardCount > 3
    ) {

      return #err(#IncorrectSetup);
    };

    if (not captainInTeam) {
      return #err(#InvalidProperty);
    };

    return #ok();
  };

  public func getTransfersAvailable(manager : AppTypes.Manager, updatedPlayerIds : [FootballIds.PlayerId], allPlayers : [PlayerQueries.Player]) : Nat {
    let newPlayers = Array.filter<PlayerQueries.Player>(
      allPlayers,
      func(player : PlayerQueries.Player) : Bool {
        return Option.isSome(
          Array.find(
            updatedPlayerIds,
            func(id : Nat16) : Bool {
              return id == player.id;
            },
          )
        );
      },
    );

    let oldPlayers = Array.filter<PlayerQueries.Player>(
      allPlayers,
      func(player : PlayerQueries.Player) : Bool {
        return Option.isSome(
          Array.find(
            manager.playerIds,
            func(id : Nat16) : Bool {
              return id == player.id;
            },
          )
        );
      },
    );

    let additions = Array.filter<PlayerQueries.Player>(
      newPlayers,
      func(newPlayer : PlayerQueries.Player) : Bool {
        return Option.isNull(
          Array.find(
            oldPlayers,
            func(oldPlayer : PlayerQueries.Player) : Bool {
              return oldPlayer.id == newPlayer.id;
            },
          )
        );
      },
    );

    let transfersUsed = Array.size(additions);
    let currentTransfers = Nat8.toNat(manager.transfersAvailable);
    if (transfersUsed > currentTransfers) {
      return 0;//no transfers available
    } else {
      return currentTransfers - transfersUsed;
    };
  };

  public func isGameweekBonusUsed(manager : AppTypes.Manager, gameweek : FootballDefinitions.GameweekNumber) : Bool {
    return (manager.goalGetterGameweek == gameweek) or (manager.passMasterGameweek == gameweek) or (manager.noEntryGameweek == gameweek) or (manager.teamBoostGameweek == gameweek) or (manager.safeHandsGameweek == gameweek) or (manager.captainFantasticGameweek == gameweek) or (manager.prospectsGameweek == gameweek) or (manager.oneNationGameweek == gameweek) or (manager.braceBonusGameweek == gameweek) or (manager.hatTrickHeroGameweek == gameweek);
  };

  public func getNewBankBalance(manager : AppTypes.Manager, dto : UserCommands.SaveFantasyTeam, allPlayers : [PlayerQueries.Player]) : Result.Result<Nat16, Enums.Error> {
    let updatedPlayers = Array.filter<PlayerQueries.Player>(
      allPlayers,
      func(player : PlayerQueries.Player) : Bool {
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

    let playersAdded = Array.filter<PlayerQueries.Player>(
      updatedPlayers,
      func(player : PlayerQueries.Player) : Bool {
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
          func(player : PlayerQueries.Player) : Bool {
            return player.id == playerId;
          },
        );
        return Option.isNull(isPlayerIdInPlayers);
      },
    );

    let spent = Array.foldLeft<PlayerQueries.Player, Nat16>(
      playersAdded,
      0,
      func(sumSoFar, x) = sumSoFar + x.valueQuarterMillions,
    );

    var sold : Nat16 = 0;
    for (i in Iter.range(0, Array.size(playersRemoved) - 1)) {
      let foundPlayer = List.find<PlayerQueries.Player>(
        List.fromArray(allPlayers),
        func(player : PlayerQueries.Player) : Bool {
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

    if (spent <= sold) {
      let gain = sold - spent;
      let newBalance = manager.bankQuarterMillions + gain;
      return #ok(newBalance);
    } else {
      let netSpend = spent - sold;
      if (manager.bankQuarterMillions >= netSpend) {
        let newBalance = manager.bankQuarterMillions - netSpend;
        return #ok(newBalance);
      } else {
        return #err(#InsufficientFunds);
      };
    };
  };

  public func valueOrDefaultGameweek(value : ?FootballDefinitions.GameweekNumber, default : FootballDefinitions.GameweekNumber) : FootballDefinitions.GameweekNumber {
    switch (value) {
      case (?foundValue) {
        return foundValue;
      };
      case (null) {
        return default;
      };
    };
  };

  public func valueOrDefaultPlayerId(value : ?FootballIds.PlayerId, default : FootballIds.PlayerId) : FootballIds.PlayerId {
    switch (value) {
      case (?foundValue) {
        return foundValue;
      };
      case (null) {
        return default;
      };
    };
  };

  public func valueOrDefaultClubId(value : ?FootballIds.ClubId, default : FootballIds.ClubId) : FootballIds.ClubId {
    switch (value) {
      case (?foundValue) {
        return foundValue;
      };
      case (null) {
        return default;
      };
    };
  };

  public func valueOrDefaultCountryId(value : ?Ids.CountryId, default : FootballIds.ClubId) : FootballIds.ClubId {
    switch (value) {
      case (?foundValue) {
        return foundValue;
      };
      case (null) {
        return default;
      };
    };
  };

};

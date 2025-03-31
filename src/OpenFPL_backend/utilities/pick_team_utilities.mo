import Array "mo:base/Array";
import BaseTypes "mo:waterway-mops/BaseTypes";
import FootballTypes "mo:waterway-mops/FootballTypes";
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
import DataCanister "canister:data_canister";

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

  public func overspent(currentBankBalance : Nat16, existingPlayerIds : [FootballTypes.PlayerId], updatedPlayerIds : [FootballTypes.PlayerId], allPlayers : [FootballGodQueries.Player]) : Bool {

    let updatedPlayers = Array.filter<FootballGodQueries.Player>(
      allPlayers,
      func(player : FootballGodQueries.Player) : Bool {
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

    let playersAdded = Array.filter<FootballGodQueries.Player>(
      updatedPlayers,
      func(player : FootballGodQueries.Player) : Bool {
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
          func(player : FootballGodQueries.Player) : Bool {
            return player.id == playerId;
          },
        );
        return Option.isNull(isPlayerIdInPlayers);
      },
    );

    let spentNat16 = Array.foldLeft<FootballGodQueries.Player, Nat16>(playersAdded, 0, func(sumSoFar, x) = sumSoFar + x.valueQuarterMillions);
    var sold : Int = 0;

    for (i in Iter.range(0, Array.size(playersRemoved) -1)) {
      let foundPlayer = List.find<FootballGodQueries.Player>(
        List.fromArray(allPlayers),
        func(player : FootballGodQueries.Player) : Bool {
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

  public func teamValid(updatedFantasyTeam : UserCommands.SaveFantasyTeam, players : [FootballGodQueries.Player]) : Result.Result<(), MopsEnums.Error> {

    let newTeamPlayers = Array.filter<FootballGodQueries.Player>(
      players,
      func(player : FootballGodQueries.Player) : Bool {
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
      goalkeeperCount != 1 or defenderCount < 3 or defenderCount > 5 or midfielderCount < 3 or midfielderCount > 5 or forwardCount < 1 or forwardCount > 3
    ) {

      return #err(#NumberPerPositionError);
    };

    if (not captainInTeam) {
      return #err(#SelectedCaptainNotInTeam);
    };

    return #ok();
  };

  public func getTransfersAvailable(manager : AppTypes.Manager, updatedPlayerIds : [FootballTypes.PlayerId], allPlayers : [FootballGodQueries.Player]) : Nat {
    let newPlayers = Array.filter<FootballGodQueries.Player>(
      allPlayers,
      func(player : FootballGodQueries.Player) : Bool {
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

    let oldPlayers = Array.filter<FootballGodQueries.Player>(
      allPlayers,
      func(player : FootballGodQueries.Player) : Bool {
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

    let additions = Array.filter<FootballGodQueries.Player>(
      newPlayers,
      func(newPlayer : FootballGodQueries.Player) : Bool {
        return Option.isNull(
          Array.find(
            oldPlayers,
            func(oldPlayer : FootballGodQueries.Player) : Bool {
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

  public func isGameweekBonusUsed(manager : AppTypes.Manager, gameweek : FootballTypes.GameweekNumber) : Bool {
    return (manager.goalGetterGameweek == gameweek) or (manager.passMasterGameweek == gameweek) or (manager.noEntryGameweek == gameweek) or (manager.teamBoostGameweek == gameweek) or (manager.safeHandsGameweek == gameweek) or (manager.captainFantasticGameweek == gameweek) or (manager.prospectsGameweek == gameweek) or (manager.oneNationGameweek == gameweek) or (manager.braceBonusGameweek == gameweek) or (manager.hatTrickHeroGameweek == gameweek);
  };

  public func getNewBankBalance(manager : AppTypes.Manager, dto : UserCommands.SaveFantasyTeam, allPlayers : [FootballGodQueries.Player]) : Result.Result<Nat16, MopsEnums.Error> {
    let updatedPlayers = Array.filter<FootballGodQueries.Player>(
      allPlayers,
      func(player : FootballGodQueries.Player) : Bool {
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

    let playersAdded = Array.filter<FootballGodQueries.Player>(
      updatedPlayers,
      func(player : FootballGodQueries.Player) : Bool {
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
          func(player : FootballGodQueries.Player) : Bool {
            return player.id == playerId;
          },
        );
        return Option.isNull(isPlayerIdInPlayers);
      },
    );

    let spent = Array.foldLeft<FootballGodQueries.Player, Nat16>(
      playersAdded,
      0,
      func(sumSoFar, x) = sumSoFar + x.valueQuarterMillions,
    );

    var sold : Nat16 = 0;
    for (i in Iter.range(0, Array.size(playersRemoved) - 1)) {
      let foundPlayer = List.find<FootballGodQueries.Player>(
        List.fromArray(allPlayers),
        func(player : FootballGodQueries.Player) : Bool {
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

  public func valueOrDefaultGameweek(value : ?FootballTypes.GameweekNumber, default : FootballTypes.GameweekNumber) : FootballTypes.GameweekNumber {
    switch (value) {
      case (?foundValue) {
        return foundValue;
      };
      case (null) {
        return default;
      };
    };
  };

  public func valueOrDefaultPlayerId(value : ?FootballTypes.PlayerId, default : FootballTypes.PlayerId) : FootballTypes.PlayerId {
    switch (value) {
      case (?foundValue) {
        return foundValue;
      };
      case (null) {
        return default;
      };
    };
  };

  public func valueOrDefaultClubId(value : ?FootballTypes.ClubId, default : FootballTypes.ClubId) : FootballTypes.ClubId {
    switch (value) {
      case (?foundValue) {
        return foundValue;
      };
      case (null) {
        return default;
      };
    };
  };

  public func valueOrDefaultCountryId(value : ?BaseTypes.CountryId, default : FootballTypes.ClubId) : FootballTypes.ClubId {
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

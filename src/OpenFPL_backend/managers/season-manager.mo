import Result "mo:base/Result";
import Buffer "mo:base/Buffer";
import Iter "mo:base/Iter";
import Array "mo:base/Array";
import Option "mo:base/Option";
import Base "mo:waterway-mops/BaseTypes";
import BaseTypes "mo:waterway-mops/BaseTypes";
import SHA224 "mo:waterway-mops/SHA224";
import Enums "mo:waterway-mops/Enums";
import FootballIds "mo:waterway-mops/football/FootballIds";
import FootballDefinitions "mo:waterway-mops/football/FootballDefinitions";
import BaseQueries "mo:waterway-mops/queries/BaseQueries";
import PlayerQueries "mo:waterway-mops/queries/football-queries/PlayerQueries";
import AppCommands "../../OpenFPL_backend/commands/app_commands";
import AppTypes "../types/app_types";
import AppQueries "../queries/app_queries";

module {

  public class SeasonManager() {

    var appStatus : BaseTypes.AppStatus = {
      onHold = false;
      version = "2.0.0";
    };

    private var dataHashes : [Base.DataHash] = [
      { category = "weekly_leaderboard"; hash = "OPENFPL_2" },
      { category = "monthly_leaderboards"; hash = "OPENFPL_2" },
      { category = "season_leaderboard"; hash = "OPENFPL_2" },
      { category = "app_status"; hash = "OPENFPL_2" },
      { category = "reward_rates"; hash = "OPENFPL_2" },
      { category = "clubs"; hash = "OPENFPL_2" },
      { category = "countries"; hash = "OPENFPL_2" },
      { category = "fixtures"; hash = "OPENFPL_2" },
      { category = "player_events"; hash = "OPENFPL_2" },
      { category = "seasons"; hash = "OPENFPL_2" },
      { category = "players"; hash = "OPENFPL_2" },
      { category = "league_status"; hash = "OPENFPL_2" },
    ];

    private var playersSnapshots : [(FootballIds.SeasonId, [(FootballDefinitions.GameweekNumber, [PlayerQueries.Player])])] = [];

    public func updateDataHash(category : Text) : async () {
      let hashBuffer = Buffer.fromArray<Base.DataHash>([]);
      var updated = false;

      for (hashObj in Iter.fromArray(dataHashes)) {
        if (hashObj.category == category) {
          let randomHash = await SHA224.getRandomHash();
          hashBuffer.add({ category = hashObj.category; hash = randomHash });
          updated := true;
        } else { hashBuffer.add(hashObj) };
      };

      if (not updated) {
        let randomHash = await SHA224.getRandomHash();
        hashBuffer.add({ category = category; hash = randomHash });
      };

      dataHashes := Buffer.toArray<Base.DataHash>(hashBuffer);
    };

    public func addNewDataHash(category : Text) : async () {
      let exists = Array.find<Base.DataHash>(
        dataHashes,
        func(foundHash : Base.DataHash) : Bool {
          foundHash.category == category;
        },
      );
      if (Option.isNull(exists)) {
        let hashBuffer = Buffer.fromArray<Base.DataHash>(dataHashes);
        let randomHash = await SHA224.getRandomHash();
        hashBuffer.add({ category = category; hash = randomHash });
        dataHashes := Buffer.toArray<Base.DataHash>(hashBuffer);
      };
    };
    
    public func getDataHashes() : Result.Result<[BaseQueries.DataHash], Enums.Error> {
      return #ok(dataHashes);
    };

    public func getAppStatus() : Result.Result<BaseQueries.AppStatus, Enums.Error> {
      return #ok({
        onHold = appStatus.onHold;
        version = appStatus.version;
      });
    };

    public func storePlayersSnapshot(seasonId : FootballIds.SeasonId, gameweek : FootballDefinitions.GameweekNumber, players : PlayerQueries.Players) {

      let existingSeasonsSnapshot = Array.find<(FootballIds.SeasonId, [(FootballDefinitions.GameweekNumber, [PlayerQueries.Player])])>(
        playersSnapshots,
        func(seasonPlayersEntry : (FootballIds.SeasonId, [(FootballDefinitions.GameweekNumber, [PlayerQueries.Player])])) : Bool {
          seasonPlayersEntry.0 == seasonId;
        },
      );

      switch (existingSeasonsSnapshot) {
        case (?foundSeasonSnapshot) {
          let existingGameweekSnapshot = Array.find<(FootballDefinitions.GameweekNumber, [PlayerQueries.Player])>(
            foundSeasonSnapshot.1,
            func(gameweekEntry : (FootballDefinitions.GameweekNumber, [PlayerQueries.Player])) : Bool {
              gameweekEntry.0 == gameweek;
            },
          );

          switch (existingGameweekSnapshot) {
            case (?_) {
              playersSnapshots := Array.map<(FootballIds.SeasonId, [(FootballDefinitions.GameweekNumber, [PlayerQueries.Player])]), (FootballIds.SeasonId, [(FootballDefinitions.GameweekNumber, [PlayerQueries.Player])])>(
                playersSnapshots,
                func(seasonsSnapshotEntry : (FootballIds.SeasonId, [(FootballDefinitions.GameweekNumber, [PlayerQueries.Player])])) {
                  if (seasonsSnapshotEntry.0 == seasonId) {
                    return (
                      seasonsSnapshotEntry.0,
                      Array.map<(FootballDefinitions.GameweekNumber, [PlayerQueries.Player]), (FootballDefinitions.GameweekNumber, [PlayerQueries.Player])>(
                        seasonsSnapshotEntry.1,
                        func(gameweekEntry : (FootballDefinitions.GameweekNumber, [PlayerQueries.Player])) {
                          if (gameweekEntry.0 == gameweek) {
                            return (gameweekEntry.0, players.players);
                          } else {
                            return gameweekEntry;
                          };
                        },
                      ),
                    );
                  } else {
                    return seasonsSnapshotEntry;
                  };
                },
              );
            };
            case (null) {
              playersSnapshots := Array.map<(FootballIds.SeasonId, [(FootballDefinitions.GameweekNumber, [PlayerQueries.Player])]), (FootballIds.SeasonId, [(FootballDefinitions.GameweekNumber, [PlayerQueries.Player])])>(
                playersSnapshots,
                func(seasonsSnapshotEntry : (FootballIds.SeasonId, [(FootballDefinitions.GameweekNumber, [PlayerQueries.Player])])) {
                  if (seasonsSnapshotEntry.0 == seasonId) {
                    let updatedGameweeksBuffer = Buffer.fromArray<(FootballDefinitions.GameweekNumber, [PlayerQueries.Player])>(seasonsSnapshotEntry.1);
                    updatedGameweeksBuffer.add(gameweek, players.players);
                    return (seasonsSnapshotEntry.0, Buffer.toArray(updatedGameweeksBuffer));
                  } else {
                    return seasonsSnapshotEntry;
                  };
                },
              );
            };
          };
        };
        case (null) {
          let newEntry : (FootballIds.SeasonId, [(FootballDefinitions.GameweekNumber, [PlayerQueries.Player])]) = (seasonId, [(gameweek, players.players)]);

          let playerSnapshotsBuffer = Buffer.fromArray<(FootballIds.SeasonId, [(FootballDefinitions.GameweekNumber, [PlayerQueries.Player])])>(playersSnapshots);
          playerSnapshotsBuffer.add(newEntry);
          playersSnapshots := Buffer.toArray(playerSnapshotsBuffer);
        };
      };
    };

    public func getPlayersSnapshot(dto : AppQueries.GetPlayersSnapshot) : async Result.Result<AppQueries.PlayersSnapshot, Enums.Error> {
      let seasonPlayers = Array.find<(FootballIds.SeasonId, [(FootballDefinitions.GameweekNumber, [PlayerQueries.Player])])>(
        playersSnapshots,
        func(seasonsPlayerSnapshots : (FootballIds.SeasonId, [(FootballDefinitions.GameweekNumber, [PlayerQueries.Player])])) : Bool {
          seasonsPlayerSnapshots.0 == dto.seasonId;
        },
      );

      switch (seasonPlayers) {
        case (?foundSeasonPlayers) {
          let gameweekPlayers = Array.find<(FootballDefinitions.GameweekNumber, [PlayerQueries.Player])>(
            foundSeasonPlayers.1,
            func(gameweekPlayers : (FootballDefinitions.GameweekNumber, [PlayerQueries.Player])) : Bool {
              gameweekPlayers.0 == dto.gameweek;
            },
          );
          switch (gameweekPlayers) {
            case (?foundGameweekPlayers) {
              return #ok({ players = foundGameweekPlayers.1 });
            };
            case (null) {};
          };
        };
        case (null) {};
      };

      return #err(#NotFound);
    };

    public func resetAllDataHashes() : async () {
      await updateDataHash("weekly_leaderboard");
      await updateDataHash("monthly_leaderboards");
      await updateDataHash("season_leaderboard");
      await updateDataHash("app_status");
      await updateDataHash("reward_rates");
      await updateDataHash("clubs");
      await updateDataHash("countries");
      await updateDataHash("fixtures");
      await updateDataHash("player_events");
      await updateDataHash("seasons");
      await updateDataHash("players");
      await updateDataHash("league_status");
    };

    public func putOnHold() : async () {
      appStatus := {
        onHold = true;
        version = appStatus.version;
      };
      await updateDataHash("app_status");
    };

    public func removeOnHold() : async () {
      appStatus := {
        onHold = false;
        version = appStatus.version;
      };
      await updateDataHash("app_status");
    };

    public func updateSystemStatus(dto : AppCommands.UpdateSystemStatus) {
      appStatus := {
        onHold = dto.onHold;
        version = dto.version;
      };
    };

    //Stable variable functions

    public func getStableAppStatus() : AppTypes.AppStatus {
      return appStatus;
    };

    public func setStableAppStatus(stable_app_status : AppTypes.AppStatus) {
      appStatus := stable_app_status;
    };

    public func getStableDataHashes() : [Base.DataHash] {
      return dataHashes;
    };

    public func setStableDataHashes(stable_data_hashes : [Base.DataHash]) {
      dataHashes := stable_data_hashes;
    };
    
    public func getStablePlayersSnapshots() : [(FootballIds.SeasonId, [(FootballDefinitions.GameweekNumber, [PlayerQueries.Player])])] {
      return playersSnapshots;
    };
    public func setStablePlayersSnapshots(stable_players_snapshots : [(FootballIds.SeasonId, [(FootballDefinitions.GameweekNumber, [PlayerQueries.Player])])]) {
      playersSnapshots := stable_players_snapshots;
    };
  }

};

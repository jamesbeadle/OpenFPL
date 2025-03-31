import Result "mo:base/Result";
import Buffer "mo:base/Buffer";
import Iter "mo:base/Iter";
import Array "mo:base/Array";
import Option "mo:base/Option";
import FootballTypes "mo:waterway-mops/FootballTypes";
import Base "mo:waterway-mops/BaseTypes";
import BaseTypes "mo:waterway-mops/BaseTypes";
import AppCommands "../../OpenFPL_backend/commands/app_commands";
import AppTypes "../types/app_types";

module {

  public class SeasonManager() {

    var appStatus : BaseTypes.AppStatus = {
      onHold = false;
      version = "2.0.0";
    };

    private var dataHashes : [Base.DataHash] = [
      { category = "weekly_leaderboard"; hash = "OPENFPL_1" },
      { category = "monthly_leaderboards"; hash = "OPENFPL_1" },
      { category = "season_leaderboard"; hash = "OPENFPL_1" },
      { category = "app_status"; hash = "OPENFPL_1" },
      { category = "reward_rates"; hash = "OPENFPL_1" },
    ];

    private var leagueGameweekStatuses : [AppTypes.LeagueGameweekStatus] = [];
    private var leagueMonthStatuses : [AppTypes.LeagueMonthStatus] = [];
    private var leagueSeasonStatuses : [AppTypes.LeagueSeasonStatus] = [];

    private var playersSnapshots : [(FootballTypes.SeasonId, [(FootballTypes.GameweekNumber, [DTOs.PlayerDTO])])] = [];

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

    public func getDataHashes() : Result.Result<[DTOs.DataHashDTO], MopsEnums.Error> {
      return #ok(dataHashes);
    };

    public func getAppStatus() : Result.Result<DTOs.AppStatusDTO, MopsEnums.Error> {
      return #ok({
        onHold = appStatus.onHold;
        version = appStatus.version;
      });
    };

    public func storePlayersSnapshot(seasonId : FootballTypes.SeasonId, gameweek : FootballTypes.GameweekNumber, players : [DTOs.PlayerDTO]) {

      let existingSeasonsSnapshot = Array.find<(FootballTypes.SeasonId, [(FootballTypes.GameweekNumber, [DTOs.PlayerDTO])])>(
        playersSnapshots,
        func(seasonPlayersEntry : (FootballTypes.SeasonId, [(FootballTypes.GameweekNumber, [DTOs.PlayerDTO])])) : Bool {
          seasonPlayersEntry.0 == seasonId;
        },
      );

      switch (existingSeasonsSnapshot) {
        case (?foundSeasonSnapshot) {
          let existingGameweekSnapshot = Array.find<(FootballTypes.GameweekNumber, [DTOs.PlayerDTO])>(
            foundSeasonSnapshot.1,
            func(gameweekEntry : (FootballTypes.GameweekNumber, [DTOs.PlayerDTO])) : Bool {
              gameweekEntry.0 == gameweek;
            },
          );

          switch (existingGameweekSnapshot) {
            case (?_) {
              playersSnapshots := Array.map<(FootballTypes.SeasonId, [(FootballTypes.GameweekNumber, [DTOs.PlayerDTO])]), (FootballTypes.SeasonId, [(FootballTypes.GameweekNumber, [DTOs.PlayerDTO])])>(
                playersSnapshots,
                func(seasonsSnapshotEntry : (FootballTypes.SeasonId, [(FootballTypes.GameweekNumber, [DTOs.PlayerDTO])])) {
                  if (seasonsSnapshotEntry.0 == seasonId) {
                    return (
                      seasonsSnapshotEntry.0,
                      Array.map<(FootballTypes.GameweekNumber, [DTOs.PlayerDTO]), (FootballTypes.GameweekNumber, [DTOs.PlayerDTO])>(
                        seasonsSnapshotEntry.1,
                        func(gameweekEntry : (FootballTypes.GameweekNumber, [DTOs.PlayerDTO])) {
                          if (gameweekEntry.0 == gameweek) {
                            return (gameweekEntry.0, players);
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
              playersSnapshots := Array.map<(FootballTypes.SeasonId, [(FootballTypes.GameweekNumber, [DTOs.PlayerDTO])]), (FootballTypes.SeasonId, [(FootballTypes.GameweekNumber, [DTOs.PlayerDTO])])>(
                playersSnapshots,
                func(seasonsSnapshotEntry : (FootballTypes.SeasonId, [(FootballTypes.GameweekNumber, [DTOs.PlayerDTO])])) {
                  if (seasonsSnapshotEntry.0 == seasonId) {
                    let updatedGameweeksBuffer = Buffer.fromArray<(FootballTypes.GameweekNumber, [DTOs.PlayerDTO])>(seasonsSnapshotEntry.1);
                    updatedGameweeksBuffer.add(gameweek, players);
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
          let newEntry : (FootballTypes.SeasonId, [(FootballTypes.GameweekNumber, [DTOs.PlayerDTO])]) = (seasonId, [(gameweek, players)]);

          let playerSnapshotsBuffer = Buffer.fromArray<(FootballTypes.SeasonId, [(FootballTypes.GameweekNumber, [DTOs.PlayerDTO])])>(playersSnapshots);
          playerSnapshotsBuffer.add(newEntry);
          playersSnapshots := Buffer.toArray(playerSnapshotsBuffer);
        };
      };
    };

    public func getPlayersSnapshot(dto : FootballGodQueries.GetSnapshotPlayersDTO) : [DTOs.PlayerDTO] {
      let seasonPlayers = Array.find<(FootballTypes.SeasonId, [(FootballTypes.GameweekNumber, [DTOs.PlayerDTO])])>(
        playersSnapshots,
        func(seasonsPlayerSnapshots : (FootballTypes.SeasonId, [(FootballTypes.GameweekNumber, [DTOs.PlayerDTO])])) : Bool {
          seasonsPlayerSnapshots.0 == dto.seasonId;
        },
      );

      switch (seasonPlayers) {
        case (?foundSeasonPlayers) {
          let gameweekPlayers = Array.find<(FootballTypes.GameweekNumber, [DTOs.PlayerDTO])>(
            foundSeasonPlayers.1,
            func(gameweekPlayers : (FootballTypes.GameweekNumber, [DTOs.PlayerDTO])) : Bool {
              gameweekPlayers.0 == dto.gameweek;
            },
          );
          switch (gameweekPlayers) {
            case (?foundGameweekPlayers) {
              return foundGameweekPlayers.1;
            };
            case (null) {};
          };
        };
        case (null) {};
      };

      return [];
    };

    //Stable variable functions

    public func getStableAppStatus() : T.AppStatus {
      return appStatus;
    };

    public func setStableAppStatus(stable_app_status : T.AppStatus) {
      appStatus := stable_app_status;
    };

    public func getStableLeagueGameweekStatuses() : [T.LeagueGameweekStatus] {
      return leagueGameweekStatuses;
    };

    public func setStableLeagueGameweekStatuses(stable_league_gameweek_statuses : [T.LeagueGameweekStatus]) {
      leagueGameweekStatuses := stable_league_gameweek_statuses;
    };

    public func getStableLeagueMonthStatuses() : [T.LeagueMonthStatus] {
      return leagueMonthStatuses;
    };

    public func setStableLeagueMonthStatuses(stable_league_month_statuses : [T.LeagueMonthStatus]) {
      leagueMonthStatuses := stable_league_month_statuses;
    };

    public func getStableLeagueSeasonStatuses() : [T.LeagueSeasonStatus] {
      return leagueSeasonStatuses;
    };

    public func setStableLeagueSeasonStatuses(stable_league_season_statuses : [T.LeagueSeasonStatus]) {
      leagueSeasonStatuses := stable_league_season_statuses;
    };

    public func getStableDataHashes() : [Base.DataHash] {
      return dataHashes;
    };

    public func setStableDataHashes(stable_data_hashes : [Base.DataHash]) {
      dataHashes := stable_data_hashes;
    };

    public func getStablePlayersSnapshots() : [(FootballTypes.SeasonId, [(FootballTypes.GameweekNumber, [DTOs.PlayerDTO])])] {
      return playersSnapshots;
    };

    public func setStablePlayersSnapshots(stable_players_snapshots : [(FootballTypes.SeasonId, [(FootballTypes.GameweekNumber, [DTOs.PlayerDTO])])]) {
      playersSnapshots := stable_players_snapshots;
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
  }

};

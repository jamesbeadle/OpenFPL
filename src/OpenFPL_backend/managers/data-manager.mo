import Result "mo:base/Result";
import CanisterIds "mo:waterway-mops/CanisterIds";
import Enums "mo:waterway-mops/Enums";
import LeagueQueries "mo:waterway-mops/queries/football-queries/LeagueQueries";
import SeasonQueries "mo:waterway-mops/queries/football-queries/SeasonQueries";
import ClubQueries "mo:waterway-mops/queries/football-queries/ClubQueries";
import PlayerQueries "mo:waterway-mops/queries/football-queries/PlayerQueries";
import FixtureQueries "mo:waterway-mops/queries/football-queries/FixtureQueries";
import LogsManager "mo:waterway-mops/logs-management/LogsManager";
import { message } "mo:base/Error";

module {

  public class DataManager() {

    private let logsManager = LogsManager.LogsManager();

    public func getLeagueStatus(dto : LeagueQueries.GetLeagueStatus) : async Result.Result<LeagueQueries.LeagueStatus, Enums.Error> {
      try {
        let data_canister = actor (CanisterIds.ICFC_DATA_CANISTER_ID) : actor {
          getLeagueStatus : shared (dto : LeagueQueries.GetLeagueStatus) -> async Result.Result<LeagueQueries.LeagueStatus, Enums.Error>;
        };
        return await data_canister.getLeagueStatus(dto);
      } catch (err) {
        let _ = await logsManager.addApplicationLog({
          app = #OpenFPL;
          error = ?#FailedInterCanisterCall;
          detail = message(err);
          title = "Failed to get league status";
          logType = #Error;
        });
        return #err(#FailedInterCanisterCall);
      };
    };

    public func getSeasons(dto : SeasonQueries.GetSeasons) : async Result.Result<SeasonQueries.Seasons, Enums.Error> {
      try {
        let data_canister = actor (CanisterIds.ICFC_DATA_CANISTER_ID) : actor {
          getSeasons : shared (dto : SeasonQueries.GetSeasons) -> async Result.Result<SeasonQueries.Seasons, Enums.Error>;
        };
        return await data_canister.getSeasons(dto);
      } catch (err) {
        let _ = await logsManager.addApplicationLog({
          app = #OpenFPL;
          error = ?#FailedInterCanisterCall;
          detail = message(err);
          title = "Failed to get seasons";
          logType = #Error;
        });
        return #err(#FailedInterCanisterCall);
      };
    };

    public func getClubs(dto : ClubQueries.GetClubs) : async Result.Result<ClubQueries.Clubs, Enums.Error> {
      try {
        let data_canister = actor (CanisterIds.ICFC_DATA_CANISTER_ID) : actor {
          getClubs : shared (dto : ClubQueries.GetClubs) -> async Result.Result<ClubQueries.Clubs, Enums.Error>;
        };
        return await data_canister.getClubs(dto);
      } catch (err) {
        let _ = await logsManager.addApplicationLog({
          app = #OpenFPL;
          error = ?#FailedInterCanisterCall;
          detail = message(err);
          title = "Failed to get clubs";
          logType = #Error;
        });
        return #err(#FailedInterCanisterCall);
      };
    };

    public func getPlayers(dto : PlayerQueries.GetPlayers) : async Result.Result<PlayerQueries.Players, Enums.Error> {
      try {
        let data_canister = actor (CanisterIds.ICFC_DATA_CANISTER_ID) : actor {
          getPlayers : shared (dto : PlayerQueries.GetPlayers) -> async Result.Result<PlayerQueries.Players, Enums.Error>;
        };
        return await data_canister.getPlayers(dto);
      } catch (err) {
        let _ = await logsManager.addApplicationLog({
          app = #OpenFPL;
          error = ?#FailedInterCanisterCall;
          detail = message(err);
          title = "Failed to get players";
          logType = #Error;
        });
        return #err(#FailedInterCanisterCall);
      };
    };

    public func getPlayerDetailsForGameweek(dto : PlayerQueries.GetPlayerDetailsForGameweek) : async Result.Result<PlayerQueries.PlayerDetailsForGameweek, Enums.Error> {
      try {
        let data_canister = actor (CanisterIds.ICFC_DATA_CANISTER_ID) : actor {
          getPlayerDetailsForGameweek : shared (dto : PlayerQueries.GetPlayerDetailsForGameweek) -> async Result.Result<PlayerQueries.PlayerDetailsForGameweek, Enums.Error>;
        };
        return await data_canister.getPlayerDetailsForGameweek(dto);
      } catch (err) {
        let _ = await logsManager.addApplicationLog({
          app = #OpenFPL;
          error = ?#FailedInterCanisterCall;
          detail = message(err);
          title = "Failed to get player details for gameweek";
          logType = #Error;
        });
        return #err(#FailedInterCanisterCall);
      };
    };

    public func getFixtures(dto : FixtureQueries.GetFixtures) : async Result.Result<FixtureQueries.Fixtures, Enums.Error> {
      try {
        let data_canister = actor (CanisterIds.ICFC_DATA_CANISTER_ID) : actor {
          getFixtures : shared (dto : FixtureQueries.GetFixtures) -> async Result.Result<FixtureQueries.Fixtures, Enums.Error>;
        };
        return await data_canister.getFixtures(dto);
      } catch (err) {
        let _ = await logsManager.addApplicationLog({
          app = #OpenFPL;
          error = ?#FailedInterCanisterCall;
          detail = message(err);
          title = "Failed to get fixtures";
          logType = #Error;
        });
        return #err(#FailedInterCanisterCall);
      };
    };

    public func getPlayersMap(dto : PlayerQueries.GetPlayersMap) : async Result.Result<PlayerQueries.PlayersMap, Enums.Error> {
      try {
        let data_canister = actor (CanisterIds.ICFC_DATA_CANISTER_ID) : actor {
          getPlayersMap : shared (dto : PlayerQueries.GetPlayersMap) -> async Result.Result<PlayerQueries.PlayersMap, Enums.Error>;
        };
        return await data_canister.getPlayersMap(dto);
      } catch (err) {
        let _ = await logsManager.addApplicationLog({
          app = #OpenFPL;
          error = ?#FailedInterCanisterCall;
          detail = message(err);
          title = "Failed to get players map";
          logType = #Error;
        });
        return #err(#FailedInterCanisterCall);
      };
    };

    public func getPlayerDetails(dto : PlayerQueries.GetPlayerDetails) : async Result.Result<PlayerQueries.PlayerDetails, Enums.Error> {
      try {
        let data_canister = actor (CanisterIds.ICFC_DATA_CANISTER_ID) : actor {
          getPlayerDetails : shared (dto : PlayerQueries.GetPlayerDetails) -> async Result.Result<PlayerQueries.PlayerDetails, Enums.Error>;
        };
        return await data_canister.getPlayerDetails(dto);
      } catch (err) {
        let _ = await logsManager.addApplicationLog({
          app = #OpenFPL;
          error = ?#FailedInterCanisterCall;
          detail = message(err);
          title = "Failed to get player details";
          logType = #Error;
        });
        return #err(#FailedInterCanisterCall);
      };
    };

  };

};

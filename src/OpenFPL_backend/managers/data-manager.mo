import Result "mo:base/Result";
import { message } "mo:base/Error";

import CanisterIds "mo:waterway-mops/product/wwl/canister-ids";
import ClubQueries "mo:waterway-mops/product/icfc/data-canister-queries/club-queries";
import Enums "mo:waterway-mops/base/enums";
import LeagueQueries "mo:waterway-mops/product/icfc/data-canister-queries/league-queries";
import LogManager "mo:waterway-mops/product/wwl/log-management/manager";
import FixtureQueries "mo:waterway-mops/product/icfc/data-canister-queries/fixture-queries";
import SeasonQueries "mo:waterway-mops/product/icfc/data-canister-queries/season-queries";
import PlayerQueries "mo:waterway-mops/product/icfc/data-canister-queries/player-queries";

module {

  public class DataManager() {

    private let logsManager = LogManager.LogManager();

    public func getLeagueStatus(dto : LeagueQueries.GetLeagueStatus) : async Result.Result<LeagueQueries.LeagueStatus, Enums.Error> {
      try {
        let data_canister = actor (CanisterIds.ICFC_DATA_CANISTER_ID) : actor {
          getLeagueStatus : shared (dto : LeagueQueries.GetLeagueStatus) -> async Result.Result<LeagueQueries.LeagueStatus, Enums.Error>;
        };
        return await data_canister.getLeagueStatus(dto);
      } catch (err) {
        let _ = await logsManager.addApplicationLog({
          app = #OpenFPL;
          error = ?#CallFailed;
          detail = message(err);
          title = "Failed to get league status";
          logType = #Error;
        });
        return #err(#CallFailed);
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
          error = ?#CallFailed;
          detail = message(err);
          title = "Failed to get seasons";
          logType = #Error;
        });
        return #err(#CallFailed);
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
          error = ?#CallFailed;
          detail = message(err);
          title = "Failed to get clubs";
          logType = #Error;
        });
        return #err(#CallFailed);
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
          error = ?#CallFailed;
          detail = message(err);
          title = "Failed to get players";
          logType = #Error;
        });
        return #err(#CallFailed);
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
          error = ?#CallFailed;
          detail = message(err);
          title = "Failed to get player details for gameweek";
          logType = #Error;
        });
        return #err(#CallFailed);
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
          error = ?#CallFailed;
          detail = message(err);
          title = "Failed to get fixtures";
          logType = #Error;
        });
        return #err(#CallFailed);
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
          error = ?#CallFailed;
          detail = message(err);
          title = "Failed to get players map";
          logType = #Error;
        });
        return #err(#CallFailed);
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
          error = ?#CallFailed;
          detail = message(err);
          title = "Failed to get player details";
          logType = #Error;
        });
        return #err(#CallFailed);
      };
    };

  };

};

import Result "mo:base/Result";
import CanisterIds "mo:waterway-mops/CanisterIds";
import Enums "mo:waterway-mops/Enums";
import LeagueQueries "mo:waterway-mops/queries/football-queries/LeagueQueries";
import SeasonQueries "mo:waterway-mops/queries/football-queries/SeasonQueries";
import ClubQueries "mo:waterway-mops/queries/football-queries/ClubQueries";
import PlayerQueries "mo:waterway-mops/queries/football-queries/PlayerQueries";
import FixtureQueries "mo:waterway-mops/queries/football-queries/FixtureQueries";

module {

  public class DataManager() {

    public func getLeagueStatus(dto : LeagueQueries.GetLeagueStatus) : async Result.Result<LeagueQueries.LeagueStatus, Enums.Error> {
      let data_canister = actor (CanisterIds.ICFC_DATA_CANISTER_ID) : actor {
        getLeagueStatus : shared (dto : LeagueQueries.GetLeagueStatus) -> async Result.Result<LeagueQueries.LeagueStatus, Enums.Error>;
      };
      return await data_canister.getLeagueStatus(dto);
    };

    public func getSeasons(dto : SeasonQueries.GetSeasons) : async Result.Result<SeasonQueries.Seasons, Enums.Error> {
     let data_canister = actor (CanisterIds.ICFC_DATA_CANISTER_ID) : actor {
        getSeasons : shared (dto : SeasonQueries.GetSeasons) -> async Result.Result<SeasonQueries.Seasons, Enums.Error>;
      };
      return await data_canister.getSeasons(dto);
    };

    public func getClubs(dto : ClubQueries.GetClubs) : async Result.Result<ClubQueries.Clubs, Enums.Error> {
      let data_canister = actor (CanisterIds.ICFC_DATA_CANISTER_ID) : actor {
        getClubs : shared (dto : ClubQueries.GetClubs) -> async Result.Result<ClubQueries.Clubs, Enums.Error>;
      };
      return await data_canister.getClubs(dto);
    };

    public func getPlayers(dto : PlayerQueries.GetPlayers) : async Result.Result<PlayerQueries.Players, Enums.Error> {
      let data_canister = actor (CanisterIds.ICFC_DATA_CANISTER_ID) : actor {
        getPlayers : shared (dto : PlayerQueries.GetPlayers) -> async Result.Result<PlayerQueries.Players, Enums.Error>;
      };
      return await data_canister.getPlayers(dto);
    };

    public func getPlayerDetailsForGameweek(dto : PlayerQueries.GetPlayerDetailsForGameweek) : async Result.Result<PlayerQueries.PlayerDetailsForGameweek, Enums.Error> {
      let data_canister = actor (CanisterIds.ICFC_DATA_CANISTER_ID) : actor {
        getPlayerDetailsForGameweek : shared (dto : PlayerQueries.GetPlayerDetailsForGameweek) -> async Result.Result<PlayerQueries.PlayerDetailsForGameweek, Enums.Error>;
      };
      return await data_canister.getPlayerDetailsForGameweek(dto);
    };

    public func getFixtures(dto : FixtureQueries.GetFixtures) : async Result.Result<FixtureQueries.Fixtures, Enums.Error> {
      let data_canister = actor (CanisterIds.ICFC_DATA_CANISTER_ID) : actor {
        getFixtures : shared (dto : FixtureQueries.GetFixtures) -> async Result.Result<FixtureQueries.Fixtures, Enums.Error>;
      };
      return await data_canister.getFixtures(dto);
    };

    public func getPlayersMap(dto : PlayerQueries.GetPlayersMap) : async Result.Result<PlayerQueries.PlayersMap, Enums.Error> {
      let data_canister = actor (CanisterIds.ICFC_DATA_CANISTER_ID) : actor {
        getPlayersMap : shared (dto : PlayerQueries.GetPlayersMap) -> async Result.Result<PlayerQueries.PlayersMap, Enums.Error>;
      };
      return await data_canister.getPlayersMap(dto);
    };

    public func getPlayerDetails(dto : PlayerQueries.GetPlayerDetails) : async Result.Result<PlayerQueries.PlayerDetails, Enums.Error> {
      let data_canister = actor (CanisterIds.ICFC_DATA_CANISTER_ID) : actor {
        getPlayerDetails : shared (dto : PlayerQueries.GetPlayerDetails) -> async Result.Result<PlayerQueries.PlayerDetails, Enums.Error>;
      };
      return await data_canister.getPlayerDetails(dto);
    };

  };

};

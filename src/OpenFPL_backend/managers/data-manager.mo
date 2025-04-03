import Result "mo:base/Result";
import Enums "mo:waterway-mops/Enums";
import CanisterIds "mo:waterway-mops/CanisterIds";
import DataCanister "canister:data_canister";

module {

  public class DataManager() {

    public func getLeagueStatus(dto : DataCanister.GetLeagueStatus) : async Result.Result<DataCanister.LeagueStatus, Enums.Error> {
      let data_canister = actor (CanisterIds.ICFC_DATA_CANISTER_ID) : actor {
        getLeagueStatus : shared query (dto : DataCanister.GetLeagueStatus) -> async Result.Result<DataCanister.LeagueStatus, Enums.Error>;
      };
      return await data_canister.getLeagueStatus(dto);
    };

    public func getCountries(dto : DataCanister.GetCountries) : async Result.Result<DataCanister.Countries, Enums.Error> {
      let data_canister = actor (CanisterIds.ICFC_DATA_CANISTER_ID) : actor {
        getCountries : shared query (dto : DataCanister.GetCountries) -> async Result.Result<DataCanister.Countries, Enums.Error>;
      };
      return await data_canister.getCountries(dto);
    };

    public func getSeasons(dto : DataCanister.GetSeasons) : async Result.Result<DataCanister.Seasons, Enums.Error> {
     let data_canister = actor (CanisterIds.ICFC_DATA_CANISTER_ID) : actor {
        getSeasons : shared query (dto : DataCanister.GetSeasons) -> async Result.Result<DataCanister.Seasons, Enums.Error>;
      };
      return await data_canister.getSeasons(dto);
    };

    public func getClubs(dto : DataCanister.GetClubs) : async Result.Result<DataCanister.Clubs, Enums.Error> {
      let data_canister = actor (CanisterIds.ICFC_DATA_CANISTER_ID) : actor {
        getClubs : shared query (dto : DataCanister.GetClubs) -> async Result.Result<DataCanister.Clubs, Enums.Error>;
      };
      return await data_canister.getClubs(dto);
    };

    public func getPlayers(dto : DataCanister.GetPlayers) : async Result.Result<DataCanister.Players, Enums.Error> {
      let data_canister = actor (CanisterIds.ICFC_DATA_CANISTER_ID) : actor {
        getPlayers : shared query (dto : DataCanister.GetPlayers) -> async Result.Result<DataCanister.Players, Enums.Error>;
      };
      return await data_canister.getPlayers(dto);
    };

    public func getPlayerDetailsForGameweek(dto : DataCanister.GetPlayerDetailsForGameweek) : async Result.Result<DataCanister.PlayerDetailsForGameweek, Enums.Error> {
      let data_canister = actor (CanisterIds.ICFC_DATA_CANISTER_ID) : actor {
        getPlayerDetailsForGameweek : shared query (dto : DataCanister.GetPlayerDetailsForGameweek) -> async Result.Result<DataCanister.PlayerDetailsForGameweek, Enums.Error>;
      };
      return await data_canister.getPlayerDetailsForGameweek(dto);
    };

    public func getFixtures(dto : DataCanister.GetFixtures) : async Result.Result<DataCanister.Fixtures, Enums.Error> {
      let data_canister = actor (CanisterIds.ICFC_DATA_CANISTER_ID) : actor {
        getFixtures : shared query (dto : DataCanister.GetFixtures) -> async Result.Result<DataCanister.Fixtures, Enums.Error>;
      };
      return await data_canister.getFixtures(dto);
    };

    public func getPlayersMap(dto : DataCanister.GetPlayersMap) : async Result.Result<DataCanister.PlayersMap, Enums.Error> {
      let data_canister = actor (CanisterIds.ICFC_DATA_CANISTER_ID) : actor {
        getPlayersMap : shared query (dto : DataCanister.GetPlayersMap) -> async Result.Result<DataCanister.PlayersMap, Enums.Error>;
      };
      return await data_canister.getPlayersMap(dto);
    };

    public func getPlayerDetails(dto : DataCanister.GetPlayerDetails) : async Result.Result<DataCanister.PlayerDetails, Enums.Error> {
      let data_canister = actor (CanisterIds.ICFC_DATA_CANISTER_ID) : actor {
        getPlayerDetails : shared query (dto : DataCanister.GetPlayerDetails) -> async Result.Result<DataCanister.PlayerDetails, Enums.Error>;
      };
      return await data_canister.getPlayerDetails(dto);
    };

    public func getPostponedFixtures(dto : DataCanister.GetPostponedFixtures) : async Result.Result<DataCanister.PostponedFixtures, Enums.Error> {
      let data_canister = actor (CanisterIds.ICFC_DATA_CANISTER_ID) : actor {
        getPostponedFixtures : shared query (dto : DataCanister.GetPostponedFixtures) -> async Result.Result<DataCanister.PostponedFixtures, Enums.Error>;
      };
      return await data_canister.getPostponedFixtures(dto);
    };

  };

};

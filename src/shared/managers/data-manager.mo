import Result "mo:base/Result";
import DTOs "../../shared/dtos/dtos";
import FootballTypes "../../shared/types/football_types";
import T "../../shared/types/app_types";

import NetworkEnvVars "../network_environment_variables";

module {

  public class DataManager() {

    public func getVerifiedPlayers(leagueId: FootballTypes.LeagueId) : async Result.Result<[DTOs.PlayerDTO], T.Error> {
      let data_canister = actor (NetworkEnvVars.DATA_CANISTER_ID) : actor {
        getVerifiedPlayers : (leagueId: FootballTypes.LeagueId) -> async Result.Result<[DTOs.PlayerDTO], T.Error>;
      };
      return await data_canister.getVerifiedPlayers(leagueId);
    };

    public func getVerifiedClubs(leagueId: FootballTypes.LeagueId) : async Result.Result<[DTOs.ClubDTO], T.Error>{
      let data_canister = actor (NetworkEnvVars.DATA_CANISTER_ID) : actor {
        getVerifiedClubs : (leagueId: FootballTypes.LeagueId) -> async Result.Result<[DTOs.ClubDTO], T.Error>;
      };
      return await data_canister.getVerifiedClubs(leagueId);
    };

    public func getVerifiedFixtures(leagueId: FootballTypes.LeagueId) : async Result.Result<[DTOs.FixtureDTO], T.Error> {
      let data_canister = actor (NetworkEnvVars.DATA_CANISTER_ID) : actor {
        getVerifiedFixtures : (leagueId: FootballTypes.LeagueId) -> async Result.Result<[DTOs.FixtureDTO], T.Error>;
      };
      return await data_canister.getVerifiedFixtures(leagueId);
    };

  };

};
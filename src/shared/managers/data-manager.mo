import Result "mo:base/Result";
import DTOs "../../shared/dtos/DTOs";
import Base "../../shared/types/base_types";
import FootballTypes "../../shared/types/football_types";
import T "../../shared/types/app_types";

import NetworkEnvVars "../network_environment_variables";
import RequestDTOs "../../shared/dtos/request_DTOs";
import NetworkEnvironmentVariables "../network_environment_variables";

module {

  public class DataManager() {

    //verified getters

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

    public func getVerifiedFixtures(dto: RequestDTOs.RequestFixturesDTO) : async Result.Result<[DTOs.FixtureDTO], T.Error> {
      let data_canister = actor (NetworkEnvVars.DATA_CANISTER_ID) : actor {
        getVerifiedFixtures : (dto: RequestDTOs.RequestFixturesDTO) -> async Result.Result<[DTOs.FixtureDTO], T.Error>;
      };
      return await data_canister.getVerifiedFixtures(dto);
    };

    public func checkGameweekComplete(seasonId: FootballTypes.SeasonId, gameweek: FootballTypes.GameweekNumber) : async Bool {
      let data_canister = actor (NetworkEnvironmentVariables.DATA_CANISTER_ID) : actor {
        checkGameweekComplete : (seasonId: FootballTypes.SeasonId, gameweek: FootballTypes.GameweekNumber) -> async Bool;
      };
      
      return await data_canister.checkGameweekComplete(seasonId,gameweek);
    };

    public func checkMonthComplete(seasonId: FootballTypes.SeasonId, month: Base.CalendarMonth, gameweek: FootballTypes.GameweekNumber) : async Bool {
      let data_canister = actor (NetworkEnvironmentVariables.DATA_CANISTER_ID) : actor {
        checkMonthComplete : (seasonId: FootballTypes.SeasonId, month: Base.CalendarMonth, gameweek: FootballTypes.GameweekNumber) -> async Bool;
      };
      
      return await data_canister.checkMonthComplete(seasonId, month, gameweek);

    };

    public func checkSeasonComplete(seasonId: FootballTypes.SeasonId) : async Bool {
      let data_canister = actor (NetworkEnvironmentVariables.DATA_CANISTER_ID) : actor {
        checkSeasonComplete : (seasonId: FootballTypes.SeasonId) -> async Bool;
      };
      
      return await data_canister.checkSeasonComplete(seasonId);
    };

  };

};
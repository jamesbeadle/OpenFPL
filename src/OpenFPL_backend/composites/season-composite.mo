import Bool "mo:base/Bool";
import Int "mo:base/Int";
import Result "mo:base/Result";

import DTOs "../DTOs";
import Environment "../utils/Environment";
import T "../types";

module {

  public class SeasonComposite() {
    
    public func getSeason(seasonId : T.SeasonId) : async Result.Result<DTOs.SeasonDTO, T.Error> {
      let data_canister = actor (Environment.DATA_CANISTER_ID) : actor {
        getSeason : (seasonId : T.SeasonId) -> async Result.Result<DTOs.SeasonDTO, T.Error>;
      };
      return await data_canister.getSeason(seasonId);
    };

    public func getFixtures(dto: DTOs.GetFixturesDTO) : async Result.Result<[DTOs.FixtureDTO], T.Error> {
      let data_canister = actor (Environment.DATA_CANISTER_ID) : actor {
        getFixtures : (dto: DTOs.GetFixturesDTO) -> async Result.Result<[DTOs.FixtureDTO], T.Error>;
      };
      return await data_canister.getFixtures(dto);
    };

    public func getSeasons() : async Result.Result<[DTOs.SeasonDTO], T.Error> {
      let data_canister = actor (Environment.DATA_CANISTER_ID) : actor {
        getSeasons : () -> async Result.Result<[DTOs.SeasonDTO], T.Error>;
      };
      return await data_canister.getSeasons();
    };

    public func getPostponedFixtures(seasonId : T.SeasonId) : async Result.Result<[DTOs.FixtureDTO], T.Error> {
      let data_canister = actor (Environment.DATA_CANISTER_ID) : actor {
        getPostponedFixtures : (seasonId : T.SeasonId) -> async Result.Result<[DTOs.FixtureDTO], T.Error>;
      };
      return await data_canister.getPostponedFixtures(seasonId);
    };

    public func getFixturesForGameweek(seasonId : T.SeasonId, gameweek : T.GameweekNumber) : async Result.Result<[DTOs.FixtureDTO], T.Error> {
      let data_canister = actor (Environment.DATA_CANISTER_ID) : actor {
        getFixturesForGameweek : (seasonId : T.SeasonId, gameweek : T.GameweekNumber) -> async Result.Result<[DTOs.FixtureDTO], T.Error>;
      };
      return await data_canister.getFixturesForGameweek(seasonId, gameweek);
    };

    public func getGameweekKickOffTimes(seasonId : T.SeasonId, gameweek : T.GameweekNumber) : async Result.Result<[Int], T.Error> {
      let data_canister = actor (Environment.DATA_CANISTER_ID) : actor {
        getGameweekKickOffTimes : (seasonId : T.SeasonId, gameweek : T.GameweekNumber) -> async Result.Result<[Int], T.Error>;
      };
      return await data_canister.getGameweekKickOffTimes(seasonId, gameweek);
    };

    public func setFixturesToActive(seasonId : T.SeasonId) : async Result.Result<(), T.Error> {
      let data_canister = actor (Environment.DATA_CANISTER_ID) : actor {
        setFixturesToActive : (seasonId : T.SeasonId) -> async Result.Result<(), T.Error>;
      };
      return await data_canister.setFixturesToActive(seasonId);
    };

    public func setFixturesToCompleted(seasonId : T.SeasonId) : async Result.Result<(), T.Error> {
      let data_canister = actor (Environment.DATA_CANISTER_ID) : actor {
        setFixturesToCompleted : (seasonId : T.SeasonId) -> async Result.Result<(), T.Error>;
      };
      return await data_canister.setFixturesToCompleted(seasonId);
    };

    public func validateSubmitFixtureData(submitFixtureDataDTO : DTOs.SubmitFixtureDataDTO) : async Result.Result<(), T.Error> {
      let data_canister = actor (Environment.DATA_CANISTER_ID) : actor {
        validateSubmitFixtureData : (submitFixtureDataDTO : DTOs.SubmitFixtureDataDTO) -> async Result.Result<(), T.Error>;
      };
      return await data_canister.validateSubmitFixtureData(submitFixtureDataDTO);
    };

    public func addEventsToFixture(playerEventData : [T.PlayerEventData], seasonId : T.SeasonId, fixtureId : T.FixtureId) : async Result.Result<(), T.Error> {
      let data_canister = actor (Environment.DATA_CANISTER_ID) : actor {
        addEventsToFixture : (playerEventData : [T.PlayerEventData], seasonId : T.SeasonId, fixtureId : T.FixtureId) -> async Result.Result<(), T.Error>;
      };
      return await data_canister.addEventsToFixture(playerEventData, seasonId, fixtureId);
    };

    public func setFixtureToFinalised(seasonId: T.SeasonId, fixtureId: T.FixtureId) : async Result.Result<(), T.Error> {
      let data_canister = actor (Environment.DATA_CANISTER_ID) : actor {
        setFixtureToFinalised : (seasonId: T.SeasonId, fixtureId: T.FixtureId) -> async Result.Result<(), T.Error>;
      };
      return await data_canister.setFixtureToFinalised(seasonId, fixtureId);
    };

    public func checkGameweekComplete(systemState : T.SystemState) : async Result.Result<Bool, T.Error> {
      let data_canister = actor (Environment.DATA_CANISTER_ID) : actor {
        checkGameweekComplete : (systemState : T.SystemState) -> async Result.Result<Bool, T.Error>;
      };
      return await data_canister.checkGameweekComplete(systemState);
    };

    public func checkMonthComplete(systemState : T.SystemState) : async Result.Result<Bool, T.Error> {
      let data_canister = actor (Environment.DATA_CANISTER_ID) : actor {
        checkMonthComplete : (systemState : T.SystemState) -> async Result.Result<Bool, T.Error>;
      };
      return await data_canister.checkMonthComplete(systemState);
    };

    public func checkSeasonComplete(systemState : T.SystemState) : async Result.Result<Bool, T.Error> {
      let data_canister = actor (Environment.DATA_CANISTER_ID) : actor {
        checkSeasonComplete : (systemState : T.SystemState) -> async Result.Result<Bool, T.Error>;
      };
      return await data_canister.checkSeasonComplete(systemState);
    };

    public func validateAddInitialFixtures(addInitialFixturesDTO : DTOs.AddInitialFixturesDTO) : async Result.Result<(), T.Error> {
      let data_canister = actor (Environment.DATA_CANISTER_ID) : actor {
        validateAddInitialFixtures : (addInitialFixturesDTO : DTOs.AddInitialFixturesDTO) -> async Result.Result<(), T.Error>;
      };
      return await data_canister.validateAddInitialFixtures(addInitialFixturesDTO);
    };

    public func executeAddInitialFixtures(addInitialFixturesDTO : DTOs.AddInitialFixturesDTO) :  async Result.Result<(), T.Error> {
      let data_canister = actor (Environment.DATA_CANISTER_ID) : actor {
        executeAddInitialFixtures : (addInitialFixturesDTO : DTOs.AddInitialFixturesDTO) -> async Result.Result<(), T.Error>;
      };
      return await data_canister.executeAddInitialFixtures(addInitialFixturesDTO);
    };

    public func validateMoveFixture(moveFixtureDTO : DTOs.MoveFixtureDTO, systemState : T.SystemState) :  async Result.Result<(), T.Error> {
      let data_canister = actor (Environment.DATA_CANISTER_ID) : actor {
        validateMoveFixture : (moveFixtureDTO : DTOs.MoveFixtureDTO, systemState : T.SystemState) -> async Result.Result<(), T.Error>;
      };
      return await data_canister.validateMoveFixture(moveFixtureDTO, systemState);
    };

    public func executeMoveFixture(moveFixtureDTO : DTOs.MoveFixtureDTO, systemState : T.SystemState) :  async Result.Result<(), T.Error> {
      let data_canister = actor (Environment.DATA_CANISTER_ID) : actor {
        executeMoveFixture : (moveFixtureDTO : DTOs.MoveFixtureDTO, systemState : T.SystemState) -> async Result.Result<(), T.Error>;
      };
      return await data_canister.executeMoveFixture(moveFixtureDTO, systemState);
    };

    public func validatePostponeFixture(postponeFixtureDTO : DTOs.PostponeFixtureDTO, systemState : T.SystemState) :  async Result.Result<(), T.Error> {
      let data_canister = actor (Environment.DATA_CANISTER_ID) : actor {
        validatePostponeFixture : (postponeFixtureDTO : DTOs.PostponeFixtureDTO, systemState : T.SystemState) -> async Result.Result<(), T.Error>;
      };
      return await data_canister.validatePostponeFixture(postponeFixtureDTO, systemState);
    };

    public func executePostponeFixture(postponeFixtureDTO : DTOs.PostponeFixtureDTO, systemState : T.SystemState) :  async Result.Result<(), T.Error> {
      let data_canister = actor (Environment.DATA_CANISTER_ID) : actor {
        executePostponeFixture : (postponeFixtureDTO : DTOs.PostponeFixtureDTO, systemState : T.SystemState) -> async Result.Result<(), T.Error>;
      };
      return await data_canister.executePostponeFixture(postponeFixtureDTO, systemState);
    };

    public func validateRescheduleFixture(rescheduleFixtureDTO : DTOs.RescheduleFixtureDTO, systemState : T.SystemState) :  async Result.Result<(), T.Error> {
      let data_canister = actor (Environment.DATA_CANISTER_ID) : actor {
        validateRescheduleFixture : (rescheduleFixtureDTO : DTOs.RescheduleFixtureDTO, systemState : T.SystemState) -> async Result.Result<(), T.Error>;
      };
      return await data_canister.validateRescheduleFixture(rescheduleFixtureDTO, systemState);
    };

    public func executeRescheduleFixture(rescheduleFixtureDTO : DTOs.RescheduleFixtureDTO, systemState : T.SystemState) :  async Result.Result<(), T.Error> {
     let data_canister = actor (Environment.DATA_CANISTER_ID) : actor {
        executeRescheduleFixture : (rescheduleFixtureDTO : DTOs.RescheduleFixtureDTO, systemState : T.SystemState) -> async Result.Result<(), T.Error>;
      };
      return await data_canister.executeRescheduleFixture(rescheduleFixtureDTO, systemState);
    };

    public func setGameScore(seasonId: T.SeasonId, fixtureId: T.FixtureId) : async Result.Result<(), T.Error> {
     let data_canister = actor (Environment.DATA_CANISTER_ID) : actor {
        setGameScore : (seasonId: T.SeasonId, fixtureId: T.FixtureId) -> async Result.Result<(), T.Error>;
      };
      return await data_canister.setGameScore(seasonId, fixtureId);
    };

    public func setNextSeasonId(nextSeasonId: T.SeasonId) : async Result.Result<(), T.Error> {
     let data_canister = actor (Environment.DATA_CANISTER_ID) : actor {
        setNextSeasonId : (nextSeasonId: T.SeasonId) -> async Result.Result<(), T.Error>;
      };
      return await data_canister.setNextSeasonId(nextSeasonId);
    };

    public func setFixtureToComplete(seasonId: T.SeasonId, fixtureId: T.FixtureId) : async Result.Result<(), T.Error> {
     let data_canister = actor (Environment.DATA_CANISTER_ID) : actor {
        setFixtureToComplete : (seasonId: T.SeasonId, fixtureId: T.FixtureId) -> async Result.Result<(), T.Error>;
      };
      return await data_canister.setFixtureToComplete(seasonId, fixtureId);
    };

    public func initialiseData() : async Result.Result<(), T.Error>{
      let data_canister = actor (Environment.DATA_CANISTER_ID) : actor {
        initialiseData : () -> async Result.Result<(), T.Error>;
      };
      return await data_canister.initialiseData();
    };

  };
};

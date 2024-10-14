import Result "mo:base/Result";
import List "mo:base/List";
import Array "mo:base/Array";
import Order "mo:base/Order";
import Buffer "mo:base/Buffer";
import Iter "mo:base/Iter";
import Option "mo:base/Option";
import TrieMap "mo:base/TrieMap";
import Debug "mo:base/Debug";
import DTOs "../../shared/DTOs";
import T "../../shared/types";
import NetworkEnvVars "../network_environment_variables";
import RequestDTOs "../../shared/RequestDTOs";
import NetworkEnvironmentVariables "../network_environment_variables";
import Utilities "../utils/utilities";

module {

  public class DataManager() {

    public func getLeagues() : async Result.Result<[DTOs.FootballLeagueDTO], T.Error> {
      let data_canister = actor (NetworkEnvVars.DATA_CANISTER_ID) : actor {
        getLeagues : () -> async Result.Result<[T.FootballLeague], T.Error>;
      };
      return await data_canister.getLeagues();
    };

    public func getClubs(leagueId: T.FootballLeagueId) : async Result.Result<[DTOs.ClubDTO], T.Error> {
      let data_canister = actor (NetworkEnvVars.DATA_CANISTER_ID) : actor {
        getClubs : (leagueId: T.FootballLeagueId) -> async Result.Result<[T.Club], T.Error>;
      };
      return await data_canister.getClubs(leagueId);
    };

    public func getFixtures(leagueId: T.FootballLeagueId, dto: RequestDTOs.RequestFixturesDTO) : async Result.Result<[DTOs.FixtureDTO], T.Error> {
      let data_canister = actor (NetworkEnvVars.DATA_CANISTER_ID) : actor {
        getFixtures : (leagueId: T.FootballLeagueId, dto: RequestDTOs.RequestFixturesDTO) -> async Result.Result<[DTOs.FixtureDTO], T.Error>;
      };
      return await data_canister.getFixtures(leagueId, dto);
    };

    public func getSeasons(leagueId: T.FootballLeagueId) : async Result.Result<[DTOs.SeasonDTO], T.Error> {
      let data_canister = actor (NetworkEnvVars.DATA_CANISTER_ID) : actor {
        getSeasons : (leagueId: T.FootballLeagueId) -> async Result.Result<[DTOs.SeasonDTO], T.Error>;
      };
      return await data_canister.getSeasons(leagueId);
    };

    public func getPostponedFixtures(leagueId: T.FootballLeagueId, dto: RequestDTOs.RequestFixturesDTO) : async Result.Result<[DTOs.FixtureDTO], T.Error> {
      let data_canister = actor (NetworkEnvVars.DATA_CANISTER_ID) : actor {
        getPostponedFixtures : (leagueId: T.FootballLeagueId, dto: RequestDTOs.RequestFixturesDTO
        ) -> async Result.Result<[DTOs.FixtureDTO], T.Error>;
      };
      return await data_canister.getPostponedFixtures(leagueId, dto);
    };

    public func getPlayers(leagueId: T.FootballLeagueId, dto: RequestDTOs.RequestPlayersDTO) : async Result.Result<[DTOs.PlayerDTO], T.Error> {
      let data_canister = actor (NetworkEnvVars.DATA_CANISTER_ID) : actor {
        getPlayers : (leagueId: T.FootballLeagueId, dto: RequestDTOs.RequestPlayersDTO) -> async Result.Result<[DTOs.PlayerDTO], T.Error>;
      };
      return await data_canister.getPlayers(leagueId, dto);
    };

    public func getLoanedPlayers(leagueId: T.FootballLeagueId, dto: DTOs.ClubFilterDTO) : async Result.Result<[DTOs.PlayerDTO], T.Error> {
      let data_canister = actor (NetworkEnvVars.DATA_CANISTER_ID) : actor {
        getLoanedPlayers : (leagueId: T.FootballLeagueId, dto: DTOs.ClubFilterDTO) -> async Result.Result<[DTOs.PlayerDTO], T.Error>;
      };
      return await data_canister.getLoanedPlayers(leagueId, dto);
    };

    public func getRetiredPlayers(leagueId: T.FootballLeagueId, dto: DTOs.ClubFilterDTO) : async Result.Result<[DTOs.PlayerDTO], T.Error> {
      let data_canister = actor (NetworkEnvVars.DATA_CANISTER_ID) : actor {
        getRetiredPlayers : (leagueId: T.FootballLeagueId, dto: DTOs.ClubFilterDTO) -> async Result.Result<[DTOs.PlayerDTO], T.Error>;
      };
      return await data_canister.getRetiredPlayers(leagueId, dto);
    };

    public func getPlayerDetailsForGameweek(leagueId: T.FootballLeagueId, dto: DTOs.GameweekFiltersDTO) : async Result.Result<[DTOs.PlayerPointsDTO], T.Error> {
      let data_canister = actor (NetworkEnvVars.DATA_CANISTER_ID) : actor {
        getPlayerDetailsForGameweek : (leagueId: T.FootballLeagueId, dto: DTOs.GameweekFiltersDTO) -> async Result.Result<[DTOs.PlayerPointsDTO], T.Error>;
      };
      return await data_canister.getPlayerDetailsForGameweek(leagueId, dto);
    };

    public func getPlayersMap(leagueId: T.FootballLeagueId, dto: DTOs.GameweekFiltersDTO) : async Result.Result<[(Nat16, DTOs.PlayerScoreDTO)], T.Error> {
      let data_canister = actor (NetworkEnvVars.DATA_CANISTER_ID) : actor {
        getPlayersMap : (leagueId: T.FootballLeagueId, dto: DTOs.GameweekFiltersDTO) -> async Result.Result<[(Nat16, DTOs.PlayerScoreDTO)], T.Error>;
      };
      return await data_canister.getPlayersMap(leagueId, dto);
    };

    public func getPlayerDetails(leagueId: T.FootballLeagueId, dto: DTOs.GetPlayerDetailsDTO) : async Result.Result<DTOs.PlayerDetailDTO, T.Error> {
      let data_canister = actor (NetworkEnvVars.DATA_CANISTER_ID) : actor {
        getPlayerDetailsForGameweek : (leagueId: T.FootballLeagueId, dto: DTOs.GetPlayerDetailsDTO) -> async Result.Result<DTOs.PlayerDetailDTO, T.Error>;
      };
      return await data_canister.getPlayerDetailsForGameweek(leagueId, dto);
    };

    public func validateRevaluePlayerUp(leagueId: T.FootballLeagueId, dto : DTOs.RevaluePlayerUpDTO) :  async Result.Result<(), T.Error> {
      let data_canister = actor (NetworkEnvVars.DATA_CANISTER_ID) : actor {
        validateRevaluePlayerUp : (leagueId: T.FootballLeagueId, dto : DTOs.RevaluePlayerUpDTO) -> async Result.Result<(), T.Error>;
      };
      return await data_canister.validateRevaluePlayerUp(leagueId, dto);
    };

    public func validateRevaluePlayerDown(leagueId: T.FootballLeagueId, dto : DTOs.RevaluePlayerDownDTO) :  async Result.Result<(), T.Error> {
      let data_canister = actor (NetworkEnvVars.DATA_CANISTER_ID) : actor {
        validateRevaluePlayerDown : (leagueId: T.FootballLeagueId, dto : DTOs.RevaluePlayerDownDTO) -> async Result.Result<(), T.Error>;
      };
      return await data_canister.validateRevaluePlayerDown(leagueId, dto);
    };

    public func validateSubmitFixtureData(leagueId: T.FootballLeagueId, dto : DTOs.SubmitFixtureDataDTO) : async Result.Result<(), T.Error>{
      let data_canister = actor (NetworkEnvVars.DATA_CANISTER_ID) : actor {
        validateSubmitFixtureData : (leagueId: T.FootballLeagueId, dto : DTOs.SubmitFixtureDataDTO) -> async Result.Result<(), T.Error>;
      };
      return await data_canister.validateSubmitFixtureData(leagueId, dto);
    };

    public func validateAddInitialFixtures(leagueId: T.FootballLeagueId, dto: DTOs.AddInitialFixturesDTO) : async Result.Result<(), T.Error>{
      let data_canister = actor (NetworkEnvVars.DATA_CANISTER_ID) : actor {
        validateAddInitialFixtures : (leagueId: T.FootballLeagueId, dto : DTOs.AddInitialFixturesDTO) -> async Result.Result<(), T.Error>;
      };
      return await data_canister.validateAddInitialFixtures(leagueId, dto);
    }; 

    public func validateMoveFixture(leagueId: T.FootballLeagueId, dto: DTOs.MoveFixtureDTO) : async Result.Result<(), T.Error>{
      let data_canister = actor (NetworkEnvVars.DATA_CANISTER_ID) : actor {
        validateMoveFixture : (leagueId: T.FootballLeagueId, dto : DTOs.MoveFixtureDTO) -> async Result.Result<(), T.Error>;
      };
      return await data_canister.validateMoveFixture(leagueId, dto);
    }; 

    public func validatePostponeFixture(leagueId: T.FootballLeagueId, dto: DTOs.PostponeFixtureDTO) : async Result.Result<(), T.Error>{
      let data_canister = actor (NetworkEnvVars.DATA_CANISTER_ID) : actor {
        validatePostponeFixture : (leagueId: T.FootballLeagueId, dto : DTOs.PostponeFixtureDTO) -> async Result.Result<(), T.Error>;
      };
      return await data_canister.validatePostponeFixture(leagueId, dto);
    }; 

    public func validateRescheduleFixture(leagueId: T.FootballLeagueId, dto: DTOs.RescheduleFixtureDTO) : async Result.Result<(), T.Error>{
      let data_canister = actor (NetworkEnvVars.DATA_CANISTER_ID) : actor {
        validateRescehduleFixture : (leagueId: T.FootballLeagueId, dto : DTOs.RescheduleFixtureDTO) -> async Result.Result<(), T.Error>;
      };
      return await data_canister.validateRescehduleFixture(leagueId, dto);
    }; 

    public func validatePromoteNewClub(leagueId: T.FootballLeagueId, dto: DTOs.PromoteNewClubDTO) : async Result.Result<(), T.Error>{
      let data_canister = actor (NetworkEnvVars.DATA_CANISTER_ID) : actor {
        promoteNewClub : (leagueId: T.FootballLeagueId, dto : DTOs.PromoteNewClubDTO) -> async Result.Result<(), T.Error>;
      };
      return await data_canister.promoteNewClub(leagueId, dto);
    }; 

    public func validateUpdateClub(leagueId: T.FootballLeagueId, dto: DTOs.UpdateClubDTO) : async Result.Result<(), T.Error>{
      let data_canister = actor (NetworkEnvVars.DATA_CANISTER_ID) : actor {
        validateUpdateClub : (leagueId: T.FootballLeagueId, dto : DTOs.UpdateClubDTO) -> async Result.Result<(), T.Error>;
      };
      return await data_canister.validateUpdateClub(leagueId, dto);
    }; 

    public func validateLoanPlayer(leagueId: T.FootballLeagueId, loanPlayerDTO : DTOs.LoanPlayerDTO) :  async Result.Result<(), T.Error> {
      let data_canister = actor (NetworkEnvVars.DATA_CANISTER_ID) : actor {
        validateLoanPlayer : (leagueId: T.FootballLeagueId, loanPlayerDTO : DTOs.LoanPlayerDTO) -> async Result.Result<(), T.Error>;
      };
      return await data_canister.validateLoanPlayer(leagueId, loanPlayerDTO);
    };

    public func validateTransferPlayer(leagueId: T.FootballLeagueId, transferPlayerDTO : DTOs.TransferPlayerDTO) :  async Result.Result<(), T.Error> {
      let data_canister = actor (NetworkEnvVars.DATA_CANISTER_ID) : actor {
        validateTransferPlayer : (leagueId: T.FootballLeagueId, transferPlayerDTO : DTOs.TransferPlayerDTO) -> async Result.Result<(), T.Error>;
      };
      return await data_canister.validateTransferPlayer(leagueId, transferPlayerDTO);
    };

    public func validateRecallPlayer(leagueId: T.FootballLeagueId, recallPlayerDTO : DTOs.RecallPlayerDTO) :  async Result.Result<(), T.Error> {
      let data_canister = actor (NetworkEnvVars.DATA_CANISTER_ID) : actor {
        recallPlayerDTO : (leagueId: T.FootballLeagueId, recallPlayerDTO : DTOs.RecallPlayerDTO) -> async Result.Result<(), T.Error>;
      };
      return await data_canister.recallPlayerDTO(leagueId, recallPlayerDTO);
    };

    public func validateCreatePlayer(leagueId: T.FootballLeagueId, createPlayerDTO : DTOs.CreatePlayerDTO) :  async Result.Result<(), T.Error> {
      let data_canister = actor (NetworkEnvVars.DATA_CANISTER_ID) : actor {
        validateCreatePlayer : (leagueId: T.FootballLeagueId, createPlayerDTO : DTOs.CreatePlayerDTO) -> async Result.Result<(), T.Error>;
      };
      return await data_canister.validateCreatePlayer(leagueId, createPlayerDTO);
    };

    public func validateUpdatePlayer(leagueId: T.FootballLeagueId, updatePlayerDTO : DTOs.UpdatePlayerDTO) :  async Result.Result<(), T.Error> {
      let data_canister = actor (NetworkEnvVars.DATA_CANISTER_ID) : actor {
        validateUpdatePlayer : (leagueId: T.FootballLeagueId, updatePlayerDTO : DTOs.UpdatePlayerDTO) -> async Result.Result<(), T.Error>;
      };
      return await data_canister.validateUpdatePlayer(leagueId, updatePlayerDTO);
    };

    public func validateSetPlayerInjury(leagueId: T.FootballLeagueId, setPlayerInjuryDTO : DTOs.SetPlayerInjuryDTO) :  async Result.Result<(), T.Error> {
      let data_canister = actor (NetworkEnvVars.DATA_CANISTER_ID) : actor {
        validateSetPlayerInjury : (leagueId: T.FootballLeagueId, setPlayerInjuryDTO : DTOs.SetPlayerInjuryDTO) -> async Result.Result<(), T.Error>;
      };
      return await data_canister.validateSetPlayerInjury(leagueId, setPlayerInjuryDTO);
    };

    public func validateRetirePlayer(leagueId: T.FootballLeagueId, retirePlayerDTO : DTOs.RetirePlayerDTO) :  async Result.Result<(), T.Error> {
      let data_canister = actor (NetworkEnvVars.DATA_CANISTER_ID) : actor {
        validateRetirePlayer : (leagueId: T.FootballLeagueId, retirePlayerDTO : DTOs.RetirePlayerDTO) -> async Result.Result<(), T.Error>;
      };
      return await data_canister.validateRetirePlayer(leagueId, retirePlayerDTO);
    };

    public func validateUnretirePlayer(leagueId: T.FootballLeagueId, unretirePlayerDTO : DTOs.UnretirePlayerDTO) :  async Result.Result<(), T.Error> {
     let data_canister = actor (NetworkEnvVars.DATA_CANISTER_ID) : actor {
        validateUnretirePlayer : (leagueId: T.FootballLeagueId, unretirePlayerDTO : DTOs.UnretirePlayerDTO) -> async Result.Result<(), T.Error>;
      };
      return await data_canister.validateUnretirePlayer(leagueId, unretirePlayerDTO);
    };

    public func executeRevaluePlayerUp(leagueId: T.FootballLeagueId, dto : DTOs.RevaluePlayerUpDTO) : async Result.Result<(), T.Error> {
      let data_canister = actor (NetworkEnvVars.DATA_CANISTER_ID) : actor {
        revaluePlayerUp : (leagueId: T.FootballLeagueId, dto : DTOs.RevaluePlayerUpDTO) -> async Result.Result<(), T.Error>;
      };
      return await data_canister.revaluePlayerUp(leagueId, dto);
    };

    public func executeRevaluePlayerDown(leagueId: T.FootballLeagueId, dto : DTOs.RevaluePlayerDownDTO) : async Result.Result<(), T.Error> {
      let data_canister = actor (NetworkEnvVars.DATA_CANISTER_ID) : actor {
        revaluePlayerDown : (leagueId: T.FootballLeagueId, dto : DTOs.RevaluePlayerDownDTO) -> async Result.Result<(), T.Error>;
      };
      return await data_canister.revaluePlayerDown(leagueId, dto);
    };
    
    public func executeSubmitFixtureData( leagueId: T.FootballLeagueId, seasonId: T.SeasonId, submitFixtureData : DTOs.SubmitFixtureDataDTO) : async Result.Result<(), T.Error> {
      
      let playersResult = await getPlayers(leagueId, { seasonId = seasonId});

      switch(playersResult){
        case (#ok players){
          let populatedPlayerEvents = await populatePlayerEventData(seasonId, submitFixtureData, players);
          switch (populatedPlayerEvents) {
            case (null) {
              return #err(#NotFound);
            };
            case (?events) {
              let data_canister = actor (NetworkEnvVars.DATA_CANISTER_ID) : actor {
                addEventsToPlayers : (playerEventData : [T.PlayerEventData], seasonId : T.SeasonId, gameweek : T.GameweekNumber) -> async ();
                addEventsToFixture : (playerEventData : [T.PlayerEventData], seasonId : T.SeasonId, fixtureId : T.FixtureId) -> async ();
                setGameScore : (seasonId: T.SeasonId, fixtureId: T.FixtureId) -> async ();
                setFixtureToFinalised : (seasonId: T.SeasonId, fixtureId: T.FixtureId) -> async ();
              };
              
              let _ = await data_canister.addEventsToPlayers(events, seasonId, submitFixtureData.gameweek);
              let _ = await data_canister.addEventsToFixture(events, seasonId, submitFixtureData.fixtureId); 
              let _ = await data_canister.setGameScore(seasonId, submitFixtureData.fixtureId);
              let _ = await data_canister.setFixtureToFinalised(seasonId, submitFixtureData.fixtureId);
              

              return #ok();
            };
          };
        };
        case _ {
            return #err(#NotFound);
        }
      };
    };

    public func executeAddInitialFixtures(leagueId: T.FootballLeagueId, addInitialFixturesDTO : DTOs.AddInitialFixturesDTO) : async Result.Result<(), T.Error> {
      return #err(#NotFound);
    };

    public func executeMoveFixture(leagueId: T.FootballLeagueId, dto : DTOs.MoveFixtureDTO) : async Result.Result<(), T.Error> {
      return #err(#NotFound);
    };

    public func executePostponeFixture(leagueId: T.FootballLeagueId, dto : DTOs.PostponeFixtureDTO) : async Result.Result<(), T.Error> {
      return #err(#NotFound);
    };

    public func executeRescheduleFixture(leagueId: T.FootballLeagueId, dto : DTOs.RescheduleFixtureDTO) : async Result.Result<(), T.Error> {
      return #err(#NotFound);
    };

    public func executeLoanPlayer(leagueId: T.FootballLeagueId, dto : DTOs.LoanPlayerDTO) : async Result.Result<(), T.Error> {
      let data_canister = actor (NetworkEnvVars.DATA_CANISTER_ID) : actor {
        loanPlayer : (leagueId: T.FootballLeagueId, dto : DTOs.LoanPlayerDTO) -> async Result.Result<(), T.Error>;
      };
      return await data_canister.loanPlayer(leagueId, dto);
    };

    public func executeTransferPlayer(leagueId: T.FootballLeagueId, dto : DTOs.TransferPlayerDTO) : async Result.Result<(), T.Error> {
      let data_canister = actor (NetworkEnvVars.DATA_CANISTER_ID) : actor {
        transferPlayer : (leagueId: T.FootballLeagueId, dto : DTOs.TransferPlayerDTO) -> async Result.Result<(), T.Error>;
      };
      return await data_canister.transferPlayer(leagueId, dto);
    };

    public func executeRecallPlayer(leagueId: T.FootballLeagueId, dto : DTOs.RecallPlayerDTO) : async Result.Result<(), T.Error> {
      let data_canister = actor (NetworkEnvVars.DATA_CANISTER_ID) : actor {
        recallPlayer : (leagueId: T.FootballLeagueId, dto : DTOs.RecallPlayerDTO) -> async Result.Result<(), T.Error>;
      };
      return await data_canister.recallPlayer(leagueId, dto);
    };

    public func executeCreatePlayer(leagueId: T.FootballLeagueId, dto : DTOs.CreatePlayerDTO) : async Result.Result<(), T.Error> {
      let data_canister = actor (NetworkEnvVars.DATA_CANISTER_ID) : actor {
        createPlayer : (leagueId: T.FootballLeagueId, dto : DTOs.CreatePlayerDTO) -> async Result.Result<(), T.Error>;
      };
      return await data_canister.createPlayer(leagueId, dto);
    };

    public func executeUpdatePlayer(leagueId: T.FootballLeagueId, dto : DTOs.UpdatePlayerDTO) : async Result.Result<(), T.Error> {
      let data_canister = actor (NetworkEnvVars.DATA_CANISTER_ID) : actor {
        updatePlayer : (leagueId: T.FootballLeagueId, dto : DTOs.UpdatePlayerDTO) -> async Result.Result<(), T.Error>;
      };
      return await data_canister.updatePlayer(leagueId, dto);
    };

    public func executeSetPlayerInjury(leagueId: T.FootballLeagueId, dto : DTOs.SetPlayerInjuryDTO) : async Result.Result<(), T.Error> {
      let data_canister = actor (NetworkEnvVars.DATA_CANISTER_ID) : actor {
        setPlayerInjury : (leagueId: T.FootballLeagueId, dto : DTOs.SetPlayerInjuryDTO) -> async Result.Result<(), T.Error>;
      };
      return await data_canister.setPlayerInjury(leagueId, dto);
    };

    public func executeRetirePlayer(leagueId: T.FootballLeagueId, dto : DTOs.RetirePlayerDTO) : async Result.Result<(), T.Error> {
      let data_canister = actor (NetworkEnvVars.DATA_CANISTER_ID) : actor {
        retirePlayer : (leagueId: T.FootballLeagueId, dto : DTOs.RetirePlayerDTO) -> async Result.Result<(), T.Error>;
      };
      return await data_canister.retirePlayer(leagueId, dto);
    };

    public func executeUnretirePlayer(leagueId: T.FootballLeagueId, dto : DTOs.UnretirePlayerDTO) : async Result.Result<(), T.Error> {
      let data_canister = actor (NetworkEnvVars.DATA_CANISTER_ID) : actor {
        unretirePlayer : (leagueId: T.FootballLeagueId, dto : DTOs.UnretirePlayerDTO) -> async Result.Result<(), T.Error>;
      };
      return await data_canister.unretirePlayer(leagueId, dto);
    };

    public func executePromoteNewClub(leagueId: T.FootballLeagueId, dto : DTOs.PromoteNewClubDTO) : async Result.Result<(), T.Error> {
      return #err(#NotFound);
    };

    public func executeUpdateClub(leagueId: T.FootballLeagueId, dto : DTOs.UpdateClubDTO) : async Result.Result<(), T.Error> {
      return #err(#NotFound);
    };

    public func loanExpired() : async () {
      let data_canister = actor (NetworkEnvVars.DATA_CANISTER_ID) : actor {
        loanExpired : () -> async ();
      };
      return await data_canister.loanExpired();
    };

    public func injuryExpired() : async () {
      let data_canister = actor (NetworkEnvVars.DATA_CANISTER_ID) : actor {
        injuryExpired : () -> async ();
      };
      return await data_canister.injuryExpired();
    };

    public func getSnapshotPlayers(dto: RequestDTOs.GetSnapshotPlayers) : async [DTOs.PlayerDTO] {
      let data_canister = actor (NetworkEnvVars.DATA_CANISTER_ID) : actor {
        getSnapshotPlayers : (dto: RequestDTOs.GetSnapshotPlayers) -> async [DTOs.PlayerDTO];
      };
      return await data_canister.getSnapshotPlayers(dto);
    };

    public func checkGameweekComplete(seasonId: T.SeasonId, gameweek: T.GameweekNumber) : async Bool {
      let data_canister = actor (NetworkEnvironmentVariables.DATA_CANISTER_ID) : actor {
        checkGameweekComplete : (seasonId: T.SeasonId, gameweek: T.GameweekNumber) -> async Bool;
      };
      
      return await data_canister.checkGameweekComplete(seasonId,gameweek);
    };

    public func checkMonthComplete(seasonId: T.SeasonId, month: T.CalendarMonth, gameweek: T.GameweekNumber) : async Bool {
      let data_canister = actor (NetworkEnvironmentVariables.DATA_CANISTER_ID) : actor {
        checkMonthComplete : (seasonId: T.SeasonId, month: T.CalendarMonth, gameweek: T.GameweekNumber) -> async Bool;
      };
      
      return await data_canister.checkMonthComplete(seasonId, month, gameweek);

    };

    public func checkSeasonComplete(seasonId: T.SeasonId) : async Bool {
      let data_canister = actor (NetworkEnvironmentVariables.DATA_CANISTER_ID) : actor {
        checkSeasonComplete : (seasonId: T.SeasonId) -> async Bool;
      };
      
      return await data_canister.checkSeasonComplete(seasonId);
    };

    private func populatePlayerEventData(seasonId: T.SeasonId, submitFixtureDataDTO : DTOs.SubmitFixtureDataDTO, allPlayers : [DTOs.PlayerDTO]) : async ?[T.PlayerEventData] {

      let allPlayerEventsBuffer = Buffer.fromArray<T.PlayerEventData>(submitFixtureDataDTO.playerEventData);

      let homeTeamPlayerIdsBuffer = Buffer.fromArray<Nat16>([]);
      let awayTeamPlayerIdsBuffer = Buffer.fromArray<Nat16>([]);

      let data_canister = actor (NetworkEnvironmentVariables.DATA_CANISTER_ID) : actor {
        getSeason : (seasonId: T.SeasonId) -> async ?T.Season;
      };
      
      let currentSeason = await data_canister.getSeason(seasonId);

      switch (currentSeason) {
        case (null) { return null };
        case (?foundSeason) {
          let fixture = List.find<T.Fixture>(
            foundSeason.fixtures,
            func(f : T.Fixture) : Bool {
              return f.id == submitFixtureDataDTO.fixtureId;
            },
          );
          switch (fixture) {
            case (null) { return null };
            case (?foundFixture) {

              for (event in Iter.fromArray(submitFixtureDataDTO.playerEventData)) {
                if (event.clubId == foundFixture.homeClubId) {
                  let alreadyAdded = Option.isSome(Array.find<T.PlayerId>(Buffer.toArray(homeTeamPlayerIdsBuffer), func(playerId: T.PlayerId) : Bool{
                    playerId == event.playerId
                  }));
                  if(not alreadyAdded){
                    homeTeamPlayerIdsBuffer.add(event.playerId);
                  }
                } else if (event.clubId == foundFixture.awayClubId) {
                  let alreadyAdded = Option.isSome(Array.find<T.PlayerId>(Buffer.toArray(awayTeamPlayerIdsBuffer), func(playerId: T.PlayerId) : Bool{
                    playerId == event.playerId
                  }));
                  if(not alreadyAdded){
                    awayTeamPlayerIdsBuffer.add(event.playerId);
                  };
                };
              };

              let homeTeamDefensivePlayerIdsBuffer = Buffer.fromArray<Nat16>([]);
              let awayTeamDefensivePlayerIdsBuffer = Buffer.fromArray<Nat16>([]);

              for (playerId in Iter.fromArray<Nat16>(Buffer.toArray(homeTeamPlayerIdsBuffer))) {
                let player = Array.find<DTOs.PlayerDTO>(allPlayers, func(p : DTOs.PlayerDTO) : Bool { return p.id == playerId });
                switch (player) {
                  case (null) {};
                  case (?actualPlayer) {
                    if (actualPlayer.position == #Goalkeeper or actualPlayer.position == #Defender) {
                      if (Array.find<Nat16>(Buffer.toArray(homeTeamDefensivePlayerIdsBuffer), func(x : Nat16) : Bool { return x == playerId }) == null) {
                        homeTeamDefensivePlayerIdsBuffer.add(playerId);
                      };
                    };
                  };
                };
              };

              for (playerId in Iter.fromArray<Nat16>(Buffer.toArray(awayTeamPlayerIdsBuffer))) {
                let player = Array.find<DTOs.PlayerDTO>(allPlayers, func(p : DTOs.PlayerDTO) : Bool { return p.id == playerId });
                switch (player) {
                  case (null) {};
                  case (?actualPlayer) {
                    if (actualPlayer.position == #Goalkeeper or actualPlayer.position == #Defender) {
                      if (Array.find<Nat16>(Buffer.toArray(awayTeamDefensivePlayerIdsBuffer), func(x : Nat16) : Bool { return x == playerId }) == null) {
                        awayTeamDefensivePlayerIdsBuffer.add(playerId);
                      };
                    };
                  };
                };
              };

              let homeTeamGoals = Array.filter<T.PlayerEventData>(
                submitFixtureDataDTO.playerEventData,
                func(event : T.PlayerEventData) : Bool {
                  return event.clubId == foundFixture.homeClubId and event.eventType == #Goal;
                },
              );

              let awayTeamGoals = Array.filter<T.PlayerEventData>(
                submitFixtureDataDTO.playerEventData,
                func(event : T.PlayerEventData) : Bool {
                  return event.clubId == foundFixture.awayClubId and event.eventType == #Goal;
                },
              );

              let homeTeamOwnGoals = Array.filter<T.PlayerEventData>(
                submitFixtureDataDTO.playerEventData,
                func(event : T.PlayerEventData) : Bool {
                  return event.clubId == foundFixture.homeClubId and event.eventType == #OwnGoal;
                },
              );

              let awayTeamOwnGoals = Array.filter<T.PlayerEventData>(
                submitFixtureDataDTO.playerEventData,
                func(event : T.PlayerEventData) : Bool {
                  return event.clubId == foundFixture.awayClubId and event.eventType == #OwnGoal;
                },
              );

              let totalHomeScored = Array.size(homeTeamGoals) + Array.size(awayTeamOwnGoals);
              let totalAwayScored = Array.size(awayTeamGoals) + Array.size(homeTeamOwnGoals);

              if (totalHomeScored == 0) {
                for (playerId in Iter.fromArray(Buffer.toArray(awayTeamDefensivePlayerIdsBuffer))) {
                  let player = Array.find<DTOs.PlayerDTO>(allPlayers, func(p : DTOs.PlayerDTO) : Bool { return p.id == playerId });
                  switch (player) {
                    case (null) {};
                    case (?actualPlayer) {
                      let cleanSheetEvent : T.PlayerEventData = {
                        fixtureId = submitFixtureDataDTO.fixtureId;
                        playerId = playerId;
                        eventType = #CleanSheet;
                        eventStartMinute = 90;
                        eventEndMinute = 90;
                        clubId = actualPlayer.clubId;
                        position = actualPlayer.position;
                      };
                      allPlayerEventsBuffer.add(cleanSheetEvent);
                    };
                  };
                };
              } else {
                for (goal in Iter.fromArray(homeTeamGoals)) {
                  for (playerId in Iter.fromArray(Buffer.toArray(awayTeamDefensivePlayerIdsBuffer))) {
                    let player = Array.find<DTOs.PlayerDTO>(allPlayers, func(p : DTOs.PlayerDTO) : Bool { return p.id == playerId });
                    switch (player) {
                      case (null) {};
                      case (?actualPlayer) {
                        let concededEvent : T.PlayerEventData = {
                          fixtureId = submitFixtureDataDTO.fixtureId;
                          playerId = actualPlayer.id;
                          eventType = #GoalConceded;
                          eventStartMinute = goal.eventStartMinute;
                          eventEndMinute = goal.eventStartMinute;
                          clubId = actualPlayer.clubId;
                          position = actualPlayer.position;
                        };
                        allPlayerEventsBuffer.add(concededEvent);
                      };
                    };
                  };
                };
              };

              if (totalAwayScored == 0) {
                for (playerId in Iter.fromArray(Buffer.toArray(homeTeamDefensivePlayerIdsBuffer))) {
                  let player = Array.find<DTOs.PlayerDTO>(allPlayers, func(p : DTOs.PlayerDTO) : Bool { return p.id == playerId });
                  switch (player) {
                    case (null) {};
                    case (?actualPlayer) {
                      let cleanSheetEvent : T.PlayerEventData = {
                        fixtureId = submitFixtureDataDTO.fixtureId;
                        playerId = playerId;
                        eventType = #CleanSheet;
                        eventStartMinute = 90;
                        eventEndMinute = 90;
                        clubId = actualPlayer.clubId;
                        position = actualPlayer.position;
                      };
                      allPlayerEventsBuffer.add(cleanSheetEvent);
                    };
                  };
                };
              } else {
                for (goal in Iter.fromArray(awayTeamGoals)) {
                  for (playerId in Iter.fromArray(Buffer.toArray(homeTeamDefensivePlayerIdsBuffer))) {
                    let player = Array.find<DTOs.PlayerDTO>(allPlayers, func(p : DTOs.PlayerDTO) : Bool { return p.id == playerId });
                    switch (player) {
                      case (null) {};
                      case (?actualPlayer) {
                        let concededEvent : T.PlayerEventData = {
                          fixtureId = goal.fixtureId;
                          playerId = actualPlayer.id;
                          eventType = #GoalConceded;
                          eventStartMinute = goal.eventStartMinute;
                          eventEndMinute = goal.eventStartMinute;
                          clubId = actualPlayer.clubId;
                          position = actualPlayer.position;
                        };
                        allPlayerEventsBuffer.add(concededEvent);
                      };
                    };
                  };
                };
              };

              let playerEvents = Buffer.toArray<T.PlayerEventData>(allPlayerEventsBuffer);
              let eventsWithHighestScoringPlayer = populateHighestScoringPlayer(playerEvents, foundFixture, allPlayers);
              return ?eventsWithHighestScoringPlayer;
            };
          };
        };
      };
    };

    private func populateHighestScoringPlayer(playerEvents : [T.PlayerEventData], fixture : T.Fixture, players : [DTOs.PlayerDTO]) : [T.PlayerEventData] {

      let playerEventsMap : TrieMap.TrieMap<T.PlayerId, [T.PlayerEventData]> = TrieMap.TrieMap<T.PlayerId, [T.PlayerEventData]>(Utilities.eqNat16, Utilities.hashNat16);

      for (event in Iter.fromArray(playerEvents)) {
        
        let playerId : T.PlayerId = event.playerId;
        switch (playerEventsMap.get(playerId)) {
          case (null) {
            playerEventsMap.put(playerId, [event]);
          };
          case (?existingEvents) {
            let existingEventsBuffer = Buffer.fromArray<T.PlayerEventData>(existingEvents);
            existingEventsBuffer.add(event);
            playerEventsMap.put(playerId, Buffer.toArray(existingEventsBuffer));
          };
        };
      };

      let playerScoresMap : TrieMap.TrieMap<Nat16, Int16> = TrieMap.TrieMap<Nat16, Int16>(Utilities.eqNat16, Utilities.hashNat16);
      for ((playerId, events) in playerEventsMap.entries()) {
        let currentPlayer = Array.find<DTOs.PlayerDTO>(
          players,
          func(player : DTOs.PlayerDTO) : Bool {
            return player.id == playerId;
          },
        );

        switch (currentPlayer) {
          case (null) {};
          case (?foundPlayer) {
            let totalScore = Array.foldLeft<T.PlayerEventData, Int16>(
              events,
              0,
              func(acc : Int16, event : T.PlayerEventData) : Int16 {
                return acc + Utilities.calculateIndividualScoreForEvent(event, foundPlayer.position);
              },
            );

            let aggregateScore = Utilities.calculateAggregatePlayerEvents(events, foundPlayer.position);
            playerScoresMap.put(playerId, totalScore + aggregateScore);
          };
        };
      };

      var highestScore : Int16 = 0;
      var highestScoringPlayerId : T.PlayerId = 0;
      var isUniqueHighScore : Bool = true;
      let uniquePlayerIdsBuffer = Buffer.fromArray<T.PlayerId>([]);

      for (event in Iter.fromArray(playerEvents)) {
        if (not Buffer.contains<T.PlayerId>(uniquePlayerIdsBuffer, event.playerId, func(a : T.PlayerId, b : T.PlayerId) : Bool { a == b })) {
          uniquePlayerIdsBuffer.add(event.playerId);
        };
      };

      let uniquePlayerIds = Buffer.toArray<Nat16>(uniquePlayerIdsBuffer);

      for (j in Iter.range(0, Array.size(uniquePlayerIds) -1)) {
        let playerId = uniquePlayerIds[j];
        switch (playerScoresMap.get(playerId)) {
          case (?playerScore) {
            if (playerScore > highestScore) {
              highestScore := playerScore;
              highestScoringPlayerId := playerId;
              isUniqueHighScore := true;
            } else if (playerScore == highestScore) {
              isUniqueHighScore := false;
            };
          };
          case null {};
        };
      };

      if (isUniqueHighScore) {
        let highestScoringPlayer = Array.find<DTOs.PlayerDTO>(players, func(p : DTOs.PlayerDTO) : Bool { return p.id == highestScoringPlayerId });
        switch (highestScoringPlayer) {
          case (null) {};
          case (?foundPlayer) {
            let newEvent : T.PlayerEventData = {
              fixtureId = fixture.id;
              playerId = highestScoringPlayerId;
              eventType = #HighestScoringPlayer;
              eventStartMinute = 90;
              eventEndMinute = 90;
              clubId = foundPlayer.clubId;
            };
            let existingEvents = playerEventsMap.get(highestScoringPlayerId);
            switch (existingEvents) {
              case (null) {};
              case (?foundEvents) {
                let existingEventsBuffer = Buffer.fromArray<T.PlayerEventData>(foundEvents);
                existingEventsBuffer.add(newEvent);
                playerEventsMap.put(highestScoringPlayerId, Buffer.toArray(existingEventsBuffer));
              };
            };
          };
        };
      };

      let allEventsBuffer = Buffer.fromArray<T.PlayerEventData>([]);
      for ((playerId, playerEventArray) in playerEventsMap.entries()) {
        allEventsBuffer.append(Buffer.fromArray(playerEventArray));
      };

      return Buffer.toArray(allEventsBuffer);
    };

    //Admin functions

    public func createLeague(dto: RequestDTOs.CreateLeagueDTO) : async Result.Result<(), T.Error> {
      Debug.print("creating league in data manager");
      Debug.print(debug_show dto);
      let data_canister = actor (NetworkEnvironmentVariables.DATA_CANISTER_ID) : actor {
        createLeague : (dto: RequestDTOs.CreateLeagueDTO) -> async Result.Result<(), T.Error>;
      };
      
      return await data_canister.createLeague(dto);
    };
    
    public func setLeagueName(leagueId: T.FootballLeagueId, leagueName: Text) : async Result.Result<(), T.Error> {
      let data_canister = actor (NetworkEnvironmentVariables.DATA_CANISTER_ID) : actor {
        setLeagueName : (leagueId: T.FootballLeagueId, leagueName: Text) -> async Result.Result<(), T.Error>;
      };
      
      Debug.print("calling data canister to set league name");
      return await data_canister.setLeagueName(leagueId, leagueName);
    };


    public func setAbbreviatedLeagueName(leagueId: T.FootballLeagueId, abbreviatedName: Text) : async Result.Result<(), T.Error> {
      let data_canister = actor (NetworkEnvironmentVariables.DATA_CANISTER_ID) : actor {
        setAbbreviatedLeagueName : (leagueId: T.FootballLeagueId, abbreviatedName: Text) -> async Result.Result<(), T.Error>;
      };
      
      return await data_canister.setAbbreviatedLeagueName(leagueId, abbreviatedName);
    };


    public func setLeagueGoverningBody(leagueId: T.FootballLeagueId, governingBody: Text) : async Result.Result<(), T.Error> {
      let data_canister = actor (NetworkEnvironmentVariables.DATA_CANISTER_ID) : actor {
        setLeagueGoverningBody : (leagueId: T.FootballLeagueId, governingBody: Text) -> async Result.Result<(), T.Error>;
      };
      
      return await data_canister.setLeagueGoverningBody(leagueId, governingBody);
    };


    public func setLeagueGender(leagueId: T.FootballLeagueId, gender: T.Gender) : async Result.Result<(), T.Error> {
      let data_canister = actor (NetworkEnvironmentVariables.DATA_CANISTER_ID) : actor {
        setLeagueGender : (leagueId: T.FootballLeagueId, gender: T.Gender) -> async Result.Result<(), T.Error>;
      };
      
      return await data_canister.setLeagueGender(leagueId, gender);
    };


    public func setLeagueDateFormed(leagueId: T.FootballLeagueId, dateFormed: Int) : async Result.Result<(), T.Error> {
      let data_canister = actor (NetworkEnvironmentVariables.DATA_CANISTER_ID) : actor {
        setLeagueDateFormed : (leagueId: T.FootballLeagueId, dateFormed: Int) -> async Result.Result<(), T.Error>;
      };
      
      return await data_canister.setLeagueDateFormed(leagueId, dateFormed);
    };


    public func setLeagueCountryId(leagueId: T.FootballLeagueId, countryId: T.CountryId) : async Result.Result<(), T.Error> {
      let data_canister = actor (NetworkEnvironmentVariables.DATA_CANISTER_ID) : actor {
        setLeagueCountryId : (leagueId: T.FootballLeagueId, countryId: T.CountryId) -> async Result.Result<(), T.Error>;
      };
      
      return await data_canister.setLeagueCountryId(leagueId, countryId);
    };


    public func setLeagueLogo(leagueId: T.FootballLeagueId, logo: Blob) : async Result.Result<(), T.Error> {
     let data_canister = actor (NetworkEnvironmentVariables.DATA_CANISTER_ID) : actor {
        setLeagueLogo : (leagueId: T.FootballLeagueId, logo: Blob) -> async Result.Result<(), T.Error>;
      };
      
      return await data_canister.setLeagueLogo(leagueId, logo);
    };
    
    public func setLeagueTeamCount(leagueId: T.FootballLeagueId, teamCount: Nat8) : async Result.Result<(), T.Error> {
      let data_canister = actor (NetworkEnvironmentVariables.DATA_CANISTER_ID) : actor {
        setLeagueTeamCount : (leagueId: T.FootballLeagueId, teamCount: Nat8) -> async Result.Result<(), T.Error>;
      };
      
      Debug.print("calling data canister to set league name");
      return await data_canister.setLeagueTeamCount(leagueId, teamCount);
    };


  };

};
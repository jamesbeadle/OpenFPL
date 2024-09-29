import Result "mo:base/Result";
import DTOs "../../shared/DTOs";
import T "../../shared/types";
import NetworkEnvVars "../network_environment_variables";
import RequestDTOs "../../shared/RequestDTOs";

module {

  public class DataManager() {


    public func getClubs() : async Result.Result<[DTOs.ClubDTO], T.Error> {
      let data_canister = actor (NetworkEnvVars.DATA_CANISTER_ID) : actor {
        getClubs : () -> async Result.Result<[T.Club], T.Error>;
      };
      return await data_canister.getClubs();
    };

    public func getFixtures(dto: RequestDTOs.RequestFixturesDTO) : async Result.Result<[DTOs.FixtureDTO], T.Error> {
      let data_canister = actor (NetworkEnvVars.DATA_CANISTER_ID) : actor {
        getFixtures : (dto: RequestDTOs.RequestFixturesDTO) -> async Result.Result<[DTOs.FixtureDTO], T.Error>;
      };
      return await data_canister.getFixtures(dto);
    };

    public func getSeasons() : async Result.Result<[DTOs.SeasonDTO], T.Error> {
      let data_canister = actor (NetworkEnvVars.DATA_CANISTER_ID) : actor {
        getSeasons : () -> async Result.Result<[DTOs.SeasonDTO], T.Error>;
      };
      return await data_canister.getSeasons();
    };

    public func getPostponedFixtures() : async Result.Result<[DTOs.FixtureDTO], T.Error> {
      let data_canister = actor (NetworkEnvVars.DATA_CANISTER_ID) : actor {
        getPostponedFixtures : () -> async Result.Result<[DTOs.FixtureDTO], T.Error>;
      };
      return await data_canister.getPostponedFixtures();
    };

    public func getPlayers() : async Result.Result<[DTOs.PlayerDTO], T.Error> {
      let data_canister = actor (NetworkEnvVars.DATA_CANISTER_ID) : actor {
        getPlayers : () -> async Result.Result<[DTOs.PlayerDTO], T.Error>;
      };
      return await data_canister.getPlayers();
    };

    public func getLoanedPlayers(dto: DTOs.ClubFilterDTO) : async Result.Result<[DTOs.PlayerDTO], T.Error> {
      let data_canister = actor (NetworkEnvVars.DATA_CANISTER_ID) : actor {
        getLoanedPlayers : (dto: DTOs.ClubFilterDTO) -> async Result.Result<[DTOs.PlayerDTO], T.Error>;
      };
      return await data_canister.getLoanedPlayers(dto);
    };

    public func getRetiredPlayers(dto: DTOs.ClubFilterDTO) : async Result.Result<[DTOs.PlayerDTO], T.Error> {
      let data_canister = actor (NetworkEnvVars.DATA_CANISTER_ID) : actor {
        getRetiredPlayers : (dto: DTOs.ClubFilterDTO) -> async Result.Result<[DTOs.PlayerDTO], T.Error>;
      };
      return await data_canister.getRetiredPlayers(dto);
    };

    public func getPlayerDetailsForGameweek(dto: DTOs.GameweekFiltersDTO) : async Result.Result<[DTOs.PlayerPointsDTO], T.Error> {
      let data_canister = actor (NetworkEnvVars.DATA_CANISTER_ID) : actor {
        getPlayerDetailsForGameweek : (dto: DTOs.GameweekFiltersDTO) -> async Result.Result<[DTOs.PlayerPointsDTO], T.Error>;
      };
      return await data_canister.getPlayerDetailsForGameweek(dto);
    };

    public func getPlayersMap(dto: DTOs.GameweekFiltersDTO) : async Result.Result<[(Nat16, DTOs.PlayerScoreDTO)], T.Error> {
      let data_canister = actor (NetworkEnvVars.DATA_CANISTER_ID) : actor {
        getPlayersMap : (dto: DTOs.GameweekFiltersDTO) -> async Result.Result<[(Nat16, DTOs.PlayerScoreDTO)], T.Error>;
      };
      return await data_canister.getPlayersMap(dto);
    };

    public func getPlayerDetails(dto: DTOs.GetPlayerDetailsDTO) : async Result.Result<DTOs.PlayerDetailDTO, T.Error> {
      let data_canister = actor (NetworkEnvVars.DATA_CANISTER_ID) : actor {
        getPlayerDetailsForGameweek : (dto: DTOs.GetPlayerDetailsDTO) -> async Result.Result<DTOs.PlayerDetailDTO, T.Error>;
      };
      return await data_canister.getPlayerDetailsForGameweek(dto);
    };

    public func validateRevaluePlayerUp(revaluePlayerUpDTO : DTOs.RevaluePlayerUpDTO) :  async Result.Result<(), T.Error> {
      let data_canister = actor (NetworkEnvVars.DATA_CANISTER_ID) : actor {
        validateRevaluePlayerUp : (revaluePlayerUpDTO : DTOs.RevaluePlayerUpDTO) -> async Result.Result<(), T.Error>;
      };
      return await data_canister.validateRevaluePlayerUp(revaluePlayerUpDTO);
    };

    public func validateRevaluePlayerDown(revaluePlayerDownDTO : DTOs.RevaluePlayerDownDTO) :  async Result.Result<(), T.Error> {
      let data_canister = actor (NetworkEnvVars.DATA_CANISTER_ID) : actor {
        validateRevaluePlayerDown : (revaluePlayerDownDTO : DTOs.RevaluePlayerDownDTO) -> async Result.Result<(), T.Error>;
      };
      return await data_canister.validateRevaluePlayerDown(revaluePlayerDownDTO);
    };

    public func validateSubmitFixtureData(dto : DTOs.SubmitFixtureDataDTO) : async Result.Result<(), T.Error>{
      let data_canister = actor (NetworkEnvVars.DATA_CANISTER_ID) : actor {
        validateSubmitFixtureData : (dto : DTOs.SubmitFixtureDataDTO) -> async Result.Result<(), T.Error>;
      };
      return await data_canister.validateSubmitFixtureData(dto);
    };

    public func validateAddInitialFixtures(dto: DTOs.AddInitialFixturesDTO) : async Result.Result<(), T.Error>{
      let data_canister = actor (NetworkEnvVars.DATA_CANISTER_ID) : actor {
        validateAddInitialFixtures : (dto : DTOs.AddInitialFixturesDTO) -> async Result.Result<(), T.Error>;
      };
      return await data_canister.validateAddInitialFixtures(dto);
    }; 

    public func validateMoveFixture(dto: DTOs.MoveFixtureDTO) : async Result.Result<(), T.Error>{
      let data_canister = actor (NetworkEnvVars.DATA_CANISTER_ID) : actor {
        validateMoveFixture : (dto : DTOs.MoveFixtureDTO) -> async Result.Result<(), T.Error>;
      };
      return await data_canister.validateMoveFixture(dto);
    }; 

    public func validatePostponeFixture(dto: DTOs.PostponeFixtureDTO) : async Result.Result<(), T.Error>{
      let data_canister = actor (NetworkEnvVars.DATA_CANISTER_ID) : actor {
        validatePostponeFixture : (dto : DTOs.PostponeFixtureDTO) -> async Result.Result<(), T.Error>;
      };
      return await data_canister.validatePostponeFixture(dto);
    }; 

    public func validateRescheduleFixture(dto: DTOs.RescheduleFixtureDTO) : async Result.Result<(), T.Error>{
      let data_canister = actor (NetworkEnvVars.DATA_CANISTER_ID) : actor {
        validateRescehduleFixture : (dto : DTOs.RescheduleFixtureDTO) -> async Result.Result<(), T.Error>;
      };
      return await data_canister.validateRescehduleFixture(dto);
    }; 

    public func validatePromoteFormerClub(dto: DTOs.PromoteFormerClubDTO) : async Result.Result<(), T.Error>{
      let data_canister = actor (NetworkEnvVars.DATA_CANISTER_ID) : actor {
        validatePromoteFormerClub : (dto : DTOs.PromoteFormerClubDTO) -> async Result.Result<(), T.Error>;
      };
      return await data_canister.validatePromoteFormerClub(dto);
    }; 

    public func validatePromoteNewClub(dto: DTOs.PromoteNewClubDTO) : async Result.Result<(), T.Error>{
      let data_canister = actor (NetworkEnvVars.DATA_CANISTER_ID) : actor {
        validatePromoteNewClub : (dto : DTOs.PromoteNewClubDTO) -> async Result.Result<(), T.Error>;
      };
      return await data_canister.validatePromoteNewClub(dto);
    }; 

    public func validateUpdateClub(dto: DTOs.UpdateClubDTO) : async Result.Result<(), T.Error>{
      let data_canister = actor (NetworkEnvVars.DATA_CANISTER_ID) : actor {
        validateUpdateClub : (dto : DTOs.UpdateClubDTO) -> async Result.Result<(), T.Error>;
      };
      return await data_canister.validateUpdateClub(dto);
    }; 

    public func validateLoanPlayer(loanPlayerDTO : DTOs.LoanPlayerDTO) :  async Result.Result<(), T.Error> {
      let data_canister = actor (NetworkEnvVars.DATA_CANISTER_ID) : actor {
        validateLoanPlayer : (loanPlayerDTO : DTOs.LoanPlayerDTO) -> async Result.Result<(), T.Error>;
      };
      return await data_canister.validateLoanPlayer(loanPlayerDTO);
    };

    public func validateTransferPlayer(transferPlayerDTO : DTOs.TransferPlayerDTO) :  async Result.Result<(), T.Error> {
      let data_canister = actor (NetworkEnvVars.DATA_CANISTER_ID) : actor {
        validateTransferPlayer : (transferPlayerDTO : DTOs.TransferPlayerDTO) -> async Result.Result<(), T.Error>;
      };
      return await data_canister.validateTransferPlayer(transferPlayerDTO);
    };

    public func validateRecallPlayer(recallPlayerDTO : DTOs.RecallPlayerDTO) :  async Result.Result<(), T.Error> {
      let data_canister = actor (NetworkEnvVars.DATA_CANISTER_ID) : actor {
        recallPlayerDTO : (recallPlayerDTO : DTOs.RecallPlayerDTO) -> async Result.Result<(), T.Error>;
      };
      return await data_canister.recallPlayerDTO(recallPlayerDTO);
    };

    public func validateCreatePlayer(createPlayerDTO : DTOs.CreatePlayerDTO) :  async Result.Result<(), T.Error> {
      let data_canister = actor (NetworkEnvVars.DATA_CANISTER_ID) : actor {
        validateCreatePlayer : (createPlayerDTO : DTOs.CreatePlayerDTO) -> async Result.Result<(), T.Error>;
      };
      return await data_canister.validateCreatePlayer(createPlayerDTO);
    };

    public func validateUpdatePlayer(updatePlayerDTO : DTOs.UpdatePlayerDTO) :  async Result.Result<(), T.Error> {
      let data_canister = actor (NetworkEnvVars.DATA_CANISTER_ID) : actor {
        validateUpdatePlayer : (updatePlayerDTO : DTOs.UpdatePlayerDTO) -> async Result.Result<(), T.Error>;
      };
      return await data_canister.validateUpdatePlayer(updatePlayerDTO);
    };

    public func validateSetPlayerInjury(setPlayerInjuryDTO : DTOs.SetPlayerInjuryDTO) :  async Result.Result<(), T.Error> {
      let data_canister = actor (NetworkEnvVars.DATA_CANISTER_ID) : actor {
        validateSetPlayerInjury : (setPlayerInjuryDTO : DTOs.SetPlayerInjuryDTO) -> async Result.Result<(), T.Error>;
      };
      return await data_canister.validateSetPlayerInjury(setPlayerInjuryDTO);
    };

    public func validateRetirePlayer(retirePlayerDTO : DTOs.RetirePlayerDTO) :  async Result.Result<(), T.Error> {
      let data_canister = actor (NetworkEnvVars.DATA_CANISTER_ID) : actor {
        validateRetirePlayer : (retirePlayerDTO : DTOs.RetirePlayerDTO) -> async Result.Result<(), T.Error>;
      };
      return await data_canister.validateRetirePlayer(retirePlayerDTO);
    };

    public func validateUnretirePlayer(unretirePlayerDTO : DTOs.UnretirePlayerDTO) :  async Result.Result<(), T.Error> {
     let data_canister = actor (NetworkEnvVars.DATA_CANISTER_ID) : actor {
        validateUnretirePlayer : (unretirePlayerDTO : DTOs.UnretirePlayerDTO) -> async Result.Result<(), T.Error>;
      };
      return await data_canister.validateUnretirePlayer(unretirePlayerDTO);
    };

    public func executeRevaluePlayerUp(dto : DTOs.RevaluePlayerUpDTO) : async Result.Result<(), T.Error> {
      let data_canister = actor (NetworkEnvVars.DATA_CANISTER_ID) : actor {
        revaluePlayerUp : (dto : DTOs.RevaluePlayerUpDTO) -> async Result.Result<(), T.Error>;
      };
      return await data_canister.revaluePlayerUp(dto);
    };

    public func executeRevaluePlayerDown(dto : DTOs.RevaluePlayerDownDTO) : async Result.Result<(), T.Error> {
      let data_canister = actor (NetworkEnvVars.DATA_CANISTER_ID) : actor {
        revaluePlayerDown : (dto : DTOs.RevaluePlayerDownDTO) -> async Result.Result<(), T.Error>;
      };
      return await data_canister.revaluePlayerDown(dto);
    };

    public func executeSubmitFixtureData(dto : DTOs.SubmitFixtureDataDTO) : async Result.Result<(), T.Error> {
      return #err(#NotFound);
    };

    public func executeAddInitialFixtures(dto : DTOs.AddInitialFixturesDTO) : async Result.Result<(), T.Error> {
      return #err(#NotFound);
    };

    public func executeMoveFixture(dto : DTOs.MoveFixtureDTO) : async Result.Result<(), T.Error> {
      return #err(#NotFound);
    };

    public func executePostponeFixture(dto : DTOs.PostponeFixtureDTO) : async Result.Result<(), T.Error> {
      return #err(#NotFound);
    };

    public func executeRescheduleFixture(dto : DTOs.RescheduleFixtureDTO) : async Result.Result<(), T.Error> {
      return #err(#NotFound);
    };

    public func executeLoanPlayer(dto : DTOs.LoanPlayerDTO) : async Result.Result<(), T.Error> {
      let data_canister = actor (NetworkEnvVars.DATA_CANISTER_ID) : actor {
        loanPlayer : (dto : DTOs.LoanPlayerDTO) -> async Result.Result<(), T.Error>;
      };
      return await data_canister.loanPlayer(dto);
    };

    public func executeTransferPlayer(dto : DTOs.TransferPlayerDTO) : async Result.Result<(), T.Error> {
      let data_canister = actor (NetworkEnvVars.DATA_CANISTER_ID) : actor {
        transferPlayer : (dto : DTOs.TransferPlayerDTO) -> async Result.Result<(), T.Error>;
      };
      return await data_canister.transferPlayer(dto);
    };

    public func executeRecallPlayer(dto : DTOs.RecallPlayerDTO) : async Result.Result<(), T.Error> {
      let data_canister = actor (NetworkEnvVars.DATA_CANISTER_ID) : actor {
        recallPlayer : (dto : DTOs.RecallPlayerDTO) -> async Result.Result<(), T.Error>;
      };
      return await data_canister.recallPlayer(dto);
    };

    public func executeCreatePlayer(dto : DTOs.CreatePlayerDTO) : async Result.Result<(), T.Error> {
      let data_canister = actor (NetworkEnvVars.DATA_CANISTER_ID) : actor {
        createPlayer : (dto : DTOs.CreatePlayerDTO) -> async Result.Result<(), T.Error>;
      };
      return await data_canister.createPlayer(dto);
    };

    public func executeUpdatePlayer(dto : DTOs.UpdatePlayerDTO) : async Result.Result<(), T.Error> {
      let data_canister = actor (NetworkEnvVars.DATA_CANISTER_ID) : actor {
        updatePlayer : (dto : DTOs.UpdatePlayerDTO) -> async Result.Result<(), T.Error>;
      };
      return await data_canister.updatePlayer(dto);
    };

    public func executeSetPlayerInjury(dto : DTOs.SetPlayerInjuryDTO) : async Result.Result<(), T.Error> {
      let data_canister = actor (NetworkEnvVars.DATA_CANISTER_ID) : actor {
        setPlayerInjury : (dto : DTOs.SetPlayerInjuryDTO) -> async Result.Result<(), T.Error>;
      };
      return await data_canister.setPlayerInjury(dto);
    };

    public func executeRetirePlayer(dto : DTOs.RetirePlayerDTO) : async Result.Result<(), T.Error> {
      let data_canister = actor (NetworkEnvVars.DATA_CANISTER_ID) : actor {
        retirePlayer : (dto : DTOs.RetirePlayerDTO) -> async Result.Result<(), T.Error>;
      };
      return await data_canister.retirePlayer(dto);
    };

    public func executeUnretirePlayer(dto : DTOs.UnretirePlayerDTO) : async Result.Result<(), T.Error> {
      let data_canister = actor (NetworkEnvVars.DATA_CANISTER_ID) : actor {
        unretirePlayer : (dto : DTOs.UnretirePlayerDTO) -> async Result.Result<(), T.Error>;
      };
      return await data_canister.unretirePlayer(dto);
    };

    public func executePromoteFormerClub(dto : DTOs.PromoteFormerClubDTO) : async Result.Result<(), T.Error> {
      return #err(#NotFound);
    };

    public func executePromoteNewClub(dto : DTOs.PromoteNewClubDTO) : async Result.Result<(), T.Error> {
      return #err(#NotFound);
    };

    public func executeUpdateClub(dto : DTOs.UpdateClubDTO) : async Result.Result<(), T.Error> {
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

    

  };

};
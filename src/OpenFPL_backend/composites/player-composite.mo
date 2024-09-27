import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import Iter "mo:base/Iter";
import List "mo:base/List";
import Text "mo:base/Text";
import Time "mo:base/Time";
import Int "mo:base/Int";
import Timer "mo:base/Timer";
import Nat16 "mo:base/Nat16";
import TrieMap "mo:base/TrieMap";
import Option "mo:base/Option";
import Debug "mo:base/Debug";
import Result "mo:base/Result";

import Countries "../Countries";
import DTOs "../DTOs";
import T "../types";
import Utilities "../utils/utilities";
import Environment "../utils/Environment";

module {
  public class PlayerComposite() {

    public func getActivePlayers(currentSeasonId : T.SeasonId, activeClubs: [T.ClubId]) : async Result.Result<[DTOs.PlayerDTO], T.Error> {
      let data_canister = actor (Environment.DATA_CANISTER_ID) : actor {
        getActivePlayers : (currentSeasonId : T.SeasonId, activeClubs: [T.ClubId]) -> async Result.Result<[DTOs.PlayerDTO], T.Error>;
      };
      return await data_canister.getActivePlayers(currentSeasonId, activeClubs);
    };

    public func getAllPlayers(currentSeasonId : T.SeasonId) : async Result.Result<[DTOs.PlayerDTO], T.Error> {
      let data_canister = actor (Environment.DATA_CANISTER_ID) : actor {
        getAllPlayers : (currentSeasonId : T.SeasonId) -> async Result.Result<[DTOs.PlayerDTO], T.Error>;
      };
      return await data_canister.getAllPlayers(currentSeasonId);
    };

    public func getLoanedPlayers(dto: DTOs.ClubFilterDTO) : async Result.Result<[DTOs.PlayerDTO], T.Error> {
      let data_canister = actor (Environment.DATA_CANISTER_ID) : actor {
        getLoanedPlayers : (dto: DTOs.ClubFilterDTO) -> async Result.Result<[DTOs.PlayerDTO], T.Error>;
      };
      return await data_canister.getLoanedPlayers(dto);
    };

    public func getRetiredPlayers(dto: DTOs.ClubFilterDTO) : async Result.Result<[DTOs.PlayerDTO], T.Error> {
      let data_canister = actor (Environment.DATA_CANISTER_ID) : actor {
        getRetiredPlayers : (dto: DTOs.ClubFilterDTO) -> async Result.Result<[DTOs.PlayerDTO], T.Error>;
      };
      return await data_canister.getRetiredPlayers(dto);
    };

    public func getPlayerDetailsForGameweek(dto: DTOs.GameweekFiltersDTO) : async Result.Result<[DTOs.PlayerPointsDTO], T.Error> {
      let data_canister = actor (Environment.DATA_CANISTER_ID) : actor {
        getPlayerDetailsForGameweek : (dto: DTOs.GameweekFiltersDTO) -> async Result.Result<[DTOs.PlayerPointsDTO], T.Error>;
      };
      return await data_canister.getPlayerDetailsForGameweek(dto);
    };

    public func getPlayersMap(dto: DTOs.GameweekFiltersDTO) : async Result.Result<[(Nat16, DTOs.PlayerScoreDTO)], T.Error> {
      let data_canister = actor (Environment.DATA_CANISTER_ID) : actor {
        getPlayersMap : (dto: DTOs.GameweekFiltersDTO) -> async Result.Result<[(Nat16, DTOs.PlayerScoreDTO)], T.Error>;
      };
      return await data_canister.getPlayersMap(dto);
    };

    public func getPlayerDetails(dto: DTOs.GetPlayerDetailsDTO) : async Result.Result<DTOs.PlayerDetailDTO, T.Error> {
      let data_canister = actor (Environment.DATA_CANISTER_ID) : actor {
        getPlayerDetails : (dto: DTOs.GetPlayerDetailsDTO) -> async Result.Result<DTOs.PlayerDetailDTO, T.Error>;
      };
      return await data_canister.getPlayerDetails(dto);
    };

    public func getPlayerPosition(playerId : T.PlayerId) : async Result.Result<?T.PlayerPosition, T.Error> {
      let data_canister = actor (Environment.DATA_CANISTER_ID) : actor {
        getPlayerPosition : (playerId : T.PlayerId) -> async Result.Result<?T.PlayerPosition, T.Error>;
      };
      return await data_canister.getPlayerPosition(playerId);
    };
    
    public func revaluePlayerUp(revaluePlayerUpDTO : DTOs.RevaluePlayerUpDTO) : async Result.Result<(), T.Error> {
      let data_canister = actor (Environment.DATA_CANISTER_ID) : actor {
        revaluePlayerUp : (revaluePlayerUpDTO : DTOs.RevaluePlayerUpDTO) -> async Result.Result<(), T.Error>;
      };
      return await data_canister.revaluePlayerUp(revaluePlayerUpDTO);
    };

    public func revaluePlayerDown(revaluePlayerDownDTO : DTOs.RevaluePlayerDownDTO) : async Result.Result<(), T.Error> {
      let data_canister = actor (Environment.DATA_CANISTER_ID) : actor {
        revaluePlayerDown : (revaluePlayerDownDTO : DTOs.RevaluePlayerDownDTO) -> async Result.Result<(), T.Error>;
      };
      return await data_canister.revaluePlayerDown(revaluePlayerDownDTO);
    };

    public func loanPlayer(loanPlayerDTO : DTOs.LoanPlayerDTO) : async Result.Result<(), T.Error> {
      let data_canister = actor (Environment.DATA_CANISTER_ID) : actor {
        loanPlayer : (loanPlayerDTO : DTOs.LoanPlayerDTO) -> async Result.Result<(), T.Error>;
      };
      return await data_canister.loanPlayer(loanPlayerDTO);
    };

    public func transferPlayer(transferPlayerDTO : DTOs.TransferPlayerDTO) : async Result.Result<(), T.Error> {
      let data_canister = actor (Environment.DATA_CANISTER_ID) : actor {
        transferPlayer : (transferPlayerDTO : DTOs.TransferPlayerDTO) -> async Result.Result<(), T.Error>;
      };
      return await data_canister.transferPlayer(transferPlayerDTO);
    };

    public func recallPlayer(recallPlayerDTO : DTOs.RecallPlayerDTO) : async Result.Result<(), T.Error> {
      let data_canister = actor (Environment.DATA_CANISTER_ID) : actor {
        recallPlayer : (recallPlayerDTO : DTOs.RecallPlayerDTO) -> async Result.Result<(), T.Error>;
      };
      return await data_canister.recallPlayer(recallPlayerDTO);
    };

    public func resetPlayerInjury(playerId : T.PlayerId) : async Result.Result<(), T.Error>{
      let data_canister = actor (Environment.DATA_CANISTER_ID) : actor {
        resetPlayerInjury : (playerId : T.PlayerId) -> async Result.Result<(), T.Error>;
      };
      return await data_canister.resetPlayerInjury(playerId);
    };

    public func createPlayer(createPlayerDTO : DTOs.CreatePlayerDTO) : async Result.Result<(), T.Error> {
      let data_canister = actor (Environment.DATA_CANISTER_ID) : actor {
        createPlayer : (createPlayerDTO : DTOs.CreatePlayerDTO) -> async Result.Result<(), T.Error>;
      };
      return await data_canister.createPlayer(createPlayerDTO);
    };

    public func updatePlayer(updatePlayerDTO : DTOs.UpdatePlayerDTO) : async Result.Result<(), T.Error>{
      let data_canister = actor (Environment.DATA_CANISTER_ID) : actor {
        updatePlayer : (updatePlayerDTO : DTOs.UpdatePlayerDTO) -> async Result.Result<(), T.Error>;
      };
      return await data_canister.updatePlayer(updatePlayerDTO);
    };

    public func setPlayerInjury(setPlayerInjuryDTO : DTOs.SetPlayerInjuryDTO) : async Result.Result<(), T.Error> {
      let data_canister = actor (Environment.DATA_CANISTER_ID) : actor {
        setPlayerInjury : (setPlayerInjuryDTO : DTOs.SetPlayerInjuryDTO) -> async Result.Result<(), T.Error>;
      };
      return await data_canister.setPlayerInjury(setPlayerInjuryDTO);
    };

    public func retirePlayer(retirePlayerDTO : DTOs.RetirePlayerDTO) : async Result.Result<(), T.Error> {
      let data_canister = actor (Environment.DATA_CANISTER_ID) : actor {
        retirePlayer : (retirePlayerDTO : DTOs.RetirePlayerDTO) -> async Result.Result<(), T.Error>;
      };
      return await data_canister.retirePlayer(retirePlayerDTO);
    };

    public func unretirePlayer(unretirePlayerDTO : DTOs.UnretirePlayerDTO) : async Result.Result<(), T.Error>{
      let data_canister = actor (Environment.DATA_CANISTER_ID) : actor {
        unretirePlayer : (unretirePlayerDTO : DTOs.UnretirePlayerDTO) -> async Result.Result<(), T.Error>;
      };
      return await data_canister.unretirePlayer(unretirePlayerDTO);
    };

    public func addEventsToPlayers(playerEventData : [T.PlayerEventData], seasonId : T.SeasonId, gameweek : T.GameweekNumber) : async Result.Result<(), T.Error> {
      let data_canister = actor (Environment.DATA_CANISTER_ID) : actor {
        addEventsToPlayers : (playerEventData : [T.PlayerEventData], seasonId : T.SeasonId, gameweek : T.GameweekNumber) -> async Result.Result<(), T.Error>;
      };
      return await data_canister.addEventsToPlayers(playerEventData, seasonId, gameweek);
    };

    public func validateRevaluePlayerUp(revaluePlayerUpDTO : DTOs.RevaluePlayerUpDTO) :  async Result.Result<(), T.Error> {
      let data_canister = actor (Environment.DATA_CANISTER_ID) : actor {
        validateRevaluePlayerUp : (revaluePlayerUpDTO : DTOs.RevaluePlayerUpDTO) -> async Result.Result<(), T.Error>;
      };
      return await data_canister.validateRevaluePlayerUp(revaluePlayerUpDTO);
    };

    public func validateRevaluePlayerDown(revaluePlayerDownDTO : DTOs.RevaluePlayerDownDTO) :  async Result.Result<(), T.Error> {
      let data_canister = actor (Environment.DATA_CANISTER_ID) : actor {
        validateRevaluePlayerDown : (revaluePlayerDownDTO : DTOs.RevaluePlayerDownDTO) -> async Result.Result<(), T.Error>;
      };
      return await data_canister.validateRevaluePlayerDown(revaluePlayerDownDTO);
    };

    public func validateLoanPlayer(loanPlayerDTO : DTOs.LoanPlayerDTO) :  async Result.Result<(), T.Error> {
      let data_canister = actor (Environment.DATA_CANISTER_ID) : actor {
        validateLoanPlayer : (loanPlayerDTO : DTOs.LoanPlayerDTO) -> async Result.Result<(), T.Error>;
      };
      return await data_canister.validateLoanPlayer(loanPlayerDTO);
    };

    public func validateTransferPlayer(transferPlayerDTO : DTOs.TransferPlayerDTO) :  async Result.Result<(), T.Error> {
      let data_canister = actor (Environment.DATA_CANISTER_ID) : actor {
        validateTransferPlayer : (transferPlayerDTO : DTOs.TransferPlayerDTO) -> async Result.Result<(), T.Error>;
      };
      return await data_canister.validateTransferPlayer(transferPlayerDTO);
    };

    public func validateRecallPlayer(recallPlayerDTO : DTOs.RecallPlayerDTO) :  async Result.Result<(), T.Error> {
      let data_canister = actor (Environment.DATA_CANISTER_ID) : actor {
        recallPlayerDTO : (recallPlayerDTO : DTOs.RecallPlayerDTO) -> async Result.Result<(), T.Error>;
      };
      return await data_canister.recallPlayerDTO(recallPlayerDTO);
    };

    public func validateCreatePlayer(createPlayerDTO : DTOs.CreatePlayerDTO) :  async Result.Result<(), T.Error> {
      let data_canister = actor (Environment.DATA_CANISTER_ID) : actor {
        validateCreatePlayer : (createPlayerDTO : DTOs.CreatePlayerDTO) -> async Result.Result<(), T.Error>;
      };
      return await data_canister.validateCreatePlayer(createPlayerDTO);
    };

    public func validateUpdatePlayer(updatePlayerDTO : DTOs.UpdatePlayerDTO) :  async Result.Result<(), T.Error> {
      let data_canister = actor (Environment.DATA_CANISTER_ID) : actor {
        validateUpdatePlayer : (updatePlayerDTO : DTOs.UpdatePlayerDTO) -> async Result.Result<(), T.Error>;
      };
      return await data_canister.validateUpdatePlayer(updatePlayerDTO);
    };

    public func validateSetPlayerInjury(setPlayerInjuryDTO : DTOs.SetPlayerInjuryDTO) :  async Result.Result<(), T.Error> {
      let data_canister = actor (Environment.DATA_CANISTER_ID) : actor {
        validateSetPlayerInjury : (setPlayerInjuryDTO : DTOs.SetPlayerInjuryDTO) -> async Result.Result<(), T.Error>;
      };
      return await data_canister.validateSetPlayerInjury(setPlayerInjuryDTO);
    };

    public func validateRetirePlayer(retirePlayerDTO : DTOs.RetirePlayerDTO) :  async Result.Result<(), T.Error> {
      let data_canister = actor (Environment.DATA_CANISTER_ID) : actor {
        validateRetirePlayer : (retirePlayerDTO : DTOs.RetirePlayerDTO) -> async Result.Result<(), T.Error>;
      };
      return await data_canister.validateRetirePlayer(retirePlayerDTO);
    };

    public func validateUnretirePlayer(unretirePlayerDTO : DTOs.UnretirePlayerDTO) :  async Result.Result<(), T.Error> {
     let data_canister = actor (Environment.DATA_CANISTER_ID) : actor {
        validateUnretirePlayer : (unretirePlayerDTO : DTOs.UnretirePlayerDTO) -> async Result.Result<(), T.Error>;
      };
      return await data_canister.validateUnretirePlayer(unretirePlayerDTO);
    };


    
  };
};

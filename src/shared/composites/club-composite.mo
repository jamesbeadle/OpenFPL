import Result "mo:base/Result";
import DTOs "../../shared/DTOs";
import T "../../shared/types";
import NetworkEnvironmentVariables "../network_environment_variables";

module {

  public class ClubComposite() {

    public func getClubs() : async Result.Result<[T.Club], T.Error> {
      let data_canister = actor (NetworkEnvironmentVariables.DATA_CANISTER_ID) : actor {
        getClubs : () -> async Result.Result<[T.Club], T.Error>;
      };
      return await data_canister.getClubs();
    };

    public func getFormerClubs() : async Result.Result<[T.Club], T.Error> {
      let data_canister = actor (NetworkEnvironmentVariables.DATA_CANISTER_ID) : actor {
        getFormerClubs : () -> async Result.Result<[T.Club], T.Error>;
      };
      return await data_canister.getFormerClubs();
    };

    public func promoteFormerClub(promoteFormerClubDTO : DTOs.PromoteFormerClubDTO) : async Result.Result<(), T.Error> {
      let data_canister = actor (NetworkEnvironmentVariables.DATA_CANISTER_ID) : actor {
        promoteFormerClub : (promoteFormerClubDTO : DTOs.PromoteFormerClubDTO) -> async Result.Result<(), T.Error>;
      };
      return await data_canister.promoteFormerClub(promoteFormerClubDTO);
    };
    public func promoteNewClub(promoteNewClubDTO : DTOs.PromoteNewClubDTO) : async Result.Result<(), T.Error> {
      let data_canister = actor (NetworkEnvironmentVariables.DATA_CANISTER_ID) : actor {
        promoteNewClub : (promoteNewClubDTO : DTOs.PromoteNewClubDTO) -> async Result.Result<(), T.Error>;
      };
      return await data_canister.promoteNewClub(promoteNewClubDTO);
    };

    public func updateClub(updateClubDTO : DTOs.UpdateClubDTO) : async Result.Result<(), T.Error> {
      let data_canister = actor (NetworkEnvironmentVariables.DATA_CANISTER_ID) : actor {
        updateClub : (updateClubDTO : DTOs.UpdateClubDTO) -> async Result.Result<(), T.Error>;
      };
      return await data_canister.updateClub(updateClubDTO);
    };



    public func validatePromoteFormerClub(promoteFormerClubDTO : DTOs.PromoteFormerClubDTO) :  async Result.Result<(), T.Error> {
      let data_canister = actor (NetworkEnvironmentVariables.DATA_CANISTER_ID) : actor {
        validatePromoteFormerClub : (promoteFormerClubDTO : DTOs.PromoteFormerClubDTO) -> async Result.Result<(), T.Error>;
      };
      return await data_canister.validatePromoteFormerClub(promoteFormerClubDTO);
    };

    public func validatePromoteNewClub(promoteNewClubDTO : DTOs.PromoteNewClubDTO) :  async Result.Result<(), T.Error> {
      let data_canister = actor (NetworkEnvironmentVariables.DATA_CANISTER_ID) : actor {
        validatePromoteNewClub : (promoteNewClubDTO : DTOs.PromoteNewClubDTO) -> async Result.Result<(), T.Error>;
      };
      return await data_canister.validatePromoteNewClub(promoteNewClubDTO);
    };

    public func validateUpdateClub(updateClubDTO : DTOs.UpdateClubDTO) :  async Result.Result<(), T.Error> {
      let data_canister = actor (NetworkEnvironmentVariables.DATA_CANISTER_ID) : actor {
        validateUpdateClub : (updateClubDTO : DTOs.UpdateClubDTO) -> async Result.Result<(), T.Error>;
      };
      return await data_canister.validateUpdateClub(updateClubDTO);
    };

  };
};

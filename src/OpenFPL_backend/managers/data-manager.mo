import Result "mo:base/Result";
import FootballTypes "mo:waterway-mops/FootballTypes";

module {

  public class DataManager() {

    //TODO: John we should map all functions we allow openfpl to access from the data canister here

    public func getVerifiedPlayers(leagueId : FootballTypes.LeagueId) : async Result.Result<[DTOs.PlayerDTO], MopsEnums.Error> {
      let data_canister = actor (MopsCanisterIds.ICFC_DATA_CANISTER_ID) : actor {
        getVerifiedPlayers : (leagueId : FootballTypes.LeagueId) -> async Result.Result<[DTOs.PlayerDTO], MopsEnums.Error>;
      };
      return await data_canister.getVerifiedPlayers(leagueId);
    };

    public func getVerifiedClubs(leagueId : FootballTypes.LeagueId) : async Result.Result<[DTOs.ClubDTO], MopsEnums.Error> {
      let data_canister = actor (MopsCanisterIds.ICFC_DATA_CANISTER_ID) : actor {
        getVerifiedClubs : (leagueId : FootballTypes.LeagueId) -> async Result.Result<[DTOs.ClubDTO], MopsEnums.Error>;
      };
      return await data_canister.getVerifiedClubs(leagueId);
    };

  };

};

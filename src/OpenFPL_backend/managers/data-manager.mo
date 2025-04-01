import Result "mo:base/Result";
import FootballTypes "mo:waterway-mops/FootballTypes";
import Enums "mo:waterway-mops/Enums";
import CanisterIds "mo:waterway-mops/CanisterIds";
import DataCanister "canister:data_canister";

module {

  public class DataManager() {

    //TODO: John we should map all functions we allow openfpl to access from the data canister here

    public func getVerifiedPlayers(leagueId : FootballTypes.LeagueId) : async Result.Result<[DataCanister.PlayerDTO], Enums.Error> {
      let data_canister = actor (CanisterIds.ICFC_DATA_CANISTER_ID) : actor {
        getVerifiedPlayers : (leagueId : FootballTypes.LeagueId) -> async Result.Result<[DataCanister.PlayerDTO], Enums.Error>;
      };
      return await data_canister.getVerifiedPlayers(leagueId);
    };

    public func getVerifiedClubs(leagueId : FootballTypes.LeagueId) : async Result.Result<[DataCanister.ClubDTO], Enums.Error> {
      let data_canister = actor (CanisterIds.ICFC_DATA_CANISTER_ID) : actor {
        getVerifiedClubs : (leagueId : FootballTypes.LeagueId) -> async Result.Result<[DataCanister.ClubDTO], Enums.Error>;
      };
      return await data_canister.getVerifiedClubs(leagueId);
    };

  };

};

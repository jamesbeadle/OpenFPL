import Result "mo:base/Result";
import Enums "mo:waterway-mops/Enums";
import CanisterIds "mo:waterway-mops/CanisterIds";
import FootballIds "mo:waterway-mops/football/FootballIds";
import DataCanister "canister:data_canister";

module {

  public class DataManager() {

    //TODO: John we should map all functions we allow openfpl to access from the data canister here

    public func getVerifiedPlayers(leagueId : FootballIds.LeagueId) : async Result.Result<[DataCanister.Player], Enums.Error> {
      let data_canister = actor (CanisterIds.ICFC_DATA_CANISTER_ID) : actor {
        getVerifiedPlayers : (leagueId : FootballIds.LeagueId) -> async Result.Result<[DataCanister.Player], Enums.Error>;
      };
      return await data_canister.getVerifiedPlayers(leagueId);
    };

    public func getVerifiedClubs(leagueId : FootballIds.LeagueId) : async Result.Result<[DataCanister.Club], Enums.Error> {
      let data_canister = actor (CanisterIds.ICFC_DATA_CANISTER_ID) : actor {
        getVerifiedClubs : (leagueId : FootballIds.LeagueId) -> async Result.Result<[DataCanister.Club], Enums.Error>;
      };
      return await data_canister.getVerifiedClubs(leagueId);
    };

  };

};

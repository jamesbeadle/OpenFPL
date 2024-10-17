import FootballTypes "../shared/types/football_types";

module Environment {

  public let LEAGUE_ID: FootballTypes.LeagueId = 2;
  public let NUM_OF_TEAMS: Nat8 = 12;
  public let NUM_OF_GAMEWEEKS: Nat8 = 22;
  public let NUM_OF_MONTHS: Nat8 = 7;

//IC
  public let BACKEND_CANISTER_ID = "5bafg-ayaaa-aaaal-qmzqq-cai";
  public let FRONTEND_CANISTER_ID = "5ido2-wqaaa-aaaal-qmzra-cai";


//Local
/*
  public let BACKEND_CANISTER_ID = "by6od-j4aaa-aaaaa-qaadq-cai";
  public let FRONTEND_CANISTER_ID = "avqkn-guaaa-aaaaa-qaaea-cai";
*/

};
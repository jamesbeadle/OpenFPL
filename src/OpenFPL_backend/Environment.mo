import T "../shared/types";

module Environment {

  //IC

  public let BACKEND_CANISTER_ID = "y22zx-giaaa-aaaal-qmzpq-cai";
  public let FRONTEND_CANISTER_ID = "5gbds-naaaa-aaaal-qmzqa-cai";
  
  public let LEAGUE_ID: T.FootballLeagueId = 1;
  public let NUM_OF_TEAMS: Nat8 = 20;
  public let NUM_OF_GAMEWEEKS: Nat8 = 38;
  public let NUM_OF_MONTHS: Nat8 = 7;

  public let ADMIN_PRINCIPALS = [
    "pewqp-ppt6k-7mbxh-7lm7i-3cb53-pb3c5-pblif-ajie3-voomg-6wcwp-zae", //JB LIVE
    "lpqql-mr3t6-vrkxu-st5fk-x5kc2-ltg5j-2m5dw-zjygm-blpqx-6tymw-aqe", //KH
  ];
  
  //Local
  /*
  public let BACKEND_CANISTER_ID = "bd3sg-teaaa-aaaaa-qaaba-cai";
  public let FRONTEND_CANISTER_ID = "be2us-64aaa-aaaaa-qaabq-cai";
  */

};
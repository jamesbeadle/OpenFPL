import T "../shared/types";

module Environment {

  public let BACKEND_CANISTER_ID = "y22zx-giaaa-aaaal-qmzpq-cai";
  public let FRONTEND_CANISTER_ID = "5gbds-naaaa-aaaal-qmzqa-cai";

  public let LEAGUE_ID: T.FootballLeagueId = 1;
  public let NUM_OF_TEAMS: Nat8 = 20;
  public let NUM_OF_GAMEWEEKS: Nat8 = 38;
  public let NUM_OF_MONTHS: Nat8 = 10;

  public let ADMIN_PRINCIPALS = [
    "tdvwh-6hdzs-5cqex-7rt6i-muogk-2zyvx-n47rl-eflq6-554c6-mhkfd-jqe", //JB LOCAL
    "pewqp-ppt6k-7mbxh-7lm7i-3cb53-pb3c5-pblif-ajie3-voomg-6wcwp-zae", //JB LIVE
    "lpqql-mr3t6-vrkxu-st5fk-x5kc2-ltg5j-2m5dw-zjygm-blpqx-6tymw-aqe", //KH
    "q3rfy-wb7hh-dcmv2-j7o67-nmng4-ygcl4-iwdwh-to7es-juacv-qgxnr-kqe", //JW
    "emwdt-zxw7k-3jik5-mmop2-ettxg-yxqzk-4tmpw-gljes-jkm4h-wlbf4-oae" //TT
  ];
  
  /*
  public let BACKEND_CANISTER_ID = "bd3sg-teaaa-aaaaa-qaaba-cai";
  public let FRONTEND_CANISTER_ID = "be2us-64aaa-aaaaa-qaabq-cai";
  */

};
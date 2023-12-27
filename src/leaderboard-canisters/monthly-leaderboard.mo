import T "../OpenFPL_backend/types";

actor MonthlyLeaderboardCanister {
  //TODO: IMPLEMENT
  private stable var stable_leaderboards : [T.ClubLeaderboard] = [];

  system func preupgrade() {
  };

  system func postupgrade() {
  };
};

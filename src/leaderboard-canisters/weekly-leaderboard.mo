import T "../OpenFPL_backend/types";

actor Self {

  private stable var stable_leaderboards : [T.WeeklyLeaderboard] = [];

  system func preupgrade() {
  };

  system func postupgrade() {
  };
};

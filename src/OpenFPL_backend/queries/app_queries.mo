module AppQueries {

    public type GetRewardRates = {

    };

    public type RewardRates = {
        seasonLeaderboardRewardRate : Nat64;
        monthlyLeaderboardRewardRate : Nat64;
        weeklyLeaderboardRewardRate : Nat64;
        mostValuableTeamRewardRate : Nat64;
        highestScoringMatchRewardRate : Nat64;
        allTimeWeeklyHighScoreRewardRate : Nat64;
        allTimeMonthlyHighScoreRewardRate : Nat64;
        allTimeSeasonHighScoreRewardRate : Nat64;
    };
}
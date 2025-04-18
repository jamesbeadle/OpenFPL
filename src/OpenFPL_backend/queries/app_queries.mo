import FootballIds "mo:waterway-mops/football/FootballIds";
import FootballDefinitions "mo:waterway-mops/football/FootballDefinitions";
import DataCanister "canister:data_canister";

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
    public type GetPlayersSnapshot = {
        seasonId: FootballIds.SeasonId;
        gameweek: FootballDefinitions.GameweekNumber;
    };

    public type PlayersSnapshot = {
        players: [DataCanister.Player]
    };
}
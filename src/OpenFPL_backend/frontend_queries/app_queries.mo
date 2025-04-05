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


    public type GetWeeklyLeaderboard = {
        seasonId : FootballIds.SeasonId;
        gameweek : FootballDefinitions.GameweekNumber;
        limit : Nat;
        offset : Nat;
        searchTerm : Text;
    };

    public type WeeklyLeaderboard = {
        seasonId : FootballIds.SeasonId;
        gameweek : FootballDefinitions.GameweekNumber;
        entries : [LeaderboardEntry];
        totalEntries : Nat;
    };

    public type GetMonthlyLeaderboard = {

    };

    public type MonthlyLeaderboard = {

    };

    public type GetSeasonLeaderboard = {

    };

    public type SeasonLeaderboard = {

    };

    public type LeaderboardEntry = {
        principalId : Text;
        username: Text;
        displayName: Text;
        nationality: ?Ids.CountryId;
        profilePicture : ?Blob;
        position : Nat;
        positionText : Text;
        username : Text;
        points : Int16;
    };
}
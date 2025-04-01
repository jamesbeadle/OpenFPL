import FootballIds "mo:waterway-mops/football/FootballIds";
import FootballDefinitions "mo:waterway-mops/football/FootballDefinitions";

module LeaderboardQueries = {

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
        position : Nat;
        positionText : Text;
        username : Text;
        principalId : Text;
        points : Int16;
    };


};
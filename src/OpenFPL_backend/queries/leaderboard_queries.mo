import FootballTypes "mo:waterway-mops/FootballTypes"; // TODO Move to IDs to remove type def

module LeaderboardQueries = {

    public type GetWeeklyLeaderboard = {
        seasonId : FootballTypes.SeasonId;
        gameweek : FootballTypes.GameweekNumber;
        limit : Nat;
        offset : Nat;
        searchTerm : Text;
    };

    public type WeeklyLeaderboard = {
        seasonId : FootballTypes.SeasonId;
        gameweek : FootballTypes.GameweekNumber;
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
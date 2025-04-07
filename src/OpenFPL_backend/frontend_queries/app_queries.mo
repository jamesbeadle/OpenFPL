import FootballIds "mo:waterway-mops/football/FootballIds";
import FootballDefinitions "mo:waterway-mops/football/FootballDefinitions";
import BaseDefinitions "mo:waterway-mops/BaseDefinitions";
import Ids "mo:waterway-mops/Ids";
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
        page: Nat;
        searchTerm : Text;
    };

    public type WeeklyLeaderboard = {
        seasonId : FootballIds.SeasonId;
        gameweek : FootballDefinitions.GameweekNumber;
        entries : [WeeklyLeaderboardEntry];
        page: Nat;
        totalEntries : Nat;
        searchTerm : Text;
    };

    public type WeeklyLeaderboardEntry = {
        principalId : Text;
        username: Text;
        displayName: Text;
        nationality: ?Ids.CountryId;
        profilePicture : ?Blob;
        position : Nat;
        positionText : Text;
        points : Int16;
        prize: Nat;
    };

    public type GetMonthlyLeaderboard = {
        seasonId : FootballIds.SeasonId;
        month : BaseDefinitions.CalendarMonth;
        club: FootballIds.ClubId;
        page: Nat;
        searchTerm : Text;
    };

    public type MonthlyLeaderboard = {
        seasonId : FootballIds.SeasonId;
        month : BaseDefinitions.CalendarMonth;
        entries : [MonthlyLeaderboardEntry];
        page: Nat;
        totalEntries : Nat;
        searchTerm : Text;
    };

    public type MonthlyLeaderboardEntry = {
        principalId : Text;
        username: Text;
        displayName: Text;
        nationality: ?Ids.CountryId;
        profilePicture : ?Blob;
        position : Nat;
        positionText : Text;
        points : Int16;
        clubId: FootballIds.ClubId;
        prize: Nat;
    };

    public type GetSeasonLeaderboard = {
        seasonId : FootballIds.SeasonId;
        page: Nat;
        searchTerm : Text;
    };

    public type SeasonLeaderboard = {
        seasonId : FootballIds.SeasonId;
        entries : [SeasonLeaderboardEntry];
        page: Nat;
        totalEntries : Nat;
        searchTerm : Text;
    };

    public type SeasonLeaderboardEntry = {
        principalId : Text;
        username: Text;
        displayName: Text;
        nationality: ?Ids.CountryId;
        profilePicture : ?Blob;
        position : Nat;
        positionText : Text;
        points : Int16;
        prize: Nat;
    };
}
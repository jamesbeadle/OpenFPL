import FootballIds "mo:waterway-mops/football/FootballIds";
import FootballDefinitions "mo:waterway-mops/football/FootballDefinitions";
import Ids "mo:waterway-mops/Ids";
import PlayerQueries "mo:waterway-mops/queries/football-queries/PlayerQueries";
import FootballEnums "mo:waterway-mops/football/FootballEnums";

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
        seasonId : FootballIds.SeasonId;
        gameweek : FootballDefinitions.GameweekNumber;
    };

    public type PlayersSnapshot = {
        players : [SnapshotPlayer];
    };

    public type SnapshotPlayer = {
        id : FootballIds.PlayerId;
        position : FootballEnums.PlayerPosition;
        nationality : Ids.CountryId;
        dateOfBirth : Int;
        clubId : FootballIds.ClubId;
        valueQuarterMillions : Nat16;
    };

    public type GetAllTimeHighScores = {};

    public type AllTimeHighScores = {
        weeklyHighScore : ?HighScoreRecord;
        monthlyHighScore : ?HighScoreRecord;
        seasonHighScore : ?HighScoreRecord;
    };

    public type HighScoreRecord = {
        recordPoints : Nat16;
        recordHolderPrincipalId : Ids.PrincipalId;
        recordHolderUsername : Text;
        recordHolderProfilePicture : ?Blob;
        recordPrizePool : Nat64;
    };
};

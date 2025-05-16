import FootballIds "mo:waterway-mops/domain/football/ids";
import FootballDefinitions "mo:waterway-mops/domain/football/definitions";
import Ids "mo:waterway-mops/base/ids";
import FootballEnums "mo:waterway-mops/domain/football/enums";

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

import FootballIds "mo:waterway-mops/football/FootballIds";
import FootballDefinitions "mo:waterway-mops/football/FootballDefinitions";
import Ids "mo:waterway-mops/Ids";
import IcfcEnums "mo:waterway-mops/ICFCEnums";
import AppEnums "../enums/app_enums";

module LeaderboardQueries = {

    public type GetWeeklyLeaderboard = {
        seasonId : FootballIds.SeasonId;
        gameweek : FootballDefinitions.GameweekNumber;
        page : Nat;
        searchTerm : Text;
    };

    public type WeeklyLeaderboard = {
        seasonId : FootballIds.SeasonId;
        gameweek : FootballDefinitions.GameweekNumber;
        entries : [LeaderboardEntry];
        page : Nat;
        totalEntries : Nat;
    };

    public type LeaderboardEntry = {
        position : Nat;
        positionText : Text;
        username : Text;
        principalId : Ids.PrincipalId;
        points : Int16;
        nationalityId : ?Ids.CountryId;
        membershipLevel : IcfcEnums.MembershipType;
        bonusPlayed : ?AppEnums.BonusType;
        profilePicture : ?Blob;
        rewardAmount : ?Nat64;
    };

    public type GetMonthlyLeaderboard = {
        seasonId : FootballIds.SeasonId;
        month : FootballDefinitions.GameweekNumber;
        club : FootballIds.ClubId;
        page : Nat;
    };

    public type MonthlyLeaderboard = {
        seasonId : FootballIds.SeasonId;
        month : FootballDefinitions.GameweekNumber;
        club : FootballIds.ClubId;
        entries : [LeaderboardEntry];
        totalEntries : Nat;
    };

    public type GetSeasonLeaderboard = {
        seasonId : FootballIds.SeasonId;
        page : Nat;
    };

    public type SeasonLeaderboard = {
        seasonId : FootballIds.SeasonId;
        entries : [LeaderboardEntry];
        totalEntries : Nat;
    };

    public type GetMostValuableTeamLeaderboard = {
        seasonId : FootballIds.SeasonId;
        page : Nat;
    };

    public type MostValuableTeamLeaderboard = {
        seasonId : FootballIds.SeasonId;
        entries : [TeamValueLeaderboardEntry];
        totalEntries : Nat;
    };

    public type TeamValueLeaderboardEntry = {
        position : Nat;
        positionText : Text;
        username : Text;
        principalId : Ids.PrincipalId;
        teamValue : Nat16;
        nationalityId : ?Ids.CountryId;
        membershipLevel : IcfcEnums.MembershipType;
        bonusPlayed : ?AppEnums.BonusType;
        profilePicture : ?Blob;
        rewardAmount : ?Nat64;
    };

};

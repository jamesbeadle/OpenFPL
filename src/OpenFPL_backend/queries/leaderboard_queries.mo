import FootballIds "mo:waterway-mops/football/FootballIds";
import FootballDefinitions "mo:waterway-mops/football/FootballDefinitions";
import Ids "mo:waterway-mops/Ids";
import IcfcEnums "mo:waterway-mops/ICFCEnums";
import AppTypes "../types/app_types";
import AppEnums "../enums/app_enums";

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
        principalId : Ids.PrincipalId;
        points : Int16;
        nationalityId: ?Ids.CountryId;
        membershipLevel: IcfcEnums.MembershipType;
        bonusPlayed: ?AppEnums.BonusType;
        profilePicture: ?Blob;
        rewardAmount: ?Nat64;
    };


};
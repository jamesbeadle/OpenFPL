import FootballIds "mo:waterway-mops/football/FootballIds";
import FootballDefinitions "mo:waterway-mops/football/FootballDefinitions";
import Nat64 "mo:base/Nat64";

module MVPQueries = {

    public type GetMostValuableGameweekPlayers = {
        seasonId : FootballIds.SeasonId;
        gameweek : FootballDefinitions.GameweekNumber;
    };

    public type MostValuableGameweekPlayers = {
        seasonId : FootballIds.SeasonId;
        gameweek : FootballDefinitions.GameweekNumber;
        entries : [MostValuablePlayer];
        totalEntries : Nat;
    };

    public type MostValuablePlayer = {
        fixtureId : FootballIds.FixtureId;
        playerId: FootballIds.PlayerId;
        points: Nat16;
        selectedByCount: Nat;
        totalRewardAmount: Nat64;
        rewardPerManager: Nat64;
    };



};
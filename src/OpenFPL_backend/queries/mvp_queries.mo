import FootballIds "mo:waterway-mops/domain/football/ids";
import FootballDefinitions "mo:waterway-mops/domain/football/definitions";
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

import FootballIds "mo:waterway-mops/football/FootballIds";
import FootballDefinitions "mo:waterway-mops/football/FootballDefinitions";
import AppEnums "../enums/app_enums";
module RewardQueries {

    public type GetWeeklyRewardsLeaderboard = {
        seasonId : FootballIds.SeasonId;
        gameweek : FootballDefinitions.GameweekNumber;
    };

    public type WeeklyRewardsLeaderboard = {
        seasonId : FootballIds.SeasonId;
        gameweek : FootballDefinitions.GameweekNumber;
        entries : [RewardEntry];
    };
  
    public type RewardEntry = {
        principalId : Text;
        rewardType : AppEnums.RewardType;
        position : Nat;
        amount : Nat64;
    };
}
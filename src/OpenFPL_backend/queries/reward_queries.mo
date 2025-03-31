import FootballTypes "mo:waterway-mops/FootballTypes"; //TODO should be just the ids
import Enums "../enums/enums";
module RewardQueries {

    public type GetWeeklyRewardsLeaderboard = {
        seasonId : FootballTypes.SeasonId;
        gameweek : FootballTypes.GameweekNumber;
    };

    public type WeeklyRewardsLeaderboard = {
        seasonId : FootballTypes.SeasonId;
        gameweek : FootballTypes.GameweekNumber;
        entries : [RewardEntry];
    };
  
    public type RewardEntry = {
        principalId : Text;
        rewardType : Enums.RewardType;
        position : Nat;
        amount : Nat64;
    };
}
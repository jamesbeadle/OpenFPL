import FootballTypes "../types/football_types";
import Base "../types/base_types";
import T "../types/app_types";

module ResponseDTOs {

  public type AppStatusDTO = {
    onHold : Bool;
    version: Text;
  };

  public type WeeklyRewardsDTO = {
    seasonId : FootballTypes.SeasonId;
    gameweek : FootballTypes.GameweekNumber;
    rewards : [T.RewardEntry];
  };
};

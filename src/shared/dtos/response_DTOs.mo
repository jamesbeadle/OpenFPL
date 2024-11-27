import FootballTypes "../types/football_types";
import Base "../types/base_types";
import T "../types/app_types";

module GovernanceDTOs {

  public type SystemStateDTO = {
    calculationGameweek : FootballTypes.GameweekNumber;
    calculationMonth : Base.CalendarMonth;
    calculationSeasonId : FootballTypes.SeasonId;
    pickTeamGameweek : FootballTypes.GameweekNumber;
    pickTeamSeasonId : FootballTypes.SeasonId;
    pickTeamMonth : Base.CalendarMonth;
    transferWindowActive : Bool;
    onHold : Bool;
    seasonActive: Bool;
    version: Text;
  };

  public type WeeklyRewardsDTO = {
    seasonId : FootballTypes.SeasonId;
    gameweek : FootballTypes.GameweekNumber;
    rewards : [T.RewardEntry];
  };
};

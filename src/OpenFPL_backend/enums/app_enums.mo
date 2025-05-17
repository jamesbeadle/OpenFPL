module Enums {

  public type BonusType = {
    #GoalGetter;
    #PassMaster;
    #NoEntry;
    #TeamBoost;
    #SafeHands;
    #CaptainFantastic;
    #Prospects;
    #OneNation;
    #BraceBonus;
    #HatTrickHero;
  };

  public type RecordType = {
    #WeeklyHighScore;
    #MonthlyHighScore;
    #SeasonHighScore;
  };

  public type LeaderboardStatus = {
    #NotStarted;
    #Active;
    #Settled;
    #Void;
  };
}
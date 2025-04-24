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

  public type RewardType = {
    #SeasonLeaderboard;
    #MonthlyLeaderboard;
    #WeeklyLeaderboard;
    #MostValuableTeam;
    #HighestScoringPlayer;
    #WeeklyATHScore;
    #MonthlyATHScore;
    #SeasonATHScore;
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

  public type PaymentChoice = {
    #ICP;
    #FPL;
  };

  public type InviteStatus = {
    #Sent;
    #Accepted;
    #Rejected;
  };

  public type MembershipType = {
    #Monthly;
    #Seasonal;
    #Lifetime;
    #Founding;
    #Expired;
    #NotClaimed;
    #NotEligible;
  };
}
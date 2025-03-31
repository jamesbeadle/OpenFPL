module ICFCEnums {

  public type TimerType = {
    #LoanComplete;
    #GameweekBegin;
    #GameKickOff;
    #GameComplete;
    #InjuryExpired;
    #TransferWindow;
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

  public type SubApp = {
    #OpenFPL;
    #OpenWSL;
    #JeffBets;
    #TransferKings;
    #FootballGod;
  };

  public type ICFCLinkStatus = {
    #PendingVerification;
    #Verified;
  };
}
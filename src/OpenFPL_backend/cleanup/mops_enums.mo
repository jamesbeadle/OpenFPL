module MopsEnums {
    
  public type Error = {
    #NotFound;
    #AlreadyExists;
    #NotAuthorized;
    #NotAllowed;
    #DecodeError;
    #InvalidData;
    #SystemOnHold;
    #CanisterCreateError;
    #Not11Players;
    #DuplicatePlayerInTeam;
    #MoreThan2PlayersFromClub;
    #NumberPerPositionError;
    #SelectedCaptainNotInTeam;
    #InvalidBonuses;
    #TeamOverspend;
    #TooManyTransfers;
    #InvalidGameweek;
    #InsufficientFunds;
  };

  public type EntryRequirement = {
    #FreeEntry;
    #InviteOnly;
    #PaidEntry;
    #PaidInviteEntry;
  };

  public type EventLogEntryType = {
    #SystemCheck;
    #UnexpectedError;
    #CanisterTopup;
    #ManagerCanisterCreated;
  };

  public type CanisterType = {
    #SNS;
    #Static;
    #Dynamic;
  };
}
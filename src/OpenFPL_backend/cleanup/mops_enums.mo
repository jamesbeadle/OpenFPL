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
    #IncorrectSetup;
    #DuplicateData;
    #MaxDataExceeded;
    #InvalidProperty;
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
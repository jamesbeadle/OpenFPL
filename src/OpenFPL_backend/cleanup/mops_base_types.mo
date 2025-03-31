import MopsIds "mops_ids";
module BaseTypes {

    public type CalendarMonth = Nat8;
    public type RustResult = { #Ok : Text; #Err : Text };

    public type AppStatus = {
        onHold : Bool;
        version : Text;
    };

    public type DataHash = {
        category : Text;
        hash : Text;
    };

    public type Country = {
        id : MopsIds.CountryId;
        name : Text;
        code : Text;
    };

    public type CanisterTopup = {
        canisterId: MopsIds.CanisterId;
        topupTime: Int;
        cyclesAmount: Nat;
    };

    public type SystemLog = {
        eventId: Nat;
        eventTime: Int;
        eventType: LogEntryType;
        eventTitle: Text;
        eventDetail: Text;
    };

    public type LogEntryType = {
        #SystemCheck;
        #UnexpectedError;
        #CanisterTopup;
        #ManagerCanisterCreated;
    };

    public type Account = {
        owner : Principal;
        subaccount : Blob;
    };

    public type TimerInfo = {
        id : Int;
        triggerTime : Int;
        callbackName : Text;
    };
};
import Principal "mo:base/Principal";
module Types{
    
    public type Error = {
        #NotFound;
        #AlreadyExists;
        #NotAuthorized;
        #NotAllowed;
        #DecodeError;
    };
    
    public type Profile = {
        principalName: Text;
        displayName: Text;
        icpDepositAddress: Blob;
        fplDepositAddress: Blob;
        termsAccepted: Bool;
        profilePicture: Blob;
        favouriteTeamId: Nat16;
        membershipType: Nat8;
        createDate: Int;
        subscriptionDate: Int;
        reputation: Nat32;
    };

    public type Season = {
        id: Nat8;
        name: Text;
        gameweeks: [Gameweek]
    };

    public type Gameweek = {
        id: Nat16;
        number: Nat8;
        canisterId: Text;
    };

    public type Team = {
        id: Nat16;
        name: Text;
        players: [Player]
    };

    public type Fixture = {
        id: Nat32;
        homeTeamId: Nat16;
        awayTeamId: Nat16;
        homeGoals: Nat8;
        awayGoal: Nat8;
    };

    public type Player = {
        id: Nat16;
        firstName: Text;
        lastName: Text;
    };

    public type Account = {
        owner: Principal;
        subaccount: Blob;
    };


}

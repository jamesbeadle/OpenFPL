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
        wallet: Text;
        depositAddress: Blob;
        balance: Nat64;
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


}

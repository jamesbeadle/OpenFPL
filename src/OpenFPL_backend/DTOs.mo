import T "./types";
module DTOs {
    
    public type ProfileDTO = {
        principalName: Text;
        icpDepositAddress: Blob;
        fplDepositAddress: Blob;
        displayName: Text;
        membershipType: Nat8;
        profilePicture: Blob;
        favouriteTeamId: Nat16;
        createDate: Int;
        reputation: Nat32;
    };

    public type AccountBalanceDTO = {
        icpBalance: Nat64;
        fplBalance: Nat64;
    };

    public type PlayerRatingsDTO = {
        players: [T.Player];
        totalEntries: Nat16;
    };

    public type PlayerDTO = {
        id: Nat16;
        teamId: Nat16;
        position: Nat8; //0 = Goalkeeper //1 = Defender //2 = Midfielder //3 = Forward
        firstName: Text;
        lastName: Text;
        shirtNumber: Nat8;
        value: Float;
        dateOfBirth: Int;
        nationality: Text;
        totalPoints: Nat16;
    };
    
}

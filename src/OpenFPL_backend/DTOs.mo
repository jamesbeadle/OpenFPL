import T "./types";
import List "mo:base/List";

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

    public type PlayerScoreDTO = {
        id: Nat16;
        points: Int16;
        teamId: Nat16;
        goalsScored: Nat8;
        goalsConceded: Nat8;
        position: Nat8;
        events: List.List<T.PlayerEventData>;
    };
    
}

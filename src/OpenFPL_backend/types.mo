import Principal "mo:base/Principal";
import List "mo:base/List";
import Bool "mo:base/Bool";

module Types{
    
    public type Error = {
        #NotFound;
        #AlreadyExists;
        #NotAuthorized;
        #NotAllowed;
        #DecodeError;
        #InvalidTeamError;
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
        id: Nat16;
        name: Text;
    };

    public type Gameweek = {
        id: Nat16;
        number: Nat8;
        canisterId: Text;
    };

    public type Team = {
        id: Nat16;
        name: Text;
        friendlyName: Text;
        primaryColourHex: Text;
        secondaryColourHex: Text;
    };

    public type Fixture = {
        id: Nat32;
        seasonId: Nat16;
        gameweek: Nat8;
        kickOff: Int;
        homeTeamId: Nat16;
        awayTeamId: Nat16;
        homeGoals: Nat8;
        awayGoals: Nat8;
    };

    public type Player = {
        id: Nat16;
        teamId: Nat16;
        position: Nat8; //0 = Goalkeeper //1 = Defender //2 = Midfielder //3 = Forward
        firstName: Text;
        lastName: Text;
        shirtNumber: Nat8;
        value: Float;
        dateOfBirth: Int;
        nationality: Text;
    };

    public type Account = {
        owner: Principal;
        subaccount: Blob;
    };

    public type FantasyTeam = {
        principalId: Text;
        transfersAvailable: Nat8;
        bankBalance: Float;
        playerIds: [Nat16];
        captainId: Nat16;
        goalGetterGameweek: Nat8;
        goalGetterPlayerId: Nat16;
        passMasterGameweek: Nat8;
        passMasterPlayerId: Nat16;
        noEntryGameweek: Nat8;
        noEntryPlayerId: Nat16;
        teamBoostGameweek: Nat8;
        teamBoostTeamId: Nat16;
        safeHandsGameweek: Nat8;
        safeHandsPlayerId: Nat16;
        captainFantasticGameweek: Nat8;
        captainFantasticPlayerId: Nat16;
        braceBonusGameweek: Nat8;
        hatTrickHeroGameweek: Nat8;
    };

    public type FantasySelection = {
        principalId: Text;
        seasonId: Nat16;
        gameweekId: Nat16;
        bonusId: Nat8;
        playerIds: [Nat16];
        captainId: Nat16;
        score: Nat16;
        teamValue: Nat32;
        bankBalance: Nat32;
    };













     public type Proposal = {
        id : Nat;
        votes_no : Tokens;
        voters : List.List<Principal>;
        state : ProposalState;
        timestamp : Int;
        proposer : Principal;
        votes_yes : Tokens;
        payload : ProposalPayload;
    };

    public type ProposalPayload = {
        method : Text;
        canister_id : Principal;
        message : Blob;
    };

    public type ProposalState = {
        // A failure occurred while executing the proposal
        #failed : Text;
        // The proposal is open for voting
        #open;
        // The proposal is currently being executed
        #executing;
        // Enough "no" votes have been cast to reject the proposal, and it will not be executed
        #rejected;
        // The proposal has been successfully executed
        #succeeded;
        // Enough "yes" votes have been cast to accept the proposal, and it will soon be executed
        #accepted;
    };

    public type Tokens = { amount_e8s : Nat };


}

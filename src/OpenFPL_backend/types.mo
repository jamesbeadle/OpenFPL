import Principal "mo:base/Principal";
import List "mo:base/List";

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

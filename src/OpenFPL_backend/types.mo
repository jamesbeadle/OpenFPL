import List "mo:base/List";

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
        year: Nat16;
        gameweeks: List.List<Gameweek>;
    };

    public type Gameweek = {
        id: Nat16;
        number: Nat8;
        canisterId: Text;
        fixtures: List.List<Fixture>;
    };

    public type Team = {
        id: Nat16;
        name: Text;
        friendlyName: Text;
        primaryColourHex: Text;
        secondaryColourHex: Text;
        abbreviatedName: Text;
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
        status: Nat8; //0 = Unplayed, 1 = Active, 2 = Completed, 3 = Data Finalised
        events: List.List<PlayerEventData>;
        highestScoringPlayerId: Nat16;
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
        seasons: List.List<PlayerSeason>;
    };

    public type PlayerSeason = {
        year: Nat16;
        gameweeks: List.List<PlayerGameweek>;
    };

    public type PlayerGameweek = {
        number: Nat8;
        events: List.List<PlayerEventData>;
        points: Int16;
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

    
    public type UserFantasyTeam = {
        fantasyTeam: FantasyTeam;
        history: List.List<FantasyTeamSeason>;
    };

    public type FantasyTeamSeason = {
        seasonId: Nat16;
        totalPoints: Int16;
        gameweeks: List.List<FantasyTeamSnapshot>;
    };

    public type FantasyTeamSnapshot = {
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
        points: Int16;
    };

    public type SeasonLeaderboards = {
        seasonLeaderboard: Leaderboard;
        gameweekLeaderboards: List.List<Leaderboard>;
    };

    public type PaginatedLeaderboard = {
        seasonId: Nat16;
        gameweek: Nat8;
        entries: List.List<LeaderboardEntry>;
        totalEntries: Nat;
    };

    public type Leaderboard = {
        seasonId: Nat16;
        gameweek: Nat8;
        entries: List.List<LeaderboardEntry>;
    };

    public type LeaderboardEntry ={
        position: Int;
        positionText: Text;
        username: Text;
        principalId: Text;
        points: Int16;
    };

    public type PlayerEventData = {
        fixtureId: Nat32;
        playerId: Nat16;
        //0 = Appearance
        //1 = Goal Scored
        //2 = Goal Assisted
        //3 = Goal Conceded
        //4 = Keeper Save
        //5 = Clean Sheet
        //6 = Penalty Saved
        //7 = Penalty Missed
        //8 = Yellow Card
        //9 = Red Card
        //10 = Own Goal
        //11 = Highest Scoring Player 
        eventType: Nat8;
        eventStartMinute: Nat8; //use to record event time of all other events
        eventEndTime: Nat8; //currently only used for Appearance
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

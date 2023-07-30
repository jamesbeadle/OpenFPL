import List "mo:base/List";

module Types{
    
    public type FixtureId = Nat32;
    public type SeasonId = Nat16;
    public type GameweekNumber = Nat8;
    public type PlayerId = Nat16;
    public type TeamId = Nat16;
    
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
        favouriteTeamId: TeamId;
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
        number: GameweekNumber;
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
        seasonId: SeasonId;
        gameweek: GameweekNumber;
        kickOff: Int;
        homeTeamId: TeamId;
        awayTeamId: TeamId;
        homeGoals: Nat8;
        awayGoals: Nat8;
        status: Nat8; //0 = Unplayed, 1 = Active, 2 = Completed, 3 = Data Finalised
        events: List.List<PlayerEventData>;
        highestScoringPlayerId: Nat16;
    };

    public type Player = {
        id: PlayerId;
        teamId: TeamId;
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
        playerIds: [PlayerId];
        captainId: PlayerId;
        goalGetterGameweek: GameweekNumber;
        goalGetterPlayerId: PlayerId;
        passMasterGameweek: GameweekNumber;
        passMasterPlayerId: PlayerId;
        noEntryGameweek: GameweekNumber;
        noEntryPlayerId: PlayerId;
        teamBoostGameweek: GameweekNumber;
        teamBoostTeamId: TeamId;
        safeHandsGameweek: GameweekNumber;
        safeHandsPlayerId: PlayerId;
        captainFantasticGameweek: GameweekNumber;
        captainFantasticPlayerId: PlayerId;
        braceBonusGameweek: GameweekNumber;
        hatTrickHeroGameweek: GameweekNumber;
    };

    
    public type UserFantasyTeam = {
        fantasyTeam: FantasyTeam;
        history: List.List<FantasyTeamSeason>;
    };

    public type FantasyTeamSeason = {
        seasonId: SeasonId;
        totalPoints: Int16;
        gameweeks: List.List<FantasyTeamSnapshot>;
    };

    public type FantasyTeamSnapshot = {
        principalId: Text;
        transfersAvailable: Nat8;
        bankBalance: Float;
        playerIds: [PlayerId];
        captainId: Nat16;
        goalGetterGameweek: GameweekNumber;
        goalGetterPlayerId: PlayerId;
        passMasterGameweek: GameweekNumber;
        passMasterPlayerId: PlayerId;
        noEntryGameweek: GameweekNumber;
        noEntryPlayerId: PlayerId;
        teamBoostGameweek: GameweekNumber;
        teamBoostTeamId: TeamId;
        safeHandsGameweek: GameweekNumber;
        safeHandsPlayerId: PlayerId;
        captainFantasticGameweek: GameweekNumber;
        captainFantasticPlayerId: PlayerId;
        braceBonusGameweek: GameweekNumber;
        hatTrickHeroGameweek: GameweekNumber;
        points: Int16;
    };

    public type SeasonLeaderboards = {
        seasonLeaderboard: Leaderboard;
        gameweekLeaderboards: List.List<Leaderboard>;
    };

    public type PaginatedLeaderboard = {
        seasonId: SeasonId;
        gameweek: GameweekNumber;
        entries: List.List<LeaderboardEntry>;
        totalEntries: Nat;
    };

    public type Leaderboard = {
        seasonId: SeasonId;
        gameweek: GameweekNumber;
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
        fixtureId: FixtureId;
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

    public type DataSubmission = {
        fixtureId: FixtureId;
        proposer: Text;
        timestamp: Int;
        events: List.List<PlayerEventData>;
        votes_yes: List.List<PlayerValuationVote>;
        votes_no: List.List<PlayerValuationVote>;
    };

    public type PlayerValuationSubmission = {
        playerId: Nat16;
        gameweek: GameweekNumber;
        timestamp: Int;
        votes_up: List.List<PlayerValuationVote>;
        votes_down: List.List<PlayerValuationVote>;
    };

    public type PlayerValuationVote = {
        principalId: Text;
        votes: Tokens;
    };

    public type Tokens = { amount_e8s : Nat64 };
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

    public type ProposalState = {
        #failed : Text;
        #open;
        #executing;
        #rejected;
        #succeeded;
        #accepted;
    };

    public type ProposalPayload = {
        method : Text;
        canister_id : Principal;
        message : Blob;
    };

    public type SystemParams = {
        transfer_fee: Tokens;
        proposal_vote_threshold: Tokens;
        proposal_submission_deposit: Tokens;
    };

    public type ConsensusData = {
        fixtureId: FixtureId;
        events: List.List<PlayerEventData>;
        totalVotes: Tokens;
    };

}

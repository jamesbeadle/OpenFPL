import List "mo:base/List";

module Types{
    
    public type FixtureId = Nat32;
    public type SeasonId = Nat16;
    public type GameweekNumber = Nat8;
    public type PlayerId = Nat16;
    public type TeamId = Nat16;
    public type ProposalId = Nat;
    
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
        postponedFixtures: List.List<Fixture>;
    };

    public type Gameweek = {
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
        value: Nat; //Value in £0.25m units
        dateOfBirth: Int;
        nationality: Text;
        seasons: List.List<PlayerSeason>;
        valueHistory: List.List<ValueHistory>;
        onLoan: Bool;
        parentTeamId: Nat16;
        isInjured: Bool;
        injuryHistory: List.List<InjuryHistory>;
        retirementDate: Int;
    };

    public type ValueHistory = {
        seasonId: Nat16;
        gameweek: Nat8;
        oldValue: Float;
        newValue: Float;
    };

    public type InjuryHistory = {
        description: Text;
        expectedEndDate: Int;
    };

    public type PlayerSeason = {
        id: Nat16;
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
        gameweek: GameweekNumber;
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
        entries: [LeaderboardEntry];
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
        //3 = Goal Conceded - Inferred
        //4 = Keeper Save
        //5 = Clean Sheet - Inferred
        //6 = Penalty Saved
        //7 = Penalty Missed
        //8 = Yellow Card
        //9 = Red Card
        //10 = Own Goal
        //11 = Highest Scoring Player 
        eventType: Nat8;
        eventStartMinute: Nat8; //use to record event time of all other events
        eventEndMinute: Nat8; //currently only used for Appearance
        teamId: TeamId;
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
        principalId: Principal;
        votes: Tokens;
    };

    public type Tokens = { amount_e8s : Nat64 };
    public type Proposal = {
        id : Nat;
        votes_no : List.List<PlayerValuationVote>;
        voters : List.List<Principal>;
        state : ProposalState;
        timestamp : Int;
        proposer : Principal;
        votes_yes : List.List<PlayerValuationVote>;
        payload : ProposalPayload;
        proposalType: ProposalType;
        data: PayloadData;
    };

    public type PayloadData = {
        #AddInitialFixtures : AddInitialFixturesPayload;
        #RescheduleFixture : RescheduleFixturePayload;
        #TransferPlayer : TransferPlayerPayload;
        #LoanPlayer : LoanPlayerPayload;
        #RecallPlayer : RecallPlayerPayload;
        #CreatePlayer : CreatePlayerPayload;
        #UpdatePlayer : UpdatePlayerPayload;
        #SetPlayerInjury : SetPlayerInjuryPayload;
        #RetirePlayer : RetirePlayerPayload;
        #UnretirePlayer : UnretirePlayerPayload;
        #PromoteTeam : PromoteTeamPayload;
        #RelegateTeam : RelegateTeamPayload;
        #UpdateTeam : UpdateTeamPayload;
        #UpdateSystemParameters : UpdateSystemParametersPayload;
    };

    public type AddInitialFixturesPayload = {
        seasonId: SeasonId;
        fixtures: [Fixture];
    };

    public type RescheduleFixturePayload = {
        seasonId: SeasonId;
        fixtureId: FixtureId;
        oldGameweek: GameweekNumber;
        newGameweek: GameweekNumber;
        newKickOffTime: Int;
    };

    public type TransferPlayerPayload = {
        playerId: PlayerId;
        newTeamId: TeamId;
    };

    public type LoanPlayerPayload = {
        playerId: PlayerId;
        loanTeamId: TeamId;
        loanEndDate: Int;
    };

    public type RecallPlayerPayload = {
        playerId: PlayerId;
    };

    public type CreatePlayerPayload = {
        teamId: TeamId;
        position: Nat8;
        firstName: Text;
        lastName: Text;
        shirtNumber: Nat8;
        value: Nat;
        dateOfBirth: Int;
        nationality: Text;
    };

    public type UpdatePlayerPayload = {
        playerId: PlayerId;
        teamId: TeamId;
        position: Nat8;
        firstName: Text;
        lastName: Text;
        shirtNumber: Nat8;
        dateOfBirth: Int;
        nationality: Text;
    };

    public type SetPlayerInjuryPayload = {
        playerId: PlayerId;
        injuryDescription: Text;
        expectedEndDate: Int;
        recovered: Bool;
    };

    public type RetirePlayerPayload = {
        playerId: PlayerId;
        retirementDate: Int;
    };

    public type UnretirePlayerPayload = {
        playerId: PlayerId;
    };

    public type PromoteTeamPayload = {
        teamId: TeamId;
        name: Text;
        friendlyName: Text;
        primaryColourHex: Text;
        secondaryColourHex: Text;
        abbreviatedName: Text;
    };

    public type RelegateTeamPayload = {
        teamId: TeamId;
    };

    public type UpdateTeamPayload = {
        teamId: TeamId;
        name: Text;
        friendlyName: Text;
        primaryColourHex: Text;
        secondaryColourHex: Text;
        abbreviatedName: Text;
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
    
    public type UpdateFlag = {
        #EventData_VotePeriod;
        #EventData_VoteThreshold;
        #Revaluation_VoteThreshold;
        #Proposal_VoteThreshold;
        #Max_Votes_Per_User;
        #Proposal_Submission_e8_Fee;
    };

    public type UpdateSystemParametersPayload = {
        flag: UpdateFlag;
        event_data_voting_period: ?Int;
        event_data_vote_threshold: ?Nat64;
        revalution_vote_threshold: ?Nat64;
        proposal_vote_threshold: ?Nat64;
        max_votes_per_user: ?Nat64;
        proposal_submission_e8_fee: ?Nat64;
    };

    public type ConsensusData = {
        fixtureId: FixtureId;
        events: List.List<PlayerEventData>;
        totalVotes: Tokens;
    };

    public type VoteChoice = {
        #Yes;
        #No;
    };

    public type ProposalType = {
        #AddInitialFixtures;
        #RescheduleFixture;
        #TransferPlayer;
        #LoanPlayer;
        #RecallPlayer;
        #CreatePlayer;
        #UpdatePlayer;
        #SetPlayerInjury;
        #RetirePlayer;
        #UnretirePlayer;
        #PromoteTeam;
        #RelegateTeam;
        #UpdateTeam;
        #UpdateSystemParameters;
    };

    public type RevaluedPlayer = {
        playerId: PlayerId; 
        direction: RevaluationDirection;
    };

    public type RevaluationDirection = {
        #Increase;
        #Decrease;
    };

    public type TimerInfo = {
        id: Int;
        triggerTime: Int;
        callbackName: Text;
        playerId: PlayerId;
        fixtureId: FixtureId;
    };

    public type ProposalTimer = {
        timerInfo: TimerInfo;
    };

    public type LoanTimer = {
        timerInfo: TimerInfo;
        playerId: Nat16;
        expires: Int;
    };



}

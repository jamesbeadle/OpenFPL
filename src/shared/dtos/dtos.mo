import FootballTypes "mo:waterway-mops/FootballTypes";
import Base "mo:waterway-mops/BaseTypes";

module DTOs {

    public type SeasonDTO = {
        id : FootballTypes.SeasonId;
        name : Text;
        year : Nat16;
    };

    public type FixtureDTO = {
        id : Nat32;
        seasonId : FootballTypes.SeasonId;
        gameweek : FootballTypes.GameweekNumber;
        kickOff : Int;
        homeClubId : FootballTypes.ClubId;
        awayClubId : FootballTypes.ClubId;
        homeGoals : Nat8;
        awayGoals : Nat8;
        status : FootballTypes.FixtureStatusType;
        highestScoringPlayerId : Nat16;
        events : [FootballTypes.PlayerEventData];
    };

    public type ManagerDTO = {
        principalId : Text;
        username : Text;
        profilePicture : ?Blob;
        profilePictureType : Text;
        favouriteClubId : ?FootballTypes.ClubId;
        createDate : Int;
        gameweeks : [ManagerGameweekDTO];
        weeklyPosition : Int;
        monthlyPosition : Int;
        seasonPosition : Int;
        weeklyPositionText : Text;
        monthlyPositionText : Text;
        seasonPositionText : Text;
        weeklyPoints : Int16;
        monthlyPoints : Int16;
        seasonPoints : Int16;
    };

    public type ManagerGameweekDTO = {
        principalId : Text;
        username : Text;
        favouriteClubId : ?FootballTypes.ClubId;
        monthlyBonusesAvailable : Nat8;
        transfersAvailable : Nat8;
        bankQuarterMillions : Nat16;
        teamValueQuarterMillions : Nat16;
        playerIds : [FootballTypes.PlayerId];
        captainId : FootballTypes.PlayerId;
        gameweek : FootballTypes.GameweekNumber;
        goalGetterGameweek : FootballTypes.GameweekNumber;
        goalGetterPlayerId : FootballTypes.PlayerId;
        passMasterGameweek : FootballTypes.GameweekNumber;
        passMasterPlayerId : FootballTypes.PlayerId;
        noEntryGameweek : FootballTypes.GameweekNumber;
        noEntryPlayerId : FootballTypes.PlayerId;
        teamBoostGameweek : FootballTypes.GameweekNumber;
        teamBoostClubId : FootballTypes.ClubId;
        safeHandsGameweek : FootballTypes.GameweekNumber;
        safeHandsPlayerId : FootballTypes.PlayerId;
        captainFantasticGameweek : FootballTypes.GameweekNumber;
        captainFantasticPlayerId : FootballTypes.PlayerId;
        oneNationGameweek : FootballTypes.GameweekNumber;
        oneNationCountryId : Base.CountryId;
        prospectsGameweek : FootballTypes.GameweekNumber;
        braceBonusGameweek : FootballTypes.GameweekNumber;
        hatTrickHeroGameweek : FootballTypes.GameweekNumber;
        points : Int16;
        monthlyPoints : Int16;
        seasonPoints : Int16;
        transferWindowGameweek : FootballTypes.GameweekNumber;
        month : Base.CalendarMonth;
        seasonId : FootballTypes.SeasonId;
    };

    public type ProfileDTO = {
        principalId : Text;
        username : Text;
        termsAccepted : Bool;
        profilePicture : ?Blob;
        profilePictureType : Text;
        favouriteClubId : ?FootballTypes.ClubId;
        createDate : Int;
    };

    public type PlayerDTO = {
        id : Nat16;
        clubId : FootballTypes.ClubId;
        position : FootballTypes.PlayerPosition;
        firstName : Text;
        lastName : Text;
        shirtNumber : Nat8;
        valueQuarterMillions : Nat16;
        dateOfBirth : Int;
        nationality : Base.CountryId;
        status : FootballTypes.PlayerStatus;
        leagueId : FootballTypes.LeagueId;
        parentLeagueId : FootballTypes.LeagueId;
        parentClubId : FootballTypes.ClubId;
        currentLoanEndDate : Int;
    };

    public type PlayerDetailDTO = {
        id : FootballTypes.PlayerId;
        clubId : FootballTypes.ClubId;
        position : FootballTypes.PlayerPosition;
        firstName : Text;
        lastName : Text;
        shirtNumber : Nat8;
        valueQuarterMillions : Nat16;
        dateOfBirth : Int;
        nationality : Base.CountryId;
        seasonId : FootballTypes.SeasonId;
        gameweeks : [PlayerGameweekDTO];
        valueHistory : [FootballTypes.ValueHistory];
        status : FootballTypes.PlayerStatus;
        parentClubId : FootballTypes.ClubId;
        latestInjuryEndDate : Int;
        injuryHistory : [FootballTypes.InjuryHistory];
        retirementDate : Int;
    };

    public type PlayerGameweekDTO = {
        number : Nat8;
        events : [FootballTypes.PlayerEventData];
        points : Int16;
        fixtureId : FootballTypes.FixtureId;
    };

    public type ClubDTO = {
        id : FootballTypes.ClubId;
        name : Text;
        friendlyName : Text;
        primaryColourHex : Text;
        secondaryColourHex : Text;
        thirdColourHex : Text;
        abbreviatedName : Text;
        shirtType : FootballTypes.ShirtType;
    };

    public type PlayerScoreDTO = {
        id : Nat16;
        points : Int16;
        clubId : FootballTypes.ClubId;
        goalsScored : Int16;
        goalsConceded : Int16;
        position : FootballTypes.PlayerPosition;
        nationality : Base.CountryId;
        dateOfBirth : Int;
        saves : Int16;
        assists : Int16;
        events : [FootballTypes.PlayerEventData];
    };

    public type WeeklyLeaderboardDTO = {
        seasonId : FootballTypes.SeasonId;
        gameweek : FootballTypes.GameweekNumber;
        entries : [LeaderboardEntryDTO];
        totalEntries : Nat;
    };

    public type LeaderboardEntryDTO = {
        position : Nat;
        positionText : Text;
        username : Text;
        principalId : Text;
        points : Int16;
    };

    public type DataHashDTO = {
        category : Text;
        hash : Text;
    };

    public type AppStatusDTO = {
        onHold : Bool;
        version : Text;
    };

    public type PlayerPointsDTO = {
        id : Nat16;
        gameweek : FootballTypes.GameweekNumber;
        points : Int16;
        clubId : FootballTypes.ClubId;
        position : FootballTypes.PlayerPosition;
        events : [FootballTypes.PlayerEventData];
    };

    public type CountryDTO = {
        id : Base.CountryId;
        name : Text;
        code : Text;
    };

    public type RewardRatesDTO = {
        seasonLeaderboardRewardRate : Nat64;
        monthlyLeaderboardRewardRate : Nat64;
        weeklyLeaderboardRewardRate : Nat64;
        mostValuableTeamRewardRate : Nat64;
        highestScoringMatchRewardRate : Nat64;
        allTimeWeeklyHighScoreRewardRate : Nat64;
        allTimeMonthlyHighScoreRewardRate : Nat64;
        allTimeSeasonHighScoreRewardRate : Nat64;
    };

};

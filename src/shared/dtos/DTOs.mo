
import FootballTypes "../types/football_types";
import Base "../types/base_types";

module DTOs {

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
        seasonId: FootballTypes.SeasonId;
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
        leagueId: FootballTypes.LeagueId;
        parentLeagueId: FootballTypes.LeagueId;
        parentClubId: FootballTypes.ClubId;
        currentLoanEndDate: Int;
    };


};

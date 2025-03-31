import FootballTypes "mo:waterway-mops/FootballTypes"; //TODO replace with ID link
import BaseTypes "mo:waterway-mops/BaseTypes";
import Enums "../enums/enums";
import MopsIds "../cleanup/mops_ids";

module UserQueries = {

    public type GetProfile = {
        principalId : MopsIds.PrincipalId;
    };

    public type Profile = {
        principalId : MopsIds.PrincipalId;
        username : Text;
        termsAccepted : Bool;
        profilePicture : ?Blob;
        profilePictureType : Text;
        favouriteClubId : ?FootballTypes.ClubId;
        createDate : Int;
    };

    public type GetICFCProfile = {};
    
    public type ICFCProfile = {
        principalId : MopsIds.PrincipalId;
        username : Text;
        displayName : Text;
        membershipType : Enums.MembershipType;
        membershipClaims : [MembershipClaim];
        createdOn : Int;
        profilePicture : ?Blob;
        termsAgreed : Bool;
        membershipExpiryTime : Int;
        favouriteLeagueId : ?FootballTypes.LeagueId;
        favouriteClubId : ?FootballTypes.ClubId;
        nationalityId : ?MopsIds.CountryId;
    };

    public type MembershipClaim = {
        membershipType : Enums.MembershipType;
        claimedOn : Int;
        expiresOn : ?Int;
    };

    public type GetManager = {
        principalId : Text;
    };

    public type Manager = {
        principalId : MopsIds.PrincipalId;
        username : Text;
        profilePicture : ?Blob;
        profilePictureType : Text;
        favouriteClubId : ?FootballTypes.ClubId;
        createDate : Int;
        gameweeks : [Gameweek];
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

    public type Gameweek = {
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
        oneNationCountryId : MopsIds.CountryId;
        prospectsGameweek : FootballTypes.GameweekNumber;
        braceBonusGameweek : FootballTypes.GameweekNumber;
        hatTrickHeroGameweek : FootballTypes.GameweekNumber;
        points : Int16;
        monthlyPoints : Int16;
        seasonPoints : Int16;
        transferWindowGameweek : FootballTypes.GameweekNumber;
        month : BaseTypes.CalendarMonth;
        seasonId : FootballTypes.SeasonId;
    };

    public type GetTeamSetup = {};

    public type TeamSetup = {
        principalId : Text;
        username : Text;
        transfersAvailable : Nat8;
        monthlyBonusesAvailable : Nat8;
        bankQuarterMillions : Nat16;
        playerIds : [FootballTypes.ClubId];
        captainId : FootballTypes.ClubId;
        goalGetterGameweek : FootballTypes.GameweekNumber;
        goalGetterPlayerId : FootballTypes.ClubId;
        passMasterGameweek : FootballTypes.GameweekNumber;
        passMasterPlayerId : FootballTypes.ClubId;
        noEntryGameweek : FootballTypes.GameweekNumber;
        noEntryPlayerId : FootballTypes.ClubId;
        teamBoostGameweek : FootballTypes.GameweekNumber;
        teamBoostClubId : FootballTypes.ClubId;
        safeHandsGameweek : FootballTypes.GameweekNumber;
        safeHandsPlayerId : FootballTypes.ClubId;
        captainFantasticGameweek : FootballTypes.GameweekNumber;
        captainFantasticPlayerId : FootballTypes.ClubId;
        oneNationGameweek : FootballTypes.GameweekNumber;
        oneNationCountryId : MopsIds.CountryId;
        prospectsGameweek : FootballTypes.GameweekNumber;
        braceBonusGameweek : FootballTypes.GameweekNumber;
        hatTrickHeroGameweek : FootballTypes.GameweekNumber;
        transferWindowGameweek : FootballTypes.GameweekNumber;
        canisterId : MopsIds.CanisterId;
        firstGameweek : Bool;
    };

    public type GetFantasyTeamSnapshot = {
        principalId : MopsIds.PrincipalId;
    };

    public type FantasyTeamSnapshot = {
        principalId : MopsIds.PrincipalId;
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
        oneNationCountryId : BaseTypes.CountryId;
        prospectsGameweek : FootballTypes.GameweekNumber;
        braceBonusGameweek : FootballTypes.GameweekNumber;
        hatTrickHeroGameweek : FootballTypes.GameweekNumber;
        points : Int16;
        monthlyPoints : Int16;
        seasonPoints : Int16;
        transferWindowGameweek : FootballTypes.GameweekNumber;
        month : BaseTypes.CalendarMonth;
        seasonId : FootballTypes.SeasonId;
    };
};
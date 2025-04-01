import Ids "mo:waterway-mops/Ids";
import FootballIds "mo:waterway-mops/football/FootballIds";
import FootballDefinitions "mo:waterway-mops/football/FootballDefinitions";
import BaseDefinitions "mo:waterway-mops/BaseDefinitions";
import Enums "../enums/enums";
import ICFCEnums "mo:waterway-mops/ICFCEnums";

module UserQueries = {

    public type GetProfile = {
        principalId : Ids.PrincipalId;
    };

    public type Profile = {
        principalId : Ids.PrincipalId;
        username : Text;
        termsAccepted : Bool;
        profilePicture : ?Blob;
        profilePictureType : Text;
        favouriteClubId : ?FootballIds.ClubId;
        createDate : Int;
    };

    public type GetICFCProfile = {
        principalId : Ids.PrincipalId;
    };
    public type GetICFCMembership = {
        principalId : Ids.PrincipalId;
    };

    public type ICFCProfile = {
        principalId : Ids.PrincipalId;
        username : Text;
        displayName : Text;
        membershipType : Enums.MembershipType;
        membershipClaims : [MembershipClaim];
        createdOn : Int;
        profilePicture : ?Blob;
        termsAgreed : Bool;
        membershipExpiryTime : Int;
        favouriteLeagueId : ?FootballIds.LeagueId;
        favouriteClubId : ?FootballIds.ClubId;
        nationalityId : ?Ids.CountryId;
    };

    public type ICFCLink = {
        membershipType : Enums.MembershipType;
        principalId : Ids.PrincipalId;
        linkStatus : ICFCEnums.ICFCLinkStatus;
        dataHash : Text;
    };

    public type MembershipClaim = {
        membershipType : Enums.MembershipType;
        claimedOn : Int;
        expiresOn : ?Int;
    };

    public type GetManager = {
        principalId : Text;
    };

    public type GetManagerByUsername = {
        username : Text;
    };

    public type Manager = {
        principalId : Ids.PrincipalId;
        username : Text;
        profilePicture : ?Blob;
        profilePictureType : Text;
        favouriteClubId : ?FootballIds.ClubId;
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
        favouriteClubId : ?FootballIds.ClubId;
        monthlyBonusesAvailable : Nat8;
        transfersAvailable : Nat8;
        bankQuarterMillions : Nat16;
        teamValueQuarterMillions : Nat16;
        playerIds : [FootballIds.PlayerId];
        captainId : FootballIds.PlayerId;
        gameweek : FootballDefinitions.GameweekNumber;
        goalGetterGameweek : FootballDefinitions.GameweekNumber;
        goalGetterPlayerId : FootballIds.PlayerId;
        passMasterGameweek : FootballDefinitions.GameweekNumber;
        passMasterPlayerId : FootballIds.PlayerId;
        noEntryGameweek : FootballDefinitions.GameweekNumber;
        noEntryPlayerId : FootballIds.PlayerId;
        teamBoostGameweek : FootballDefinitions.GameweekNumber;
        teamBoostClubId : FootballIds.ClubId;
        safeHandsGameweek : FootballDefinitions.GameweekNumber;
        safeHandsPlayerId : FootballIds.PlayerId;
        captainFantasticGameweek : FootballDefinitions.GameweekNumber;
        captainFantasticPlayerId : FootballIds.PlayerId;
        oneNationGameweek : FootballDefinitions.GameweekNumber;
        oneNationCountryId : Ids.CountryId;
        prospectsGameweek : FootballDefinitions.GameweekNumber;
        braceBonusGameweek : FootballDefinitions.GameweekNumber;
        hatTrickHeroGameweek : FootballDefinitions.GameweekNumber;
        points : Int16;
        monthlyPoints : Int16;
        seasonPoints : Int16;
        transferWindowGameweek : FootballDefinitions.GameweekNumber;
        month : BaseDefinitions.CalendarMonth;
        seasonId : FootballIds.SeasonId;
    };

    public type GetTeamSetup = {
        principalId : Text;
    };

    public type TeamSetup = {
        principalId : Text;
        username : Text;
        transfersAvailable : Nat8;
        monthlyBonusesAvailable : Nat8;
        bankQuarterMillions : Nat16;
        playerIds : [FootballIds.ClubId];
        captainId : FootballIds.ClubId;
        goalGetterGameweek : FootballDefinitions.GameweekNumber;
        goalGetterPlayerId : FootballIds.ClubId;
        passMasterGameweek : FootballDefinitions.GameweekNumber;
        passMasterPlayerId : FootballIds.ClubId;
        noEntryGameweek : FootballDefinitions.GameweekNumber;
        noEntryPlayerId : FootballIds.ClubId;
        teamBoostGameweek : FootballDefinitions.GameweekNumber;
        teamBoostClubId : FootballIds.ClubId;
        safeHandsGameweek : FootballDefinitions.GameweekNumber;
        safeHandsPlayerId : FootballIds.ClubId;
        captainFantasticGameweek : FootballDefinitions.GameweekNumber;
        captainFantasticPlayerId : FootballIds.ClubId;
        oneNationGameweek : FootballDefinitions.GameweekNumber;
        oneNationCountryId : Ids.CountryId;
        prospectsGameweek : FootballDefinitions.GameweekNumber;
        braceBonusGameweek : FootballDefinitions.GameweekNumber;
        hatTrickHeroGameweek : FootballDefinitions.GameweekNumber;
        transferWindowGameweek : FootballDefinitions.GameweekNumber;
        canisterId : Ids.CanisterId;
        firstGameweek : Bool;
    };

    public type GetFantasyTeamSnapshot = {
        principalId : Ids.PrincipalId;
        seasonId : FootballIds.SeasonId;
        gameweek : FootballDefinitions.GameweekNumber;
    };

    public type FantasyTeamSnapshot = {
        principalId : Ids.PrincipalId;
        username : Text;
        favouriteClubId : ?FootballIds.ClubId;
        monthlyBonusesAvailable : Nat8;
        transfersAvailable : Nat8;
        bankQuarterMillions : Nat16;
        teamValueQuarterMillions : Nat16;
        playerIds : [FootballIds.PlayerId];
        captainId : FootballIds.PlayerId;
        gameweek : FootballDefinitions.GameweekNumber;
        goalGetterGameweek : FootballDefinitions.GameweekNumber;
        goalGetterPlayerId : FootballIds.PlayerId;
        passMasterGameweek : FootballDefinitions.GameweekNumber;
        passMasterPlayerId : FootballIds.PlayerId;
        noEntryGameweek : FootballDefinitions.GameweekNumber;
        noEntryPlayerId : FootballIds.PlayerId;
        teamBoostGameweek : FootballDefinitions.GameweekNumber;
        teamBoostClubId : FootballIds.ClubId;
        safeHandsGameweek : FootballDefinitions.GameweekNumber;
        safeHandsPlayerId : FootballIds.PlayerId;
        captainFantasticGameweek : FootballDefinitions.GameweekNumber;
        captainFantasticPlayerId : FootballIds.PlayerId;
        oneNationGameweek : FootballDefinitions.GameweekNumber;
        oneNationCountryId : Ids.CountryId;
        prospectsGameweek : FootballDefinitions.GameweekNumber;
        braceBonusGameweek : FootballDefinitions.GameweekNumber;
        hatTrickHeroGameweek : FootballDefinitions.GameweekNumber;
        points : Int16;
        monthlyPoints : Int16;
        seasonPoints : Int16;
        transferWindowGameweek : FootballDefinitions.GameweekNumber;
        month : BaseDefinitions.CalendarMonth;
        seasonId : FootballIds.SeasonId;
    };
};

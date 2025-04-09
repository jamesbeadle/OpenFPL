import Ids "mo:waterway-mops/Ids";
import FootballIds "mo:waterway-mops/football/FootballIds";
import AppEnums "../enums/app_enums";

module UserCommands = {

    public type LinkICFCProfile = {
        principalId : Ids.PrincipalId;
        icfcPrincipalId : Ids.PrincipalId;
        favouriteClubId : FootballIds.ClubId;
        icfcMembershipType : AppEnums.MembershipType;
    };

    public type SetFavouriteClub = {
        principalId : Ids.PrincipalId;
        favouriteClubId : FootballIds.ClubId;
    };

    public type SaveFantasyTeam = {
        principalId : Ids.PrincipalId;
        playerIds : [FootballIds.PlayerId];
        captainId : FootballIds.ClubId;
        playTransferWindowBonus : Bool;
    };

    public type PlayBonus = {
        principalId : Ids.PrincipalId;
        bonusType : AppEnums.BonusType;
        playerId : FootballIds.PlayerId;
        clubId : FootballIds.ClubId;
        countryId : Ids.CountryId;
    };

    public type MembershipClaim = {
        membershipType : AppEnums.MembershipType;
        purchasedOn : Int;
        expiresOn : ?Int;
    };

    public type ICFCProfile = {
        principalId : Ids.PrincipalId;
        username : Text;
        displayName : Text;
        membershipType : AppEnums.MembershipType;
        membershipClaims : [MembershipClaim];
        createdOn : Int;
        profilePicture : ?Blob;
        termsAgreed : Bool;
        membershipExpiryTime : Int;
        favouriteLeagueId : ?FootballIds.LeagueId;
        favouriteClubId : ?FootballIds.ClubId;
        nationalityId : ?Ids.CountryId;
    };

};

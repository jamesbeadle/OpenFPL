import FootballIds "mo:waterway-mops/football/FootballIds";
import Enums "../enums/enums";
import Ids "mo:waterway-mops/Ids";

module UserCommands = {

    public type LinkICFCProfile = {
        icfcPrincipalId : Ids.PrincipalId;
        favouriteClubId : FootballIds.ClubId;
        icfcMembershipType : Enums.MembershipType;
    };

    public type SetFavouriteClub = {
        favouriteClubId : FootballIds.ClubId;
    };

    public type SaveFantasyTeam = {
        playerIds : [FootballIds.PlayerId];
        captainId : FootballIds.ClubId;
        playTransferWindowBonus : Bool;
    };

    public type PlayBonus = {
        bonusType : Enums.BonusType;
        playerId : FootballIds.PlayerId;
        clubId : FootballIds.ClubId;
        countryId : Ids.CountryId;
    };

    public type MembershipClaim = {
        membershipType : Enums.MembershipType;
        claimedOn : Int;
        expiresOn : ?Int;
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

};

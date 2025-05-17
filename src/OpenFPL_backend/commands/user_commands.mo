import Ids "mo:waterway-mops/base/ids";
import FootballIds "mo:waterway-mops/domain/football/ids";
import IcfcEnums "mo:waterway-mops/product/icfc/enums";
import AppEnums "../enums/app_enums";

module UserCommands = {

    public type LinkICFCProfile = {
        principalId : Ids.PrincipalId;
        icfcPrincipalId : Ids.PrincipalId;
        favouriteClubId : FootballIds.ClubId;
        icfcSubscriptionType : IcfcEnums.SubscriptionType;
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

};

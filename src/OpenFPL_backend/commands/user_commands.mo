
import Ids "mo:waterway-mops/Ids";
import FootballIds "mo:waterway-mops/football/FootballIds";
import Enums "../enums/enums";
import ICFCEnums "mo:waterway-mops/ICFCEnums";

module UserCommands = {

    public type LinkICFCProfile = {
        principalId: Ids.PrincipalId;
        icfcPrincipalId: Ids.PrincipalId;
        favouriteClubId: FootballIds.ClubId;
        icfcMembershipType: Enums.MembershipType;
    };

    public type SetFavouriteClub = {
        principalId: Ids.PrincipalId;
        favouriteClubId: FootballIds.ClubId;
    };

    public type SaveFantasyTeam = {
        principalId: Ids.PrincipalId;
        playerIds : [FootballIds.PlayerId];
        captainId : FootballIds.ClubId;
        playTransferWindowBonus: Bool;
    };

    public type PlayBonus = {
        principalId: Ids.PrincipalId;
        bonusType: Enums.BonusType;
        playerId: FootballIds.PlayerId;
        clubId: FootballIds.ClubId;
        countryId: Ids.CountryId;
    };


};
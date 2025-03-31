import FootballTypes "mo:waterway-mops/FootballTypes";
import Enums "../enums/enums";
import MopsIds "../cleanup/mops_ids";

module UserCommands = {

    public type LinkICFCProfile = {
        principalId: MopsIds.PrincipalId;
        openFPLPrincipalId: MopsIds.PrincipalId;
        icfcPrincipalId: MopsIds.PrincipalId;
        favouriteClubId: FootballTypes.ClubId;
    };

    public type SetFavouriteClub = {
        principalId: MopsIds.PrincipalId;
        favouriteClubId: FootballTypes.ClubId;
    };

    public type SaveFantasyTeam = {
        principalId: MopsIds.PrincipalId;
        playerIds : [FootballTypes.PlayerId];
        captainId : FootballTypes.ClubId;
        playTransferWindowBonus: Bool;
    };

    public type PlayBonus = {
        principalId: MopsIds.PrincipalId;
        bonusType: Enums.BonusType;
    };


};
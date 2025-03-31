import FootballTypes "mo:waterway-mops/FootballTypes";
import Ids "mo:waterway-mops/Ids";
import Enums "../enums/enums";

module UserCommands = {

    public type LinkICFCProfile = {
        principalId: Ids.PrincipalId;
        openFPLPrincipalId: Ids.PrincipalId;
        icfcPrincipalId: Ids.PrincipalId;
        favouriteClubId: FootballTypes.ClubId;
    };

    public type SetFavouriteClub = {
        principalId: Ids.PrincipalId;
        favouriteClubId: FootballTypes.ClubId;
    };

    public type SaveFantasyTeam = {
        principalId: Ids.PrincipalId;
        playerIds : [FootballTypes.PlayerId];
        captainId : FootballTypes.ClubId;
        playTransferWindowBonus: Bool;
    };

    public type PlayBonus = {
        principalId: Ids.PrincipalId;
        bonusType: Enums.BonusType;
    };


};
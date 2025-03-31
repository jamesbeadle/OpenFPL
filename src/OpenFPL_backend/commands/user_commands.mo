import FootballTypes "mo:waterway-mops/FootballTypes";
import Enums "../enums/enums";
import MopsIds "../cleanup/mops_ids";

module UserCommands = {

    public type CreateManager = {
        username : Text;
        favouriteClubId : ?FootballTypes.ClubId;
    };

    public type LinkICFCProfile = {
        principalId: MopsIds.PrincipalId;
        openFPLPrincipalId: MopsIds.PrincipalId;
        icfcPrincipalId: MopsIds.PrincipalId;
    };

    public type SetUsername = {
        principalId: MopsIds.PrincipalId;
        username: Text;
    };

    public type SetProfilePicture = {
        principalId: MopsIds.PrincipalId;
        profilePicture: Blob;
        extension: Text;
    };

    public type SetFavouriteClub = {
        principalId: MopsIds.PrincipalId;
        clubId: FootballTypes.ClubId;
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
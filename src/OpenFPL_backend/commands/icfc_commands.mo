import ICFCEnums "mo:waterway-mops/product/icfc/enums";
import Ids "mo:waterway-mops/base/ids";

module {
    public type NotifyAppofLink = {
        membershipType : ICFCEnums.MembershipType;
        subAppUserPrincipalId : Ids.PrincipalId;
        subApp : ICFCEnums.SubApp;
        icfcPrincipalId : Ids.PrincipalId;
    };

    public type UpdateICFCProfile = {
        subAppUserPrincipalId : Ids.PrincipalId;
        subApp : ICFCEnums.SubApp;
        membershipType : ICFCEnums.MembershipType;
    };

    public type VerifyICFCProfile = {
        principalId : Ids.PrincipalId;
    };
    public type VerifySubApp = {
        subAppUserPrincipalId : Ids.PrincipalId;
        subApp : ICFCEnums.SubApp;
        icfcPrincipalId : Ids.PrincipalId;
    };

    public type NotifyAppofRemoveLink = {
        subApp : ICFCEnums.SubApp;
        icfcPrincipalId : Ids.PrincipalId;
    };
};

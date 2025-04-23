import Ids "mo:waterway-mops/Ids";
import Enums "mo:waterway-mops/ICFCEnums";

module ICFCQUeries {
  public type GetICFCLinks = {};

  public type ICFCLinks = {
    icfcPrincipalId : Ids.PrincipalId;
    subAppUserPrincipalId : Ids.PrincipalId;
    membershipType : Enums.MembershipType;
    subApp : Enums.SubApp;
  };

};
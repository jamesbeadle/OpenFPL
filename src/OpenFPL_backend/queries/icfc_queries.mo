import Ids "mo:waterway-mops/base/ids";
import Enums "mo:waterway-mops/product/icfc/enums";

module ICFCQUeries {
  public type GetICFCLinks = {};

  public type ICFCLinks = {
    icfcPrincipalId : Ids.PrincipalId;
    subAppUserPrincipalId : Ids.PrincipalId;
    membershipType : Enums.MembershipType;
    subApp : Enums.SubApp;
  };

};
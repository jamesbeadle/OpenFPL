import IcfcEnums "mo:waterway-mops/product/icfc/enums";

module MemberbershipTypes = {
  
  public type MembershipClaim = {
    membershipType : IcfcEnums.MembershipType;
    purchasedOn : Int;
    expiresOn : ?Int;
  };

  public type EligibleMembership = {
    membershipType : IcfcEnums.MembershipType;
    eligibleNeuronIds : [Blob];
  };
  };
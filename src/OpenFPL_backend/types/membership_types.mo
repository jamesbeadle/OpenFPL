import Enums "../../OpenFPL_backend/enums/enums";
module MemberbershipTypes = {
  
  public type MembershipClaim = {
    membershipType : Enums.MembershipType;
    purchasedOn : Int;
    expiresOn : ?Int;
  };

  public type EligibleMembership = {
    membershipType : Enums.MembershipType;
    eligibleNeuronIds : [Blob];
  };
  };
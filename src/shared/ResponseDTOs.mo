import Base "./types/base_types";
module ResponseDTOs {

  public type CanisterInfoDTO = {
    canisterId: Base.CanisterId;
    cycles: Nat;
  };

  public type StaticCanistersDTO = {
    canisters: [CanisterInfoDTO];
  };

  public type ManagerCanistersDTO = {
    canisters: [CanisterInfoDTO];
  };

  public type LeaderboardCanistersDTO = {
    canisters: [CanisterInfoDTO];
  };

};
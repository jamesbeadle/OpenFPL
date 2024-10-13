import T "types";
module ResponseDTOs {

  public type CanisterInfoDTO = {
    canisterId: T.CanisterId;
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

  public type AdminDashboardDTO = {
    openFPLCanisterId: T.CanisterId;
    openWSLCanisterId: T.CanisterId;
    dataCanisterId: T.CanisterId;
    openFPLBackendCycles: Nat;
    openWSLBackendCycles: Nat;
    dataCanisterCycles: Nat;
    managerCanisters: [(T.CanisterId, Nat)];
  };

};
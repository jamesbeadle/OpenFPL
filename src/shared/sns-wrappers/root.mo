// This is a generated Motoko binding.
// Please use `import service "ic:canister_id"` instead to call canisters on the IC if possible.

module {
  public type CanisterCallError = { code : ?Int32; description : Text };
  public type CanisterIdRecord = { canister_id : Principal };
  public type CanisterInstallMode = { #reinstall; #upgrade; #install };
  public type CanisterStatusResult = {
    status : CanisterStatusType;
    memory_size : Nat;
    cycles : Nat;
    settings : DefiniteCanisterSettings;
    module_hash : ?Blob;
  };
  public type CanisterStatusResultV2 = {
    status : CanisterStatusType;
    memory_size : Nat;
    cycles : Nat;
    settings : DefiniteCanisterSettingsArgs;
    idle_cycles_burned_per_day : Nat;
    module_hash : ?Blob;
  };
  public type CanisterStatusType = { #stopped; #stopping; #running };
  public type CanisterSummary = {
    status : ?CanisterStatusResultV2;
    canister_id : ?Principal;
  };
  public type ChangeCanisterRequest = {
    arg : Blob;
    wasm_module : Blob;
    stop_before_installing : Bool;
    mode : CanisterInstallMode;
    canister_id : Principal;
    query_allocation : ?Nat;
    memory_allocation : ?Nat;
    compute_allocation : ?Nat;
  };
  public type DefiniteCanisterSettings = { controllers : [Principal] };
  public type DefiniteCanisterSettingsArgs = {
    freezing_threshold : Nat;
    controllers : [Principal];
    memory_allocation : Nat;
    compute_allocation : Nat;
  };
  public type FailedUpdate = {
    err : ?CanisterCallError;
    dapp_canister_id : ?Principal;
  };
  public type GetSnsCanistersSummaryRequest = { update_canister_list : ?Bool };
  public type GetSnsCanistersSummaryResponse = {
    root : ?CanisterSummary;
    swap : ?CanisterSummary;
    ledger : ?CanisterSummary;
    index : ?CanisterSummary;
    governance : ?CanisterSummary;
    dapps : [CanisterSummary];
    archives : [CanisterSummary];
  };
  public type ListSnsCanistersResponse = {
    root : ?Principal;
    swap : ?Principal;
    ledger : ?Principal;
    index : ?Principal;
    governance : ?Principal;
    dapps : [Principal];
    archives : [Principal];
  };
  public type ManageDappCanisterSettingsRequest = {
    freezing_threshold : ?Nat64;
    canister_ids : [Principal];
    reserved_cycles_limit : ?Nat64;
    log_visibility : ?Int32;
    memory_allocation : ?Nat64;
    compute_allocation : ?Nat64;
  };
  public type ManageDappCanisterSettingsResponse = { failure_reason : ?Text };
  public type RegisterDappCanisterRequest = { canister_id : ?Principal };
  public type RegisterDappCanistersRequest = { canister_ids : [Principal] };
  public type SetDappControllersRequest = {
    canister_ids : ?RegisterDappCanistersRequest;
    controller_principal_ids : [Principal];
  };
  public type SetDappControllersResponse = { failed_updates : [FailedUpdate] };
  public type SnsRootCanister = {
    dapp_canister_ids : [Principal];
    testflight : Bool;
    latest_ledger_archive_poll_timestamp_seconds : ?Nat64;
    archive_canister_ids : [Principal];
    governance_canister_id : ?Principal;
    index_canister_id : ?Principal;
    swap_canister_id : ?Principal;
    ledger_canister_id : ?Principal;
  };
  public type Self = SnsRootCanister -> async actor {
    canister_status : shared CanisterIdRecord -> async CanisterStatusResult;
    change_canister : shared ChangeCanisterRequest -> async ();
    get_build_metadata : shared query () -> async Text;
    get_sns_canisters_summary : shared GetSnsCanistersSummaryRequest -> async GetSnsCanistersSummaryResponse;
    list_sns_canisters : shared query {} -> async ListSnsCanistersResponse;
    manage_dapp_canister_settings : shared ManageDappCanisterSettingsRequest -> async ManageDappCanisterSettingsResponse;
    register_dapp_canister : shared RegisterDappCanisterRequest -> async {};
    register_dapp_canisters : shared RegisterDappCanistersRequest -> async {};
    set_dapp_controllers : shared SetDappControllersRequest -> async SetDappControllersResponse;
  }
}
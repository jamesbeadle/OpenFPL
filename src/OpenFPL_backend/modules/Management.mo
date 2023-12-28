module {
  //Types
  public type canister_id = Principal;
  public type canister_settings = {
    freezing_threshold : ?Nat;
    controllers : ?[Principal];
    memory_allocation : ?Nat;
    compute_allocation : ?Nat;
  };

  public type wasm_module = Blob;

  public type Management = actor {
    create_canister : shared { settings : ?canister_settings } -> async {
      canister_id : canister_id;
    };
    update_settings : shared {
      canister_id : Principal;
      settings : canister_settings;
    } -> async ();
    install_code : shared {
      arg : Blob;
      wasm_module : wasm_module;
      mode : {
        #reinstall;
        #upgrade : ?{
          skip_pre_upgrade : ?Bool;
        };
        #install;
      };
      canister_id : canister_id;
    } -> async ();
  };
};

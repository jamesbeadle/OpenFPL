module {
  public type canister_id = Principal;
  public type wasm_module = Blob;

  public type canister_settings = {
      controllers : ? [Principal];
      compute_allocation : ?Nat;
      memory_allocation : ?Nat;
      freezing_threshold : ?Nat;
      reserved_cycles_limit : ?Nat;
  };

  public type definite_canister_settings = {
      controllers : [Principal];
      compute_allocation : Nat;
      memory_allocation : Nat;
      freezing_threshold : Nat;
      reserved_cycles_limit : Nat;
  };

  public type change_origin = {
      #from_user : {
          user_id : Principal;
      };
      #from_canister : {
          canister_id : Principal;
          canister_version : ?Nat64;
      };
  };

  public type change_details = {
      #creation : {
          controllers : [Principal];
      };
      #code_uninstall;
      #code_deployment : {
          mode : { #install; #reinstall; #upgrade };
          module_hash : Blob;
      };
      #controllers_change : {
          controllers : [Principal];
      };
  };

  public type change = {
      timestamp_nanos : Nat64;
      canister_version : Nat64;
      origin : change_origin;
      details : change_details;
  };

  public type chunk_hash = {
    hash : Blob;
  };

  public type http_header = {
      name : Text;
      value : Text;
  };

  public type http_request_result = {
      status : Nat;
      headers : [http_header];
      body : Blob;
  };

  public type ecdsa_curve = {
      #secp256k1;
  };

  public type satoshi = Nat64;

  public type bitcoin_network = {
      #mainnet;
      #testnet;
  };

  public type bitcoin_address = Text;

  public type block_hash = Blob;

  public type outpoint = {
      txid : Blob;
      vout : Nat32;
  };

  public type utxo = {
      outpoint : outpoint;
      value : satoshi;
      height : Nat32;
  };

  public type bitcoin_get_utxos_args = {
      address : bitcoin_address;
      network : bitcoin_network;
      filter : ?{
          #min_confirmations : Nat32;
          #page : Blob;
      };
  };

  public type bitcoin_get_utxos_query_args = {
      address : bitcoin_address;
      network : bitcoin_network;
      filter : ?{
          #min_confirmations : Nat32;
          #page : Blob;
      };
  };

  public type bitcoin_get_current_fee_percentiles_args = {
      network : bitcoin_network;
  };

  public type bitcoin_get_utxos_result = {
      utxos : [utxo];
      tip_block_hash : block_hash;
      tip_height : Nat32;
      next_page : ?Blob;
  };

  public type bitcoin_get_utxos_query_result = {
      utxos : [utxo];
      tip_block_hash : block_hash;
      tip_height : Nat32;
      next_page : ?Blob;
  };

  public type bitcoin_get_balance_args = {
      address : bitcoin_address;
      network : bitcoin_network;
      min_confirmations : ?Nat32;
  };

  public type bitcoin_get_balance_query_args = {
      address : bitcoin_address;
      network : bitcoin_network;
      min_confirmations : ?Nat32;
  };

  public type bitcoin_send_transaction_args = {
      transaction : Blob;
      network : bitcoin_network;
  };

  public type millisatoshi_per_byte = Nat64;

  public type node_metrics = {
      node_id : Principal;
      num_blocks_total : Nat64;
      num_block_failures_total : Nat64;
  };

  public type create_canister_args = {
      settings : ?canister_settings;
      sender_canister_version : ?Nat64;
  };

  public type create_canister_result = {
      canister_id : canister_id;
  };

  public type update_settings_args = {
      canister_id : Principal;
      settings : canister_settings;
      sender_canister_version : ?Nat64;
  };

  public type upload_chunk_args = {
      canister_id : Principal;
      chunk : Blob;
  };

  public type clear_chunk_store_args = {
      canister_id : canister_id;
  };

  public type stored_chunks_args = {
      canister_id : canister_id;
  };

  public type canister_install_mode = {
      #install;
      #reinstall;
      #upgrade : ?{
          skip_pre_upgrade : ?Bool;
      };
  };

  public type install_code_args = {
      mode : canister_install_mode;
      canister_id : canister_id;
      wasm_module : wasm_module;
      arg : Blob;
      sender_canister_version : ?Nat64;
  };

  public type install_chunked_code_args = {
      mode : canister_install_mode;
      target_canister : canister_id;
      store_canister : ?canister_id;
      chunk_hashes_list : [chunk_hash];
      wasm_module_hash : Blob;
      arg : Blob;
      sender_canister_version : ?Nat64;
  };

  public type uninstall_code_args = {
      canister_id : canister_id;
      sender_canister_version : ?Nat64;
  };

  public type start_canister_args = {
      canister_id : canister_id;
  };

  public type stop_canister_args = {
      canister_id : canister_id;
  };

  public type canister_status_args = {
      canister_id : canister_id;
  };

  public type canister_status_result = {
      status : { #running; #stopping; #stopped };
      settings : definite_canister_settings;
      module_hash : ?Blob;
      memory_size : Nat;
      cycles : Nat;
      reserved_cycles : Nat;
      idle_cycles_burned_per_day : Nat;
  };

  public type canister_info_args = {
      canister_id : canister_id;
      num_requested_changes : ?Nat64;
  };

  public type canister_info_result = {
      total_num_changes : Nat64;
      recent_changes : [change];
      module_hash : ?Blob;
      controllers : [Principal];
  };

  public type delete_canister_args = {
      canister_id : canister_id;
  };

  public type deposit_cycles_args = {
      canister_id : canister_id;
  };

  public type http_request_args = {
      url : Text;
      max_response_bytes : ?Nat64;
      method : { #get; #head; #post };
      headers : [http_header];
      body : ?Blob;
      transform : ?{
          function : shared { response : http_request_result; context : Blob } -> async (http_request_result);
          context : Blob;
      };
  };

  public type ecdsa_public_key_args = {
      canister_id : ?canister_id;
      derivation_path : [Blob];
      key_id : { curve : ecdsa_curve; name : Text };
  };

  public type ecdsa_public_key_result = {
      public_key : Blob;
      chain_code : Blob;
  };

  public type sign_with_ecdsa_args = {
      message_hash : Blob;
      derivation_path : [Blob];
      key_id : { curve : ecdsa_curve; name : Text };
  };

  public type sign_with_ecdsa_result = {
      signature : Blob;
  };

  public type node_metrics_history_args = {
      subnet_id : Principal;
      start_at_timestamp_nanos : Nat64;
  };

  public type node_metrics_history_result = [{
      timestamp_nanos : Nat64;
      node_metrics : [node_metrics];
  }];

  public type provisional_create_canister_with_cycles_args = {
      amount : ?Nat;
      settings : ?canister_settings;
      specified_id : ?canister_id;
      sender_canister_version : ?Nat64;
  };

  public type provisional_create_canister_with_cycles_result = {
      canister_id : canister_id;
  };

  public type provisional_top_up_canister_args = {
      canister_id : canister_id;
      amount : Nat;
  };

  public type raw_rand_result = Blob;

  public type stored_chunks_result = [chunk_hash];

  public type upload_chunk_result = chunk_hash;

  public type bitcoin_get_balance_result = satoshi;

  public type bitcoin_get_balance_query_result = satoshi;

  public type bitcoin_get_current_fee_percentiles_result = [millisatoshi_per_byte];

  public type Management = actor {
     
      create_canister : shared (create_canister_args) -> async (create_canister_result);
      update_settings : shared (update_settings_args) -> async ();
      upload_chunk : shared (upload_chunk_args) -> async (upload_chunk_result);
      clear_chunk_store : shared (clear_chunk_store_args) -> async ();
      stored_chunks : shared (stored_chunks_args) -> async (stored_chunks_result);
      install_code : shared (install_code_args) -> async ();
      install_chunked_code : shared (install_chunked_code_args) -> async ();
      uninstall_code : shared (uninstall_code_args) -> async ();
      start_canister : shared (start_canister_args) -> async ();
      stop_canister : shared (stop_canister_args) -> async ();
      canister_status : shared (canister_status_args) -> async (canister_status_result);
      canister_info : shared (canister_info_args) -> async (canister_info_result);
      delete_canister : shared (delete_canister_args) -> async ();
      deposit_cycles : shared (deposit_cycles_args) -> async ();
      raw_rand : shared () -> async (raw_rand_result);
      http_request : shared (http_request_args) -> async (http_request_result);

      // Threshold ECDSA signature
      ecdsa_public_key : shared (ecdsa_public_key_args) -> async (ecdsa_public_key_result);
      sign_with_ecdsa : shared (sign_with_ecdsa_args) -> async (sign_with_ecdsa_result);

      // bitcoin interface
      bitcoin_get_balance : shared (bitcoin_get_balance_args) -> async (bitcoin_get_balance_result);
      bitcoin_get_balance_query : shared (bitcoin_get_balance_query_args) -> async (bitcoin_get_balance_query_result);
      bitcoin_get_utxos : shared (bitcoin_get_utxos_args) -> async (bitcoin_get_utxos_result);
      bitcoin_get_utxos_query : shared (bitcoin_get_utxos_query_args) -> async (bitcoin_get_utxos_query_result);
      bitcoin_send_transaction : shared (bitcoin_send_transaction_args) -> async ();
      bitcoin_get_current_fee_percentiles : shared (bitcoin_get_current_fee_percentiles_args) -> async (bitcoin_get_current_fee_percentiles_result);

      // metrics interface
      node_metrics_history : shared (node_metrics_history_args) -> async (node_metrics_history_result);

      // provisional interfaces for the pre-ledger world
      provisional_create_canister_with_cycles : shared (provisional_create_canister_with_cycles_args) -> async (provisional_create_canister_with_cycles_result);
      provisional_top_up_canister : shared (provisional_top_up_canister_args) -> async ();
  };



};

module {
  public let CANISTER_ID : Text = "ryjl3-tyaaa-aaaaa-aaaba-cai";

  public type Result<T, E> = {
    #Ok : T;
    #Err : E;
  };

  //! Candid for canister `nns_ledger` obtained by `scripts/update_ic_commit` from: <https://raw.githubusercontent.com/dfinity/ic/release-2024-03-14_23-01-p2p/rs/rosetta-api/icp_ledger/ledger.did>
  // This is the official Ledger interface that is guaranteed to be backward compatible.

  // Amount of tokens, measured in 10^-8 of a token.
  public type Tokens = {
    e8s : Nat64;
  };

  // Number of nanoseconds from the UNIX epoch in UTC timezone.
  public type TimeStamp = {
    timestamp_nanos : Nat64;
  };

  // AccountIdentifier is a 32-byte array.
  // The first 4 bytes is big-endian encoding of a CRC32 checksum of the last 28 bytes.
  public type AccountIdentifier = Blob;

  // Subaccount is an arbitrary 32-byte byte array.
  // Ledger uses subaccounts to compute the source address, which enables one
  // principal to control multiple ledger accounts.
  public type SubAccount = Blob;

  // Sequence number of a block produced by the ledger.
  public type BlockIndex = Nat64;

  public type Transaction = {
    memo : Memo;
    icrc1_memo : ?Blob;
    operation : ?Operation;
    created_at_time : TimeStamp;
  };

  // An arbitrary number associated with a transaction.
  // The caller can set it in a `transfer` call as a correlation identifier.
  public type Memo = Nat64;

  // Arguments for the `transfer` call.
  public type TransferArgs = {
    // Transaction memo.
    // See comments for the `Memo` public type.
    memo : Memo;
    // The amount that the caller wants to transfer to the destination address.
    amount : Tokens;
    // The amount that the caller pays for the transaction.
    // Must be 10000 e8s.
    fee : Tokens;
    // The subaccount from which the caller wants to transfer funds.
    // If null, the ledger uses the default (all zeros) subaccount to compute the source address.
    // See comments for the `SubAccount` public type.
    from_subaccount : ?SubAccount;
    // The destination account.
    // If the transfer is successful, the balance of this address increases by `amount`.
    to : AccountIdentifier;
    // The point in time when the caller created this request.
    // If null, the ledger uses current IC time as the timestamp.
    created_at_time : ?TimeStamp;
  };

  public type TransferError = {
    // The fee that the caller specified in the transfer request was not the one that ledger expects.
    // The caller can change the transfer fee to the `expected_fee` and retry the request.
    #BadFee : { expected_fee : Tokens };
    // The account specified by the caller doesn't have enough funds.
    #InsufficientFunds : { balance : Tokens };
    // The request is too old.
    // The ledger only accepts requests created within 24 hours window.
    // This is a non-recoverable error.
    #TxTooOld : { allowed_window_nanos : Nat64 };
    // The caller specified `created_at_time` that is too far in future.
    // The caller can retry the request later.
    #TxCreatedInFuture;
    // The ledger has already executed the request.
    // `duplicate_of` field is equal to the index of the block containing the original transaction.
    #TxDuplicate : { duplicate_of : BlockIndex };
  };

  public type TransferResult = {
    #Ok : BlockIndex;
    #Err : TransferError;
  };

  // Arguments for the `account_balance` call.
  public type AccountBalanceArgs = {
    account : AccountIdentifier;
  };

  public type TransferFeeArg = {};

  public type TransferFee = {
    // The fee to pay to perform a transfer
    transfer_fee : Tokens;
  };

  public type GetBlocksArgs = {
    // The index of the first block to fetch.
    start : BlockIndex;
    // Max number of blocks to fetch.
    length : Nat64;
  };

  public type Operation = {
    #Mint : {
      to : AccountIdentifier;
      amount : Tokens;
    };
    #Burn : {
      from : AccountIdentifier;
      spender : ?AccountIdentifier;
      amount : Tokens;
    };
    #Transfer : {
      from : AccountIdentifier;
      to : AccountIdentifier;
      amount : Tokens;
      fee : Tokens;
      spender : ?[Nat8];
    };
    #Approve : {
      from : AccountIdentifier;
      spender : AccountIdentifier;
      // This field is deprecated and should not be used.
      allowance_e8s : Int;
      allowance : Tokens;
      fee : Tokens;
      expires_at : ?TimeStamp;
      expected_allowance : ?Tokens;
    };
  };

  public type Block = {
    parent_hash : ?Blob;
    transaction : Transaction;
    timestamp : TimeStamp;
  };

  // A prefix of the block range specified in the [GetBlocksArgs] request.
  public type BlockRange = {
    // A prefix of the requested block range.
    // The index of the first block is equal to [GetBlocksArgs.from].
    //
    // Note that the number of blocks might be less than the requested
    // [GetBlocksArgs.len] for various reasons, for example:
    //
    // 1. The query might have hit the replica with an outdated state
    //    that doesn't have the full block range yet.
    // 2. The requested range is too large to fit into a single reply.
    //
    // NOTE: the list of blocks can be empty if:
    // 1. [GetBlocksArgs.len] was zero.
    // 2. [GetBlocksArgs.from] was larger than the last block known to the canister.
    blocks : [Block];
  };

  // An error indicating that the arguments passed to [QueryArchiveFn] were invalid.
  public type QueryArchiveError = {
    // [GetBlocksArgs.from] argument was smaller than the first block
    // served by the canister that received the request.
    #BadFirstBlockIndex : {
      requested_index : BlockIndex;
      first_valid_index : BlockIndex;
    };

    // Reserved for future use.
    #Other : {
      error_code : Nat64;
      error_message : Text;
    };
  };

  public type QueryArchiveResult = {
    // Successfully fetched zero or more blocks.
    #Ok : BlockRange;
    // The [GetBlocksArgs] request was invalid.
    #Err : QueryArchiveError;
  };

  // A function that is used for fetching archived ledger blocks.
  public type QueryArchiveFn = shared GetBlocksArgs -> async QueryArchiveResult;
  // The result of a "query_blocks" call.
  //
  // The structure of the result is somewhat complicated because the main ledger canister might
  // not have all the blocks that the caller requested: One or more "archive" canisters might
  // store some of the requested blocks.
  //
  // Note: as of Q4 2021 when this interface is authored, the IC doesn't support making nested
  // query calls within a query call.
  public type QueryBlocksResponse = {
    // The total number of blocks in the chain.
    // If the chain length is positive, the index of the last block is `chain_len - 1`.
    chain_length : Nat64;

    // System certificate for the hash of the latest block in the chain.
    // Only present if `query_blocks` is called in a non-replicated query context.
    certificate : ?Blob;

    // List of blocks that were available in the ledger when it processed the call.
    //
    // The blocks form a contiguous range, with the first block having index
    // [first_block_index] (see below), and the last block having index
    // [first_block_index] + len(blocks) - 1.
    //
    // The block range can be an arbitrary sub-range of the originally requested range.
    blocks : [Block];

    // The index of the first block in "blocks".
    // If the blocks vector is empty, the exact value of this field is not specified.
    first_block_index : BlockIndex;

    // Encoding of instructions for fetching archived blocks whose indices fall into the
    // requested range.
    //
    // For each entry `e` in [archived_blocks], `[e.from, e.from + len)` is a sub-range
    // of the originally requested block range.
    archived_blocks : [ArchivedBlocksRange];
  };

  public type ArchivedBlocksRange = {
    // The index of the first archived block that can be fetched using the callback.
    start : BlockIndex;

    // The number of blocks that can be fetch using the callback.
    length : Nat64;

    // The function that should be called to fetch the archived blocks.
    // The range of the blocks accessible using this function is given by [from]
    // and [len] fields above.
    callback : QueryArchiveFn;
  };

  /*
  public type ArchivedEncodedBlocksRange =  {
      callback : (GetBlocksArgs) -> async (
           { #Ok : [Blob]; #Err : QueryArchiveError },
          );
          
      start : Nat64;
      length : Nat64;
  };
*/
  public type QueryEncodedBlocksResponse = {
    certificate : ?Blob;
    blocks : [Blob];
    chain_length : Nat64;
    first_block_index : Nat64;
    //archived_blocks : [ArchivedEncodedBlocksRange];
  };

  public type Archive = {
    canister_id : Principal;
  };

  public type Archives = {
    archives : [Archive];
  };

  public type Duration = {
    secs : Nat64;
    nanos : Nat32;
  };

  public type ArchiveOptions = {
    trigger_threshold : Nat64;
    num_blocks_to_archive : Nat64;
    node_max_memory_size_bytes : ?Nat64;
    max_message_size_bytes : ?Nat64;
    controller_id : Principal;
    more_controller_ids : ?[Principal];
    cycles_for_archive_creation : ?Nat64;
    max_transactions_per_response : ?Nat64;
  };

  // Account identifier encoded as a 64-byte ASCII hex string.
  public type TextAccountIdentifier = Text;

  // Arguments for the `send_dfx` call.
  public type SendArgs = {
    memo : Memo;
    amount : Tokens;
    fee : Tokens;
    from_subaccount : ?SubAccount;
    to : TextAccountIdentifier;
    created_at_time : ?TimeStamp;
  };

  public type AccountBalanceArgsDfx = {
    account : TextAccountIdentifier;
  };

  public type FeatureFlags = {
    icrc2 : Bool;
  };

  public type InitArgs = {
    minting_account : TextAccountIdentifier;
    icrc1_minting_account : ?Account;
    initial_values : [(TextAccountIdentifier, Tokens)];
    max_message_size_bytes : ?Nat64;
    transaction_window : ?Duration;
    archive_options : ?ArchiveOptions;
    send_whitelist : [Principal];
    transfer_fee : ?Tokens;
    token_symbol : ?Text;
    token_name : ?Text;
    feature_flags : ?FeatureFlags;
    maximum_number_of_accounts : ?Nat64;
    accounts_overflow_trim_quantity : ?Nat64;
  };

  public type Icrc1BlockIndex = Nat;
  // Number of nanoseconds since the UNIX epoch in UTC timezone.
  public type Icrc1Timestamp = Nat64;
  public type Icrc1Tokens = Nat;

  public type Account = {
    owner : Principal;
    subaccount : ?SubAccount;
  };

  public type TransferArg = {
    from_subaccount : ?SubAccount;
    to : Account;
    amount : Icrc1Tokens;
    fee : ?Icrc1Tokens;
    memo : ?Blob;
    created_at_time : ?Icrc1Timestamp;
  };

  public type Icrc1TransferError = {
    #BadFee : { expected_fee : Icrc1Tokens };
    #BadBurn : { min_burn_amount : Icrc1Tokens };
    #InsufficientFunds : { balance : Icrc1Tokens };
    #TooOld;
    #CreatedInFuture : { ledger_time : Nat64 };
    #TemporarilyUnavailable;
    #Duplicate : { duplicate_of : Icrc1BlockIndex };
    #GenericError : { error_code : Nat; message : Text };
  };

  public type Icrc1TransferResult = {
    #Ok : Icrc1BlockIndex;
    #Err : Icrc1TransferError;
  };

  // The value returned from the [icrc1_metadata] endpoint.
  public type Value = {
    #Nat : Nat;
    #Int : Int;
    #Text : Text;
    #Blob : Blob;
  };

  public type UpgradeArgs = {
    maximum_number_of_accounts : ?Nat64;
    icrc1_minting_account : ?Account;
    feature_flags : ?FeatureFlags;
  };

  public type LedgerCanisterPayload = {
    #Init : InitArgs;
    #Upgrade : ?UpgradeArgs;
  };

  public type ApproveArgs = {
    from_subaccount : ?SubAccount;
    spender : Account;
    amount : Icrc1Tokens;
    expected_allowance : ?Icrc1Tokens;
    expires_at : ?Icrc1Timestamp;
    fee : ?Icrc1Tokens;
    memo : ?Blob;
    created_at_time : ?Icrc1Timestamp;
  };

  public type ApproveError = {
    #BadFee : { expected_fee : Icrc1Tokens };
    #InsufficientFunds : { balance : Icrc1Tokens };
    #AllowanceChanged : { current_allowance : Icrc1Tokens };
    #Expired : { ledger_time : Nat64 };
    #TooOld;
    #CreatedInFuture : { ledger_time : Nat64 };
    #Duplicate : { duplicate_of : Icrc1BlockIndex };
    #TemporarilyUnavailable;
    #GenericError : { error_code : Nat; message : Text };
  };

  public type ApproveResult = {
    #Ok : Icrc1BlockIndex;
    #Err : ApproveError;
  };

  public type AllowanceArgs = {
    account : Account;
    spender : Account;
  };

  public type Allowance = {
    allowance : Icrc1Tokens;
    expires_at : ?Icrc1Timestamp;
  };

  public type TransferFromArgs = {
    spender_subaccount : ?SubAccount;
    from : Account;
    to : Account;
    amount : Icrc1Tokens;
    fee : ?Icrc1Tokens;
    memo : ?Blob;
    created_at_time : ?Icrc1Timestamp;
  };

  public type TransferFromResult = {
    #Ok : Icrc1BlockIndex;
    #Err : TransferFromError;
  };

  public type TransferFromError = {
    #BadFee : { expected_fee : Icrc1Tokens };
    #BadBurn : { min_burn_amount : Icrc1Tokens };
    #InsufficientFunds : { balance : Icrc1Tokens };
    #InsufficientAllowance : { allowance : Icrc1Tokens };
    #TooOld;
    #CreatedInFuture : { ledger_time : Icrc1Timestamp };
    #Duplicate : { duplicate_of : Icrc1BlockIndex };
    #TemporarilyUnavailable;
    #GenericError : { error_code : Nat; message : Text };
  };
  public type Interface = actor {
    // Transfers tokens from a subaccount of the caller to the destination address.
    // The source address is computed from the principal of the caller and the specified subaccount.
    // When successful, returns the index of the block containing the transaction.
    transfer : (TransferArgs) -> async (TransferResult);

    // Returns the amount of Tokens on the specified account.
    account_balance : (AccountBalanceArgs) -> async (Tokens);

    // Returns the account identifier for the given Principal and subaccount.
    account_identifier : (Account) -> async (AccountIdentifier);

    // Returns the current transfer_fee.
    transfer_fee : (TransferFeeArg) -> async (TransferFee);

    // Queries blocks in the specified range.
    query_blocks : (GetBlocksArgs) -> async (QueryBlocksResponse);

    // Queries encoded blocks in the specified range
    query_encoded_blocks : (GetBlocksArgs) -> async (QueryEncodedBlocksResponse);

    // Returns token symbol.
    symbol : () -> async ({ symbol : Text });

    // Returns token name.
    name : () -> async ({ name : Text });

    // Returns token decimals.
    decimals : () -> async ({ decimals : Nat32 });

    // Returns the existing archive canisters information.
    archives : () -> async (Archives);

    send_dfx : (SendArgs) -> async (BlockIndex);
    account_balance_dfx : (AccountBalanceArgsDfx) -> async (Tokens);

    // The following methods implement the ICRC-1 Token Standard.
    // https://github.com/dfinity/ICRC-1/tree/main/standards/ICRC-1
    icrc1_name : () -> async (Text);
    icrc1_symbol : () -> async (Text);
    icrc1_decimals : () -> async (Nat8);
    icrc1_metadata : () -> async ([(Text, Value)]);
    icrc1_total_supply : () -> async (Icrc1Tokens);
    icrc1_fee : () -> async (Icrc1Tokens);
    icrc1_minting_account : () -> async (?Account);
    icrc1_balance_of : (Account) -> async (Icrc1Tokens);
    icrc1_transfer : (TransferArg) -> async (Icrc1TransferResult);
    icrc1_supported_standards : () -> async ([(name : Text, url : Text)]);
    icrc2_approve : (ApproveArgs) -> async (ApproveResult);
    icrc2_allowance : (AllowanceArgs) -> async (Allowance);
    icrc2_transfer_from : (TransferFromArgs) -> async (TransferFromResult);
  };
};

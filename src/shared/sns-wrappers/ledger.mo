module {
    //! Candid for canister `sns_ledger` obtained by `scripts/update_ic_commit` from: <https://raw.githubusercontent.com/dfinity/ic/release-2024-04-03_23-01-base/rs/rosetta-api/icrc1/ledger/ledger.did>
    type BlockIndex = Nat;
    type Subaccount = Blob;
    // Number of nanoseconds since the UNIX epoch in UTC timezone.
    type Timestamp = Nat64;
    // Number of nanoseconds between two [Timestamp]s.
    type Duration = Nat64;
    type Tokens = Nat;
    type TxIndex = Nat;
    type Allowance = { allowance : Nat; expires_at : ?Timestamp };
    type AllowanceArgs = { account : Account; spender : Account };
    type Approve = {
    fee : ?Nat;
    from : Account;
    memo : ?Blob;
    created_at_time : ?Timestamp;
    amount : Nat;
    expected_allowance : ?Nat;
    expires_at : ?Timestamp;
    spender : Account;
    };
    type ApproveArgs = {
    fee : ?Nat;
    memo : ?Blob;
    from_subaccount : ?Blob;
    created_at_time : ?Timestamp;
    amount : Nat;
    expected_allowance : ?Nat;
    expires_at : ?Timestamp;
    spender : Account;
    };
    type ApproveError = {
    #GenericError : { message : Text; error_code : Nat };
    #TemporarilyUnavailable;
    #Duplicate : { duplicate_of : BlockIndex };
    #BadFee : { expected_fee : Nat };
    #AllowanceChanged : { current_allowance : Nat };
    #CreatedInFuture : { ledger_time : Timestamp };
    #TooOld;
    #Expired : { ledger_time : Timestamp };
    #InsufficientFunds : { balance : Nat };
    };
    type ApproveResult = { #Ok : BlockIndex; #Err : ApproveError };

    type HttpRequest = {
    url : Text;
    method : Text;
    body : Blob;
    headers : [(Text, Text)];
    };
    type HttpResponse = {
    body : Blob;
    headers : [(Text, Text)];
    status_code : Nat16;
    };

    public type Account = {
        owner : Principal;
        subaccount : ?Subaccount;
    };

    type TransferArg = {
        from_subaccount : ?Subaccount;
        to : Account;
        amount : Tokens;
        fee : ?Tokens;
        memo : ?Blob;
        created_at_time: ?Timestamp;
    };

    type TransferError = {
        #BadFee : { expected_fee : Tokens };
        #BadBurn : { min_burn_amount : Tokens };
        #InsufficientFunds : { balance : Tokens };
        #TooOld;
        #CreatedInFuture : { ledger_time : Timestamp };
        #TemporarilyUnavailable;
        #Duplicate : { duplicate_of : BlockIndex };
        #GenericError : { error_code : Nat; message : Text };
    };

    type TransferResult = {
        #Ok : BlockIndex;
        #Err : TransferError;
    };

    // The value returned from the [icrc1_metadata] endpoint.
    type MetadataValue = {
        #Nat : Nat;
        #Int : Int;
        #Text : Text;
        #Blob : Blob;
    };

    type FeatureFlags = {
        icrc2 : Bool;
    };

    // The initialization parameters of the Ledger
    type InitArgs = {
        minting_account : Account;
        fee_collector_account : ?Account;
        transfer_fee : Nat;
        decimals : ?Nat8;
        max_memo_length : ?Nat16;
        token_symbol : Text;
        token_name : Text;
        metadata : [(Text,MetadataValue)];
        initial_balances : [(Account,Nat)];
        feature_flags : ?FeatureFlags;
        maximum_number_of_accounts : ?Nat64;
        accounts_overflow_trim_quantity : ?Nat64;
        archive_options : {
            num_blocks_to_archive : Nat64;
            max_transactions_per_response : ?Nat64;
            trigger_threshold : Nat64;
            max_message_size_bytes : ?Nat64;
            cycles_for_archive_creation : ?Nat64;
            node_max_memory_size_bytes : ?Nat64;
            controller_id : Principal;
            more_controller_ids : ?[Principal];
        };
    };

    type ChangeFeeCollector = {
        #Unset; #SetTo: Account;
    };

    type UpgradeArgs = {
        metadata : ?[(Text,MetadataValue)];
        token_symbol : ?Text;
        token_name : ?Text;
        transfer_fee : ?Nat;
        change_fee_collector : ?ChangeFeeCollector;
        max_memo_length : ?Nat16;
        feature_flags : ?FeatureFlags;
        maximum_number_of_accounts: ?Nat64;
        accounts_overflow_trim_quantity: ?Nat64;
    };

    type LedgerArg = {
        #Init: InitArgs;
        #Upgrade: ?UpgradeArgs;
    };

    type GetTransactionsRequest = {
        // The index of the first tx to fetch.
        start : TxIndex;
        // The number of transactions to fetch.
        length : Nat;
    };

    type GetTransactionsResponse = {
        // The total number of transactions in the log.
        log_length : Nat;

        // List of transaction that were available in the ledger when it processed the call.
        //
        // The transactions form a contiguous range, with the first transaction having index
        // [first_index] (see below), and the last transaction having index
        // [first_index] + len(transactions) - 1.
        //
        // The transaction range can be an arbitrary sub-range of the originally requested range.
        transactions : [Transaction];

        // The index of the first transaction in [transactions].
        // If the transaction vector is empty, the exact value of this field is not specified.
        first_index : TxIndex;

        // Encoding of instructions for fetching archived transactions whose indices fall into the
        // requested range.
        //
        // For each entry `e` in [archived_transactions], `[e.from, e.from + len)` is a sub-range
        // of the originally requested transaction range.
        archived_transactions : [{
            // The index of the first archived transaction you can fetch using the [callback].
            start : TxIndex;

            // The number of transactions you can fetch using the callback.
            length : Nat;

            // The function you should call to fetch the archived transactions.
            // The range of the transaction accessible using this function is given by [from]
            // and [len] fields above.
            callback : QueryArchiveFn;
        }];
    };


    // A prefix of the transaction range specified in the [GetTransactionsRequest] request.
    type TransactionRange = {
        // A prefix of the requested transaction range.
        // The index of the first transaction is equal to [GetTransactionsRequest.from].
        //
        // Note that the number of transactions might be less than the requested
        // [GetTransactionsRequest.length] for various reasons, for example:
        //
        // 1. The query might have hit the replica with an outdated state
        //    that doesn't have the whole range yet.
        // 2. The requested range is too large to fit into a single reply.
        //
        // NOTE: the list of transactions can be empty if:
        //
        // 1. [GetTransactionsRequest.length] was zero.
        // 2. [GetTransactionsRequest.from] was larger than the last transaction known to
        //    the canister.
        transactions : [Transaction];
    };

    // A function for fetching archived transaction.
    type QueryArchiveFn = (GetTransactionsRequest) -> async (TransactionRange);

    type Transaction = {
    burn : ?Burn;
    kind : Text;
    mint : ?Mint;
    approve : ?Approve;
    timestamp : Timestamp;
    transfer : ?Transfer;
    };

    type Burn = {
    from : Account;
    memo : ?Blob;
    created_at_time : ?Timestamp;
    amount : Nat;
    spender : ?Account;
    };

    type Mint = {
    to : Account;
    memo : ?Blob;
    created_at_time : ?Timestamp;
    amount : Nat;
    };

    type Transfer = {
    to : Account;
    fee : ?Nat;
    from : Account;
    memo : ?Blob;
    created_at_time : ?Timestamp;
    amount : Nat;
    spender : ?Account;
    };

    type Value = { 
        #Blob : Blob; 
        #Text : Text; 
        #Nat : Nat;
        #Nat64: Nat64; 
        #Int : Int;
        #Array : [Value]; 
        #Map : Map; 
    };

    type Map = [(Text,Value)];

    type Block = Value;

    type GetBlocksArgs = {
        // The index of the first block to fetch.
        start : BlockIndex;
        // Max number of blocks to fetch.
        length : Nat;
    };

    // A prefix of the block range specified in the [GetBlocksArgs] request.
    type BlockRange = {
        // A prefix of the requested block range.
        // The index of the first block is equal to [GetBlocksArgs.start].
        //
        // Note that the number of blocks might be less than the requested
        // [GetBlocksArgs.length] for various reasons, for example:
        //
        // 1. The query might have hit the replica with an outdated state
        //    that doesn't have the whole range yet.
        // 2. The requested range is too large to fit into a single reply.
        //
        // NOTE: the list of blocks can be empty if:
        //
        // 1. [GetBlocksArgs.length] was zero.
        // 2. [GetBlocksArgs.start] was larger than the last block known to
        //    the canister.
        blocks : [Block];
    };

    // A function for fetching archived blocks.
    type QueryBlockArchiveFn = (GetBlocksArgs) -> async (BlockRange);

    // The result of a "get_blocks" call.
    type GetBlocksResponse = {
        // The index of the first block in "blocks".
        // If the blocks vector is empty, the exact value of this field is not specified.
        first_index : BlockIndex;

        // The total number of blocks in the chain.
        // If the chain length is positive, the index of the last block is `chain_len - 1`.
        chain_length : Nat64;

        // System certificate for the hash of the latest block in the chain.
        // Only present if `get_blocks` is called in a non-replicated query context.
        certificate : ?Blob;

        // List of blocks that were available in the ledger when it processed the call.
        //
        // The blocks form a contiguous range, with the first block having index
        // [first_block_index] (see below), and the last block having index
        // [first_block_index] + len(blocks) - 1.
        //
        // The block range can be an arbitrary sub-range of the originally requested range.
        blocks : [Block];

        // Encoding of instructions for fetching archived blocks.
        archived_blocks : [{
            // The index of the first archived block.
            start : BlockIndex;

            // The number of blocks that can be fetched.
            length : Nat;

            // Callback to fetch the archived blocks.
            callback : QueryBlockArchiveFn;
        }];
    };

    // Certificate for the block at `block_index`.
    type DataCertificate = {
        certificate : ?Blob;
        hash_tree : Blob;
    };

    type StandardRecord = { url : Text; name : Text };

    type TransferFromArgs = {
        spender_subaccount : ?Subaccount;
        from : Account;
        to : Account;
        amount : Tokens;
        fee : ?Tokens;
        memo : ?Blob;
        created_at_time: ?Timestamp;
    };

    type TransferFromResult = {
        #Ok : BlockIndex;
        #Err : TransferFromError;
    };

    type TransferFromError = {
        #BadFee : { expected_fee : Tokens };
        #BadBurn : { min_burn_amount : Tokens };
        #InsufficientFunds : { balance : Tokens };
        #InsufficientAllowance : { allowance : Tokens };
        #TooOld;
        #CreatedInFuture : { ledger_time : Timestamp };
        #Duplicate : { duplicate_of : BlockIndex };
        #TemporarilyUnavailable;
        #GenericError : { error_code : Nat; message : Text };
    };

    type ArchiveInfo = {
        canister_id: Principal;
        block_range_start: BlockIndex;
        block_range_end: BlockIndex;
    };

    type GetArchivesArgs = {
        // The last archive seen by the client.
        // The Ledger will return archives coming
        // after this one if set, otherwise it
        // will return the first archives.
        from : ?Principal;
    };

    type GetArchivesResult = [{
        // The id of the archive
        canister_id : Principal;

        // The first block in the archive
        start : Nat;

        // The last block in the archive
        end : Nat;
    }];

    type ICRC3DataCertificate = {
    // See https://internetcomputer.org/docs/current/references/ic-interface-spec#certification
    certificate : Blob;

    // CBOR encoded hash_tree
    hash_tree : Blob;
    };

    public type Interface = actor {
        archives : () -> async ([ArchiveInfo]);
        get_data_certificate : () -> async (DataCertificate); 

        icrc1_name : () -> async (Text);
        icrc1_symbol : () -> async (Text);
        icrc1_decimals : () -> async (Nat8);
        icrc1_metadata : () -> async ([(Text, MetadataValue)]);
        icrc1_total_supply : () -> async (Tokens);
        icrc1_fee : () -> async (Tokens);
        icrc1_minting_account : () -> async (?Account);
        icrc1_balance_of : (Account) -> async (Tokens);
        icrc1_transfer : (TransferArg) -> async (TransferResult);
        icrc1_supported_standards : () -> async ([StandardRecord]);
    
        icrc2_approve : (ApproveArgs) -> async (ApproveResult);
        icrc2_allowance : (AllowanceArgs) -> async (Allowance);
        icrc2_transfer_from : (TransferFromArgs) -> async (TransferFromResult);

        icrc3_get_archives : (GetArchivesArgs) -> async (GetArchivesResult);
        icrc3_get_tip_certificate : () -> async (?ICRC3DataCertificate);
        icrc3_supported_block_types : () -> async ([{ block_type : Text; url : Text }]);
    }
};
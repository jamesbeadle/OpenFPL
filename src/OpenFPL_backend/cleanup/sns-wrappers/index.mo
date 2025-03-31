// This is a generated Motoko binding.
// Please use `import service "ic:canister_id"` instead to call canisters on the IC if possible.

module {
  public type Account = { owner : Principal; subaccount : ?SubAccount };
  public type Approve = {
    fee : ?Nat;
    from : Account;
    memo : ?Blob;
    created_at_time : ?Nat64;
    amount : Nat;
    expected_allowance : ?Nat;
    expires_at : ?Nat64;
    spender : Account;
  };
  public type Block = Value;
  public type BlockIndex = Nat;
  public type Burn = {
    from : Account;
    memo : ?Blob;
    created_at_time : ?Nat64;
    amount : Nat;
    spender : ?Account;
  };
  public type FeeCollectorRanges = {
    ranges : [(Account, [(BlockIndex, BlockIndex)])];
  };
  public type GetAccountTransactionsArgs = {
    max_results : Nat;
    start : ?BlockIndex;
    account : Account;
  };
  public type GetBlocksRequest = { start : Nat; length : Nat };
  public type GetBlocksResponse = { blocks : [Block]; chain_length : Nat64 };
  public type GetTransactions = {
    balance : Tokens;
    transactions : [TransactionWithId];
    oldest_tx_id : ?BlockIndex;
  };
  public type GetTransactionsErr = { message : Text };
  public type GetTransactionsResult = {
    #Ok : GetTransactions;
    #Err : GetTransactionsErr;
  };
  public type IndexArg = { #Upgrade : UpgradeArg; #Init : InitArg };
  public type InitArg = { ledger_id : Principal };
  public type ListSubaccountsArgs = { owner : Principal; start : ?SubAccount };
  public type Map = [(Text, Value)];
  public type Mint = {
    to : Account;
    memo : ?Blob;
    created_at_time : ?Nat64;
    amount : Nat;
  };
  public type Status = { num_blocks_synced : BlockIndex };
  public type SubAccount = Blob;
  public type Tokens = Nat;
  public type Transaction = {
    burn : ?Burn;
    kind : Text;
    mint : ?Mint;
    approve : ?Approve;
    timestamp : Nat64;
    transfer : ?Transfer;
  };
  public type TransactionWithId = {
    id : BlockIndex;
    transaction : Transaction;
  };
  public type Transfer = {
    to : Account;
    fee : ?Nat;
    from : Account;
    memo : ?Blob;
    created_at_time : ?Nat64;
    amount : Nat;
    spender : ?Account;
  };
  public type UpgradeArg = { ledger_id : ?Principal };
  public type Value = {
    #Int : Int;
    #Map : Map;
    #Nat : Nat;
    #Nat64 : Nat64;
    #Blob : Blob;
    #Text : Text;
    #Array : [Value];
  };
  public type Self = ?IndexArg -> async actor {
    get_account_transactions : shared query GetAccountTransactionsArgs -> async GetTransactionsResult;
    get_blocks : shared query GetBlocksRequest -> async GetBlocksResponse;
    get_fee_collectors_ranges : shared query () -> async FeeCollectorRanges;
    icrc1_balance_of : shared query Account -> async Tokens;
    ledger_id : shared query () -> async Principal;
    list_subaccounts : shared query ListSubaccountsArgs -> async [SubAccount];
    status : shared query () -> async Status;
  }
}
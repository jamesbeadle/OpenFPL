import Nat64 "mo:base/Nat64";

module {

  public class Token() {

    type Tokens = Nat;
    type BlockIndex = Nat;
    type Timestamp = Nat64;
    type Subaccount = Blob;
    type Account = {
      owner : Principal;
      subaccount : ?Subaccount;
    };
    
    type TransferArg = {
      from_subaccount : Subaccount;
      to : Account;
      amount : Tokens;
      fee : Tokens;
      memo : Blob;
      created_at_time : Timestamp;
    };

    type TransferResult ={
      Ok : BlockIndex;
      Err : TransferError;
    };

    type TransferError = {
      BadFee : { expected_fee : Tokens };
      BadBurn : { min_burn_amount : Tokens };
      InsufficientFunds : { balance : Tokens };
      TooOld : {};
      CreatedInFuture : { ledger_time : Nat64 };
      TemporarilyUnavailable : {};
      Duplicate : { duplicate_of : BlockIndex };
      GenericError : { error_code : Nat; message : Text };
    };

    let token_canister = "tlwi3-3aaaa-aaaaa-aaapq-cai";
    let token_canister_actor = actor (token_canister) : actor {
      icrc1_name : () -> async Text;
      icrc1_total_supply : () -> async Nat;
      icrc1_balance_of : (account : Account) -> async Nat;
      icrc1_transfer : (args: TransferArg) -> async (TransferResult);
    };

    public func getAccountBalance(owner : Principal) : async Nat64 {
      let checkAccount : Account = {
        owner = owner;
        subaccount = null;
      };
      return Nat64.fromNat(await token_canister_actor.icrc1_balance_of(checkAccount));
    };

    public func getTotalSupply() : async Nat64 {
      return Nat64.fromNat(await token_canister_actor.icrc1_total_supply());
    };

    public func transferToken(principalId: Text, amount: Nat64) : async TransferResult{

      //Todo: populate transfer args
      let transferArgs: TransferArg =  {
        from_subaccount = Subaccount;
        to = Account;
        amount = amount;
        fee = Tokens;
        memo = Blob;
        created_at_time = Timestamp;
      };
      return await token_canister_actor.icrc1_transfer(transferArgs);
    };
  };
};

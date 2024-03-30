import Nat64 "mo:base/Nat64";
import Principal "mo:base/Principal";
import Blob "mo:base/Blob";
import Time "mo:base/Time";
import Int64 "mo:base/Int64";
import Array "mo:base/Array";
import Account "../lib/Account";
import Environment "../Environment";

module {

  public class Token() {

    var token_canister_id = Environment.SNS_LEDGER_CANISTER_ID;

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

    type TransferResult = {
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

    let token_canister_actor = actor (token_canister_id) : actor {
      icrc1_name : () -> async Text;
      icrc1_total_supply : () -> async Nat;
      icrc1_balance_of : (account : Account) -> async Nat;
      icrc1_minting_account : () -> async Account;
      icrc1_transfer : (args : TransferArg) -> async TransferResult;
      icrc1_fee : () -> async Tokens;
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

    public func transferToken(principalId : Text, amount : Nat) : async () {

      let tokenMintingAccount = Account.accountIdentifier(Principal.fromText(token_canister_id), Blob.fromArrayMut(Array.init(32, 0 : Nat8)));

      let transferArgs : TransferArg = {
        from_subaccount = tokenMintingAccount;
        to = {
          owner = Principal.fromText(principalId);
          subaccount = null;
        };
        amount = amount;
        fee = await token_canister_actor.icrc1_fee();
        memo = Blob.fromArray([]);
        created_at_time = Int64.toNat64(Int64.fromInt(Time.now()));
      };
      let _ = await token_canister_actor.icrc1_transfer(transferArgs);
    };

    public func mintToTreasury(amount : Nat) : async () {

      let tokenMintingAccount = Account.accountIdentifier(Principal.fromText(token_canister_id), Blob.fromArrayMut(Array.init(32, 0 : Nat8)));

      let transferArgs : TransferArg = {
        from_subaccount = tokenMintingAccount;
        to = {
          owner = Principal.fromText(token_canister_id);
          subaccount = null;
        };
        amount = amount;
        fee = await token_canister_actor.icrc1_fee();
        memo = Blob.fromArray([]);
        created_at_time = Int64.toNat64(Int64.fromInt(Time.now()));
      };
      let _ = await token_canister_actor.icrc1_transfer(transferArgs);
    };
  };
};

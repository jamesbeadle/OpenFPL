import Account "Account";
import ICPLedger "Ledger";
import Float "mo:base/Float";
import Int "mo:base/Int";
import Int64 "mo:base/Int64";
import Nat64 "mo:base/Nat64";
import Types "types";
import Time "mo:base/Time";
import Result "mo:base/Result";
import Principal "mo:base/Principal";
import Iter "mo:base/Iter";
import Buffer "mo:base/Buffer";
import Text "mo:base/Text";
import Blob "mo:base/Blob";
import DTOs "DTOs";

module {

  public class Book() {

    let icp_fee : Nat64 = 10_000;
    private let ledger : ICPLedger.Interface = actor (ICPLedger.CANISTER_ID);

    public func getUserAccountBalance(defaultAccount : Principal, user : Principal) : async Nat64 {
      let source_account = Account.accountIdentifier(defaultAccount, Account.principalToSubaccount(user));
      let balance = await ledger.account_balance({ account = source_account });
      return balance.e8s;
    };

    public func withdrawICP(defaultAccount : Principal, user : Principal, amount : Float, walletAddress : Text) : async Result.Result<(), Types.Error> {

      if (amount <= 0) {
        return #err(#NotAllowed);
      };

      let e8Amount = Int64.toNat64(Float.toInt64(amount * 1e8));
      let source_account = Account.accountIdentifier(defaultAccount, Account.principalToSubaccount(user));
      let balance = await ledger.account_balance({ account = source_account });

      if (balance.e8s < icp_fee) {
        return #err(#NotAllowed);
      };

      let withdrawable = balance.e8s - icp_fee;

      if (e8Amount >= withdrawable) {
        return #err(#NotAllowed);
      };

      let account_id = Account.decode(walletAddress);
      switch account_id {
        case (#ok array) {

          if (not Account.validateAccountIdentifier(Blob.fromArray(array))) {
            return #err(#NotAllowed);
          };

          let result = await ledger.transfer({
            memo : Nat64 = 0;
            from_subaccount = ?Account.principalToSubaccount(user);
            to = Blob.fromArray(array);
            amount = { e8s = e8Amount };
            fee = { e8s = icp_fee };
            created_at_time = ?{
              timestamp_nanos = Nat64.fromNat(Int.abs(Time.now()));
            };
          });

          return #ok(());
        };
        case (#err err) {
          return #err(#NotAllowed);
        };
      };
    };

  };
};

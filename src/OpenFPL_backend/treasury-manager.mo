import Account "./lib/Account";
import ICPLedger "./def/Ledger";
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
import CanisterIds "CanisterIds";

module {

  public class TreasuryManager() {

    let icp_fee : Nat64 = 10_000;
    let memo_txt_tpup : Nat64 = 0x50555054;
    private let ledger : ICPLedger.Interface = actor (ICPLedger.CANISTER_ID);

    public func getUserAccountBalance(defaultAccount : Principal, user : Principal) : async Nat64 {
      let source_account = Account.accountIdentifier(defaultAccount, Account.principalToSubaccount(user));
      let balance = await ledger.account_balance({ account = source_account });
      return balance.e8s;
    };

    public func sendICPForCycles(treasuryAccount : Account.AccountIdentifier, cyclesRequested : Nat64) : async () {
      
      if (cyclesRequested <= 0) {
        return;
      };

      let cycles_minting_canister = actor (CanisterIds.CYCLES_MINTING_CANISTER) : actor {
        get_icp_xdr_conversion_rate : () -> async Nat64;
      };
      let converstionRate: Nat64 = await cycles_minting_canister.get_icp_xdr_conversion_rate();

      //TODO:
      //call the cycles minting canister and get the icp xdr conversion rate
      //work out the icp to send the get the required cycles

      let amount: Nat64 = 10_000_000_000;

      let balance = await ledger.account_balance({ account = treasuryAccount });

      if (balance.e8s < icp_fee) {
        return;
      };

      let withdrawable = balance.e8s - icp_fee;

      if (amount >= withdrawable) {
        return;
      };

      let target_account = Account.accountIdentifier(Principal.fromText(CanisterIds.CYCLES_MINTING_CANISTER), Account.principalToSubaccount(Principal.fromText(CanisterIds.MAIN_CANISTER_ID)));

      if (not Account.validateAccountIdentifier(target_account)) {
        return;
      };

      let result = await ledger.transfer({
        memo = memo_txt_tpup;
        from_subaccount = null;
        to = target_account;
        amount = { e8s = amount };
        fee = { e8s = icp_fee };
        created_at_time = ?{
          timestamp_nanos = Nat64.fromNat(Int.abs(Time.now()));
        };
      });
    };

  };
};

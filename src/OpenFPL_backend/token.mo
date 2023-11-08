import Nat64 "mo:base/Nat64";

module {

  public class Token() {

    type Subaccount = Blob;
    type Account = {
      owner : Principal;
      subaccount : ?Subaccount;
    };

    let token_canister = "tlwi3-3aaaa-aaaaa-aaapq-cai";
    let token_canister_actor = actor (token_canister) : actor {
      icrc1_name : () -> async Text;
      icrc1_total_supply : () -> async Nat;
      icrc1_balance_of : (account : Account) -> async Nat;
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

    public func getTokenPriceUSD() : Nat64 {
      return 0;
    };

    public func getMarketCap() : Nat64 {
      return 0;
    };

    public func getVolume() : Nat64 {
      return 0;
    };
  };
};

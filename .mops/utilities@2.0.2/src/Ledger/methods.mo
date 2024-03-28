import { now } "mo:base/Time";
import Error "mo:base/Error";
import T "types";
import C "const";

module {

    public func balance( address : T.AccountIdentifier ) : async T.Tokens {
      let ledger : T.Interface.Interface = actor( C.CANISTER_ID );
      await ledger.account_balance({ account = address })
    };

    public func transfer(amount : Nat64, from_sa : ?T.Subaccount, to_account : T.AccountIdentifier, memo : ?Nat64) : async* T.Interface.TransferResult {
      
      let ledger : T.Interface.Interface = actor( C.CANISTER_ID );
      
      let args : T.Interface.TransferArgs = {
        memo = switch memo { case (?x) x; case _ 0 };
        amount = { e8s = amount };
        fee = { e8s = C.MIN_FEE };
        from_subaccount = from_sa;
        created_at_time = null;
        to = to_account;
      };
      
      try await ledger.transfer( args )
      catch (e) #Err( #Trapped( Error.message(e) ) )

    };

};
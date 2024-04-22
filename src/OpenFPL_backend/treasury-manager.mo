import Account "./lib/Account";
import ICPLedger "./def/Ledger";
import Int "mo:base/Int";
import Nat64 "mo:base/Nat64";
import Time "mo:base/Time";
import Principal "mo:base/Principal";
import Iter "mo:base/Iter";
import Buffer "mo:base/Buffer";
import Text "mo:base/Text";
import Blob "mo:base/Blob";
import Environment "utils/Environment";
import DTOs "DTOs";
import T "types";
import Tokens "Tokens";
import SNSToken "sns-wrappers/ledger";

module {

  public class TreasuryManager() {

    public type ConversionRateResponse = {
      data : Nat;
    };

    let icp_fee : Nat64 = 10_000;
    let memo_txt_tpup : Nat64 = 0x50555054;
    private let ledger : ICPLedger.Interface = actor (ICPLedger.CANISTER_ID);
    private var tokenList: [T.TokenInfo] = Tokens.tokens;

    public func getUserAccountBalance(defaultAccount : Principal, user : Principal) : async Nat64 {
      let source_account = Account.accountIdentifier(defaultAccount, Account.principalToSubaccount(user));
      let balance = await ledger.account_balance({ account = source_account });
      return balance.e8s;
    };

    public func sendICPForCycles(treasuryAccount : Account.AccountIdentifier, cyclesRequested : Nat64) : async () {

      if (cyclesRequested <= 0) {
        return;
      };

      var main_canister_id = Environment.BACKEND_CANISTER_ID;
      var cycles_minting_canister_id = Environment.CYCLES_MINTING_CANISTER_ID;

      let cycles_minting_canister = actor (cycles_minting_canister_id) : actor {
        get_icp_xdr_conversion_rate : () -> async ConversionRateResponse;
      };
      let converstionRate : ConversionRateResponse = await cycles_minting_canister.get_icp_xdr_conversion_rate();

      let icp_required : Nat64 = cyclesRequested / Nat64.fromNat(converstionRate.data) / 1_000_000;

      let balance = await ledger.account_balance({ account = treasuryAccount });

      if (balance.e8s < icp_fee) {
        return;
      };

      let withdrawable = balance.e8s - icp_fee;

      if (icp_required >= withdrawable) {
        return;
      };

      let target_account = Account.accountIdentifier(Principal.fromText(cycles_minting_canister_id), Account.principalToSubaccount(Principal.fromText(main_canister_id)));

      if (not Account.validateAccountIdentifier(target_account)) {
        return;
      };

      let _ = await ledger.transfer({
        memo = memo_txt_tpup;
        from_subaccount = null;
        to = target_account;
        amount = { e8s = icp_required };
        fee = { e8s = icp_fee };
        created_at_time = ?{
          timestamp_nanos = Nat64.fromNat(Int.abs(Time.now()));
        };
      });
    };

    public func validateAddNewToken(newTokenDTO : DTOs.NewTokenDTO) : T.RustResult {
      for(token in Iter.fromArray(tokenList)){
        if(newTokenDTO.canisterId == token.canisterId){
          return #Err("Token canister already exists.");
        }
      };
      return #Ok;
    };

    public func executeAddNewToken(newTokenDTO : DTOs.NewTokenDTO) : async () {
      let newTokenList = Buffer.fromArray<T.TokenInfo>(tokenList);
      newTokenList.add({
        canisterId = newTokenDTO.canisterId;
        ticker = newTokenDTO.ticker;
        tokenImageURL = newTokenDTO.tokenImageURL;
      });
      tokenList := Buffer.toArray(newTokenList);
    };

    public func getTokenList() : [T.TokenInfo] {
      return tokenList;
    };

    public func canAffordEntryFee(defaultAccount: Principal, canisterId: T.CanisterId, managerId: T.PrincipalId) : async Bool {
      
      //get the entry details for the league
      let entryFee: Nat64 = 0;

      let ledger : SNSToken.Interface = actor (canisterId);
      
      let source_account = Account.accountIdentifier(defaultAccount, Account.principalToSubaccount(Principal.fromText(managerId)));
      let checkAccount : SNSToken.Account = {
        owner = Principal.fromBlob(source_account);
        subaccount = null;
      };

      let balance = Nat64.fromNat(await ledger.icrc1_balance_of(checkAccount));

      return balance >= entryFee;
    };

    public func payEntryFee(defaultAccount: Principal, canisterId: T.CanisterId, managerId: T.PrincipalId) : async (){
      
      //get the entry details for the league
      let entryFee: Nat = 0;
      let token_fee: Nat = 0;

      let ledger : SNSToken.Interface = actor (canisterId);
      
      let _ = await ledger.icrc1_transfer({
        memo = ?Blob.fromArray([]);
        from_subaccount = ?Account.principalToSubaccount(Principal.fromText(managerId));
        to = {owner = defaultAccount; subaccount = ?Account.defaultSubaccount()};
        amount = entryFee - token_fee ;
        fee = ?token_fee;
        created_at_time = ?Nat64.fromNat(Int.abs(Time.now()));
      });
    };

  };
};

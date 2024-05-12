import Account "./lib/Account";
import ICPLedger "./def/Ledger";
import Int "mo:base/Int";
import Nat64 "mo:base/Nat64";
import Time "mo:base/Time";
import Principal "mo:base/Principal";
import Iter "mo:base/Iter";
import Buffer "mo:base/Buffer";
import Result "mo:base/Result";
import Blob "mo:base/Blob";
import Int64 "mo:base/Int64";
import Float "mo:base/Float";
import Nat8 "mo:base/Nat8";
import Environment "utils/Environment";
import DTOs "DTOs";
import T "types";
import Tokens "Tokens";
import SNSToken "sns-wrappers/ledger";
import Debug "mo:base/Debug";
import Nat "mo:base/Nat";

module {

  public class TreasuryManager() {

    public type ConversionRateResponse = {
      data : Nat;
    };
    
    let icp_fee : Nat64 = 10_000;
    let memo_txt_tpup : Nat64 = 0x50555054;
    private let ledger : ICPLedger.Interface = actor (ICPLedger.CANISTER_ID);
    private var tokenList: [T.TokenInfo] = Tokens.tokens;
    private var nextTokenId : Nat16 = 35;

    public func getStableTokenList() : [T.TokenInfo] {
      return tokenList;
    };

    public func setStableTokenList(stable_token_list: [T.TokenInfo]){
      tokenList := stable_token_list;
    };

    public func getStableNextTokenId() : Nat16 {
      return nextTokenId;
    };

    public func setStableNextTokenId(stable_next_token_id: Nat16){
      nextTokenId := stable_next_token_id;
    };

    public func getUserAccountBalance(defaultAccount : Principal, user : Principal) : async Nat64 {
      let source_account = Account.accountIdentifier(defaultAccount, Account.principalToSubaccount(user));
      let balance = await ledger.account_balance({ account = source_account });
      return balance.e8s;
    };

    public func sendICPForCycles(treasuryAccount : Account.AccountIdentifier, cyclesRequested : Nat64) : async () {

      if (cyclesRequested <= 0) {
        return;
      };

      Debug.print("Cycle minting canister");
      Debug.print(Environment.CYCLES_MINTING_CANISTER_ID);
      let cycles_minting_canister = actor (Environment.CYCLES_MINTING_CANISTER_ID) : actor {
        get_icp_xdr_conversion_rate : () -> async ConversionRateResponse;
      };
      let converstionRate : ConversionRateResponse = await cycles_minting_canister.get_icp_xdr_conversion_rate();

      Debug.print("conversion rate");
      Debug.print(Nat.toText(converstionRate.data));
      let icp_required : Nat64 = cyclesRequested / Nat64.fromNat(converstionRate.data) / 1_000_000;
      Debug.print("icp_required");
      Debug.print(Nat64.toText(icp_required));

      let balance = await ledger.account_balance({ account = treasuryAccount });
      Debug.print("balance");
      Debug.print(Nat64.toText(balance.e8s));

      if (balance.e8s < icp_fee) {
        return;
      };

      let withdrawable = balance.e8s - icp_fee;

      if (icp_required >= withdrawable) {
        return;
      };

      let target_account = Account.accountIdentifier(Principal.fromText(Environment.CYCLES_MINTING_CANISTER_ID), Account.principalToSubaccount(Principal.fromText(Environment.BACKEND_CANISTER_ID)));

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
        id = nextTokenId;
        canisterId = newTokenDTO.canisterId;
        ticker = newTokenDTO.ticker;
        tokenImageURL = newTokenDTO.tokenImageURL;
        fee = newTokenDTO.fee;
      });
      tokenList := Buffer.toArray(newTokenList);
      nextTokenId := nextTokenId + 1;
    };

    public func getTokenList() : [T.TokenInfo] {
      return tokenList;
    };  



    public func canAffordPrivateLeague(defaultAccount: Principal, managerId: T.PrincipalId, paymentChoice: T.PaymentChoice) : async Bool{
      
      var ledgerCanisterId = Environment.NNS_LEDGER_CANISTER_ID;
      var entryFee: Nat64 = 100_000_000;
      var fee: Nat64 = 10_000;

      switch(paymentChoice){
        case (#ICP){ };
        case (#FPL){
          
          let icp_coins_canister = actor (Environment.ICP_COINS_CANISTER_ID) : actor {
            get_latest : () -> async [DTOs.ICPCoinsResponse];
          };

          let allCoins = await icp_coins_canister.get_latest();

          for(coinRecord in Iter.fromArray(allCoins)){
            if(coinRecord.pairName == "FPL/ICP"){
              if(coinRecord.price <= 0){
                return false;
              };
              entryFee := Int64.toNat64(Float.toInt64(1 / coinRecord.price));
            }
          };

          ledgerCanisterId := Environment.SNS_LEDGER_CANISTER_ID;
          fee := 100_000; 
        };
      };
      
      let ledger : SNSToken.Interface = actor (ledgerCanisterId);

      let source_account = Account.accountIdentifier(defaultAccount, Account.principalToSubaccount(Principal.fromText(managerId)));
      let checkAccount : SNSToken.Account = {
        owner = Principal.fromBlob(source_account);
        subaccount = null;
      };

      let balance = Nat64.fromNat(await ledger.icrc1_balance_of(checkAccount));

      return balance >= entryFee;
    };

    public func canAffordEntryFee(defaultAccount: Principal, canisterId: T.CanisterId, managerId: T.PrincipalId) : async Bool {
        
      let private_league_canister = actor (canisterId) : actor {
        getPrivateLeague : () -> async Result.Result<DTOs.PrivateLeagueDTO, T.Error>;
      };

      let privateLeague = await private_league_canister.getPrivateLeague();

      switch(privateLeague){
        case (#ok foundPrivateLeague){
          for(token in Iter.fromArray(tokenList)){
            if(token.id == foundPrivateLeague.tokenId){
              let ledger : SNSToken.Interface = actor (token.canisterId);

              let source_account = Account.accountIdentifier(defaultAccount, Account.principalToSubaccount(Principal.fromText(managerId)));
              let checkAccount : SNSToken.Account = {
                owner = Principal.fromBlob(source_account);
                subaccount = null;
              };

              let balance = await ledger.icrc1_balance_of(checkAccount);

              return balance >= foundPrivateLeague.entryFee;
            };
          };
          return false;
        };
        case _ {
          return false;
        };
      };
    };

    public func payEntryFee(defaultAccount: Principal, canisterId: T.CanisterId, managerId: T.PrincipalId) : async (){

      let private_league_canister = actor (canisterId) : actor {
        getPrivateLeague : () -> async Result.Result<DTOs.PrivateLeagueDTO, T.Error>;
      };

      let privateLeague = await private_league_canister.getPrivateLeague();

      switch(privateLeague){
        case (#ok foundPrivateLeague){
          
          var hasAdminFee = false;
          var adminFee: Nat = 0;
          var remainingFee: Nat = 0;
          if(foundPrivateLeague.adminFee > 0){
            hasAdminFee := true;
            adminFee := Nat8.toNat(foundPrivateLeague.adminFee) * foundPrivateLeague.entryFee / 100;
            remainingFee := foundPrivateLeague.entryFee - adminFee;
          };
                    
          let tokenId = foundPrivateLeague.tokenId;
          for(token in Iter.fromArray(tokenList)){
            if(token.id == tokenId){
              let ledger : SNSToken.Interface = actor (token.canisterId);
              
              let _ = await ledger.icrc1_transfer({
                memo = ?Blob.fromArray([]);
                from_subaccount = ?Account.principalToSubaccount(Principal.fromText(managerId));
                to = {owner = defaultAccount; subaccount = ?Account.defaultSubaccount()};
                amount = remainingFee - token.fee ;
                fee = ?token.fee;
                created_at_time = ?Nat64.fromNat(Int.abs(Time.now()));
              });

              if(not hasAdminFee){
                return;
              };
              
              let _ = await ledger.icrc1_transfer({
                memo = ?Blob.fromArray([]);
                from_subaccount = ?Account.principalToSubaccount(Principal.fromText(managerId));
                to = {owner = defaultAccount; subaccount = ?Account.principalToSubaccount(Principal.fromText(foundPrivateLeague.creatorPrincipalId))};
                amount = adminFee - token.fee ;
                fee = ?token.fee;
                created_at_time = ?Nat64.fromNat(Int.abs(Time.now()));
              });
            };
          }
        };
        case (_){};
      };
    };

  };
};

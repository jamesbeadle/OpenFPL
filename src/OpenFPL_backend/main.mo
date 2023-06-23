import Principal "mo:base/Principal";
import Array "mo:base/Array";
import Blob "mo:base/Blob";
import DTOs "DTOs";
import Profiles "profiles";
import Account "Account";
import Book "book";
import Nat64 "mo:base/Nat64";
import Result "mo:base/Result";
import T "types";

actor Self {

  let admins : [Principal] = [
    Principal.fromText("ld6pc-7sgvt-fs7gg-fvsih-gspgy-34ikk-wrwl6-ixrkc-k54er-7ivom-wae")
  ];

  let profilesInstance = Profiles.Profiles();
  let bookInstance = Book.Book();

  //admin functions
  private func isAdminForCaller(caller: Principal): Bool {
    switch (Array.find<Principal>(admins, func (admin) { admin == caller })) {
      case null { false };
      case _ { true };
    };
  };
  
  public shared query ({caller}) func isAdmin(): async Bool {
    return isAdminForCaller(caller);
  };

  public shared query ({caller}) func getProfileDTO() : async DTOs.ProfileDTO {
    assert not Principal.isAnonymous(caller);
    let principalName = Principal.toText(caller);
    var depositAddress = Blob.fromArray([]);
    var displayName = "";

    var profile = profilesInstance.getProfile(Principal.toText(caller));
    
    if(profile == null){
      profilesInstance.createProfile(Principal.toText(caller), Principal.toText(caller), getUserDepositAccount(caller));
      profile := profilesInstance.getProfile(Principal.toText(caller));
    };
    
    switch(profile){
      case (null){};
      case (?p){
        depositAddress := p.depositAddress;
        displayName := p.displayName;
      };
    };

    let profileDTO: DTOs.ProfileDTO = {
      principalName = principalName;
      depositAddress = depositAddress;
      displayName = displayName;
    };
    
  };

  
  public shared ({caller}) func getAccountBalanceDTO() : async DTOs.AccountBalanceDTO {
    
    assert not Principal.isAnonymous(caller);
    let principalName = Principal.toText(caller);
    var accountBalance = Nat64.fromNat(0);

    //accountBalance := await bookInstance.getUserAccountBalance(Principal.fromActor(Self), caller);
    
    let accountBalanceDTO: DTOs.AccountBalanceDTO = {
      accountBalance = accountBalance;
    };

    return accountBalanceDTO;
  };


  private func getUserDepositAccount(caller: Principal) : Account.AccountIdentifier {
    Account.accountIdentifier(Principal.fromActor(Self), Account.principalToSubaccount(caller))
  };

  public shared query ({caller}) func isDisplayNameValid(displayName: Text) : async Bool {
    assert not Principal.isAnonymous(caller);
    return profilesInstance.isDisplayNameValid(displayName);
  };

  
  public shared ({caller}) func withdrawICP(amount: Float, withdrawalAddress: Text) : async Result.Result<(), T.Error> {
    assert not Principal.isAnonymous(caller);
    
    let userProfile = profilesInstance.getProfile(Principal.toText(caller));
    
    switch userProfile {
      case (null) {
        return #err(#NotFound);
      };
      case (?profile) {
        if(not profilesInstance.isWalletValid(withdrawalAddress)){
          return #err(#NotAllowed);
        };
        return await bookInstance.withdrawICP(Principal.fromActor(Self), caller, amount, withdrawalAddress);
      };
    };
  };


  let CANISTER_IDS = {
    token_canister = "tqtu6-byaaa-aaaaa-aaana-cai";
  };
  
  let tokenCanister = actor (CANISTER_IDS.token_canister): actor { icrc1_name: () -> async Text };

  public query func greet(name : Text) : async Text {
    return "Hello, " # name # "!";
  };

  public func getTokenName() : async Text {
    let name = await tokenCanister.icrc1_name();
    return "Token Name:, " # name # "!";
  };

  public func mintTokens() : async (){
    
  };  
};

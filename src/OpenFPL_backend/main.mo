actor {

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
};

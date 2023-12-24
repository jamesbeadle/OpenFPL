import Cycles "mo:base/ExperimentalCycles";

shared(msg) actor class CyclesWatcher(
  benefit : shared () -> async (),
  capacity: Nat,
  canisterIds : shared () -> async ()
  ) {

  let owner = msg.caller;

  public func topUpCanisters() : async () {

    //for each canister check if the balance is low and top it up if it is
        //what should I topup to?


/*
    let amount = Cycles.available();
    let limit : Nat = capacity - /;
    let acceptable =
      if (amount <= limit) amount
      else limit;
    let accepted = Cycles.accept(acceptable);
    assert (accepted == acceptable);
 */
  };

}

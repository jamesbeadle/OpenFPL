import Nat64 "mo:base/Nat64";
import Principal "mo:base/Principal";
import Blob "mo:base/Blob";
import Time "mo:base/Time";
import Int64 "mo:base/Int64";
import Array "mo:base/Array";
import Result "mo:base/Result";
import Account "../lib/Account";
import CanisterIds "../CanisterIds";
import T "../types";
import Environment "../Environment";

module {

  public class Governance() {

    let network = Environment.DFX_NETWORK;
    var governance_canister_id = CanisterIds.GOVERNANCE_CANISTER_IC_ID; //TODO: UPDATE POST SNS

  };
};

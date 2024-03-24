import ECDSA "mo:tecdsa";
import Loopback "../";
import { Fees } "mo:utilities";

module {

  public type State = {
    var self_id : Text;
    var initialized : Bool;
    var fees : Fees.State;
    var ecdsa_client : ECDSA.Client.State;
    var ecdsa_identity : ECDSA.Identity.State;
    var loopback_client : Loopback.Client.State;
    var loopback_agent : Loopback.Agent.State;
  };

  public type InitParams = {
    fees : [(Text, Nat64)];
    canister_id : Text;
    key_id : ECDSA.Identity.KeyId;
    seed_phrase : ?ECDSA.Identity.SeedPhrase;
  };
  
  public type Identity = ECDSA.Identity.Identity;

  public type AsyncReturn<T> = ECDSA.Identity.AsyncReturn<T>;

}
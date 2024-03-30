import { toArray = blobToArray; fromArray = blobFromArray } "mo:base/Blob";
import { toNat = nat64ToNat } "mo:base/Nat64";
import { KeyId; PublicKey } "../Client";
import { tabulate } "mo:base/Array";
import { hashSeedPhrase } "utils";
import { trap } "mo:base/Debug";
import { STATE_SIZE } "const";
import S "state";
import T "types";

module {

  public class Identity(state_: S.State, client: T.Client) = {
  
    let state = S.unwrap( state_ );
    
    if ( state.size() != nat64ToNat( STATE_SIZE ) ) trap("mo:tecdsa/identity/class: line 16");

    public let (key_id, public_key, derivation_path) = do {
      let bytes : [Nat8] = blobToArray( state );
      let derivation_path : [Blob] = [blobFromArray( tabulate<Nat8>(32, func(i) = bytes[i+90]) )];
      let public_key : T.PublicKey = tabulate<Nat8>(88, func(i) = bytes[i+2]);
      let key_id : T.KeyId = switch( KeyId.fromTag((bytes[0], bytes[1])) ){
        case null trap("mo:tecdsa/identity/class: line 19");
        case( ?key_id ) key_id
      };
      (key_id, public_key, derivation_path)
    };

    public func get_principal() : Principal = PublicKey.toPrincipal( public_key );
    
    public func is_owner_seed_phrase(phrase: T.SeedPhrase): Bool {
      let hash : Blob = hashSeedPhrase( phrase );
      hash == derivation_path[0]
    };

    public func sign(msg: T.Message): async* T.AsyncReturn<T.Signature>{
      await* client.request_signature(msg, {
        derivation_path = derivation_path;
        canister_id = null;
        key_id = key_id;
      })
    };

  };


};
import { SECP256K1 = { DER_PRESTRING }} "const";
import Cycles "mo:base/ExperimentalCycles";
import { tabulate } "mo:base/Array";
import { trap } "mo:base/Debug";
import { Fees } "mo:utilities";
import Sha256 "mo:sha2/Sha256";
import Nat64 "mo:base/Nat64";
import Error "mo:base/Error";
import State "state";
import KeyId "keyid";
import T "types";
import PK "pk";

module {

  public class Client(state_: State.State) = {

    let state = State.unwrap( state_ );

    let fees = Fees.Fees( state.fees );

    let server : T.IC = actor( state.canister_id );

    public func calculate_fee(key_id: T.KeyId): T.ReturnFee = fees.get( key_id.name );

    public func request_public_key(params: T.Params): async* T.AsyncReturn<T.PublicKey> {
      try {
        //let curve: T.Curve = params.key_id.curve;
        let pre_string : [Nat8] = DER_PRESTRING;
        let { public_key } = await server.ecdsa_public_key({
          canister_id = params.canister_id;
          derivation_path = params.derivation_path;
          key_id = params.key_id;
        });
        let header_size: Nat = pre_string.size();
        let encoded_size: Nat = header_size + 65;
        let decompressed_key: [Nat8] = PK.fromCompressedKey( public_key );
        let encoded_key = tabulate<Nat8>(encoded_size, func(i): Nat8 {
          if ( i < header_size ) pre_string[i] else decompressed_key[i - header_size]
        });
        #ok(  encoded_key )
      } catch (e) {
        #err(#trapped(Error.message(e)))
      }
    };

    public func request_signature<system>(msg: T.Message, params: T.Params): async* T.AsyncReturn<T.Signature> {
      try {
        let hash: Blob = Sha256.fromBlob(#sha256, msg);
        switch( fees.get( params.key_id.name ) ){
          case( #err msg ) #err(msg);
          case( #ok fee ){
            Cycles.add<system>( Nat64.toNat(fee) );
            let { signature } = await server.sign_with_ecdsa({
              message_hash = hash;
              derivation_path = params.derivation_path;
              key_id = params.key_id;
            });
            #ok(signature)
        }};
      } catch (e) {
        #err(#trapped(Error.message(e)))
      }
    };

  };

};
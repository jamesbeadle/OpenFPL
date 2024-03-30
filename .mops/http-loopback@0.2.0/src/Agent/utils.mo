import Buffer "mo:base/Buffer";
import Cbor "../Cbor";
import Time "mo:base/Time";
import Blob "mo:base/Blob";
import Nat64 "mo:base/Nat64";
import { Identity } "mo:tecdsa";
import { init; mapEntries; tabulate } "mo:base/Array";
import { toBlob = principalToBlob; fromText = principalFromText } "mo:base/Principal";
import { fromNat = natToNat64 } "mo:base/Nat64";
import Hash "mo:rep-indy-hash";
import T "types";

module {

  type Identity = Identity.Identity;

  public let IC_REQUEST_DOMAIN_SEPERATOR : [Nat8] = [10, 105, 99, 45, 114, 101, 113, 117, 101, 115, 116]; // "\0Aic-request";

  public func sign_request(identity: Identity, request: T.Request): async* T.SignResponse {
    let hash : [Nat8] = hash_content( request );
    let request_id : T.RequestId = to_request_id( hash );
    let message_id : Blob = to_message_id( hash );
    switch( await* identity.sign(message_id) ){
      case( #err msg ) #err(msg);
      case( #ok sig ){
        let envelope = Cbor.load([]);
        envelope.set( "content", #majorType5(map_content( request )) );
        envelope.set( "sender_pubkey", #majorType2( identity.public_key) );
        envelope.set( "sender_sig", #majorType2(Blob.toArray(sig)) );
        #ok(request_id, Cbor.dump(envelope))
      }
    }
  };

  func to_request_id(hash: [Nat8]): Blob = Blob.fromArray(hash);

  func to_message_id(hash: [Nat8]): Blob {
    Blob.fromArray(
      tabulate<Nat8>(43, func(i) = 
        if ( i < 11 ) IC_REQUEST_DOMAIN_SEPERATOR[i]
        else hash[i - 11]
      )
    )
  };

  func map_content(req: T.Request): Cbor.CborMap {
    let content = Cbor.load([]);
    content.set( "sender", #majorType2(Blob.toArray(req.sender)) );
    content.set( "ingress_expiry", #majorType0(natToNat64(req.ingress_expiry)) );
    switch( req.nonce ){
      case( ?nonce ) content.set( "nonce", #majorType2(Blob.toArray(nonce)) );
      case null ();
    };
    switch( req.request ){
      case( #update_method params ){
        content.set( "request_type", #majorType3("call") );
        content.set( "canister_id", #majorType2(Blob.toArray(principalToBlob(principalFromText(params.canister_id)))) );
        content.set( "method_name", #majorType3(params.method_name) );
        content.set( "arg", #majorType2(Blob.toArray(params.arg)) );
      };
      case( #query_method params ){
        content.set( "request_type", #majorType3("query") );
        content.set( "canister_id", #majorType2(Blob.toArray(principalToBlob(principalFromText(params.canister_id)))) );
        content.set( "method_name", #majorType3(params.method_name) );
        content.set( "arg", #majorType2(Blob.toArray(params.arg)) );
      };
      case( #read_state params ){
        content.set( "request_type", #majorType3("read_state") );
        content.set( "paths",
          #majorType4( mapEntries<[Blob], T.CborArray>(params.paths, func(state_path, _): T.CborArray {
            #majorType4( mapEntries<Blob, T.CborBytes>(state_path, func(path_label, _): T.CborBytes {
              #majorType2( Blob.toArray(path_label) )
            }))
          }))
        )
      }};
    content.map_cbor()
  };

  func hash_content(req: T.Request): [Nat8] {
    let buffer = Buffer.Buffer<(Text, Hash.Value)>(4);
    buffer.add( ("sender", #Blob(req.sender)) );
    buffer.add( ("ingress_expiry", #Nat(req.ingress_expiry)) );
    switch( req.nonce ){
      case( ?nonce ) buffer.add(("nonce", #Blob(nonce)));
      case null ();
    };
    switch( req.request ){
      case( #update_method params ){
        buffer.add(("request_type", #Text("call")));
        buffer.add(("canister_id", #Blob(principalToBlob(principalFromText(params.canister_id)))));
        buffer.add(("method_name", #Text(params.method_name)));
        buffer.add(("arg", #Blob(params.arg)));
      };
      case( #query_method params ){
        buffer.add(("request_type", #Text("query")));
        buffer.add(("canister_id", #Blob(principalToBlob(principalFromText(params.canister_id)))));
        buffer.add(("method_name", #Text(params.method_name)));
        buffer.add(("arg", #Blob(params.arg)));
      };
      case( #read_state params ){
        buffer.add(("request_type", #Text("read_state")));
        buffer.add(("paths",
          #Array( mapEntries<[Blob], Hash.Value>(params.paths, func(state_path, _): Hash.Value {
            #Array( mapEntries<Blob, Hash.Value>(state_path, func(path_label, _): Hash.Value {
              #Blob(path_label)
            }))
          }))
        ))
      }};
    Hash.hash_val( #Map( Buffer.toArray<(Text, Hash.Value)>( buffer ) ) )
  };

};
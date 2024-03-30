import { fromArray = blobFromArray } "mo:base/Blob";
import { encodeUtf8; decodeUtf8 } "mo:base/Text";
import Principal "mo:base/Principal";
import { sign_request } "utils";
import { Nonce } "mo:utilities";
import Time "mo:base/Time";
import { abs } "mo:base/Int";
import Cbor "../Cbor";
import State "state";
import T "types";

module {

  type Attempts = { var count : Nat };

  public class Agent(state_: T.State, client : T.Client, identity: T.Identity) = {

    let state = State.unwrap( state_ );

    let nonce_factory = Nonce.Nonce( state.nonce );

    public func query_method(req: T.CallRequest) : async* T.Response {
      switch( await* sign_and_send(#query_method(req), null) ){
        case( #err msg ) #err(msg);
        case( #ok(_, response) ){
          switch( response ){
            case( #replied candid ) #ok( blobFromArray( candid ) );
            case( #rejected _ ) #err(#fatal("mo:http-loopback/Agent/class: line 25"));
            case( #unknown _ ) #err(#fatal("mo:http-loopback/Agent/class: line 26"));
          }
        }
      }
    };

    public func update_method(req: T.CallRequest) : async* T.Response {
      switch( await* sign_and_send(#update_method(req), null) ){
        case( #err msg ) return #err(msg);
        case( #ok(req_id, response) ){
          switch( response ){
            case( #rejected msg){
              let ?reject_message = decodeUtf8( blobFromArray( msg ) ) else { return #err(#fatal("Failed to decode response")) };
              return #err(#rejected(reject_message))
            };
            case _ ()
          };
          var attempts : Nat = 0;
          let expiration : Int = Time.now() + state.ingress_expiry;
          while true {
            attempts += 1;
            if ( Time.now() >= expiration ) return #err(#expired);
            switch(
              await* sign_and_send(
                #read_state({
                  canister_id = req.canister_id;
                  max_response_bytes = req.max_response_bytes;
                  paths = [[ encodeUtf8("request_status"), req_id ]];
                }), ?req_id
              )
            ){
              case( #err msg ) return #err(msg);
              case( #ok (_, status) ){
                switch( status ){
                  case( #unknown ) ();
                  case( #replied candid ) return #ok( blobFromArray( candid ) );
                  case( #rejected msg ){
                    let ?reject_message = decodeUtf8( blobFromArray( msg ) ) else { return #err(#fatal("Failed to decode response")) };
                    return #err(#rejected(reject_message))
                  }
                }
              }
            }
          }; #err(#fatal("mo:http-loopback/Agent/class: line 80"))
        }
      }
    };

    func sign_and_send(rtype: T.RequestType, opt_context: ?Blob): async* T.SignAndSendResponse {

      let (cid, mrb, client_endpoint) = switch( rtype ){
        case( #read_state req ) (req.canister_id, req.max_response_bytes, client.read_state_endpoint);
        case( #query_method req ) (req.canister_id, req.max_response_bytes, client.query_endpoint);
        case( #update_method req ) (req.canister_id, req.max_response_bytes, client.call_endpoint);
      };

      switch(
        await* sign_request(
          identity, 
          {
            sender = Principal.toBlob( identity.get_principal() );
            ingress_expiry = abs(Time.now()) + state.ingress_expiry;
            nonce = ?nonce_factory.next_blob();
            request = rtype;
          }
        )
      ){
        case( #err msg ) #err(msg);
        case( #ok (reqid, env) ){
          let context = switch opt_context {case(?x)x;case null reqid};
          let request = {
            max_response_bytes = mrb;
            canister_id = cid;
            envelope = env;
          };

          switch( await* client_endpoint(request, context)) {
            case( #ok content ) #ok(reqid, content);
            case( #err msg ) #err(msg);
          }

        }
      } 
    };

  };



};
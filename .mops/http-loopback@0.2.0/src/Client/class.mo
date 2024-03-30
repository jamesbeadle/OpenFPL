import { fromNat = natToNat64; toNat = nat64ToNat } "mo:base/Nat64";
import { add = addCycles } "mo:base/ExperimentalCycles";
import { toNat = nat32ToNat } "mo:base/Nat32";
import { Nonce; Fees } "mo:utilities";
import Error "mo:base/Error";
import Cbor "../Cbor";
import S "state";
import T "types";
import C "const";
import H "http";

module {

  public class Client(state_: S.State, transformFn: H.TransformFunction) = {

    let ic : H.IC = actor("aaaaa-aa");

    let state = S.unwrap( state_ );
    
    let fees = Fees.Fees( state.fees );

    let nonce_factory = Nonce.Nonce( state.nonce );

    public func set_path(t: Text): () { state.path := t };

    public func set_domain(t: Text): () { state.domain := t };

    public func set_fee(k: Text, v: Nat64): () = fees.set(k, v);
    
    public func get_path(): Text = state.path;

    public func get_domain(): Text = state.domain;

    public func get_fee(k: Text): T.ReturnFee = fees.get(k);

    public func query_endpoint(request: T.Request, request_id: Blob): async* T.Response {
      await* canister_endpoint(request, request_id, "/query")
    };

    public func call_endpoint(request: T.Request, request_id: Blob): async* T.Response {
      await* canister_endpoint(request, request_id, "/call")
    };

    public func read_state_endpoint(request: T.Request, request_id: Blob): async* T.Response {
      await* canister_endpoint(request, request_id, "/read_state")
    };

    public func calculate_fee(request_bytes: Nat64, response_bytes: ?Nat64): T.ReturnFee {
      let max_response : Nat64 = switch(response_bytes){case(?n64)n64;case null C.DEFAULT_MAX_RESPONSE_BYTES};
      let #ok(base_fee) = fees.get(C.FEES.ID.PER_CALL) else { return #err(#fee_not_defined(C.FEES.ID.PER_CALL)) };
      let #ok(request_fee) = fees.multiply(C.FEES.ID.PER_REQUEST_BYTE, request_bytes) else { return #err(#fee_not_defined(C.FEES.ID.PER_REQUEST_BYTE)) };
      let #ok(response_fee) = fees.multiply(C.FEES.ID.PER_RESPONSE_BYTE, max_response) else { return #err(#fee_not_defined(C.FEES.ID.PER_RESPONSE_BYTE)) };
      #ok(base_fee + request_fee + response_fee + 600_000)
    };
  
    func canister_endpoint(request: T.Request, request_id: Blob, endpoint: Text): async* T.Response {
      switch( calculate_fee(natToNat64(request.envelope.size()), request.max_response_bytes) ) {
        case( #err msg ) #err(msg);
        case( #ok fee ){
          addCycles( nat64ToNat(fee) );
          process_http_response(
            try {
              await ic.http_request({
                method = #post;
                body = ?request.envelope;
                max_response_bytes = request.max_response_bytes;
                transform = ?{context = request_id; function = transformFn};
                url = state.domain # state.path # request.canister_id # endpoint;
                headers = [
                  { name = "Content-Type"; value = "application/cbor" },
                  { name = "Idempotency-Key"; value = nonce_factory.next_string() }
                ]
              })
            } catch (e) switch( Error.code(e) ){
              case( #system_fatal ) return error_response(Error.message(e), 1);
              case( #system_transient ) return error_response(Error.message(e), 2);
              case( #destination_invalid ) return error_response(Error.message(e), 3);
              case( #canister_reject ) return error_response(Error.message(e), 4);
              case( #canister_error ) return error_response(Error.message(e), 5);
              case( #future n ) return error_response(Error.message(e), nat32ToNat(n));
              case( #call_error e_ ) return error_response(Error.message(e), nat32ToNat(e_.err_code))
            }
          )
        }
      }
    };

    func process_http_response(res: H.HttpResponsePayload) : T.Response {
      if ( res.status != 200 ) return #err(#other("unexpected response status; are you using the transform function?"));
      let content = Cbor.load( res.body );
      let ?status = content.get<Text>("status", Cbor.getText) else { return #err(#missing("status field")) };
      if ( status == "processing" ) #ok(#unknown)
      else if ( status == "replied" ){
        let ?response = content.get<[Nat8]>("response", Cbor.getBytearray) else { return #err(#missing("response")) };
        #ok(#replied(response))
      }
      else if ( status == "rejected"){
        let ?response = content.get<[Nat8]>("response", Cbor.getBytearray) else { return #err(#missing("response")) };
        #ok(#rejected(response))
      }
      else if ( status == "error" ){
        let ?error_message = content.get<Text>("error", Cbor.getText) else { return #err(#missing("error message")) };
        #err(#rejected(error_message))
      }
      else #err(#other("unexpected response status; are you using the transform function?"))
    };

    func error_response(msg: Text, code: Nat): T.Response {
      switch( code ){
        case( 1 ) #err( #rejected("sys_fatal: " # msg) );
        case( 2 ) #err( #rejected("sys_transient: " # msg) );
        case( 3 ) #err( #rejected("destination_invalid: " # msg) );
        case( 4 ) #err( #rejected("canister_reject: " # msg) );
        case( 5 ) #err( #rejected("canister_error: " # msg) );
        case( v ) #err( #rejected("invalid_reject_code: "  # debug_show(v)) )
      }
    };
  
  };

};
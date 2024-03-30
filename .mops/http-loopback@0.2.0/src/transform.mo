import Cbor "Cbor";
import { Http } "Client";
import { toArray = blobToArray } "mo:base/Blob";
import { encodeUtf8; decodeUtf8 } "mo:base/Text";
import { toNat = nat64ToNat } "mo:base/Nat64";

module {

  public func transform(args: Http.TransformArgs): Http.HttpResponsePayload {
    if ( args.response.status >= 500 ) return respond_error("server error: " # debug_show(args.response.status));
    if ( args.response.status >= 400 ) return respond_error("malformed request: " # debug_show(args.response.status));
    switch( args.response.status ){
      case( 202 ) respond_status("processing", []);
      case( 200 ){
        let content = Cbor.load( args.response.body );
        switch( check_rejected( content ) ){
          case( ?(status, response)) respond_status(status, response);
          case null switch( check_query( content ) ){
            case( ?(status, response) ){
              if ( response.size() == 0 ) respond_error(status)
              else respond_status(status, response)
            };
            case null switch( check_read_state(content, args.context) ){
              case( ?(status, response) ){
                if ( response.size() == 0 ){
                  if (status != "processing") respond_error(status)
                  else respond_status(status, response)
                }
                else respond_status(status, response)
              };
              case null respond_error("cannot locate any response values")
            }
          }
        }
      };
      case( v ) respond_error("unrecognized response status: " # debug_show(v))
    }
  };

  func check_read_state(content: Cbor.ContentMap, reqid: Blob): ?(Text, [Nat8]) {
            switch( content.get<[Nat8]>("certificate", Cbor.getBytearray) ){
              case( ?call_response ){
                let certificate = Cbor.load( call_response );
                switch( certificate.get<Cbor.CborArray>("tree", Cbor.getArray ) ){
                  case( ?tree ){
                    let hashtree = Cbor.HashTree( tree );
                    let path = [encodeUtf8("request_status"), reqid, encodeUtf8("status")];
                    switch( hashtree.lookup( path ) ){
                      case( ?encoded_status ){
                        switch( decodeUtf8( encoded_status ) ){
                          case( ?status ){
                            if( status == "replied" ){
                              let res_path = [encodeUtf8("request_status"), reqid, encodeUtf8("reply")];
                              let ?candid = hashtree.lookup( res_path ) else { return ?("missing canister response", []) };
                              ?(status, blobToArray( candid ) )
                            }
                            else if( status == "rejected" ){
                              let msg_path = [encodeUtf8("request_status"), reqid, encodeUtf8("reject_message")];
                              let ?reject_message = hashtree.lookup( msg_path ) else { return ?("missing reject_message", []) };
                              ?(status, blobToArray(reject_message))
                            }
                            else ?("processing", [])
                          };
                          case null ?("failed to decode request status", [])
                        }
                      };
                      case null ?("missing request status", [])
                    }
                  };
                  case null ?("missing hashtree", [])
                }
              };
              case null ?("missing certificate", [])
            }
  };

  func check_rejected(content: Cbor.ContentMap): ?(Text, [Nat8]){
    let ?reject_code = content.get<Nat64>("reject_code", Cbor.getNat64) else { return null };
    let ?reject_message = content.get<Text>("reject_message", Cbor.getText) else { return null };
    ?("rejected", blobToArray( encodeUtf8( error_response(reject_message, reject_code) )) )
  };
 
  func check_query(content: Cbor.ContentMap): ?(Text, [Nat8]) {
    switch( content.get<Text>("status", Cbor.getText) ){
      case null null;
      case( ?status ){
        if ( status == "replied" ){
          let ?map = content.get<Cbor.CborMap>("reply", Cbor.getMap) else { return ?("missing query reply", []) };
          let response = Cbor.populated(Cbor.from_cbor_map( map ) );
          let ?arg = response.get<[Nat8]>("arg", Cbor.getBytearray) else { return ?("missing query reply arg", []) };
          ?(status, arg)
        }
        else if ( status == "rejected" ){
          let ?reject_message = content.get<Text>("reject_message", Cbor.getText) else { return ?("missing reject_message", []) };
          ?(status, blobToArray(encodeUtf8(reject_message)))
        }
        else ?("unknown response status", [])
      }
    };
  };


  func error_response(msg: Text, code: Nat64): Text {
    switch( code ){
      case( 1 ) "sys_fatal: " # msg;
      case( 2 ) "sys_transient: " # msg;
      case( 3 ) "destination_invalid: " # msg;
      case( 4 ) "canister_reject: " # msg;
      case( 5 ) "canister_error: " # msg;
      case( v ) "invalid_reject_code: "  # debug_show(v)
    }
  };

  func respond_status(status: Text, response: [Nat8]): Http.HttpResponsePayload {
    let content = Cbor.load([]);
    content.set("status", #majorType3( status ));
    content.set("response", #majorType2( response ));
    {status=200; body = Cbor.dump( content ); headers=[]};
  };

  func respond_error(message: Text): Http.HttpResponsePayload {
    let content = Cbor.load([]);
    content.set("status", #majorType3("error"));
    content.set("error", #majorType3( message ));
    {status=200; body = Cbor.dump( content ); headers=[]}
  };

};
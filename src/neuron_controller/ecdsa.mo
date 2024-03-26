import Principal "mo:base/Principal";
import Result "mo:base/Result";
import Blob "mo:base/Blob";
import Types "types";
import SHA256 "./SHA256";   
import Nat64 "mo:base/Nat64";
import Nat "mo:base/Nat";
import Value "mo:cbor/Value";
import CborEncoder "mo:cbor/Encoder";
import Cbor "Cbor";
import CborTypes "Cbor_Types";
import { fromNat = natToNat64 } "mo:base/Nat64";
import { toBlob = principalToBlob; fromText = principalFromText } "mo:base/Principal";
import { init; mapEntries; tabulate } "mo:base/Array";
import { encodeUtf8; decodeUtf8 } "mo:base/Text";

module {

    public class ECDSA() {

        type TransformFunction = shared query TransformArgs -> async HttpResponsePayload;

        type TransformArgs = {
            response : HttpResponsePayload;
            context : Blob;
        };

        type HttpResponsePayload = {
            status : Nat;
            headers : [HttpHeader];
            body : [Nat8];
        };

        public type HttpHeader = {
            name : Text;
            value : Text;
        };

        type IC = actor {
            ecdsa_public_key : ({
                canister_id : ?Principal;
                derivation_path : [Blob];
                key_id : { curve: { #secp256k1; } ; name: Text };
                }) -> async ({ public_key : Blob; chain_code : Blob; });
            sign_with_ecdsa : ({
                message_hash : Blob;
                derivation_path : [Blob];
                key_id : { curve: { #secp256k1; } ; name: Text };
                }) -> async ({ signature : Blob });
            http_request : ({
                url : Text;
                max_response_bytes : ?Nat64;
                method : { #get; #head; #post };
                headers : [HttpHeader];
                body : ?Blob;
                transform : ?{
                    function : TransformFunction;
                    context : Blob;
                };
            }) -> async (HttpResponsePayload);
        };
        
        let ic : IC = actor("aaaaa-aa");

        public func get_key_id(is_local_dev_mode: Bool) : async Types.EcdsaKeyId {
            let key_name = if is_local_dev_mode { "dfx_test_key" } else { "key_1" };

            let key: Types.EcdsaKeyId = {
                curve = #secp256k1;
                name = key_name;
            };

            return key;
        };
        
        public func make_canister_call_via_ecdsa(request: Types.CanisterEcdsaRequest) : async Result.Result<Text, Text> {
            
            try{

                let body = await sign_envelope(request.envelope_content, request.public_key, request.key_id);
                switch(body){
                    case (#err body){
                        return #err("Error signing envelope");
                    };
                    case (#ok body){
                        let headers: [HttpHeader] = [{name = "content-type"; value = "application/cbor"}];
                        let maxResponse: Nat64 = 1024 * 1024;
                        let response = await ic.http_request({
                            body = ?body; 
                            headers = headers; 
                            max_response_bytes = ?maxResponse;
                            method = #post;
                            transform = ?{context = Blob.fromArray([]); function = fn};
                            url = request.request_url;
                        });
                        if(response.status == 200){
                            return #ok("Canister call made");
                        };
                        return #err("Error making canister call");
                    };
                };
            } catch (error){
                return #err("Error making canister call via ecdsa");
            };
        };

        public shared query func fn (result: TransformArgs) : async HttpResponsePayload {
            return result.response;
        };

        func to_request_id(hash: [Nat8]): Blob = Blob.fromArray(hash);
        public func sign_envelope(content: Types.EnvelopeContent, public_key: Blob, key_id: Types.EcdsaKeyId): async Result.Result<Blob, Text> {
            let request_id = to_request_id(content);

            let signature = await sign(key_id, public_key);
            
            switch(content){
                case (#Call {nonce; ingress_expiry; sender; canister_id; method_name; arg}){

                    switch( signature ){
                        case( #err msg ) #err("Invalid signature");
                        case( #ok sig ){

                            let request: CborTypes.Request = {
                                ingress_expiry = Nat64.toNat(ingress_expiry);
                                nonce = nonce;
                                request = #read_state({
                                    canister_id = ""; //WHICH_CANISTER_ID;
                                    max_response_bytes = ?(0); //DEFAULT_MAX_RESPONSE_BYTES;
                                    paths = [[ encodeUtf8("request_status"), request_id ]]; //??????
                                });
                                sender = Principal.toBlob(sender);
                            };


                            let envelope = Cbor.load([]);
                            envelope.set( "content", #majorType5(map_content( request )) );
                            envelope.set( "sender_pubkey", #majorType2( Blob.toArray(public_key)) );
                            envelope.set( "sender_sig", #majorType2(Blob.toArray(sig)) );
                                                    
                            let bytes: Value.Value = #majorType5([
                                (#majorType3("Fun"), #majorType7(#bool(true))),
                                (#majorType3("Amt"), #majorType1(-2))
                            ]);
                            let serialisedBytes: [Nat8] = switch(CborEncoder.encode(bytes)) {
                                case (#err(e)) {[]};
                                case (#ok(c)) c;
                            };
                            
                            #ok(Blob.fromArray(serialisedBytes));
                        }
                    }

                };
                case _ { #err("Invalid signature") };
            };
        };

                
        func map_content(req: CborTypes.Request): Cbor.CborMap {
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
                #majorType4( mapEntries<[Blob], Value.Value>(params.paths, func(state_path, _): Value.Value {
                    #majorType4( mapEntries<Blob, CborTypes.CborBytes>(state_path, func(path_label, _): CborTypes.CborBytes {
                    #majorType2( Blob.toArray(path_label) )
                    }))
                }))
                )
            }};
            content.map_cbor()
        };

        
        
        public shared func sign(key_id: Types.EcdsaKeyId, message: Blob) : async Result.Result<Blob, Types.Error> {
            try {
                let hasher = SHA256.New();
                hasher.write(Blob.toArray(message));
                let message_hash = Blob.fromArray(hasher.sum([]));
                
                let result = await ic.sign_with_ecdsa({
                    message_hash = message_hash;
                    derivation_path = [ ];
                    key_id = key_id;
                });
                return #ok(result.signature);
            } catch (err) {
                #err(#ECSDAError);
            }
        };
    };
}
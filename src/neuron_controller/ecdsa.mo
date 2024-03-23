import Principal "mo:base/Principal";
import Cycles "mo:base/ExperimentalCycles";
import Result "mo:base/Result";
import Blob "mo:base/Blob";
import Trie "mo:base/Trie";
import T "../OpenFPL_backend/types";
import SHA256 "./SHA256";

actor Self {
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
    };
    
    let ic : IC = actor("aaaaa-aa");
        
    type CanisterId = Principal;
    type EcdsaKeyId = { name : Text; curve : EcdsaCurve };
    type EcdsaCurve = { #secp256k1 };
    
    type Label = Trie.Trie<Blob,Blob>;
    type EnvelopeContent = {
        #Call : {
            nonce : ?Blob;
            ingress_expiry : Nat64;
            sender : Principal;
            canister_id : Principal;
            method_name : Text;
            arg : Blob;
        };
        #ReadState : {
            ingress_expiry : Nat64;
            sender : Principal;
            paths : [[Label]];
        };
        #Query : {
            ingress_expiry : Nat64;
            sender : Principal;
            canister_id : Principal;
            method_name : Text;
            arg : Blob;
            nonce : ?Blob;
        };
    };
    
    type CanisterEcdsaRequest = {
        envelope_content: EnvelopeContent;
        request_url: Text;
        public_key: Blob;
        key_id: EcdsaKeyId;
        this_canister_id: CanisterId;
    };

    public func get_key_id(is_local_dev_mode: Bool) : async EcdsaKeyId {
        let key_name = if is_local_dev_mode { "dfx_test_key" } else { "key_1" };

        let key: EcdsaKeyId = {
            curve = #secp256k1;
            name = key_name;
        };

        return key;
    };

    public func get_public_key(key_id: EcdsaKeyId) : async { #Ok : { public_key: Blob }; #Err : Text } {
        try {
            let { public_key } = await ic.ecdsa_public_key({
                canister_id = null;
                derivation_path = [ ];
                key_id = key_id;
            });
            #Ok({ public_key })
        } catch (err) {
            #Err("Error getting public key.")
        }
    };

    //OC Functions:
    
    public func make_canister_call_via_ecdsa(request: CanisterEcdsaRequest) : async Result.Result<Text, Text> {
        try{
            let body = await sign_envelope(request.envelope_content, request.public_key, request.key_id);
            let response = ic.http_request();
            return #ok(response);
        } catch (error){
            return #err(#ECDSAError)
        };
    };

    //sign_envelope

    public shared func sign(key_id: EcdsaKeyId, message: Blob) : async Result.Result<Blob, T.Error> {
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
}
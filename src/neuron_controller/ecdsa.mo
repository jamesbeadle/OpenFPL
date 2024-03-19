import Principal "mo:base/Principal";
import Cycles "mo:base/ExperimentalCycles";

module {
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
        
    type EcdsaKeyId = { name : Text; curve : EcdsaCurve };
    type EcdsaCurve = { #secp256k1 };

    public func get_key_id(is_local_dev_mode: Bool) : EcdsaKeyId {
        let key_name = if is_local_dev_mode { "dfx_test_key" } else { "key_1" };

        let key: EcdsaKeyId = {
            curve = #secp256k1;
            name = key_name;
        };

        return key;
    };

    public shared (msg) func get_public_key() : async { #Ok : { public_key: Blob }; #Err : Text } {
        let caller = Principal.toBlob(msg.caller);
        try {
            let { public_key } = await ic.ecdsa_public_key({
                canister_id = null;
                derivation_path = [ caller ];
                key_id = { curve = #secp256k1; name = "dfx_test_key" };
            });
            #Ok({ public_key })
        } catch (err) {
            #Err("Error getting public key.")
        }
    };

    public shared (msg) func sign(key_id: EcdsaKeyId, message: Blob) : async { #Ok : { signature: Blob }; #Err : Text } {
        try {
            let caller = Principal.toBlob(msg.caller);
            Cycles.add<system>(10_000_000_000);
            let result = await ic.sign_with_ecdsa({
                message_hash = message;
                derivation_path = [ caller ];
                key_id = key_id;
            });

            #Ok(result);
        } catch (err) {
            #Err("Error signing message.");
        }
    };
}
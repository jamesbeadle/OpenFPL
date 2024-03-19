/*
use ic_cdk::api::call::CallResult;
use ic_cdk::api::management_canister::ecdsa::{EcdsaCurve, EcdsaKeyId, EcdsaPublicKeyArgument, SignWithEcdsaArgument};
use ic_cdk::api::management_canister::http_request::{
    CanisterHttpRequestArgument, HttpHeader, HttpMethod, TransformContext, TransformFunc,
};
use ic_transport_types::{to_request_id, EnvelopeContent};
use serde::Serialize;
use sha256::sha256;
use tracing::{error, info};
use types::CanisterId;
*/
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
    
    
    type EcdsaKeyId = { name : text; curve : EcdsaCurve };
    type EcdsaCurve = { #secp256k1 };
    type CanisterEcdsaRequest = {
        envelope_content: EnvelopeContent;
        request_url: Text;
        public_key: Blob;
        key_id: EcdsaKeyId;
        this_canister_id: CanisterId;
    };

    public func get_key_id(is_local_dev_mode: Bool) : EcdsaKeyId {
        let key_name = if is_local_dev_mode { "dfx_test_key" } else { "key_1" };

        let key: EcdsaKeyId = {
            curve: EcdsaCurve.Secp256k1;
            name: key_name;
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
        #Err(Error.message(err))
        }
    };

    public func make_canister_call_via_ecdsa(request: CanisterEcdsaRequest) : async Result<String, String> {
        let body = match sign_envelope(request.envelope_content, request.public_key, request.key_id).await {
            Ok(bytes) => bytes,
            Err(error) => return Err(format!("Failed to sign envelope: {error:?}")),
        };

        let (response,) = ic_cdk::api::management_canister::http_request::http_request(
            CanisterHttpRequestArgument {
                url: request.request_url,
                max_response_bytes: Some(1024 * 1024), // 1 MB
                method: HttpMethod::POST,
                headers: vec![HttpHeader {
                    name: "content-type".to_string(),
                    value: "application/cbor".to_string(),
                }],
                body: Some(body),
                transform: Some(TransformContext {
                    function: TransformFunc::new(request.this_canister_id, "transform_http_response".to_string()),
                    context: Vec::new(),
                }),
            },
            100_000_000_000,
        )
        .await
        .map_err(|error| format!("Failed to make http request: {error:?}"))?;

        Ok(String::from_utf8(response.body).unwrap())
    };

    public func sign_envelope(content: EnvelopeContent, public_key: Blob, key_id: EcdsaKeyId) : async CallResult<Blob> {
        let request_id = to_request_id(&content).unwrap();

        let signature = sign(key_id, &request_id.signable()).await?;

        let envelope = Envelope {
            content: content.clone(),
            sender_pubkey: Some(public_key),
            sender_sig: Some(signature.clone()),
        };

        let mut serialized_bytes = Vec::new();
        let mut serializer = serde_cbor::Serializer::new(&mut serialized_bytes);
        serializer.self_describe().unwrap();
        envelope.serialize(&mut serializer).unwrap();

        info!(
            request_id = String::from(request_id),
            signature = hex::encode(signature),
            "Signed envelope"
        );

        Ok(serialized_bytes)
    };

    public shared (msg) func sign(key_id: EcdsaKeyId, message: Blob) : async { #Ok : { signature: Blob }; #Err : Text } {
        let message_hash = sha256(message);
        Cycles.add(10_000_000_000);
        let result = await ic.sign_with_ecdsa({
            message_hash = message;
            derivation_path = [ caller ];
            key_id = key_id;
        });

        #Ok(result)
        
        let caller = Principal.toBlob(msg.caller);
        try {
        } catch (err) {
        #Err(Error.message(err))
        }
    };

    /*
    #[derive(Serialize)]
    struct Envelope {
        content: EnvelopeContent,
        #[serde(with = "serde_bytes")]
        sender_pubkey: Option<Vec<u8>>,
        #[serde(with = "serde_bytes")]
        sender_sig: Option<Vec<u8>>,
    }
    */
}
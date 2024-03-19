import Principal "mo:base/Principal";

actor NeuronController {
    public type CanisterId = Principal;
    public type CanisterEcdsaRequest = {
        //envelope_content: EnvelopeContent; //comes from ic_transport_types
        request_url: Text;
        public_key: [Int8];
        //key_id: EcdsaKeyId; //comes from ic_cdk::api::management_canister::ecdsa
        this_canister_id: CanisterId;   
    };

    //Building signing request
    public func prepare_canister_call_via_ecdsa(self: Principal, canister_id: CanisterId, method_name: Text): CanisterEcdsaRequest{
        //create a nonce
        // /  let nonce: [u8; 8] = self.env.rng().gen();

        //create envelope content
        let envelope_content = EnvelopeContent::Call {
            nonce: Some(nonce.to_vec()),
            ingress_expiry: self.env.now_nanos() + 5 * MINUTE_IN_MS * NANOS_PER_MILLISECOND,
            sender: self.data.get_principal(),
            canister_id,
            method_name,
            arg: candid::encode_one(&args).unwrap(),
        };

        CanisterEcdsaRequest {
            envelope_content,
            request_url: format!("{IC_URL}/api/v2/canister/{canister_id}/call"),
            public_key: self.data.get_public_key_der(),
            key_id: get_key_id(false),
            this_canister_id: self.env.canister_id(),
        }

    };
}
//t
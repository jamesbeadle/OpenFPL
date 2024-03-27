import Blob "mo:base/Blob";
import Random "mo:base/Random";
import Account "../OpenFPL_backend/lib/Account";
import Text "mo:base/Text";
import Principal "mo:base/Principal";
import Nat64 "mo:base/Nat64";
import Int "mo:base/Int";
import Time "mo:base/Time";
import Result "mo:base/Result";
import SHA256 "./SHA256";
import Binary "Binary";
import Ledger "Ledger";
import NNSGovernance "NNSGovernance";
import Environment "../OpenFPL_backend/Environment";
import T "types";
import TimeConstants "time";
import ECDSA "ecdsa";


actor Self {
    private let ledger : Ledger.Interface = actor (Ledger.CANISTER_ID);
    private let nns_governance : NNSGovernance.Interface = actor (NNSGovernance.CANISTER_ID);
    private stable var neuronId: Nat64 = 0;
    private let IC_URL = "https://icp-api.io";
    private let NEURON_CONTROLLER_CANISTER_ID = ""; //Todo: Set After Deploy

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
    
    public shared func stake_nns_neuron(principal: Principal): async T.Response {
        let random_bytes = await Random.blob();
        let array = Blob.toArray(random_bytes);

        let nonce: Nat64 = Binary.BigEndian.toNat64(array);
        let subaccount = computeNeuronStakingSubaccountBytes(principal, nonce);

        try {
            let _ = await ledger.transfer({
                memo = nonce;
                from_subaccount = null;
                to = Account.accountIdentifier(Principal.fromText(Environment.NNS_GOVERNANCE_CANISTER_ID), subaccount);
                amount = {e8s = 100_000_000};
                fee = { e8s = 10_000 };
                created_at_time = ?{ timestamp_nanos = Nat64.fromNat(Int.abs(Time.now())) };
            });

        } catch (error) {
            return #err(#InvalidTransaction "Error transferring neuron funds");
        };

        try {

            let manage_neuron_response = await nns_governance.manage_neuron(
                {
                    id = null;
                    command = ? #ClaimOrRefresh {
                        by: ?NNSGovernance.By = ? #MemoAndController {
                            controller = ?principal;
                            memo = nonce;
                        };
                    };
                    neuron_id_or_subaccount = null;
                }
            );

            switch(manage_neuron_response.command){
                case (null) {
                    #err(#InvalidTransaction "Error staking neuron");
                };
                case (?response) {
                    switch(response){
                        case (#ClaimOrRefresh(crResponse)) {
                            switch(crResponse.refreshed_neuron_id){
                                case null{
                                    #err(#InvalidTransaction "Error staking neuron");
                                };
                                case (?returnedNeuronId){
                                    neuronId := returnedNeuronId.id;
                                    return #ok(Nat64.toNat(returnedNeuronId.id));
                                }
                            };
                        };
                        case _{
                            #err(#InvalidTransaction "Error staking neuron");
                        };
                    };
                }
            };
        } catch (error) {
            #err(#InvalidTransaction "Error staking neuron");
        };
    };

    //manage neuron
    public shared func manage_nns_neuron(neuronId: Nat64, command: NNSGovernance.Command): async Result.Result<Text, Text> {
        await manage_nns_neuron_impl(neuronId, command);
    };

    private func manage_nns_neuron_impl(neuron_id: Nat64, command: NNSGovernance.Command) : async Result.Result<Text, Text> {
        let neuronId: T.NeuronId = { id = neuron_id; };
        let manageNeuronRequest: T.ManageNeuron = {
            id = ?neuronId;
            command = ?command;
            neuron_id_or_subaccount = null;
        };
        let request = prepare_canister_call_via_ecdsa(
            Principal.fromText(Environment.NNS_GOVERNANCE_CANISTER_ID),
            "manage_neuron",
            command
        );

        let response = await make_canister_call_via_ecdsa(request);
    
    };

    public shared query func getNeuronId() : async Nat64 {
        return neuronId;
    };

    private func computeNeuronStakingSubaccountBytes(controller: Principal, nonce: Nat64): Blob {
        let domain: Blob = Text.encodeUtf8("neuron-stake");
        let domainLength: Blob = Blob.fromArray([0x0c]);
    
        let hasher = SHA256.New();
        hasher.write(Blob.toArray(domainLength));
        hasher.write(Blob.toArray(domain));
        hasher.write(Blob.toArray(Principal.toBlob(controller)));
        hasher.write(Binary.BigEndian.fromNat64(nonce));
        return Blob.fromArray(hasher.sum([]));
    };

    private func prepare_canister_call_via_ecdsa(
        canister_id: T.CanisterId,
        method_name: Text,
        args: NNSGovernance.Command,
    ) : T.CanisterEcdsaRequest {
        let currentTime = Time.now(); //Hamish To Confirm
        let array = Binary.BigEndian.fromNat64(Nat64.fromIntWrap(currentTime));
        
        let envelope_content: T.EnvelopeContent = #Call {
            nonce = ?Blob.fromArray(array);
            ingress_expiry = Nat64.fromIntWrap(currentTime + 5) * TimeConstants.MINUTE_IN_MS * TimeConstants.NANOS_PER_MILLISECOND;
            sender = get_principal();
            canister_id = canister_id;
            method_name = method_name;
            arg = to_candid(args);
        };

        return {
            envelope_content = envelope_content;
            request_url = IC_URL # "/api/v2/canister/" # Principal.toText(canister_id) # "/call";
            public_key = self.data.get_public_key_der();
            key_id = get_key_id(false);
            this_canister_id = NEURON_CONTROLLER_CANISTER_ID;
        }
    };

    
    public func make_canister_call_via_ecdsa(request: T.CanisterEcdsaRequest) : async Result.Result<Text, Text> {
        let ecsda = ECDSA.ECDSA();
        let body = await ecsda.sign_envelope(request.envelope_content, request.public_key, request.key_id);
        
        switch(body){
            case (#ok body){
                let response = await ic.http_request({
                    body = ?body; 
                    headers = [{
                        name = "content-type";
                        value = "application/cbor";
                    }]; 
                    max_response_bytes = ?(1024 * 1024);
                    method = #post;
                    transform = ?{context = Blob.fromArray([]); function = fn};
                    url = request.request_url;
                });
                if(response.status != 200){
                    return #err("Failed to make http request.");
                };

                let returnValue = Text.decodeUtf8(Blob.fromArray(response.body));
                switch(returnValue){
                    case (null){
                        return #err("Failed to make http request.");
                    };
                    case (?value){
                        return #ok(value);
                    }
                };
            };
            case _ {
                    return #err("Failed to make http request.");
            };
        };

        
    };
    

    public shared query func fn (result: TransformArgs) : async HttpResponsePayload {
        return result.response;
    };

    private func get_principal() : Principal{
        Principal.fromText(Environment.NEURON_CONTROLLER_CANISTER_ID);
    };

    
}
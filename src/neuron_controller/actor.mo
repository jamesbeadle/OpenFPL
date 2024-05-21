import Utilities "mo:utilities";
import Nat64 "mo:base/Nat64";
import Principal "mo:base/Principal";
import Loopback "mo:http-loopback";
import ECDSA "mo:tecdsa";
import U "utils";
import S "state";
import T "types";
import Environment "../OpenFPL_backend/utils/Environment";

shared actor class NeuronController() = self {

  let MIN_FEE : Nat64 = 10_000;

  let { SECP256K1; Identity; Client } = ECDSA;

  let { Nonce; Ledger } = Utilities;

  let { FEES = { ID = FEE_ID; APP = FEE_AMT } } = Loopback.Client;

  let { Address; AccountIdentifier } = Ledger;

  stable var neuronResponse: ?T.NeuronResponse = null;

  // stable variable - state
  //
  // stores all of the canister's data structures
  //
  stable var state : T.State = S.empty();


  // query method - transform()
  //
  // Normalizes IC HTTP response values across replicas
  //
  public query func transform(args: T.Http.TransformArgs): async T.Http.HttpResponsePayload { Loopback.transform(args) };


  // query method - getNeuronId()
  //
  // Returns a Nat64 identifier for the canister's NNS neuron
  //
  public query func getNeuronId(): async Nat64 { state.neuron_id };

  public query func getNeuronResponse(): async ?T.NeuronResponse { neuronResponse };


  // query method - getAccountIdentifier()
  //
  // Return the AccountIdentifier (Blob) of the canister's ECDSA default subaccount
  //
  public query func getAccountIdentifier(): async T.AccountId {
    let client = Client.Client( state.ecdsa_client );
    let p : Principal = Identity.Identity(state.ecdsa_identity, client).get_principal();
    AccountIdentifier.from_principal(p, null)
  };


  // query method - getLedgerAddress()
  //
  // Return the Ledger address (Text) of the canister's ECDSA default subaccount
  //
  public query func getLedgerAddress(): async T.Address {
    let client = Client.Client( state.ecdsa_client );
    let p : Principal = Identity.Identity(state.ecdsa_identity, client).get_principal();
    Address.from_principal(p, null)
  };


  // query method - getNeuronAddress()
  //
  // Return the Ledger address (text) of the neuron's subaccount
  //
  public query func getNeuronAddress(): async T.Address {
    let client = Client.Client( state.ecdsa_client );
    let p : Principal = Identity.Identity(state.ecdsa_identity, client).get_principal();
    U.neuron_address(p, state.neuron_index);
  };


  // update method - manage_neuron()
  //
  // A proxy interface that will submit neuron management requests on behalf of the caller
  //
  public shared ({caller}) func manage_neuron(cmd: T.Command): async T.NeuronResponse {

    assert Principal.toText(caller) == Environment.BACKEND_CANISTER_ID;

    let governance_client = U.GovernanceClient(state, transform);

    let request : T.ManageNeuron = { command = ?cmd; id = ?{ id = state.neuron_id }; neuron_id_or_subaccount = null };

    let response = await* governance_client.manage_neuron( request );
    neuronResponse := ?response;
    return response;
  };

  public shared func getBackendCanisterId(): async Text {
    return Environment.BACKEND_CANISTER_ID;
  };


  // update method - stake_nns_neuron()
  //
  // When called for the first time this method will transfer 1 ICP from the tecdsa
  // principal's default subaccount to a Neuron's subaccount and then submit a claim
  // request to the NNS governance canister.
  //
  // If called again this method will simply return the neuron_id of the existing neuron
  //
  public shared ({caller}) func stake_nns_neuron(): async T.NeuronResponse {

    assert Principal.toText(caller) == Environment.BACKEND_CANISTER_ID;

    if ( state.neuron_id > 0 ) return #ok({ command = ?#ClaimOrRefresh({ refreshed_neuron_id = ?{ id = state.neuron_id }}) });

    let client = Client.Client( state.ecdsa_client );
    
    let p : Principal = Identity.Identity(state.ecdsa_identity, client).get_principal();

    let nonce : Nat64 = Nat64.fromNat( Nonce.Nonce( state.nonce ).next() );

    let to_account = Address.to_identifier( U.neuron_address(p, nonce) );

    let ledger_client = U.LedgerClient(state, transform);

    switch( await* ledger_client.transfer(
      {
        memo = nonce;
        amount = { e8s = 100_000_000 }; // 1 ICP
        fee = { e8s = MIN_FEE }; // .001 ICP
        from_subaccount = null;
        created_at_time = null;
        to = to_account;
      }
    )){
      case( #err msg ) return #err(msg);
      case _ ()
    };

    let governance_client = U.GovernanceClient(state, transform);

    switch( await* governance_client.manage_neuron({
      id = null;
      neuron_id_or_subaccount = null;
      command = ?#ClaimOrRefresh({ by = ?#MemoAndController({ controller = ?p; memo = nonce }) })
    })){
      case( #err msg ) #err(msg);
      case( #ok resp ) {
        let ?cmd_resp = resp.command else {
          return #err(#other("null response from governance canister")) 
        };
        switch( cmd_resp ){
          case( #Error e ) return #err(#other(e.error_message));
          case( #ClaimOrRefresh cr_resp ){
            let ?nid = cr_resp.refreshed_neuron_id else {
              return #err(#other("null value returnd for neuron id"))
            };
            state.neuron_id := nid.id;
            state.neuron_index := nonce;
            #ok({command = ?#ClaimOrRefresh({ refreshed_neuron_id = ?{id = state.neuron_id}})});
          };
          case _ return #err(#other("unexpected command response: " # debug_show(cmd_resp)))
        };
      };
    };

  };

  // update method - init()
  //
  // When called for the first time this method will initialize all state values
  //
  // If called again, this method will simply return "ok";
  //
  public shared func init() : async T.AsyncReturn<()> {

    //assert Principal.isController( caller );

    if ( state.initialized == true ) return #ok();

    await* S.load(state, {
      ecdsa_seed = ?["OpenFPL"];
      path = "/api/v2/canister/";
      nonce = Nonce.State.init();
      self = Principal.fromActor( self );
      ecdsa_key = SECP256K1.ID.KEY_1;
      ledger_canister = "ryjl3-tyaaa-aaaaa-aaaba-cai";
      governance_canister = "rrkah-fqaaa-aaaaa-aaaaq-cai";
      management_canister = "aaaaa-aa";
      ingress_expiry = 90_000_000_000;
      domain = "https://icp-api.io";
      fees = [
          (SECP256K1.ID.KEY_1,  SECP256K1.FEE.KEY_1), //todo change back to key 1 on live
          (FEE_ID.PER_RESPONSE_BYTE, FEE_AMT.PER_RESPONSE_BYTE),
          (FEE_ID.PER_REQUEST_BYTE,  FEE_AMT.PER_REQUEST_BYTE),
          (FEE_ID.PER_CALL,          FEE_AMT.PER_CALL),
      ]
    }) 

  };

};
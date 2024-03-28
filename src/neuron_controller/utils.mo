import { encodeNat64 } "mo:xtended-numbers/NatX";
import { encodeUtf8 } "mo:base/Text";
import Principal "mo:base/Principal";
import { Ledger = L } "mo:utilities";
import Loopback "mo:http-loopback";
import Buffer "mo:base/Buffer";
import Sha256 "mo:sha2/Sha256";
import ECDSA "mo:tecdsa";
import T "types";

module {

  public class LedgerClient(state: T.State, transformFn: T.Http.TransformFunction) = {

    let ecdsa_client = ECDSA.Client.Client(state.ecdsa_client);

    let ecdsa_identity = ECDSA.Identity.Identity(state.ecdsa_identity, ecdsa_client);

    let loopback_client = Loopback.Client.Client(state.loopback_client, transformFn);

    let loopback_agent = Loopback.Agent.Agent(state.loopback_agent, loopback_client, ecdsa_identity);

    public func transfer(args: T.LedgerArgs): async* T.LedgerResponse {
      switch(
        await* loopback_agent.update_method(
          {
            max_response_bytes = null;
            canister_id = state.ledger_canister;
            method_name = "transfer";
            arg = to_candid( args );
          }
        )
      ){
        case( #err msg ) #err(msg);
        case( #ok candid ){
          switch( from_candid( candid ) : ?T.TransferResult ){
            case null #err(#other("ledger canister returned an unexpected candid type"));
            case ( ?response ) #ok( response )
          }
        }
      }
    };

  };

  public class GovernanceClient(state: T.State, transformFn: T.Http.TransformFunction) = {

    let ecdsa_client = ECDSA.Client.Client(state.ecdsa_client);

    let ecdsa_identity = ECDSA.Identity.Identity(state.ecdsa_identity, ecdsa_client);

    let loopback_client = Loopback.Client.Client(state.loopback_client, transformFn);

    let loopback_agent = Loopback.Agent.Agent(state.loopback_agent, loopback_client, ecdsa_identity);

    public func manage_neuron(request: T.ManageNeuron): async* T.NeuronResponse {
      switch(
        await* loopback_agent.update_method(
          {
            max_response_bytes = null;
            canister_id = state.governance_canister;
            method_name = "manage_neuron";
            arg = to_candid( request );
          }
        )
      ){
        case( #err msg ) #err(msg);
        case( #ok candid ){
          switch( from_candid( candid ) : ?T.ManageNeuronResponse ){
            case null #err(#other("governance canister returned an unexpected candid type"));
            case ( ?response ) #ok( response )
          }
        }
      }
    };

  };

    public func neuron_subaccount(p: Principal, n: Nat64): T.Address {
      let index_bytes = Buffer.Buffer<Nat8>(0);
      encodeNat64(index_bytes, n, #msb);
      let digest = Sha256.Digest(#sha256);
      digest.writeArray([0x0C]);
      digest.writeBlob( encodeUtf8("neuron-stake") );
      digest.writeBlob( Principal.toBlob(p) );
      digest.writeIter( index_bytes.vals() );
      L.Address.from_identifier(
        Principal.toLedgerAccount(
          Principal.fromText("rrkah-fqaaa-aaaaa-aaaaq-cai"),
          ?digest.sum()
        )
      )
    };

};
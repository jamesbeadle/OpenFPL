import { Fees; Nonce } "mo:utilities";
import { toText = principalToText } "mo:base/Principal";
import Loopback "../../../src";
import ECDSA "mo:tecdsa";
import T "types";

module {

  public let { SECP256K1 } = ECDSA;

  public let { FEES = { ID = FEE_ID; APP = FEE_AMT } } = Loopback.Client;

  public func empty() : T.State = {
    var self_id = "";
    var initialized = false;
    var fees = Fees.State.empty();
    var ecdsa_client = ECDSA.Client.State.empty();
    var ecdsa_identity = ECDSA.Identity.State.empty(); 
    var loopback_client = Loopback.Client.State.empty();
    var loopback_agent = Loopback.Agent.State.empty();
  };

  public func init(state: T.State, p: Principal): async* T.AsyncReturn<()> {
    
    state.self_id := principalToText( p );

    Fees.State.load(
      state.fees,
      { 
        fees = [
          (SECP256K1.ID.TEST_KEY_1, SECP256K1.FEE.TEST_KEY_1),
          (FEE_ID.PER_RESPONSE_BYTE, FEE_AMT.PER_RESPONSE_BYTE),
          (FEE_ID.PER_REQUEST_BYTE, FEE_AMT.PER_REQUEST_BYTE),
          (FEE_ID.PER_CALL, FEE_AMT.PER_CALL),
        ]
      }
    );

    ECDSA.Client.State.load(
      state.ecdsa_client,
      {
        canister_id = "aaaaa-aa";
        fees = state.fees;
      }
    );

    Loopback.Client.State.load(
      state.loopback_client,
      {
        domain = "https://icp-api.io";
        path = "/api/v2/canister/";
        nonce = Nonce.State.init();
        fees = state.fees;
      }
    );

    Loopback.Agent.State.load(
      state.loopback_agent,
      { ingress_expiry = 90_000_000_000 }
    );

    switch(
      await* ECDSA.Identity.State.load(
        state.ecdsa_identity,
        {
          client = ECDSA.Client.Client(state.ecdsa_client);
          seed_phrase = ?["bangarang"];
          key_id = {
            curve = SECP256K1.CURVE;
            name = SECP256K1.ID.TEST_KEY_1
          }
        }
      )
    ){

      case( #ok _ ) #ok( state.initialized := true );

      case( #err msg ) #err(msg)

    }

  }

};

import { toText = principalToText } "mo:base/Principal";
import { Fees; Nonce } "mo:utilities";
import Loopback "mo:http-loopback";
import ECDSA "mo:tecdsa";

module {

  public type AsyncReturn<T> = ECDSA.Identity.AsyncReturn<T>;

  public type InitParams = {
    self : Principal;
    path : Text;
    domain : Text;
    fees : [(Text, Nat64)];
    ingress_expiry : Nat;
    ledger_canister : Text;
    governance_canister : Text;
    management_canister : Text;
    ecdsa_seed : ?[Text];
    ecdsa_key : Text;
  };

  public type State = {
    var self : Text;
    var nonce : Nonce.State;
    var fees : Fees.State;
    var initialized : Bool;
    var ecdsa_client : ECDSA.Client.State;
    var ecdsa_identity : ECDSA.Identity.State;
    var loopback_client : Loopback.Client.State;
    var loopback_agent : Loopback.Agent.State;
    var governance_canister : Text;
    var ledger_canister : Text;
    var neuron_id : Nat64;
    var neuron_index : Nat64;
  };

  public func empty() : State = {
    var self = "";
    var fees = Fees.State.empty();
    var initialized = false;
    var nonce = Nonce.State.init();
    var ecdsa_client = ECDSA.Client.State.empty();
    var ecdsa_identity = ECDSA.Identity.State.empty();
    var loopback_client = Loopback.Client.State.empty();
    var loopback_agent = Loopback.Agent.State.empty();
    var governance_canister = "";
    var ledger_canister = "";
    var neuron_id = 0;
    var neuron_index = 0;
  };

  public func load(state : State, params : InitParams) : async AsyncReturn<()> {

    state.self := principalToText(params.self);

    state.ledger_canister := params.ledger_canister;

    state.governance_canister := params.governance_canister;

    Fees.State.load(
      state.fees,
      { fees = params.fees },
    );

    Loopback.Client.State.load(
      state.loopback_client,
      {
        path = params.path;
        domain = params.domain;
        nonce = state.nonce;
        fees = state.fees;
      },
    );

    Loopback.Agent.State.load(
      state.loopback_agent,
      { ingress_expiry = params.ingress_expiry },
    );

    ECDSA.Client.State.load(
      state.ecdsa_client,
      {
        canister_id = params.management_canister;
        fees = state.fees;
      },
    );

    switch (
      await ECDSA.Identity.State.load(
        state.ecdsa_identity,
        {
          client = ECDSA.Client.Client(state.ecdsa_client);
          seed_phrase = params.ecdsa_seed;
          key_id = {
            curve = ECDSA.SECP256K1.CURVE;
            name = params.ecdsa_key;
          };
        },
      ),
    ) {

      case (#ok _) #ok(state.initialized := true);

      case (#err msg) #err(msg)

    }

  }

};

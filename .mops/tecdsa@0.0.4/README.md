# tecdsa

## Install
```
mops add tecdsa
```

## Changelog
-- Removes the Manager class
-- Breaking change to State type and methods

## Usage
```motoko
import { Manager; SECP256K1 = { CURVE; ID = { DFX_TEST_KEY } }  } "../../../src";
import { toBlob } "mo:base/Principal";
import { encodeUtf8 } "mo:base/Text";
import { print } "mo:base/Debug";
import State "state";

actor {
  
  stable let state = State.init();

  let identity_manager = Manager.Manager( state.manager_state );

  public shared func generate_new_identity(): async ?(Nat, [Text]) {
    switch( await* identity_manager.fill_next_slot({curve=CURVE; name=DFX_TEST_KEY}) ){
      case( #err _ ) null;
      case( #ok ret ) ?ret
    }
  };

  public shared query func get_principal(id: Nat): async Principal {
    let identity = identity_manager.get_slot( id );
    identity.get_principal()
  };

  public shared query func get_public_key(id: Nat): async [Nat8] {
    let identity = identity_manager.get_slot( id );
    identity.public_key
  };

  public shared func sign_message(id: Nat): async ?Blob {
    let identity = identity_manager.get_slot( id );
    let data = encodeUtf8("Hello world");
    switch( await* identity.sign( data ) ){
      case( #ok signature ) ?signature;
      case( #err msg ){
        print(debug_show(#err(msg)));
        null
      }
    }
  };

};
```
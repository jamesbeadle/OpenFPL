# utilities
A collection of helpful class objects.

## Install
```
mops add utilities
```

## Changelog
Version 2.0.2 - Adds Tokens type and Interface submodule to lib.mo
Version 2.0.1 - Adds missing State module for Cycles; Adds missing Ledger module to lib.mo
Version 2.0.0 - Adds Cycles class and Ledger methods; Breaking changes to State type and methods for all modules

## Usage
```motoko
import Utilities "mo:utilities";

// example...

suite("Nonce Class Methods", func(){

  let state = Nonce.State.init();
  let nonce_factory = Nonce.Nonce(state);

  test("next()", func() {
    let nat : Nat = nonce_factory.next();
  	assert nat == 0;
  });

  test("next_blob()", func(){
	let blob : Blob = nonce_factory.next_blob();
	assert blob == "\01"
  });

  test("next_string()", func(){
	let text : Text = nonce_factory.next_string();
    assert text == "02";
  });

  test("next_array()", func(){
	let arr : [Nat8] = nonce_factory.next_array();
	assert arr[0] == 0x03;
  });

})
```
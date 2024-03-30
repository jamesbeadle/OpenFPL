# stable-buffer

## Description
Stable buffers allow you to store and retrieve fixed-size blocks (Blob) in stable memory regions.

Data block size is configured during state initialization. See Example below.

## Types
```
  public type Block = Blob;

  public type Region = Region.Region;

  public type Return<T> = { #ok: T; #err: Error };

  public type Error = { #insufficient_memory; #out_of_bounds; #size_error: Text };

  public type StableBuffer = {
    size : () -> Nat;
    capacity : () -> Nat;
    get : (Nat) -> Block;
    getOpt : (Nat) -> ?Block;
    vals : () -> { next: () -> ?Block };
    set : (Nat, Block) -> Return<Block>;
    add : (Block) -> Return<Nat>;
  };

  public type State = {
    var next : Nat64;
    var capacity: Nat64;
    blocks_per_page : Nat64;
    page_buffer : Nat64;
    block_size : Nat64;
    blocks : Region;
  };

```

## Example
```
import SB "../../src";
import { range; toArray } "mo:base/Iter";
import Array "mo:base/Array";
import Blob "mo:base/Blob";

actor {

  stable let state = SB.State.init({size=122; capacity=1000});
  
  let buffer = SB.StableBuffer( state );

  public query func capacity(): async Nat { buffer.capacity() };

  public query func vals(): async [Blob] { toArray<Blob>( buffer.vals() ) };

  public query func get(i: Nat): async Blob { buffer.get(i) };

  public func add(): async SB.Return<Nat> {
    var byte : Nat8 = 0x00;
    let capacity : Nat = buffer.capacity();
    for ( inc in range(0, capacity) ) {
      if ( byte < 255 ) byte += 1;
      let blob : Blob = Blob.fromArray( Array.tabulate<Nat8>(122, func(_)=byte) );
      switch( buffer.add(blob) ){
        case( #err msg ) return #err(msg);
        case( #ok _ ) ()
      };
    };
    #ok(0)
  };

};
```

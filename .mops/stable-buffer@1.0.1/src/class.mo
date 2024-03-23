import { toNat = nat64ToNat; fromNat = nat64FromNat } "mo:base/Nat64";
import { fromArray = blobFromArray } "mo:base/Blob";
import { trap; print } "mo:base/Debug";
import { tabulate } "mo:base/Array";
import { range } "mo:base/Iter";
import Region "mo:base/Region";
import T "types";
import C "const";

module {


  func get_offset(i: Nat64, bpp: Nat64, pb: Nat64, bs: Nat64): Nat64 {
    let div : Nat64 = i / bpp;
    let mod : Nat64 = i % bpp;
    if ( div + mod == 0 ) 0x00000000
    else if ( mod == 0) (C.PAGE_SIZE * div) - pb - bs - 1
    else (C.PAGE_SIZE * div) + (bs * (mod)) - 1
  };

  public class StableBuffer(state: T.State) = {

    public func size() : Nat = nat64ToNat( state.next );

    public func capacity(): Nat = nat64ToNat( state.capacity );

    public func get(i: Nat): T.Block {
      let index : Nat64 = nat64FromNat( i );
      let offset : Nat64 = get_offset(index, state.blocks_per_page, state.page_buffer, state.block_size);
      if ( index >= state.next ) trap("mo:stable-buffer/class: line 30");
      Region.loadBlob(state.blocks, offset, nat64ToNat(state.block_size))
    };

    public func getOpt(i: Nat): ?T.Block {
      let index : Nat64 = nat64FromNat( i );
      if ( index >= state.next ) return null;
      let offset : Nat64 = get_offset(index, state.blocks_per_page, state.page_buffer, state.block_size);
      ?Region.loadBlob(state.blocks, offset, nat64ToNat(state.block_size))
    };

    public func set(i: Nat, b: T.Block): T.Return<Blob> {
      let index : Nat64 = nat64FromNat( i );
      let size : Nat = nat64ToNat( state.block_size);
      if ( index >= state.next ) return #err(#out_of_bounds);
      if ( b.size() != size ) return #err(#size_error("expected: " # debug_show(state.block_size) # "; received: " # debug_show(b.size())));
      let offset : Nat64 = get_offset(index, state.blocks_per_page, state.page_buffer, state.block_size);
      let old_block : Blob = Region.loadBlob(state.blocks, offset, nat64ToNat( state.block_size ));
      Region.storeBlob(state.blocks, offset, b);
      #ok(old_block)
    };

    public func add(b: T.Block): T.Return<Nat> {
      let offset : Nat64 = get_offset(state.next, state.blocks_per_page, state.page_buffer, state.block_size);
      if ( state.next >= state.capacity ){
        if( Region.grow(state.blocks, 1) == C.MEMORY_EXHAUSTED ) return #err(#insufficient_memory);
        state.capacity += state.blocks_per_page;
      };
      Region.storeBlob(state.blocks, offset, b);
      let index : Nat = nat64ToNat( state.next );
      state.next += 1;
      #ok( index )
    };

    public func vals() : { next: () -> ?T.Block } = object {
      var pointer : Nat64 = 0;
      let bound: Nat64 = state.next;
      let bs : Nat64 = state.block_size;
      let pb : Nat64 = state.page_buffer;
      let memory: T.Region = state.blocks;
      let bpp : Nat64 = state.blocks_per_page;
      public func next(): ?T.Block {
        if ( pointer >= bound ) return null
        else {
          let offset : Nat64 = get_offset(pointer, bpp, pb, bs);
          let ret = ?Region.loadBlob(memory, offset, nat64ToNat( bs ));
          pointer += 1;
          ret
        }
      }
    };

  };
  

};
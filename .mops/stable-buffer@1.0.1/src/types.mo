import Region "mo:base/Region";

module {

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

}
import { new; grow } "mo:base/Region";
import { trap } "mo:base/Debug";
import T "types";
import C "const";

module {

  public type InitParams = {size : Nat64; capacity: Nat64};

  public func init(params: InitParams): T.State {
    let memory_region : T.Region = new();
    if ( params.size > C.PAGE_SIZE ) trap("mo:stable-buffer:state: line 12");
    let block_count : Nat64 = C.PAGE_SIZE / params.size;
    var page_count : Nat64 = params.capacity / block_count;
    if ( params.capacity % block_count > 0 ) page_count+=1;
    let initial_capacity : Nat64 = block_count * page_count;
    if( grow(memory_region, page_count) == C.MEMORY_EXHAUSTED ) trap("mo:stable-buffer/state: line 17");
    let stable_array : T.State = {
      var next = 0;
      var capacity = initial_capacity;
      blocks_per_page = block_count;
      page_buffer = C.PAGE_SIZE % params.size;
      block_size = params.size;
      blocks = memory_region
    };
    stable_array
  };

}
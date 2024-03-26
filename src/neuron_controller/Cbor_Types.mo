import Errors "mo:cbor/Errors";
import Cbor "mo:cbor/Value";

module {

  public type Key = Text;

  public type Path = [Blob];

  public type ByteArray = [Nat8];

  public type Tree = [CborValue];

  public type Entry = (Key, CborValue);

  public type CborValue = Cbor.Value;

  public type CborMap = [CborEntry];
  
  public type CborArray = [CborValue];

  public type CborEntry = (CborValue, CborValue);

  public type CborRecord = (Nat64, CborValue);

  public type ValueFn<V> = (CborValue) -> ?V;

  public type ContentMap = {
    set : (Key, CborValue) -> ();
    get : <V>(Key, ValueFn<V>) -> ?V;
    map_cbor : () -> CborMap;
    map : () -> Map;
  };

  public type HashTree = {
    lookup: (Path) -> ?Blob;
  };

  public type Map = [var ?(
    keys: [var ?Key],
    values: [var ?CborValue],
    indexes: [var Nat],
    bounds: [var Nat32],
  )];

  public type ReadRequest = {
    max_response_bytes: ?Nat64;
    canister_id: Text;
    paths : Paths
  };

  public type CallRequest = {
    max_response_bytes: ?Nat64;
    canister_id: Text;
    method_name: Text;
    arg: Blob
  };

  public type RequestType = {
    #read_state: ReadRequest;
    #query_method: CallRequest;
    #update_method: CallRequest;
  };

  public type Request = {
    request: RequestType;
    ingress_expiry: Nat;
    sender: Blob;
    nonce: ?Blob;
  };

  public type Paths = [[Blob]];

  public type CborBytes = { #majorType2 : [Nat8] };
};
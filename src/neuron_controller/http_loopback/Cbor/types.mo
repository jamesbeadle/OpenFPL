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

};
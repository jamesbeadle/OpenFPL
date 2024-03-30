import { set = mapSet; get = mapGet; thash; new } "mo:map/Map";
import { fromArray = blobFromArray } "mo:base/Blob";
import { fromIter; toArray } "mo:map/Map";
import { print; trap } "mo:base/Debug";
import { mapEntries } "mo:base/Array";
import { decode } "mo:cbor/Decoder";
import { encode } "mo:cbor/Encoder";
import T "types";

module {

  public func load(bytes: T.ByteArray): T.ContentMap {
    switch( decode( blobFromArray( bytes ) ) ){
      case( #err _ ) return empty();
      case( #ok cbor ){
        let #majorType6( rec ) = cbor else { return empty() };
        let ?hashmap = from_cbor_record((rec.tag, rec.value)) else { return empty() };
        populated( hashmap )
      }
    }
  };

  public func dump(content: T.ContentMap): T.ByteArray {
    let rec = to_cbor_record( content.map() );
    let #ok( bytes ) = encode(#majorType6({tag=rec.0; value=rec.1})) else trap("Cbor.dump()");
    bytes
  };

  func empty(): T.ContentMap = object {
    let hashmap = new<T.Key, T.CborValue>();
    public func map(): T.Map = hashmap;
    public func map_cbor(): T.CborMap = to_cbor_map( hashmap );
    public func set(k: T.Key, v: T.CborValue) = set_key_value(hashmap, k, v);
    public func get<V>(k: T.Key, fn: T.ValueFn<V>): ?V = get_key_value<V>(hashmap, k, fn);
  };

  public func populated(hashmap: T.Map): T.ContentMap = object {
    public func map(): T.Map = hashmap;
    public func map_cbor(): T.CborMap = to_cbor_map( hashmap );
    public func set(k: T.Key, v: T.CborValue) = set_key_value(hashmap, k, v);
    public func get<V>(k: T.Key, fn: T.ValueFn<V>): ?V = get_key_value<V>(hashmap, k, fn);
  }; 

  func get_key_value<V>(m: T.Map, k: T.Key, fn: T.ValueFn<V>): ?V{
    let ?value = mapGet<T.Key, T.CborValue>(m, thash, k) else { return null };
    fn( value )
  };

  func set_key_value(m: T.Map, k: T.Key, v: T.CborValue): () = mapSet(m, thash, k, v);

  func to_cbor_map(map: T.Map): T.CborMap {
    mapEntries<T.Entry, T.CborEntry>(
      toArray(map), func((key, value), _) = (#majorType3(key), value)
    );
  };

  func to_cbor_record(map: T.Map): T.CborRecord {
    let cbor_map = to_cbor_map( map );
    (55799, #majorType5( cbor_map ))
  };

  public func from_cbor_map(data: T.CborMap): T.Map {
    fromIter<T.Key, T.CborValue>(
      mapEntries<T.CborEntry, T.Entry>(data, func((key, value), cnt): T.Entry {
        switch( key ){
          case( #majorType3 name ) (name, value);
          case _ ("bad_field_" # debug_show(cnt), value);
      }}).vals(),
      thash
    )
  };

  func from_cbor_record(rec: T.CborRecord): ?T.Map {
    if ( rec.0 != 55799 ) return null;
    let #majorType5( data ) = rec.1 else { return null };
    ?from_cbor_map( data ) 
  };

};
import T "types";
import C "content";
import { HashTree = HT } "tree";
module {

  public type Key = T.Key;

  public let HashTree = HT;

  public type HashTree = T.HashTree;

  public type ContentMap = T.ContentMap;

  public type CborMap = T.CborMap;

  public type CborValue = T.CborValue;

  public type CborArray = T.CborArray;

  public type CborRecord = T.CborRecord;

  public let { load; dump; populated; from_cbor_map } = C;

  public func getNat64(v: CborValue): ?Nat64 {
    let #majorType0(value) = v else { return null };
    ?value
  };

  public func getBytearray(v: CborValue): ?[Nat8] {
    let #majorType2(value) = v else { return null };
    ?value
  };

  public func getText(v: CborValue): ?Text {
    let #majorType3(value) = v else { return null };
    ?value
  };

  public func getContentMap(v: CborValue): ?ContentMap {
    let #majorType2( bytes ) = v else { return null };
    ?load( bytes )
  };

  public func getArray(v: CborValue): ?CborArray{
    let #majorType4( arr ) = v else { return null };
    ?arr
  };

  public func getMap(v: CborValue): ?CborMap{
    let #majorType5( map ) = v else { return null };
    ?map
  };

};
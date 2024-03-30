import NatX "mo:xtended-numbers/NatX";
import Buffer "mo:base/Buffer";
import Array "mo:base/Array";
import Blob "mo:base/Blob";
import Nat8 "mo:base/Nat8";
import Char "mo:base/Char";
import S "State";

module {

  /// The following code (class not included) was sourced from gekctek's xtended-numbers library
  ///
  /// link: https://github.com/edjCase/motoko_numbers/blob/main/src/Util.mo
  ///
  /// The code has been modified to fit this use case
  ///
  func toHex(array : [Nat8]) : Text {
    Array.foldLeft<Nat8, Text>(array, "", func (accum, w8) {accum # encodeW8(w8)});
  };

  let base : Nat8 = 0x10; 

  let symbols = [
    '0', '1', '2', '3', '4', '5', '6', '7',
    '8', '9', 'A', 'B', 'C', 'D', 'E', 'F',
  ];
  /**
  * Encode an unsigned 8-bit integer in hexadecimal format.
  */
  func encodeW8(w8 : Nat8) : Text {
    let c1 = symbols[Nat8.toNat(w8 / base)];
    let c2 = symbols[Nat8.toNat(w8 % base)];
    Char.toText(c1) # Char.toText(c2);
  };

  public class Nonce(state: S.State) = {

    public func next_blob(): Blob = Blob.fromArray( next_array() );

    public func next_string(): Text = toHex( next_array() );

    public func next_array(): [Nat8] {
      let buffer = Buffer.Buffer<Nat8>(0);
      NatX.encodeNat(buffer, next(), #unsignedLEB128);
      Buffer.toArray<Nat8>( buffer );
    };

    public func next(): Nat {
      let ret : Nat = state.nonce;
      state.nonce += 1;
      ret
    };
    
  };

}
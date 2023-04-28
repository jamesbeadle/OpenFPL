import Array "mo:base/Array";
import Blob "mo:base/Blob";
import Nat8 "mo:base/Nat8";
import Nat32 "mo:base/Nat32";
import Principal "mo:base/Principal";
import Text "mo:base/Text";
import CRC32 "./CRC32";
import SHA224 "./SHA224";
import Buffer "mo:base/Buffer";
import Iter "mo:base/Iter";
import Result "mo:base/Result";
import Option "mo:base/Option";
import Types "types";

module {

  public type AccountIdentifier = Blob;
  
  public type Subaccount = Blob;

  private let base : Nat8 = 0x10;

  private let symbols = [
      '0', '1', '2', '3', '4', '5', '6', '7',
      '8', '9', 'a', 'b', 'c', 'd', 'e', 'f',
  ];

  func beBytes(n: Nat32) : [Nat8] {
    func byte(n: Nat32) : Nat8 {
      Nat8.fromNat(Nat32.toNat(n & 0xff))
    };
    [byte(n >> 24), byte(n >> 16), byte(n >> 8), byte(n)]
  };

  public func defaultSubaccount() : Subaccount {
    Blob.fromArrayMut(Array.init(32, 0 : Nat8))
  };

  public func accountIdentifier(principal: Principal, subaccount: Subaccount) : AccountIdentifier {
    let hash = SHA224.Digest();
    hash.write([0x0A]);
    hash.write(Blob.toArray(Text.encodeUtf8("account-id")));
    hash.write(Blob.toArray(Principal.toBlob(principal)));
    hash.write(Blob.toArray(subaccount));
    let hashSum = hash.sum();
    let crc32Bytes = beBytes(CRC32.ofArray(hashSum));

    let buffer = Buffer.fromArray<Nat8>(crc32Bytes);
    for (x in hashSum.vals()) {
      buffer.add(x);
    };
    
    Blob.fromArray(Buffer.toArray(buffer));
  };

  public func validateAccountIdentifier(accountIdentifier : AccountIdentifier) : Bool {
    if (accountIdentifier.size() != 32) {
      return false;
    };
    let a = Blob.toArray(accountIdentifier);
    let accIdPart    = Array.tabulate(28, func(i: Nat): Nat8 { a[i + 4] });
    let checksumPart = Array.tabulate(4,  func(i: Nat): Nat8 { a[i] });
    let crc32 = CRC32.ofArray(accIdPart);
    Array.equal(beBytes(crc32), checksumPart, Nat8.equal)
  };

  public func principalToSubaccount(principal: Principal) : Blob {
    let idHash = SHA224.Digest();
    idHash.write(Blob.toArray(Principal.toBlob(principal)));
    let hashSum = idHash.sum();
    let crc32Bytes = beBytes(CRC32.ofArray(hashSum));

    let buffer = Buffer.fromArray<Nat8>(crc32Bytes);
    for (x in hashSum.vals()) {
      buffer.add(x);
    };

    let blob = Blob.fromArray(Buffer.toArray(buffer));

    return blob;
  };
 
  public func decode(text : Text) : Result.Result<[Nat8], Types.Error> {
      let next = text.chars().next;
      func parse() : Result.Result<Nat8, Types.Error> {
      Option.get<Result.Result<Nat8, Types.Error>>(
          do ? {
          let c1 = next()!;
          let c2 = next()!;
          Result.chain<Nat8, Nat8, Types.Error>(decodeW4(c1), func (x1) {
              Result.chain<Nat8, Nat8, Types.Error>(decodeW4(c2), func (x2) {
                  #ok (x1 * base + x2);
              })
          })
          },
          #err (#DecodeError),
      );
      };
      var i = 0;
      let n = text.size() / 2 + text.size() % 2;
      let array = Array.init<Nat8>(n, 0);
      while (i != n) {
      switch (parse()) {
          case (#ok w8) {
          array[i] := w8;
          i += 1;
          };
          case (#err err) {
          return #err err;
          };
      };
      };
      #ok (Array.freeze<Nat8>(array));
  };

  private func decodeW4(char : Char) : Result.Result<Nat8, Types.Error> {
      for (i in Iter.range(0, 15)) {
      if (symbols[i] == char) {
          return #ok (Nat8.fromNat(i));
      };
      };
      #err (#DecodeError);
  };
  
}

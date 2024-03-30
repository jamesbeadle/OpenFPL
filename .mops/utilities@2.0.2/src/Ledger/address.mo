import { crc32 } "crc32";
import T "types";
import { trap } "mo:base/Debug";
import { toArray = blobToArray; fromArray = blobFromArray }"mo:base/Blob";
import { tabulate; equal = equal_arrays } "mo:base/Array";
import { range } "mo:base/Iter";
import Buffer "mo:base/Buffer";
import { fromIntWrap } "mo:base/Nat8";
import { toLedgerAccount } "mo:base/Principal";
import Hex "hex";

module {

  public func from_principal(p: Principal, sa: ?Nat): T.Address {
    from_identifier( identifier_from_principal(p, sa) )
  };

  public func identifier_from_principal(p: Principal, n: ?Nat) : T.AccountIdentifier {
    let ?sa = n else { return toLedgerAccount(p, null) };
    toLedgerAccount(p, ?nat_to_subaccount(sa))
  };

  public func nat_to_subaccount(n: Nat) : T.Subaccount {
    blobFromArray(
      tabulate<Nat8>(32, func(i){
        fromIntWrap(n / 2 ** (8 * (32 - 1 - i)))
      })
    )
  };

  public func from_identifier( aid : T.AccountIdentifier ): T.Address {
    assert aid.size() == 32;
    let b : [Nat8] = blobToArray( aid );
    let crcx : [Nat8] = byte_range(b,0,3);
    let crcy : [Nat8] = crc32(byte_range(b,4,31).vals());
    if ( not equal_arrays<Nat8>(crcx, crcy, func(x:Nat8,y:Nat8) = x == y) ) trap("Account.from_identifier()")
    else Hex.encode( b )
  };

  public func to_identifier( aid : T.Address ) : T.AccountIdentifier {
    switch( Hex.decode( aid ) ){
      case ( #err(_) ) trap("Account.to_identifier()");
      case ( #ok( b ) ){
        if ( b.size() != 32 ) trap("Account.to_identifier()")
        else {
          let crcx : [Nat8] = byte_range(b,0,3);
          let crcy : [Nat8] = crc32(byte_range(b,4,31).vals());
          if ( not equal_arrays<Nat8>(crcx, crcy, func(x : Nat8,y :Nat8) = x ==y) ) trap("Account.to_identifier()")
          else blobFromArray(b);
        }
      }
    }
  };

  public func is_valid( aid : T.Address ) : Bool {
    switch( Hex.decode( aid ) ){
      case ( #err(_) ) false;
      case ( #ok( b ) ){
        if ( b.size() != 32 ) false
        else {
          let crcx : [Nat8] = byte_range(b,0,3);
          let crcy : [Nat8] = crc32(byte_range(b,4,31).vals());
          if ( not equal_arrays<Nat8>(crcx, crcy, func(x : Nat8,y :Nat8) = x ==y) ) false
          else true
        }
      }
    }
  };

  public func is_valid_identifier( aid : T.AccountIdentifier ) : Bool {
    if ( aid.size() != 32 ) return false;
    let b : [Nat8] = blobToArray( aid );
    let crcx : [Nat8] = byte_range(b,0,3);
    let crcy : [Nat8] = crc32(byte_range(b,4,31).vals());
    if ( not equal_arrays<Nat8>(crcx, crcy, func(x:Nat8,y:Nat8) = x == y) ) false
    else true
  };

  func byte_range( b : [Nat8], start : Nat, stop : Nat ) : [Nat8] {
    let buffer = Buffer.Buffer<Nat8>((stop - start) +1);
    for ( i in range(start,stop) ) buffer.add( b[i] );
    Buffer.toArray(buffer);
  };
  
};
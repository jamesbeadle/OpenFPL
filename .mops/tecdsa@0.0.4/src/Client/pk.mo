import { fromArray = blobFromArray; toArray = blobToArray } "mo:base/Blob";
import { fromBlob = principalFromBlob } "mo:base/Principal";
import { fromIter = sha256FromIter } "mo:sha2/Sha256";
import { SECP256K1 = {P_VALUE; KEY_SIZE} } "const";
import { tabulate } "mo:base/Array";
import { trap } "mo:base/Debug";
import Int "int";
import T "types";

module {


  public func toPrincipal(pk: T.PublicKey): Principal {

    if ( pk.size() != KEY_SIZE ) trap("mo:tecdsa/client/pk: line 13");

    let hash: [Nat8] = blobToArray( sha256FromIter(#sha224, pk.vals()) );

    principalFromBlob(blobFromArray(tabulate<Nat8>(29,
      func(x) = if (x < 28) hash[x] else 0x02
    )))

  };


  public func fromCompressedKey(pk: Blob): T.PublicKey {
    
    assert pk.size() == 33;
    let compressed_pk : [Nat8] = blobToArray( pk );
    let x = Int.generate(32, func(i): Nat8 {compressed_pk[i+1]});

    let p: Int = P_VALUE;
    let y_square : Int = (((x ** 3) % p) + 7) % p;
    let y_square_square_root = Int.pow_mod(y_square, ((p + 1) / 4), p);

    let prefix : Nat8 = compressed_pk[0];
    let is_even : Bool = (y_square_square_root % 2) == 0;
    let y : Int = if ( (prefix == 0x02 and not is_even ) or (prefix == 0x03 and is_even ) ) 
      Int.modulo(-1 * y_square_square_root, p) else y_square_square_root;

    let (_, y_genFn) = Int.generator( y );
    tabulate<Nat8>(65, func(i): Nat8 {
      if ( i == 0 ) return 0x04;
      if ( i < 33 ) compressed_pk[i]
      else y_genFn(i - 33)
    });

  };

}
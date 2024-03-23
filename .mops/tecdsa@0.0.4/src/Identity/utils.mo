import { trap } "mo:base/Debug";
import { range } "mo:base/Iter";
import { Buffer }  "mo:base/Buffer";
import { encodeUtf8 } "mo:base/Text";
import { rangeFrom; blob } "mo:base/Random";
import { init; freeze } "mo:base/Array";
import { BIP39_WORD_LIST; BIP39_WORD_COUNT } "const";
import { fromBlob = principalFromBlob } "mo:base/Principal";
import { tabulate } "mo:base/Array";
import {
  fromArray = blobFromArray; toArray = blobToArray
} "mo:base/Blob";
import { 
  fromBlob = sha256FromBlob; fromIter = sha256FromIter
} "mo:sha2/Sha256";

module {

  type Iter<T> = { next: () -> ?T };
  
  /// Generates a fixed array of 24 random BIP39 seed words
  public func generateSeedPhrase(): async* [Text] {
    let seed : [var Text] = init(24, "");
    let entropy = Buffer<async Blob>(24);
    for ( i in range(0, 23) ) entropy.add(blob());
    for ( i in range(0, 23) ) seed[i] := BIP39_WORD_LIST[rangeFrom(16, await entropy.get(i)) % BIP39_WORD_COUNT];
    freeze<Text>( seed );
  };

  public func hashSeedPhrase(seed: [Text]): Blob {
    var next_word : Nat = 1;
    let word_count : Nat = seed.size();
    var bytes: Iter<Nat8> = encodeUtf8(seed[0]).vals();
    sha256FromIter(#sha256, object {
      public func next(): ?Nat8 {
        switch( bytes.next() ){
          case( ?byte ) ?byte;
          case null {
            if ( next_word >= word_count ) null
            else {
              bytes := encodeUtf8(seed[next_word]).vals();
              let ?byte = bytes.next() else { trap("ECDSA.Identity.Utils.hashSeed") };
              next_word += 1;
              ?byte
            }
          }
        }
      }
    })
  };

  public func principalOfPublicKey(pk: Blob): Principal {
    let hash: [Nat8] = blobToArray(sha256FromBlob(#sha224, pk));
    principalFromBlob(blobFromArray(tabulate<Nat8>(29,
      func(x) = if (x < 28) hash[x] else 0x02
    )))
  };

}
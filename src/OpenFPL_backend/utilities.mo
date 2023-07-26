import Hash "mo:base/Hash";
import Nat32 "mo:base/Nat32";
import Nat16 "mo:base/Nat16";
module {
    public let eqNat16 = func (a: Nat16, b: Nat16) : Bool {
        a == b
    };

    public let hashNat16 = func (key: Nat16) : Hash.Hash {
        Nat32.fromNat(Nat16.toNat(key)%(2 ** 32 -1));
    };
};

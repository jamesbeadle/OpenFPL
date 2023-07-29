import Hash "mo:base/Hash";
import Nat32 "mo:base/Nat32";
import Nat16 "mo:base/Nat16";
import Nat8 "mo:base/Nat8";

module {
    public let eqNat8 = func (a: Nat8, b: Nat8) : Bool {
        a == b
    };

    public let hashNat8 = func (key: Nat8) : Hash.Hash {
        Nat32.fromNat(Nat8.toNat(key)%(2 ** 32 -1));
    };

    public let eqNat16 = func (a: Nat16, b: Nat16) : Bool {
        a == b
    };

    public let hashNat16 = func (key: Nat16) : Hash.Hash {
        Nat32.fromNat(Nat16.toNat(key)%(2 ** 32 -1));
    };

    public let eqNat32 = func (a: Nat32, b: Nat32) : Bool {
        a == b
    };

    public let hashNat32 = func (key: Nat32) : Hash.Hash {
        Nat32.fromNat(Nat32.toNat(key)%(2 ** 32 -1));
    };
};

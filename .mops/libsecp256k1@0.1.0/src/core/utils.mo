import Nat8 "mo:base/Nat8";
import Nat32 "mo:base/Nat32";
import Nat64 "mo:base/Nat64";
import Buffer "mo:base/Buffer";

module {
    public let TAG_PUBKEY_EVEN: Nat8 = 0x02;
    public let TAG_PUBKEY_ODD: Nat8 = 0x03;
    public let TAG_PUBKEY_FULL: Nat8 = 0x04;
    public let TAG_PUBKEY_HYBRID_EVEN: Nat8 = 0x06;
    public let TAG_PUBKEY_HYBRID_ODD: Nat8 = 0x07;

    public let MESSAGE_SIZE: Nat = 32;
    public let SECRET_KEY_SIZE: Nat = 32;
    public let RAW_PUBLIC_KEY_SIZE: Nat = 64;
    public let FULL_PUBLIC_KEY_SIZE: Nat = 65;
    public let COMPRESSED_PUBLIC_KEY_SIZE: Nat = 33;
    public let SIGNATURE_SIZE: Nat = 64;
    public let DER_MAX_SIGNATURE_SIZE: Nat = 72;

    public func u32(a: Nat8): Nat32 {
        Nat32.fromNat(Nat8.toNat(a))
    };

    public func u8(a: Nat32): Nat8 {
        Nat8.fromNat(Nat32.toNat(a & 0xff))
    };

    public func u64(a: Nat32): Nat64 {
        Nat64.fromNat(Nat32.toNat(a))
    };

    // u64 small u32
    public func u64u32(a: Nat64): Nat32 {
        Nat32.fromNat(Nat64.toNat(a & 0xffffffff));
    };

    public func u8u64(a: Nat8): Nat64 {
        Nat64.fromNat(Nat8.toNat(a))
    };

    public func u64u8(a: Nat64): Nat8 {
        Nat8.fromNat(Nat64.toNat(a & 0xff))
    };

    public func boolu8(b: Bool): Nat8 {
        if b { 1 } else { 0 };
    };

    public func boolu64(b: Bool): Nat64 {
        if b { 1 } else { 0 };
    };

    public func boolu32(b: Bool): Nat32 {
        if b { 1 } else { 0 };
    };
};
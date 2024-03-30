import Array "mo:base/Array";
import Iter "mo:base/Iter";
import Nat32 "mo:base/Nat32";
import Nat64 "mo:base/Nat64";

import Utils "./utils";
import subtle "../subtle/lib";

module {
    type Choice = subtle.Choice;

    let u8 = Utils.u8;
    let u32 = Utils.u32;
    let u64 = Utils.u64;
    let u8u64 = Utils.u8u64;
    let u64u32 = Utils.u64u32;
    let u64u8 = Utils.u64u8;
    let boolu8 = Utils.boolu8;
    let boolu32 = Utils.boolu32;
    let boolu64 = Utils.boolu64;

    let MaxU32: Nat32 = 0xffff_ffff;

    let SECP256K1_N: [Nat32] = [
        0xD0364141, 0xBFD25E8C, 0xAF48A03B, 0xBAAEDCE6, 0xFFFFFFFE, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF];
    let SECP256K1_N_C_0: Nat32 = 0x2FC9BEBF;
    let SECP256K1_N_C_1: Nat32 = 0x402DA173;
    let SECP256K1_N_C_2: Nat32 = 0x50B75FC4;
    let SECP256K1_N_C_3: Nat32 = 0x45512319;
    let SECP256K1_N_C_4: Nat32 = 1;

    let SECP256K1_N_H_0: Nat32 = 0x681B20A0;
    let SECP256K1_N_H_1: Nat32 = 0xDFE92F46;
    let SECP256K1_N_H_2: Nat32 = 0x57A4501D;
    let SECP256K1_N_H_3: Nat32 = 0x5D576E73;
    let SECP256K1_N_H_4: Nat32 = 0xFFFFFFFF;
    let SECP256K1_N_H_5: Nat32 = 0xFFFFFFFF;
    let SECP256K1_N_H_6: Nat32 = 0xFFFFFFFF;
    let SECP256K1_N_H_7: Nat32 = 0x7FFFFFFF;

    /// A 256-bit scalar value.
    public class Scalar() {
        public let n: [var Nat32] = Array.tabulateVar<Nat32>(8, func i = 0);

        public func clone(): Scalar {
            let ret = Scalar();
            ret.n[0] := n[0];
            ret.n[1] := n[1];
            ret.n[2] := n[2];
            ret.n[3] := n[3];
            ret.n[4] := n[4];
            ret.n[5] := n[5];
            ret.n[6] := n[6];
            ret.n[7] := n[7];
            ret
        };

        public func assign_mut(a: Scalar) {
            n[0] := a.n[0];
            n[1] := a.n[1];
            n[2] := a.n[2];
            n[3] := a.n[3];
            n[4] := a.n[4];
            n[5] := a.n[5];
            n[6] := a.n[6];
            n[7] := a.n[7];
        };

        /// Clear a scalar to prevent the leak of sensitive data.
        public func clear() {
            n[0] := 0;
            n[1] := 0;
            n[2] := 0;
            n[3] := 0;
            n[4] := 0;
            n[5] := 0;
            n[6] := 0;
            n[7] := 0;
        };

        /// Set a scalar to an unsigned integer.
        public func set_int(v: Nat32) {
            n[0] := v;
            n[1] := 0;
            n[2] := 0;
            n[3] := 0;
            n[4] := 0;
            n[5] := 0;
            n[6] := 0;
            n[7] := 0;
        };

        public func set(arr: [Nat32]) {
            n[0] := arr[0];
            n[1] := arr[1];
            n[2] := arr[2];
            n[3] := arr[3];
            n[4] := arr[4];
            n[5] := arr[5];
            n[6] := arr[6];
            n[7] := arr[7];
        };

        /// Access bits from a scalar. All requested bits must belong to
        /// the same 32-bit limb. can be used in wasm32
        public func bits(
            offset: Nat64, 
            count: Nat64
        ): Nat32 {
            assert((offset +% count -% 1) >> 5 == offset >> 5);
            let index = Nat64.toNat(offset >> 5);
            return Nat32.fromNat(Nat64.toNat(
                (Nat64.fromNat(Nat32.toNat(n[index])) >> (offset & 0x1F)) & ((1 << count) - 1)
            ));
        };

        /// Access bits from a scalar. Not constant time.
        public func bits_var(
            offset: Nat64, 
            count: Nat64
        ): Nat32 {
            assert(count < 32);
            assert(offset +% count <= 256);
            if ((offset +% count -% 1) >> 5 == offset >> 5) {
                bits(offset, count)
            } else {
                assert((offset >> 5) +% 1 < 8);
                let index = Nat64.toNat(offset >> 5);
                return Nat32.fromNat(Nat64.toNat(
                    ((Nat64.fromNat(Nat32.toNat(n[index])) >> (offset & 0x1f))
                        | (Nat64.fromNat(Nat32.toNat(n[index + 1])) << (32 -% (offset & 0x1f))))
                        & ((1 << count) -% 1)
                ));
            };
        };

        public func check_overflow(): Choice {
            let yes: Choice = subtle.into(0);
            let no: Choice = subtle.into(0);
            no.bitor_assign(subtle.into(boolu8(n[7] < SECP256K1_N[7]))); /* No need for a > check. */
            no.bitor_assign(subtle.into(boolu8(n[6] < SECP256K1_N[6]))); /* No need for a > check. */
            no.bitor_assign(subtle.into(boolu8(n[5] < SECP256K1_N[5]))); /* No need for a > check. */
            no.bitor_assign(subtle.into(boolu8(n[4] < SECP256K1_N[4])));
            yes.bitor_assign(subtle.into(boolu8(n[4] > SECP256K1_N[4])).bitand(no.no()));
            no.bitor_assign(subtle.into(boolu8(n[3] < SECP256K1_N[3])).bitand(yes.no()));
            yes.bitor_assign(subtle.into(boolu8(n[3] > SECP256K1_N[3])).bitand(no.no()));
            no.bitor_assign(subtle.into(boolu8(n[2] < SECP256K1_N[2])).bitand(yes.no()));
            yes.bitor_assign(subtle.into(boolu8(n[2] > SECP256K1_N[2])).bitand(no.no()));
            no.bitor_assign(subtle.into(boolu8(n[1] < SECP256K1_N[1])).bitand(yes.no()));
            yes.bitor_assign(subtle.into(boolu8(n[1] > SECP256K1_N[1])).bitand(no.no()));
            yes.bitor_assign(subtle.into(boolu8(n[0] >= SECP256K1_N[0])).bitand(no.no()));

            yes
        };

        func reduce(overflow: Choice) {
            let o = u8u64(overflow.unwrap_u8());
            var t: Nat64 = 0;

            t := u64(n[0]) +% o *% u64(SECP256K1_N_C_0);
            n[0] := u64u32(t & 0xFFFFFFFF);
            t >>= 32;

            t +%= u64(n[1]) +% o *% u64(SECP256K1_N_C_1);
            n[1] := u64u32(t & 0xFFFFFFFF);
            t >>= 32;

            t +%= u64(n[2]) +% o *% u64(SECP256K1_N_C_2);
            n[2] := u64u32(t & 0xFFFFFFFF);
            t >>= 32;

            t +%= u64(n[3]) +% o *% u64(SECP256K1_N_C_3);
            n[3] := u64u32(t & 0xFFFFFFFF);
            t >>= 32;

            t +%= u64(n[4]) +% o *% u64(SECP256K1_N_C_4);
            n[4] := u64u32(t & 0xFFFFFFFF);
            t >>= 32;

            t +%= u64(n[5]);
            n[5] := u64u32(t & 0xFFFFFFFF);
            t >>= 32;

            t +%= u64(n[6]);
            n[6] := u64u32(t & 0xFFFFFFFF);
            t >>= 32;

            t +%= u64(n[7]);
            n[7] := u64u32(t & 0xFFFFFFFF);
        };

        /// Conditionally add a power of two to a scalar. The result is
        /// not allowed to overflow.
        /// notion: bit can be motified.
        public func cadd_bit(_bit: Nat32, flag: Bool) {
            var bit: Nat32 = _bit;
            var t: Nat64 = 0;
            assert(bit < 256);
            bit +%= (if flag { 0 } else { MaxU32 }) & 0x100;
            t := u64(n[0]) +% u64((if ((bit >> 5) == 0) { 1 } else { 0 }) << (bit & 0x1F));
            n[0] := u64u32(t & 0xFFFFFFFF);
            t >>= 32;
            t +%= u64(n[1]) +% u64((if ((bit >> 5) == 1) { 1 } else { 0 }) << (bit & 0x1F));
            n[1] := u64u32(t & 0xFFFFFFFF);
            t >>= 32;
            t +%= u64(n[2]) +% u64((if ((bit >> 5) == 2) { 1 } else { 0 }) << (bit & 0x1F));
            n[2] := u64u32(t & 0xFFFFFFFF);
            t >>= 32;
            t +%= u64(n[3]) +% u64((if ((bit >> 5) == 3) { 1 } else { 0 }) << (bit & 0x1F));
            n[3] := u64u32(t & 0xFFFFFFFF);
            t >>= 32;
            t +%= u64(n[4]) +% u64((if ((bit >> 5) == 4) { 1 } else { 0 }) << (bit & 0x1F));
            n[4] := u64u32(t & 0xFFFFFFFF);
            t >>= 32;
            t +%= u64(n[5]) +% u64((if ((bit >> 5) == 5) { 1 } else { 0 }) << (bit & 0x1F));
            n[5] := u64u32(t & 0xFFFFFFFF);
            t >>= 32;
            t +%= u64(n[6]) +% u64((if ((bit >> 5) == 6) { 1 } else { 0 }) << (bit & 0x1F));
            n[6] := u64u32(t & 0xFFFFFFFF);
            t >>= 32;
            t +%= u64(n[7]) +% u64((if ((bit >> 5) == 7) { 1 } else { 0 }) << (bit & 0x1F));
            n[7] := u64u32(t & 0xFFFFFFFF);
            assert((t >> 32) == 0);
            assert(not subtle.from(clone().check_overflow()));
        };

        /// Set a scalar from a big endian byte array, return whether it overflowed.
        public func set_b32(b32: [Nat8], offset: Nat): Choice {
            n[0] := u32(b32[offset + 31])
                | (u32(b32[offset + 30]) << 8)
                | (u32(b32[offset + 29]) << 16)
                | (u32(b32[offset + 28]) << 24);
            n[1] := u32(b32[offset + 27])
                | (u32(b32[offset + 26]) << 8)
                | (u32(b32[offset + 25]) << 16)
                | (u32(b32[offset + 24]) << 24);
            n[2] := u32(b32[offset + 23])
                | (u32(b32[offset + 22]) << 8)
                | (u32(b32[offset + 21]) << 16)
                | (u32(b32[offset + 20]) << 24);
            n[3] := u32(b32[offset + 19])
                | (u32(b32[offset + 18]) << 8)
                | (u32(b32[offset + 17]) << 16)
                | (u32(b32[offset + 16]) << 24);
            n[4] := u32(b32[offset + 15])
                | (u32(b32[offset + 14]) << 8)
                | (u32(b32[offset + 13]) << 16)
                | (u32(b32[offset + 12]) << 24);
            n[5] := u32(b32[offset + 11])
                | (u32(b32[offset + 10]) << 8)
                | (u32(b32[offset + 9]) << 16)
                | (u32(b32[offset + 8]) << 24);
            n[6] := u32(b32[offset + 7])
                | (u32(b32[offset + 6]) << 8)
                | (u32(b32[offset + 5]) << 16)
                | (u32(b32[offset + 4]) << 24);
            n[7] := u32(b32[offset + 3])
                | (u32(b32[offset + 2]) << 8)
                | (u32(b32[offset + 1]) << 16)
                | (u32(b32[offset + 0]) << 24);

            let overflow = check_overflow();
            reduce(overflow);

            overflow
        };

        /// Convert a scalar to a byte array.
        public func b32(): [var Nat8] {
            let bin = Array.tabulateVar<Nat8>(32, func i = 0);
            fill_b32(bin, 0);
            bin
        };

        /// Convert a scalar to a byte array.
        public func fill_b32(bin: [var Nat8], offset: Nat) {
            bin[offset + 0] := u8(n[7] >> 24);
            bin[offset + 1] := u8(n[7] >> 16);
            bin[offset + 2] := u8(n[7] >> 8);
            bin[offset + 3] := u8(n[7] & 0xff);
            bin[offset + 4] := u8(n[6] >> 24);
            bin[offset + 5] := u8(n[6] >> 16);
            bin[offset + 6] := u8(n[6] >> 8);
            bin[offset + 7] := u8(n[6] & 0xff);
            bin[offset + 8] := u8(n[5] >> 24);
            bin[offset + 9] := u8(n[5] >> 16);
            bin[offset + 10] := u8(n[5] >> 8);
            bin[offset + 11] := u8(n[5] & 0xff);
            bin[offset + 12] := u8(n[4] >> 24);
            bin[offset + 13] := u8(n[4] >> 16);
            bin[offset + 14] := u8(n[4] >> 8);
            bin[offset + 15] := u8(n[4] & 0xff);
            bin[offset + 16] := u8(n[3] >> 24);
            bin[offset + 17] := u8(n[3] >> 16);
            bin[offset + 18] := u8(n[3] >> 8);
            bin[offset + 19] := u8(n[3] & 0xff);
            bin[offset + 20] := u8(n[2] >> 24);
            bin[offset + 21] := u8(n[2] >> 16);
            bin[offset + 22] := u8(n[2] >> 8);
            bin[offset + 23] := u8(n[2]) & 0xff;
            bin[offset + 24] := u8(n[1] >> 24);
            bin[offset + 25] := u8(n[1] >> 16);
            bin[offset + 26] := u8(n[1] >> 8);
            bin[offset + 27] := u8(n[1] & 0xff);
            bin[offset + 28] := u8(n[0] >> 24);
            bin[offset + 29] := u8(n[0] >> 16);
            bin[offset + 30] := u8(n[0] >> 8);
            bin[offset + 31] := u8(n[0] & 0xff);
        };

        /// Check whether a scalar equals zero.
        public func is_zero(): Bool {
            (n[0]
                | n[1]
                | n[2]
                | n[3]
                | n[4]
                | n[5]
                | n[6]
                | n[7])
                == 0
        };

        /// Check whether a scalar equals one.
        public func is_one(): Bool {
            ((n[0] ^ 1)
                | n[1]
                | n[2]
                | n[3]
                | n[4]
                | n[5]
                | n[6]
                | n[7])
                == 0
        };

        /// Check whether a scalar is higher than the group order divided
        /// by 2.
        public func is_high(): Bool {
            let yes: Choice = subtle.into(0);
            let no: Choice = subtle.into(0);
            no.bitor_assign(subtle.into(boolu8(n[7] < SECP256K1_N_H_7)));
            yes.bitor_assign(subtle.into(boolu8(n[7] > SECP256K1_N_H_7)).bitand(no.no()));
            no.bitor_assign(subtle.into(boolu8(n[6] < SECP256K1_N_H_6)).bitand(yes.no())); /* No need for a > check. */
            no.bitor_assign(subtle.into(boolu8(n[5] < SECP256K1_N_H_5)).bitand(yes.no())); /* No need for a > check. */
            no.bitor_assign(subtle.into(boolu8(n[4] < SECP256K1_N_H_4)).bitand(yes.no())); /* No need for a > check. */
            no.bitor_assign(subtle.into(boolu8(n[3] < SECP256K1_N_H_3)).bitand(yes.no()));
            yes.bitor_assign(subtle.into(boolu8(n[3] > SECP256K1_N_H_3)).bitand(no.no()));
            no.bitor_assign(subtle.into(boolu8(n[2] < SECP256K1_N_H_2)).bitand(yes.no()));
            yes.bitor_assign(subtle.into(boolu8(n[2] > SECP256K1_N_H_2)).bitand(no.no()));
            no.bitor_assign(subtle.into(boolu8(n[1] < SECP256K1_N_H_1)).bitand(yes.no()));
            yes.bitor_assign(subtle.into(boolu8(n[1] > SECP256K1_N_H_1)).bitand(no.no()));
            yes.bitor_assign(subtle.into(boolu8(n[0] >= SECP256K1_N_H_0)).bitand(no.no()));
            
            subtle.from(yes)
        };

        /// Conditionally negate a number, in constant time.
        public func cond_neg_assign(flag: Choice) {
            let mask = MaxU32 *% u32(flag.unwrap_u8());

            let nonzero = 0xFFFFFFFF *% boolu64(not is_zero());
            var t = 1 *% u8u64(flag.unwrap_u8());

            for (i in Iter.range(0, 7)) { //0..8
                t +%= u64(n[i] ^ mask) +% u64(SECP256K1_N[i] & mask);
                n[i] := u64u32(t & nonzero);
                t >>= 32;
            };


            let _ = t;
        };

        func reduce_512(l: [Nat32]) {
            var c0: Nat32 = 0;
            var c1: Nat32 = 0;
            var c2: Nat32 = 0;

            var c: Nat64 = 0;
            let (n0, n1, n2, n3, n4, n5, n6, n7) =
                (l[8], l[9], l[10], l[11], l[12], l[13], l[14], l[15]);
            var m0: Nat32 = 0;
            var m1: Nat32 = 0;
            var m2: Nat32 = 0;
            var m3: Nat32 = 0;
            var m4: Nat32 = 0;            
            var m5: Nat32 = 0;
            var m6: Nat32 = 0;
            var m7: Nat32 = 0;
            var m8: Nat32 = 0;
            var m9: Nat32 = 0;
            var m10: Nat32 = 0;
            var m11: Nat32 = 0;
            var m12: Nat32 = 0;

            var p0: Nat32 = 0;
            var p1: Nat32 = 0;
            var p2: Nat32 = 0;
            var p3: Nat32 = 0;
            var p4: Nat32 = 0;
            var p5: Nat32 = 0;
            var p6: Nat32 = 0;
            var p7: Nat32 = 0;
            var p8: Nat32 = 0;

            c0 := l[0];
            c1 := 0;
            c2 := 0;

            // muladd_fast!(n0, SECP256K1_N_C_0);
            do {
                let (_c0, _c1, _c2) = muladd_fast(c0, c1, c2, n0, SECP256K1_N_C_0);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
            };

            // m0 = extract_fast!();
            do {
                let (_c0, _c1, _c2, _m0) = extract_fast(c0, c1, c2);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
                m0 := _m0;
            };

            // sumadd_fast!(l[1]);
            do {
                let (_c0, _c1, _c2) = sumadd_fast(c0, c1, c2, l[1]);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
            };

            // muladd!(n1, SECP256K1_N_C_0);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, n1, SECP256K1_N_C_0);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
            };

            // muladd!(n0, SECP256K1_N_C_1);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, n0, SECP256K1_N_C_1);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;   
            };
         
            // m1 = extract!();
            do {
                let (_c0, _c1, _c2, _m1) = extract(c0, c1, c2);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
                m1 := _m1;
            };

            // sumadd!(l[2]);
            do {
                let (_c0, _c1, _c2) = sumadd(c0, c1, c2, l[2]);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
            };

            // muladd!(n2, SECP256K1_N_C_0);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, n2, SECP256K1_N_C_0);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;  
            };

            // muladd!(n1, SECP256K1_N_C_1);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, n1, SECP256K1_N_C_1);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
            };
            
            // muladd!(n0, SECP256K1_N_C_2);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, n0, SECP256K1_N_C_2);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
            };

            // m2 = extract!();
            do {
                let (_c0, _c1, _c2, _m2) = extract(c0, c1, c2);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
                m2 := _m2;
            };

            // sumadd!(l[3]);
            do {
                let (_c0, _c1, _c2) = sumadd(c0, c1, c2, l[3]);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
            };

            // muladd!(n3, SECP256K1_N_C_0);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, n3, SECP256K1_N_C_0);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
            };

            // muladd!(n2, SECP256K1_N_C_1);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, n2, SECP256K1_N_C_1);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
            };

            // muladd!(n1, SECP256K1_N_C_2);
            do {
                let (tp0, tp1, tp2) = muladd(c0, c1, c2, n1, SECP256K1_N_C_2);
                c0 := tp0;
                c1 := tp1;
                c2 := tp2;
            };

            // muladd!(n0, SECP256K1_N_C_3);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, n0, SECP256K1_N_C_3);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
            };

            // m3 = extract!();
            do {
                let (_c0, _c1, _c2, _m3) = extract(c0, c1, c2);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
                m3 := _m3;
            };

            // sumadd!(l[4]);
            do {
                let (_c0, _c1, _c2) = sumadd(c0, c1, c2, l[4]);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
            };

            // muladd!(n4, SECP256K1_N_C_0);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, n4, SECP256K1_N_C_0);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
            };

            // muladd!(n3, SECP256K1_N_C_1);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, n3, SECP256K1_N_C_1);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
            };

            // muladd!(n2, SECP256K1_N_C_2);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, n2, SECP256K1_N_C_2);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
            };

            // muladd!(n1, SECP256K1_N_C_3);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, n1, SECP256K1_N_C_3);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
            };

            // sumadd!(n0);
            do {
                let (_c0, _c1, _c2) = sumadd(c0, c1, c2, n0);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
            };

            // m4 = extract!();
            do {
                let (_c0, _c1, _c2, _m4) = extract(c0, c1, c2);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
                m4 := _m4;
            };

            // sumadd!(l[5]);
            do {
                let (_c0, _c1, _c2) = sumadd(c0, c1, c2, l[5]);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
            };

            // muladd!(n5, SECP256K1_N_C_0);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, n5, SECP256K1_N_C_0);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
            };

            // muladd!(n4, SECP256K1_N_C_1);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, n4, SECP256K1_N_C_1);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
            };

            // muladd!(n3, SECP256K1_N_C_2);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, n3, SECP256K1_N_C_2);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
            };

            // muladd!(n2, SECP256K1_N_C_3);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, n2, SECP256K1_N_C_3);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
            };

            // sumadd!(n1);
            do {
                let (_c0, _c1, _c2) = sumadd(c0, c1, c2, n1);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
            };
            
            // m5 = extract!();
            do {
                let (_c0, _c1, _c2, _m5) = extract(c0, c1, c2);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
                m5 := _m5;
            };

            // sumadd!(l[6]);
            do {
                let (_c0, _c1, _c2) = sumadd(c0, c1, c2, l[6]);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
            };
            
            // muladd!(n6, SECP256K1_N_C_0);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, n6, SECP256K1_N_C_0);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
            };

            // muladd!(n5, SECP256K1_N_C_1);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, n5, SECP256K1_N_C_1);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
            };
            
            // muladd!(n4, SECP256K1_N_C_2);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, n4, SECP256K1_N_C_2);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
            };

            // muladd!(n3, SECP256K1_N_C_3);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, n3, SECP256K1_N_C_3);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
            };

            // sumadd!(n2);
            do {
                let (_c0, _c1, _c2) = sumadd(c0, c1, c2, n2);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
            };

            // m6 = extract!();
            do {
                let (_c0, _c1, _c2, _m6) = extract(c0, c1, c2);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
                m6 := _m6;
            };
            
            // sumadd!(l[7]);
            do {
                let (_c0, _c1, _c2) = sumadd(c0, c1, c2, l[7]);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
            };

            // muladd!(n7, SECP256K1_N_C_0);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, n7, SECP256K1_N_C_0);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
            };

            // muladd!(n6, SECP256K1_N_C_1);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, n6, SECP256K1_N_C_1);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
            };

            // muladd!(n5, SECP256K1_N_C_2);
            do {
                let (taq0, taq1, taq2) = muladd(c0, c1, c2, n5, SECP256K1_N_C_2);
                c0 := taq0;
                c1 := taq1;
                c2 := taq2;
            };

            // muladd!(n4, SECP256K1_N_C_3);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, n4, SECP256K1_N_C_3);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
            };

            // sumadd!(n3);
            do {
                let (_c0, _c1, _c2) = sumadd(c0, c1, c2, n3);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
            };

            // m7 = extract!();
            do {
                let (_c0, _c1, _c2, _m7) = extract(c0, c1, c2);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
                m7 := _m7;
            };
            
            // muladd!(n7, SECP256K1_N_C_1);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, n7, SECP256K1_N_C_1);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
            };

            // muladd!(n6, SECP256K1_N_C_2);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, n6, SECP256K1_N_C_2);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
            };

            // muladd!(n5, SECP256K1_N_C_3);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, n5, SECP256K1_N_C_3);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
            };

            // sumadd!(n4);
            do {
                let (_c0, _c1, _c2) = sumadd(c0, c1, c2, n4);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
            };

            // m8 = extract!();
            do {
                let (_c0, _c1, _c2, _m8) = extract(c0, c1, c2);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
                m8 := _m8;
            };

            // muladd!(n7, SECP256K1_N_C_2);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, n7, SECP256K1_N_C_2);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
            };

            // muladd!(n6, SECP256K1_N_C_3);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, n6, SECP256K1_N_C_3);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
            };

            // sumadd!(n5);
            do {
                let (_c0, _c1, _c2) = sumadd(c0, c1, c2, n5);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
            };

            // m9 = extract!();
            do {
                let (_c0, _c1, _c2, _m9) = extract(c0, c1, c2);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
                m9 := _m9;
            };

            // muladd!(n7, SECP256K1_N_C_3);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, n7, SECP256K1_N_C_3);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
            };

            // sumadd!(n6);
            do {
                let (_c0, _c1, _c2) = sumadd(c0, c1, c2, n6);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
            };

            // m10 = extract!();
            do {
                let (_c0, _c1, _c2, _m10) = extract(c0, c1, c2);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
                m10 := _m10;
            };

            // sumadd_fast!(n7);
            do {
                let (_c0, _c1, _c2) = sumadd_fast(c0, c1, c2, n7);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
            };

            // m11 = extract_fast!();
            do {
                let (_c0, _c1, _c2, _m11) = extract_fast(c0, c1, c2);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
                m11 := _m11;
            };

            assert(c0 <= 1);
            m12 := c0;

            /* Reduce 385 bits into 258. */
            /* p[0..8] = m[0..7] +% m[8..12] *% SECP256K1_N_C. */
            c0 := m0;
            c1 := 0;
            c2 := 0;

            // muladd_fast!(m8, SECP256K1_N_C_0);
            do {
                let (_c0, _c1, _c2) = muladd_fast(c0, c1, c2, m8, SECP256K1_N_C_0);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
            };

            // p0 = extract_fast!();
            do {
                let (_c0, _c1, _c2, _p0) = extract_fast(c0, c1, c2);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
                p0 := _p0;
            };

            // sumadd_fast!(m1);
            do {
                let (_c0, _c1, _c2) = sumadd_fast(c0, c1, c2, m1);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
            };

            // muladd!(m9, SECP256K1_N_C_0);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, m9, SECP256K1_N_C_0);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
            };

            // muladd!(m8, SECP256K1_N_C_1);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, m8, SECP256K1_N_C_1);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
            };
            
            // p1 = extract!();
            do {
                let (_c0, _c1, _c2, _p1) = extract(c0, c1, c2);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
                p1 := _p1;
            };

            // sumadd!(m2);
            do {
                let (_c0, _c1, _c2) = sumadd(c0, c1, c2, m2);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
            };

            // muladd!(m10, SECP256K1_N_C_0);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, m10, SECP256K1_N_C_0);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
            };

            // muladd!(m9, SECP256K1_N_C_1);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, m9, SECP256K1_N_C_1);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
            };

            // muladd!(m8, SECP256K1_N_C_2);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, m8, SECP256K1_N_C_2);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
            };

            // p2 = extract!();
            do {
                let (_c0, _c1, _c2, np2) = extract(c0, c1, c2);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
                p2 := np2;
            };

            // sumadd!(m3);
            do {
                let (_c0, _c1, _c2) = sumadd(c0, c1, c2, m3);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
            };

            // muladd!(m11, SECP256K1_N_C_0);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, m11, SECP256K1_N_C_0);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
            };

            // muladd!(m10, SECP256K1_N_C_1);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, m10, SECP256K1_N_C_1);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
            };

            // muladd!(m9, SECP256K1_N_C_2);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, m9, SECP256K1_N_C_2);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
            };

            // muladd!(m8, SECP256K1_N_C_3);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, m8, SECP256K1_N_C_3);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
            };

            // p3 = extract!();
            do {
                let (_c0, _c1, _c2, _p3) = extract(c0, c1, c2);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
                p3 := _p3;
            };

            // sumadd!(m4);
            do {
                let (_c0, _c1, _c2) = sumadd(c0, c1, c2, m4);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
            };

            // muladd!(m12, SECP256K1_N_C_0);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, m12, SECP256K1_N_C_0);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
            };

            // muladd!(m11, SECP256K1_N_C_1);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, m11, SECP256K1_N_C_1);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
            };

            // muladd!(m10, SECP256K1_N_C_2);
            let (_c0, _c1, _c2) = muladd(c0, c1, c2, m10, SECP256K1_N_C_2);
            c0 := _c0;
            c1 := _c1;
            c2 := _c2;

            // muladd!(m9, SECP256K1_N_C_3);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, m9, SECP256K1_N_C_3);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
            };

            // sumadd!(m8);
            do {
                let (_c0, _c1, _c2) = sumadd(c0, c1, c2, m8);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
            };

            // p4 = extract!();
            do {
                let (_c0, _c1, _c2, _p4) = extract(c0, c1, c2);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
                p4 := _p4;
            };

            // sumadd!(m5);
            do {
                let (_c0, _c1, _c2) = sumadd(c0, c1, c2, m5);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
            };

            // muladd!(m12, SECP256K1_N_C_1);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, m12, SECP256K1_N_C_1);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
            };

            // muladd!(m11, SECP256K1_N_C_2);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, m11, SECP256K1_N_C_2);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
            };

            // muladd!(m10, SECP256K1_N_C_3);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, m10, SECP256K1_N_C_3);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
            };

            // sumadd!(m9);
            do {
                let (_c0, _c1, _c2) = sumadd(c0, c1, c2, m9);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
            };

            // p5 = extract!();
            do {
                let (_c0, _c1, _c2, _p5) = extract(c0, c1, c2);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
                p5 := _p5;
            };

            // sumadd!(m6);
            do {
                let (_c0, _c1, _c2) = sumadd(c0, c1, c2, m6);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
            };

            // muladd!(m12, SECP256K1_N_C_2);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, m12, SECP256K1_N_C_2);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
            };

            // muladd!(m11, SECP256K1_N_C_3);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, m11, SECP256K1_N_C_3);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
            };

            // sumadd!(m10);
            do {
                let (_c0, _c1, _c2) = sumadd(c0, c1, c2, m10);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
            };

            // p6 = extract!();
            do {
                let (_c0, _c1, _c2, _p6) = extract(c0, c1, c2);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
                p6 := _p6;
            };

            // sumadd_fast!(m7);
            do {
                let (_c0, _c1, _c2) = sumadd_fast(c0, c1, c2, m7);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
            };

            // muladd_fast!(m12, SECP256K1_N_C_3);
            do {
                let (_c0, _c1, _c2) = muladd_fast(c0, c1, c2, m12, SECP256K1_N_C_3);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
            };

            // sumadd_fast!(m11);
            do {
                let (_c0, _c1, _c2) = sumadd_fast(c0, c1, c2, m11);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
            };

            // p7 = extract_fast!();
            do {
                let (_c0, _c1, _c2, _p7) = extract_fast(c0, c1, c2);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
                p7 := _p7;
            };

            p8 := c0 +% m12;
            assert(p8 <= 2);

            /* Reduce 258 bits into 256. */
            /* r[0..7] = p[0..7] +% p[8] *% SECP256K1_N_C. */
            c := u64(p0) +% u64(SECP256K1_N_C_0) *% u64(p8);
            n[0] := u64u32(c & 0xFFFFFFFF);
            c >>= 32;
            c +%= u64(p1) +% u64(SECP256K1_N_C_1) *% u64(p8);
            n[1] := u64u32(c & 0xFFFFFFFF);
            c >>= 32;
            c +%= u64(p2) +% u64(SECP256K1_N_C_2) *% u64(p8);
            n[2] := u64u32(c & 0xFFFFFFFF);
            c >>= 32;
            c +%= u64(p3) +% u64(SECP256K1_N_C_3) *% u64(p8);
            n[3] := u64u32(c & 0xFFFFFFFF);
            c >>= 32;
            c +%= u64(p4) +% u64(p8);
            n[4] := u64u32(c & 0xFFFFFFFF);
            c >>= 32;
            c +%= u64(p5);
            n[5] := u64u32(c & 0xFFFFFFFF);
            c >>= 32;
            c +%= u64(p6);
            n[6] := u64u32(c & 0xFFFFFFFF);
            c >>= 32;
            c +%= u64(p7);
            n[7] := u64u32(c & 0xFFFFFFFF);
            c >>= 32;

            let overflow = check_overflow();
            reduce(subtle.into(u64u8(c)).bitor(overflow));
        };

        public func mul_512(b: Scalar, l: [var Nat32]) {
            var c0: Nat32 = 0;
            var c1: Nat32 = 0;
            var c2: Nat32 = 0;


            /* l[0..15] = a[0..7] *% b[0..7]. */
            // muladd_fast!(n[0], b.n[0]);
            do {
                let (_c0, _c1, _c2) = muladd_fast(c0, c1, c2, n[0], b.n[0]);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
            };

            // l[0] = extract_fast!();
            do {
                let (_c0, _c1, _c2, _l0) = extract_fast(c0, c1, c2);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
                l[0] := _l0;
            };

            // muladd!(n[0], b.n[1]);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, n[0], b.n[1]);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2; 
            };    

            // muladd!(n[1], b.n[0]);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, n[1], b.n[0]);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2; 
            };

            // l[1] = extract!();
            do {
                let (_c0, _c1, _c2, _l1) = extract(c0, c1, c2);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
                l[1] := _l1;
            };

            // muladd!(n[0], b.n[2]);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, n[0], b.n[2]);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2; 
            };
 
            // muladd!(n[1], b.n[1]);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, n[1], b.n[1]);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
            };

            // muladd!(n[2], b.n[0]);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, n[2], b.n[0]);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2; 
            };

            // l[2] = extract!();
            do {
                let (_c0, _c1, _c2, _l2) = extract(c0, c1, c2);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
                l[2] := _l2;
            };

            // muladd!(n[0], b.n[3]);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, n[0], b.n[3]);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2; 
            };

            // muladd!(n[1], b.n[2]);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, n[1], b.n[2]);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2; 
            };

            // muladd!(n[2], b.n[1]);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, n[2], b.n[1]);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2; 
            };

            // muladd!(n[3], b.n[0]);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, n[3], b.n[0]);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;                 
            };

            // l[3] = extract!();
            do {
                let (_c0, _c1, _c2, _l3) = extract(c0, c1, c2);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
                l[3] := _l3;
            };

            // muladd!(n[0], b.n[4]);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, n[0], b.n[4]);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;                 
            };

            // muladd!(n[1], b.n[3]);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, n[1], b.n[3]);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;                 
            };

            // muladd!(n[2], b.n[2]);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, n[2], b.n[2]);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;                 
            };

            // muladd!(n[3], b.n[1]);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, n[3], b.n[1]);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;                 
            };

            // muladd!(n[4], b.n[0]);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, n[4], b.n[0]);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;                 
            };

            // l[4] = extract!();
            do {
                let (_c0, _c1, _c2, _l4) = extract(c0, c1, c2);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
                l[4] := _l4;
            };

            // muladd!(n[0], b.n[5]);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, n[0], b.n[5]);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;                 
            };

            // muladd!(n[1], b.n[4]);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, n[1], b.n[4]);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;                 
            };

            // muladd!(n[2], b.n[3]);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, n[2], b.n[3]);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;                 
            };

            // muladd!(n[3], b.n[2]);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, n[3], b.n[2]);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;                 
            };

            // muladd!(n[4], b.n[1]);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, n[4], b.n[1]);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;                 
            };

            // muladd!(n[5], b.n[0]);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, n[5], b.n[0]);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;                 
            };

            // l[5] = extract!();
            do {
                let (_c0, _c1, _c2, _l5) = extract(c0, c1, c2);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
                l[5] := _l5;
            };

            // muladd!(n[0], b.n[6]);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, n[0], b.n[6]);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;                 
            };

            // muladd!(n[1], b.n[5]);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, n[1], b.n[5]);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;                 
            };

            // muladd!(n[2], b.n[4]);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, n[2], b.n[4]);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;                 
            };

            // muladd!(n[3], b.n[3]);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, n[3], b.n[3]);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;                 
            };

            // muladd!(n[4], b.n[2]);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, n[4], b.n[2]);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;                 
            };

            // muladd!(n[5], b.n[1]);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, n[5], b.n[1]);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;                 
            };

            // muladd!(n[6], b.n[0]);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, n[6], b.n[0]);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;                 
            };
            
            // l[6] = extract!();
            do {
                let (_c0, _c1, _c2, _l6) = extract(c0, c1, c2);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
                l[6] := _l6;
            };

            // muladd!(n[0], b.n[7]);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, n[0], b.n[7]);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;                 
            };

            // muladd!(n[1], b.n[6]);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, n[1], b.n[6]);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;                 
            };

            // muladd!(n[2], b.n[5]);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, n[2], b.n[5]);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;                 
            };

            // muladd!(n[3], b.n[4]);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, n[3], b.n[4]);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;                 
            };
            
            // muladd!(n[4], b.n[3]);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, n[4], b.n[3]);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;                 
            };

            // muladd!(n[5], b.n[2]);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, n[5], b.n[2]);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;                 
            };

            // muladd!(n[6], b.n[1]);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, n[6], b.n[1]);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;                 
            };

            // muladd!(n[7], b.n[0]);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, n[7], b.n[0]);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;                 
            };

            // l[7] = extract!();
            do {
                let (_c0, _c1, _c2, _l7) = extract(c0, c1, c2);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
                l[7] := _l7;
            };

            // muladd!(n[1], b.n[7]);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, n[1], b.n[7]);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;                 
            };

            // muladd!(n[2], b.n[6]);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, n[2], b.n[6]);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;                 
            };

            // muladd!(n[3], b.n[5]);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, n[3], b.n[5]);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;                 
            };

            // muladd!(n[4], b.n[4]);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, n[4], b.n[4]);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;                 
            };

            // muladd!(n[5], b.n[3]);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, n[5], b.n[3]);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;                 
            };

            // muladd!(n[6], b.n[2]);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, n[6], b.n[2]);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;                 
            };

            // muladd!(n[7], b.n[1]);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, n[7], b.n[1]);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;                 
            };

            // l[8] = extract!();
            do {
                let (_c0, _c1, _c2, _l8) = extract(c0, c1, c2);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
                l[8] := _l8;
            };

            // muladd!(n[2], b.n[7]);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, n[2], b.n[7]);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;                 
            };

            // muladd!(n[3], b.n[6]);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, n[3], b.n[6]);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;                 
            };

            // muladd!(n[4], b.n[5]);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, n[4], b.n[5]);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;                 
            };

            // muladd!(n[5], b.n[4]);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, n[5], b.n[4]);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;                 
            };

            // muladd!(n[6], b.n[3]);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, n[6], b.n[3]);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;                 
            };

            // muladd!(n[7], b.n[2]);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, n[7], b.n[2]);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;                 
            };

            // l[9] = extract!();
            do {
                let (_c0, _c1, _c2, _l9) = extract(c0, c1, c2);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
                l[9] := _l9;
            };

            // muladd!(n[3], b.n[7]);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, n[3], b.n[7]);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;                 
            };

            // muladd!(n[4], b.n[6]);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, n[4], b.n[6]);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;                 
            };

            // muladd!(n[5], b.n[5]);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, n[5], b.n[5]);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;                 
            };

            // muladd!(n[6], b.n[4]);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, n[6], b.n[4]);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;                 
            };

            // muladd!(n[7], b.n[3]);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, n[7], b.n[3]);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;                 
            };

            // l[10] = extract!();
            do {
                let (_c0, _c1, _c2, _l10) = extract(c0, c1, c2);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
                l[10] := _l10;
            };

            // muladd!(n[4], b.n[7]);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, n[4], b.n[7]);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;                 
            };

            // muladd!(n[5], b.n[6]);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, n[5], b.n[6]);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;                 
            };

            // muladd!(n[6], b.n[5]);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, n[6], b.n[5]);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;                 
            };

            // muladd!(n[7], b.n[4]);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, n[7], b.n[4]);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;                 
            };

            // l[11] = extract!();
            do {
                let (_c0, _c1, _c2, _l11) = extract(c0, c1, c2);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
                l[11] := _l11;
            };

            // muladd!(n[5], b.n[7]);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, n[5], b.n[7]);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;                 
            };

            // muladd!(n[6], b.n[6]);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, n[6], b.n[6]);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;                 
            };

            // muladd!(n[7], b.n[5]);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, n[7], b.n[5]);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;                 
            };

            // l[12] = extract!();
            do {
                let (_c0, _c1, _c2, _l12) = extract(c0, c1, c2);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
                l[12] := _l12;
            };

            // muladd!(n[6], b.n[7]);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, n[6], b.n[7]);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;                 
            };

            // muladd!(n[7], b.n[6]);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, n[7], b.n[6]);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;                 
            };

            // l[13] = extract!();
            do {
                let (_c0, _c1, _c2, _l13) = extract(c0, c1, c2);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
                l[13] := _l13;
            };

            // muladd_fast!(n[7], b.n[7]);
            do {
                let (_c0, _c1, _c2) = muladd_fast(c0, c1, c2, n[7], b.n[7]);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
            };

            // l[14] = extract_fast!();
            do {
                let (_c0, _c1, _c2, _l14) = extract_fast(c0, c1, c2);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
                l[14] := _l14;
            };

            assert(c1 == 0);
            l[15] := c0;
        };

        public func sqr_512(l: [var Nat32]) {
            var c0: Nat32 = 0;
            var c1: Nat32 = 0;
            var c2: Nat32 = 0;

            /* l[0..15] = a[0..7]^2. */
            // muladd_fast!(self.0[0], self.0[0]);
            do {
                let (_c0, _c1, _c2) = muladd_fast(c0, c1, c2, n[0], n[0]);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
            };

            // l[0] = extract_fast!();
            do {
                let (_c0, _c1, _c2, _l0) = extract_fast(c0, c1, c2);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
                l[0] := _l0;
            };

            // muladd2!(self.0[0], self.0[1]);
            do {
                let (_c0, _c1, _c2) = muladd2(c0, c1, c2, n[0], n[1]);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;                 
            };

            // l[1] = extract!();
            do {
                let (_c0, _c1, _c2, _l1) = extract(c0, c1, c2);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
                l[1] := _l1;
            };

            // muladd2!(self.0[0], self.0[2]);
            do {
                let (_c0, _c1, _c2) = muladd2(c0, c1, c2, n[0], n[2]);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;                 
            };

            // muladd!(self.0[1], self.0[1]);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, n[1], n[1]);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;                 
            };

            // l[2] = extract!();
            do {
                let (_c0, _c1, _c2, _l2) = extract(c0, c1, c2);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
                l[2] := _l2;
            };

            // muladd2!(self.0[0], self.0[3]);
            do {
                let (_c0, _c1, _c2) = muladd2(c0, c1, c2, n[0], n[3]);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;                 
            };

            // muladd2!(self.0[1], self.0[2]);
            do {
                let (_c0, _c1, _c2) = muladd2(c0, c1, c2, n[1], n[2]);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;                 
            };
            
            // l[3] = extract!();
            do {
                let (_c0, _c1, _c2, _l3) = extract(c0, c1, c2);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
                l[3] := _l3;
            };

            // muladd2!(self.0[0], self.0[4]);
            do {
                let (_c0, _c1, _c2) = muladd2(c0, c1, c2, n[0], n[4]);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;                 
            };

            // muladd2!(self.0[1], self.0[3]);
            do {
                let (_c0, _c1, _c2) = muladd2(c0, c1, c2, n[1], n[3]);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;                 
            };

            // muladd!(self.0[2], self.0[2]);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, n[2], n[2]);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;                 
            };

            // l[4] = extract!();
            do {
                let (_c0, _c1, _c2, _l4) = extract(c0, c1, c2);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
                l[4] := _l4;
            };

            // muladd2!(self.0[0], self.0[5]);
            do {
                let (_c0, _c1, _c2) = muladd2(c0, c1, c2, n[0], n[5]);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;                 
            };

            // muladd2!(self.0[1], self.0[4]);
            do {
                let (_c0, _c1, _c2) = muladd2(c0, c1, c2, n[1], n[4]);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;                 
            };

            // muladd2!(self.0[2], self.0[3]);
            do {
                let (_c0, _c1, _c2) = muladd2(c0, c1, c2, n[2], n[3]);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;                 
            };

            // l[5] = extract!();
            do {
                let (_c0, _c1, _c2, _l5) = extract(c0, c1, c2);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
                l[5] := _l5;
            };

            // muladd2!(self.0[0], self.0[6]);
            do {
                let (_c0, _c1, _c2) = muladd2(c0, c1, c2, n[0], n[6]);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;                 
            };

            // muladd2!(self.0[1], self.0[5]);
            do {
                let (_c0, _c1, _c2) = muladd2(c0, c1, c2, n[1], n[5]);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;                 
            };

            // muladd2!(self.0[2], self.0[4]);
            do {
                let (_c0, _c1, _c2) = muladd2(c0, c1, c2, n[2], n[4]);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;                 
            };

            // muladd!(self.0[3], self.0[3]);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, n[3], n[3]);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;                 
            };

            // l[6] = extract!();
            do {
                let (_c0, _c1, _c2, _l6) = extract(c0, c1, c2);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
                l[6] := _l6;
            };

            // muladd2!(self.0[0], self.0[7]);
            do {
                let (_c0, _c1, _c2) = muladd2(c0, c1, c2, n[0], n[7]);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;                 
            };

            // muladd2!(self.0[1], self.0[6]);
            do {
                let (_c0, _c1, _c2) = muladd2(c0, c1, c2, n[1], n[6]);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;                 
            };
            
            // muladd2!(self.0[2], self.0[5]);
            do {
                let (_c0, _c1, _c2) = muladd2(c0, c1, c2, n[2], n[5]);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;                 
            };

            // muladd2!(self.0[3], self.0[4]);
            do {
                let (_c0, _c1, _c2) = muladd2(c0, c1, c2, n[3], n[4]);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;                 
            };

            // l[7] = extract!();
            do {
                let (_c0, _c1, _c2, _l7) = extract(c0, c1, c2);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
                l[7] := _l7;
            };

            // muladd2!(self.0[1], self.0[7]);
            do {
                let (_c0, _c1, _c2) = muladd2(c0, c1, c2, n[1], n[7]);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;                 
            };

            // muladd2!(self.0[2], self.0[6]);
            do {
                let (_c0, _c1, _c2) = muladd2(c0, c1, c2, n[2], n[6]);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;                 
            };

            // muladd2!(self.0[3], self.0[5]);
            do {
                let (_c0, _c1, _c2) = muladd2(c0, c1, c2, n[3], n[5]);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;                 
            };

            // muladd!(self.0[4], self.0[4]);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, n[4], n[4]);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
            };

            // l[8] = extract!();
            do {
                let (_c0, _c1, _c2, _l8) = extract(c0, c1, c2);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
                l[8] := _l8;
            };
            
            // muladd2!(self.0[2], self.0[7]);
            do {
                let (_c0, _c1, _c2) = muladd2(c0, c1, c2, n[2], n[7]);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
            };

            // muladd2!(self.0[3], self.0[6]);
            do {
                let (_c0, _c1, _c2) = muladd2(c0, c1, c2, n[3], n[6]);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
            };

            // muladd2!(self.0[4], self.0[5]);
            do {
                let (_c0, _c1, _c2) = muladd2(c0, c1, c2, n[4], n[5]);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
            };

            // l[9] = extract!();
            do {
                let (_c0, _c1, _c2, _l9) = extract(c0, c1, c2);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
                l[9] := _l9;
            };

            // muladd2!(self.0[3], self.0[7]);
            do {
                let (_c0, _c1, _c2) = muladd2(c0, c1, c2, n[3], n[7]);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
            };

            // muladd2!(self.0[4], self.0[6]);
            do {
                let (_c0, _c1, _c2) = muladd2(c0, c1, c2, n[4], n[6]);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
            };

            // muladd!(self.0[5], self.0[5]);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, n[5], n[5]);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
            };

            // l[10] = extract!();
            do {
                let (_c0, _c1, _c2, _l10) = extract(c0, c1, c2);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
                l[10] := _l10;
            };

            // muladd2!(self.0[4], self.0[7]);
            do {
                let (_c0, _c1, _c2) = muladd2(c0, c1, c2, n[4], n[7]);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
            };

            // muladd2!(self.0[5], self.0[6]);
            do {
                let (_c0, _c1, _c2) = muladd2(c0, c1, c2, n[5], n[6]);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
            };

            // l[11] = extract!();
            do {
                let (_c0, _c1, _c2, _l11) = extract(c0, c1, c2);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
                l[11] := _l11;
            };

            // muladd2!(self.0[5], self.0[7]);
            do {
                let (_c0, _c1, _c2) = muladd2(c0, c1, c2, n[5], n[7]);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
            };

            // muladd!(self.0[6], self.0[6]);
            do {
                let (_c0, _c1, _c2) = muladd(c0, c1, c2, n[6], n[6]);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
            };

            // l[12] = extract!();
            do {
                let (_c0, _c1, _c2, _l12) = extract(c0, c1, c2);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
                l[12] := _l12;
            };

            // muladd2!(self.0[6], self.0[7]);
            do {
                let (_c0, _c1, _c2) = muladd2(c0, c1, c2, n[6], n[7]);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
            };

            // l[13] = extract!();
            do {
                let (_c0, _c1, _c2, _l13) = extract(c0, c1, c2);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
                l[13] := _l13;
            };

            // muladd_fast!(self.0[7], self.0[7]);
            do {
                let (_c0, _c1, _c2) = muladd_fast(c0, c1, c2, n[7], n[7]);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
            };

            // l[14] = extract_fast!();
            do {
                let (_c0, _c1, _c2, _l14) = extract_fast(c0, c1, c2);
                c0 := _c0;
                c1 := _c1;
                c2 := _c2;
                l[14] := _l14;
            };

            assert(c1 == 0);
            l[15] := c0;
        };

        public func mul_in_place(a: Scalar, b: Scalar) {
            let l = Array.tabulateVar<Nat32>(16, func i = 0);
            a.mul_512(b, l);
            reduce_512(Array.freeze<Nat32>(l));
        };

        /// Shift a scalar right by some amount strictly between 0 and 16,
        /// returning the low bits that were shifted off.
        public func shr_int(_n: Nat32): Nat32 {
            var ret: Nat32 = 0;
            ret := n[0] & ((1 << _n) - 1);
            n[0] := (n[0] >> _n) +% (n[1] << (32 - _n));
            n[1] := (n[1] >> _n) +% (n[2] << (32 - _n));
            n[2] := (n[2] >> _n) +% (n[3] << (32 - _n));
            n[3] := (n[3] >> _n) +% (n[4] << (32 - _n));
            n[4] := (n[4] >> _n) +% (n[5] << (32 - _n));
            n[5] := (n[5] >> _n) +% (n[6] << (32 - _n));
            n[6] := (n[6] >> _n) +% (n[7] << (32 - _n));
            n[7] >>= _n;
            ret
        };

        public func sqr_in_place(a: Scalar) {
            let l = Array.tabulateVar<Nat32>(16, func i = 0);
            a.sqr_512(l);
            reduce_512(Array.freeze<Nat32>(l));
        };

        public func sqr(): Scalar {
            let ret = Scalar();
            ret.sqr_in_place(clone());
            ret
        };

        public func inv_in_place(x: Scalar) {
            let u2 = x.sqr();
            let x2 = u2.mul(x);
            let u5 = u2.mul(x2);
            let x3 = u5.mul(u2);
            let u9 = x3.mul(u2);
            let u11 = u9.mul(u2);
            let u13 = u11.mul(u2);

            var x6 = u13.sqr();
            x6 := x6.sqr();
            x6 := x6.mul(u11);

            var x8 = x6.sqr();
            x8 := x8.sqr();
            x8 := x8.mul(x2);

            var x14 = x8.sqr();
            for (_ in Iter.range(0, 4)) {//0..5
                x14 := x14.sqr();
            };
            x14 := x14.mul(x6);

            var x28 = x14.sqr();
            for (_ in Iter.range(0, 12)) {//0..13
                x28 := x28.sqr();
            };
            x28 := x28.mul(x14);

            var x56 = x28.sqr();
            for (_ in Iter.range(0, 26)) {//0..27
                x56 := x56.sqr();
            };
            x56 := x56.mul(x28);

            var x112 = x56.sqr();
            for (_ in Iter.range(0,54)) {//0..55
                x112 := x112.sqr();
            };
            x112 := x112.mul(x56);

            var x126 = x112.sqr();
            for (_ in Iter.range(0, 12)) {//0..13
                x126 := x126.sqr();
            };
            x126 := x126.mul(x14);

            var t = x126;
            for (_ in Iter.range(0, 2)) {//0..3
                t := t.sqr();
            };
            t := t.mul(u5);
            for (_ in Iter.range(0, 3)) {//0..4
                t := t.sqr();
            };
            t := t.mul(x3);
            for (_ in Iter.range(0, 3)) {//0..4
                t := t.sqr();
            };
            t := t.mul(u5);
            for (_ in Iter.range(0, 4)) {//0..5
                t := t.sqr();
            };
            t := t.mul(u11);
            for (_ in Iter.range(0, 3)) {//0..4
                t := t.sqr();
            };
            t := t.mul(u11);
            for (_ in Iter.range(0, 3)) {//0..4
                t := t.sqr();
            };
            t := t.mul(x3);
            for (_ in Iter.range(0, 4)) {//0..5
                t := t.sqr();
            };
            t := t.mul(x3);
            for (_ in Iter.range(0, 5)) {//0..6
                t := t.sqr();
            };
            t := t.mul(u13);
            for (_ in Iter.range(0, 3)) {//0..4
                t := t.sqr();
            };
            t := t.mul(u5);
            for (_ in Iter.range(0, 2)) {//0..3
                t := t.sqr();
            };
            t := t.mul(x3);
            for (_ in Iter.range(0, 4)) {//0..5
                t := t.sqr();
            };
            t := t.mul(u9);
            for (_ in Iter.range(0, 5)) {//0..6
                t := t.sqr();
            };
            t := t.mul(u5);
            for (_ in Iter.range(0, 9)) {//0..10
                t := t.sqr();
            };
            t := t.mul(x3);
            for (_ in Iter.range(0, 3)) {//0..4
                t := t.sqr();
            };
            t := t.mul(x3);
            for (_ in Iter.range(0, 8)) {//0..9
                t := t.sqr();
            };
            t := t.mul(x8);
            for (_ in Iter.range(0, 4)) {//0..5
                t := t.sqr();
            };
            t := t.mul(u9);
            for (_ in Iter.range(0, 5)) {//0..6
                t := t.sqr();
            };
            t := t.mul(u11);
            for (_ in Iter.range(0, 3)) {//0..4
                t := t.sqr();
            };
            t := t.mul(u13);
            for (_ in Iter.range(0, 4)) {//0..5
                t := t.sqr();
            };
            t := t.mul(x2);
            for (_ in Iter.range(0, 5)) {//0..6
                t := t.sqr();
            };
            t := t.mul(u13);
            for (_ in Iter.range(0, 9)) {//0..10
                t := t.sqr();
            };
            t := t.mul(u13);
            for (_ in Iter.range(0, 3)) {//0..4
                t := t.sqr();
            };
            t := t.mul(u9);
            for (_ in Iter.range(0, 5)) {//0..6
                t := t.sqr();
            };
            t := t.mul(x);
            for (_ in Iter.range(0, 7)) {//0..8
                t := t.sqr();
            };
            assign_mut(t.mul(x6));
        };

        public func inv(): Scalar {
            let ret = Scalar();
            ret.inv_in_place(clone());
            ret
        };

        public func add(other: Scalar): Scalar {
            let ret = clone();
            ret.add_assign(other);
            ret
        };

        public func add_assign(other: Scalar) {
            var t: Nat64 = 0;

            for (i in Iter.range(0, 7)) {//0..8
                t +%= u64(n[i]) +% u64(other.n[i]);
                n[i] := u64u32(t & 0xFFFFFFFF);
                t >>= 32;
            };

            let overflow = check_overflow();
            reduce(subtle.into(u64u8(t)).bitor(overflow));
        };

        public func mul(other: Scalar): Scalar {
            let ret = Scalar();
            ret.mul_in_place(clone(), other);
            ret
        };

        public func mul_assign(other: Scalar) {
            mul_in_place(clone(), other);
        };

        public func neg_mut() {
            cond_neg_assign(subtle.into(1));
        };

        public func neg_unmut(): Scalar {
            let ret = clone();
            ret.neg_mut();
            ret
        };

    };

    public func muladd(c0_: Nat32, c1_: Nat32, c2_: Nat32, a: Nat32, b: Nat32): (Nat32, Nat32, Nat32) {
        var c0 = c0_;
        var c1 = c1_;
        var c2 = c2_;

        let t = u64(a) *% u64(b);
        var th: Nat32 = u64u32(t >> 32);
        let tl = u64u32(t);
        c0 +%= tl;
        th +%= Utils.boolu32(c0 < tl);
        c1 +%= th;
        c2 +%= Utils.boolu32(c1 < th);
        assert(c1 >= th or c2 != 0);
        (c0, c1, c2)
    };

    public func muladd_fast(c0_: Nat32, c1_: Nat32, c2_: Nat32, a: Nat32, b: Nat32): (Nat32, Nat32, Nat32) {
        var c0 = c0_;
        var c1 = c1_;
        var c2 = c2_;

        let t = u64(a) *% u64(b);
        var th: Nat32 = u64u32(t >> 32);
        let tl = u64u32(t);
        c0 +%= tl;
        th +%= Utils.boolu32(c0 < tl);
        c1 +%= th;
        assert(c1 >= th);
        (c0, c1, c2)
    };

    public func muladd2(c0_: Nat32, c1_: Nat32, c2_: Nat32, a: Nat32, b: Nat32): (Nat32, Nat32, Nat32) {
        var c0 = c0_;
        var c1 = c1_;
        var c2 = c2_;

        let t = u64(a) *% u64(b);
        let th: Nat32 = u64u32(t >> 32);
        let tl = u64u32(t);
        var th2 = th +% th;
        c2 +%= Utils.boolu32(th2 < th);
        assert(th2 >= th or c2 != 0);
        let tl2 = tl +% tl;
        th2 +%= Utils.boolu32(tl2 < tl);
        c0 +%= tl2;
        th2 +%= Utils.boolu32(c0 < tl2);
        c2 +%= Utils.boolu32(c0 < tl2 and th2 == 0 );
        assert(c0 >= tl2 or th2 != 0 or c2 != 0);

        c1 +%= th2;
        c2 +%= Utils.boolu32(c1 < th2);
        assert(c1 >= th2 or c2 != 0);
        (c0, c1, c2)
    };


    public func sumadd(c0_: Nat32, c1_: Nat32, c2_: Nat32, a: Nat32): (Nat32, Nat32, Nat32) {
        var c0 = c0_;
        var c1 = c1_;
        var c2 = c2_;

        c0 +%= a;
        let over = Utils.boolu32(c0 < a);
        c1 +%= over;
        c2 +%= Utils.boolu32(c1 < over);
        (c0, c1, c2)
    };

    public func sumadd_fast(c0_: Nat32, c1_: Nat32, c2_: Nat32, a: Nat32): (Nat32, Nat32, Nat32) {
        var c0 = c0_;
        var c1 = c1_;
        var c2 = c2_;

        c0 +%= a;
        c1 +%= Utils.boolu32(c0 < a);
        assert(c1 != 0 or c0 >= a);
        assert(c2 == 0);
        (c0, c1, c2)
    };

    public func extract(c0: Nat32, c1: Nat32, c2: Nat32): (Nat32, Nat32, Nat32, Nat32) {
        let n = c0;
        let t0 = c1;
        let t1 = c2;
        let t2: Nat32 = 0;
        (t0, t1, t2, n)
    };

    public func extract_fast(c0: Nat32, c1: Nat32, c2: Nat32): (Nat32, Nat32, Nat32, Nat32) {
        let n = c0;
        let t0 = c1;
        let t1: Nat32 = 0;
        assert(c2 == 0);
        (t0, t1, c2, n)
    };

    /// Create a scalar from an unsigned integer.
    public func from_int(v: Nat32): Scalar {
        let ret = Scalar();
        ret.set_int(v);
        ret
    };
};
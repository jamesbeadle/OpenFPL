import Array "mo:base/Array";
import Order "mo:base/Order";
import Iter "mo:base/Iter";
import Nat64 "mo:base/Nat64";
import Int "mo:base/Int";
import Utils "./utils";

module {

    let u32 = Utils.u32;
    let u8 = Utils.u8;
    let u64 = Utils.u64;
    let u64u32 = Utils.u64u32;
    let wrapping_add = Nat64.addWrap;

    /// Field element for secp256k1.
    public class Field() {
        /// Store representation of X.
        /// X = sum(i=0..9, n[i]*2^(i*26)) mod p
        /// where p = 2^256 - 0x1000003D1
        ///
        /// The least signifiant byte is in the front.
        public var n: [var Nat32] = Array.tabulateVar<Nat32>(10, func i = 0);
        public var magnitude: Nat32 = 0;
        public var normalized: Bool = true;

        public func clone(): Field {
            let ret = Field();
            ret.n[0] := n[0];
            ret.n[1] := n[1];
            ret.n[2] := n[2];
            ret.n[3] := n[3];
            ret.n[4] := n[4];
            ret.n[5] := n[5];
            ret.n[6] := n[6];
            ret.n[7] := n[7];
            ret.n[8] := n[8];
            ret.n[9] := n[9];
            ret.magnitude := magnitude;
            ret.normalized := normalized;
            ret
        };

        public func assign_mut(a: Field) {
            n[0] := a.n[0];
            n[1] := a.n[1];
            n[2] := a.n[2];
            n[3] := a.n[3];
            n[4] := a.n[4];
            n[5] := a.n[5];
            n[6] := a.n[6];
            n[7] := a.n[7];
            n[8] := a.n[8];
            n[9] := a.n[9];
            magnitude := a.magnitude;
            normalized := a.normalized;
        };

        public func verify(): Bool {
            let m = (if normalized { 1 } else { 2 }) *% magnitude;
            var r = true;
            r := r and (n[0] <= 0x3ffffff *% m);
            r := r and (n[1] <= 0x3ffffff *% m);
            r := r and (n[2] <= 0x3ffffff *% m);
            r := r and (n[3] <= 0x3ffffff *% m);
            r := r and (n[4] <= 0x3ffffff *% m);
            r := r and (n[5] <= 0x3ffffff *% m);
            r := r and (n[6] <= 0x3ffffff *% m);
            r := r and (n[7] <= 0x3ffffff *% m);
            r := r and (n[8] <= 0x3ffffff *% m);
            r := r and (n[9] <= 0x03fffff *% m);
            r := r and (magnitude <= 32);
            if normalized {
                r := r and magnitude <= 1;
                if (r and (n[9] == 0x03fffff)) {
                    let mid = n[8]
                        & n[7]
                        & n[6]
                        & n[5]
                        & n[4]
                        & n[3]
                        & n[2];
                    if (mid == 0x3ffffff) {
                        r := r and ((n[1] +% 0x40 +% ((n[0] +% 0x3d1) >> 26)) <= 0x3ffffff)
                    };
                };
            };
            r            
        };

        /// Normalize a field element.
        public func normalize() {
            var t0 = n[0];
            var t1 = n[1];
            var t2 = n[2];
            var t3 = n[3];
            var t4 = n[4];
            var t5 = n[5];
            var t6 = n[6];
            var t7 = n[7];
            var t8 = n[8];
            var t9 = n[9];

            var m: Nat32 = 0;
            var x = t9 >> 22;
            t9 &= 0x03fffff;

            t0 +%= x *% 0x3d1;
            t1 +%= x << 6;
            t1 +%= t0 >> 26;
            t0 &= 0x3ffffff;
            t2 +%= t1 >> 26;
            t1 &= 0x3ffffff;
            t3 +%= t2 >> 26;
            t2 &= 0x3ffffff;
            m := t2;
            t4 +%= t3 >> 26;
            t3 &= 0x3ffffff;
            m &= t3;
            t5 +%= t4 >> 26;
            t4 &= 0x3ffffff;
            m &= t4;
            t6 +%= t5 >> 26;
            t5 &= 0x3ffffff;
            m &= t5;
            t7 +%= t6 >> 26;
            t6 &= 0x3ffffff;
            m &= t6;
            t8 +%= t7 >> 26;
            t7 &= 0x3ffffff;
            m &= t7;
            t9 +%= t8 >> 26;
            t8 &= 0x3ffffff;
            m &= t8;

            assert(t9 >> 23 == 0);

            x := (t9 >> 22)
                | ((if (t9 == 0x03fffff) { 1 } else { 0 })
                    & (if (m == 0x3ffffff) { 1 } else { 0 })
                    & (if ((t1 +% 0x40 +% ((t0 +% 0x3d1) >> 26)) > 0x3ffffff) {
                        1
                    } else {
                        0
                    }));

            t0 +%= x *% 0x3d1;
            t1 +%= x << 6;
            t1 +%= t0 >> 26;
            t0 &= 0x3ffffff;
            t2 +%= t1 >> 26;
            t1 &= 0x3ffffff;
            t3 +%= t2 >> 26;
            t2 &= 0x3ffffff;
            t4 +%= t3 >> 26;
            t3 &= 0x3ffffff;
            t5 +%= t4 >> 26;
            t4 &= 0x3ffffff;
            t6 +%= t5 >> 26;
            t5 &= 0x3ffffff;
            t7 +%= t6 >> 26;
            t6 &= 0x3ffffff;
            t8 +%= t7 >> 26;
            t7 &= 0x3ffffff;
            t9 +%= t8 >> 26;
            t8 &= 0x3ffffff;

            assert(t9 >> 22 == x);

            n[0] := t0;
            n[1] := t1;
            n[2] := t2;
            n[3] := t3;
            n[4] := t4;
            n[5] := t5;
            n[6] := t6;
            n[7] := t7;
            n[8] := t8;
            n[9] := t9;

            magnitude := 1;
            normalized := true;
            assert(verify());
        };

        /// Weakly normalize a field element: reduce it magnitude to 1,
        /// but don't fully normalize.
        public func normalize_weak() {
            var t0 = n[0];
            var t1 = n[1];
            var t2 = n[2];
            var t3 = n[3];
            var t4 = n[4];
            var t5 = n[5];
            var t6 = n[6];
            var t7 = n[7];
            var t8 = n[8];
            var t9 = n[9];

            let x = t9 >> 22;
            t9 &= 0x03fffff;

            t0 +%= x *% 0x3d1;
            t1 +%= x << 6;
            t1 +%= t0 >> 26;
            t0 &= 0x3ffffff;
            t2 +%= t1 >> 26;
            t1 &= 0x3ffffff;
            t3 +%= t2 >> 26;
            t2 &= 0x3ffffff;
            t4 +%= t3 >> 26;
            t3 &= 0x3ffffff;
            t5 +%= t4 >> 26;
            t4 &= 0x3ffffff;
            t6 +%= t5 >> 26;
            t5 &= 0x3ffffff;
            t7 +%= t6 >> 26;
            t6 &= 0x3ffffff;
            t8 +%= t7 >> 26;
            t7 &= 0x3ffffff;
            t9 +%= t8 >> 26;
            t8 &= 0x3ffffff;

            assert(t9 >> 23 == 0);

            n[0] := t0;
            n[1] := t1;
            n[2] := t2;
            n[3] := t3;
            n[4] := t4;
            n[5] := t5;
            n[6] := t6;
            n[7] := t7;
            n[8] := t8;
            n[9] := t9;
            magnitude := 1;
            assert(verify());
        };

        /// Normalize a field element, without constant-time guarantee.
        public func normalize_var() {
            var t0 = n[0];
            var t1 = n[1];
            var t2 = n[2];
            var t3 = n[3];
            var t4 = n[4];
            var t5 = n[5];
            var t6 = n[6];
            var t7 = n[7];
            var t8 = n[8];
            var t9 = n[9];

            var m: Nat32 = 0;
            var x = t9 >> 22;
            t9 &= 0x03fffff;

            t0 +%= x *% 0x3d1;
            t1 +%= x << 6;
            t1 +%= t0 >> 26;
            t0 &= 0x3ffffff;
            t2 +%= t1 >> 26;
            t1 &= 0x3ffffff;
            t3 +%= t2 >> 26;
            t2 &= 0x3ffffff;
            m := t2;
            t4 +%= t3 >> 26;
            t3 &= 0x3ffffff;
            m &= t3;
            t5 +%= t4 >> 26;
            t4 &= 0x3ffffff;
            m &= t4;
            t6 +%= t5 >> 26;
            t5 &= 0x3ffffff;
            m &= t5;
            t7 +%= t6 >> 26;
            t6 &= 0x3ffffff;
            m &= t6;
            t8 +%= t7 >> 26;
            t7 &= 0x3ffffff;
            m &= t7;
            t9 +%= t8 >> 26;
            t8 &= 0x3ffffff;
            m &= t8;

            assert(t9 >> 23 == 0);

            x := (t9 >> 22)
                | ((if (t9 == 0x03fffff) { 1 } else { 0 })
                    & (if (m == 0x3ffffff) { 1 } else { 0 })
                    & (if ((t1 +% 0x40 +% ((t0 +% 0x3d1) >> 26)) > 0x3ffffff) {
                        1
                    } else {
                        0
                    }));

            if (x > 0) {
                t0 +%= 0x3d1;
                t1 +%= x << 6;
                t1 +%= t0 >> 26;
                t0 &= 0x3ffffff;
                t2 +%= t1 >> 26;
                t1 &= 0x3ffffff;
                t3 +%= t2 >> 26;
                t2 &= 0x3ffffff;
                t4 +%= t3 >> 26;
                t3 &= 0x3ffffff;
                t5 +%= t4 >> 26;
                t4 &= 0x3ffffff;
                t6 +%= t5 >> 26;
                t5 &= 0x3ffffff;
                t7 +%= t6 >> 26;
                t6 &= 0x3ffffff;
                t8 +%= t7 >> 26;
                t7 &= 0x3ffffff;
                t9 +%= t8 >> 26;
                t8 &= 0x3ffffff;

                assert(t9 >> 22 == x);

                t9 &= 0x03fffff;
            };

            n[0] := t0;
            n[1] := t1;
            n[2] := t2;
            n[3] := t3;
            n[4] := t4;
            n[5] := t5;
            n[6] := t6;
            n[7] := t7;
            n[8] := t8;
            n[9] := t9;
            magnitude := 1;
            normalized := true;
            assert(verify());            
        };

        /// Verify whether a field element represents zero i.e. would
        /// normalize to a zero value. The field implementation may
        /// optionally normalize the input, but this should not be relied
        /// upon.
        public func normalizes_to_zero(): Bool {
            var t0 = n[0];
            var t1 = n[1];
            var t2 = n[2];
            var t3 = n[3];
            var t4 = n[4];
            var t5 = n[5];
            var t6 = n[6];
            var t7 = n[7];
            var t8 = n[8];
            var t9 = n[9];

            var z0: Nat32 = 0;
            var z1: Nat32 = 0;

            let x = t9 >> 22;
            t9 &= 0x03fffff;

            t0 +%= x *% 0x3d1;
            t1 +%= x << 6;
            t1 +%= t0 >> 26;
            t0 &= 0x3ffffff;
            z0 := t0;
            z1 := t0 ^ 0x3d0;
            t2 +%= t1 >> 26;
            t1 &= 0x3ffffff;
            z0 |= t1;
            z1 &= t1 ^ 0x40;
            t3 +%= t2 >> 26;
            t2 &= 0x3ffffff;
            z0 |= t2;
            z1 &= t2;
            t4 +%= t3 >> 26;
            t3 &= 0x3ffffff;
            z0 |= t3;
            z1 &= t3;
            t5 +%= t4 >> 26;
            t4 &= 0x3ffffff;
            z0 |= t4;
            z1 &= t4;
            t6 +%= t5 >> 26;
            t5 &= 0x3ffffff;
            z0 |= t5;
            z1 &= t5;
            t7 +%= t6 >> 26;
            t6 &= 0x3ffffff;
            z0 |= t6;
            z1 &= t6;
            t8 +%= t7 >> 26;
            t7 &= 0x3ffffff;
            z0 |= t7;
            z1 &= t7;
            t9 +%= t8 >> 26;
            t8 &= 0x3ffffff;
            z0 |= t8;
            z1 &= t8;
            z0 |= t9;
            z1 &= t9 ^ 0x3c00000;

            assert(t9 >> 23 == 0);

            z0 == 0 or z1 == 0x3ffffff
        };

        /// Verify whether a field element represents zero i.e. would
        /// normalize to a zero value. The field implementation may
        /// optionally normalize the input, but this should not be relied
        /// upon.
        public func normalizes_to_zero_var(): Bool {
            var t0 = n[0];
            var t9 = n[9];

            var x = t9 >> 22;
            t0 +%= x *% 0x3d1;

            var z0 = t0 & 0x3ffffff;
            var z1 = z0 ^ 0x3d0;

            if ((z0 != 0) and (z1 != 0x3ffffff)) {
                return false;
            };

            var t1 = n[1];
            var t2 = n[2];
            var t3 = n[3];
            var t4 = n[4];
            var t5 = n[5];
            var t6 = n[6];
            var t7 = n[7];
            var t8 = n[8];

            t9 &= 0x03fffff;
            t1 +%= x << 6;

            t1 +%= t0 >> 26;
            t2 +%= t1 >> 26;
            t1 &= 0x3ffffff;
            z0 |= t1;
            z1 &= t1 ^ 0x40;
            t3 +%= t2 >> 26;
            t2 &= 0x3ffffff;
            z0 |= t2;
            z1 &= t2;
            t4 +%= t3 >> 26;
            t3 &= 0x3ffffff;
            z0 |= t3;
            z1 &= t3;
            t5 +%= t4 >> 26;
            t4 &= 0x3ffffff;
            z0 |= t4;
            z1 &= t4;
            t6 +%= t5 >> 26;
            t5 &= 0x3ffffff;
            z0 |= t5;
            z1 &= t5;
            t7 +%= t6 >> 26;
            t6 &= 0x3ffffff;
            z0 |= t6;
            z1 &= t6;
            t8 +%= t7 >> 26;
            t7 &= 0x3ffffff;
            z0 |= t7;
            z1 &= t7;
            t9 +%= t8 >> 26;
            t8 &= 0x3ffffff;
            z0 |= t8;
            z1 &= t8;
            z0 |= t9;
            z1 &= t9 ^ 0x3c00000;

            assert(t9 >> 23 == 0);

            z0 == 0 or z1 == 0x3ffffff
        };

        /// Set a field element equal to a small integer. Resulting field
        /// element is normalized.
        public func set_int(a: Nat32) {
            n[0] := a;
            n[1] := 0;
            n[2] := 0;
            n[3] := 0;
            n[4] := 0;
            n[5] := 0;
            n[6] := 0;
            n[7] := 0;
            n[8] := 0;
            n[9] := 0;
            magnitude := 1;
            normalized := true;
            assert(verify());
        };

        /// Verify whether a field element is zero. Requires the input to
        /// be normalized.
        public func is_zero(): Bool {
            assert(normalized);
            assert(verify());
            (n[0]
            | n[1]
            | n[2]
            | n[3]
            | n[4]
            | n[5]
            | n[6]
            | n[7]
            | n[8]
            | n[9])
            == 0
        };

        /// Check the "oddness" of a field element. Requires the input to
        /// be normalized.
        public func is_odd(): Bool {
            assert(normalized);
            assert(verify());
            n[0] & 1 != 0
        };

        /// Sets a field element equal to zero, initializing all fields.
        public func clear() {
            magnitude := 0;
            normalized := true;
            n[0] := 0;
            n[1] := 0;
            n[2] := 0;
            n[3] := 0;
            n[4] := 0;
            n[5] := 0;
            n[6] := 0;
            n[7] := 0;
            n[8] := 0;
            n[9] := 0;
        };

        /// Set a field element equal to 32-byte big endian value. If
        /// successful, the resulting field element is normalized.
        public func set_b32(a: [Nat8], offset: Nat): Bool {
            n[0] := (u32(a[offset + 31]))
                | ((u32(a[offset + 30])) << 8)
                | ((u32(a[offset + 29])) << 16)
                | ((u32(a[offset + 28] & 0x3)) << 24);
            n[1] := (u32((a[offset + 28] >> 2) & 0x3f))
                | ((u32(a[offset + 27])) << 6)
                | ((u32(a[offset + 26])) << 14)
                | ((u32(a[offset + 25] & 0xf)) << 22);
            n[2] := (u32((a[offset + 25] >> 4) & 0xf))
                | ((u32(a[offset + 24])) << 4)
                | ((u32(a[offset + 23])) << 12)
                | (((u32(a[offset + 22])) & 0x3f) << 20);
            n[3] := (u32((a[offset + 22] >> 6) & 0x3))
                | ((u32(a[offset + 21])) << 2)
                | ((u32(a[offset + 20])) << 10)
                | ((u32(a[offset + 19])) << 18);
            n[4] := (u32(a[offset + 18]))
                | ((u32(a[offset + 17])) << 8)
                | ((u32(a[offset + 16])) << 16)
                | ((u32(a[offset + 15] & 0x3)) << 24);
            n[5] := (u32((a[offset + 15] >> 2) & 0x3f))
                | ((u32(a[offset + 14])) << 6)
                | ((u32(a[offset + 13])) << 14)
                | (((u32(a[offset + 12])) & 0xf) << 22);
            n[6] := (u32((a[offset + 12] >> 4) & 0xf))
                | ((u32(a[offset + 11])) << 4)
                | ((u32(a[offset + 10])) << 12)
                | ((u32(a[offset + 9] & 0x3f)) << 20);
            n[7] := (u32((a[offset + 9] >> 6) & 0x3))
                | ((u32(a[offset + 8])) << 2)
                | ((u32(a[offset + 7])) << 10)
                | ((u32(a[offset + 6])) << 18);
            n[8] := (u32(a[offset + 5]))
                | ((u32(a[offset + 4])) << 8)
                | ((u32(a[offset + 3])) << 16)
                | ((u32(a[offset + 2] & 0x3)) << 24);
            n[9] := (u32((a[offset + 2] >> 2) & 0x3f)) | ((u32(a[offset + 1])) << 6) | ((u32(a[offset + 0])) << 14);

            if (n[9] == 0x03fffff
                and (n[8] & n[7] & n[6] & n[5] & n[4] & n[3] & n[2])
                    == 0x3ffffff
                and (n[1] +% 0x40 +% ((n[0] +% 0x3d1) >> 26)) > 0x3ffffff)
            {
                return false;
            };

            magnitude := 1;
            normalized := true;
            assert(verify());

            true
        };

        public func fill_b32(r: [var Nat8], offset: Nat) {
            assert(normalized);
            assert(verify());

            r[offset + 0] := u8((n[9] >> 14) & 0xff);
            r[offset + 1] := u8((n[9] >> 6) & 0xff);
            r[offset + 2] := u8(((n[9] & 0x3f) << 2) | ((n[8] >> 24) & 0x3));
            r[offset + 3] := u8((n[8] >> 16) & 0xff);
            r[offset + 4] := u8((n[8] >> 8) & 0xff);
            r[offset + 5] := u8(n[8] & 0xff);
            r[offset + 6] := u8((n[7] >> 18) & 0xff);
            r[offset + 7] := u8((n[7] >> 10) & 0xff);
            r[offset + 8] := u8((n[7] >> 2) & 0xff);
            r[offset + 9] := u8(((n[7] & 0x3) << 6) | ((n[6] >> 20) & 0x3f));
            r[offset + 10] := u8((n[6] >> 12) & 0xff);
            r[offset + 11] := u8((n[6] >> 4) & 0xff);
            r[offset + 12] := u8(((n[6] & 0xf) << 4) | ((n[5] >> 22) & 0xf));
            r[offset + 13] := u8((n[5] >> 14) & 0xff);
            r[offset + 14] := u8((n[5] >> 6) & 0xff);
            r[offset + 15] := u8(((n[5] & 0x3f) << 2) | ((n[4] >> 24) & 0x3));
            r[offset + 16] := u8((n[4] >> 16) & 0xff);
            r[offset + 17] := u8((n[4] >> 8) & 0xff);
            r[offset + 18] := u8(n[4] & 0xff);
            r[offset + 19] := u8((n[3] >> 18) & 0xff);
            r[offset + 20] := u8((n[3] >> 10) & 0xff);
            r[offset + 21] := u8((n[3] >> 2) & 0xff);
            r[offset + 22] := u8(((n[3] & 0x3) << 6) | ((n[2] >> 20) & 0x3f));
            r[offset + 23] := u8((n[2] >> 12) & 0xff);
            r[offset + 24] := u8((n[2] >> 4) & 0xff);
            r[offset + 25] := u8(((n[2] & 0xf) << 4) | ((n[1] >> 22) & 0xf));
            r[offset + 26] := u8((n[1] >> 14) & 0xff);
            r[offset + 27] := u8((n[1] >> 6) & 0xff);
            r[offset + 28] := u8(((n[1] & 0x3f) << 2) | ((n[0] >> 24) & 0x3));
            r[offset + 29] := u8((n[0] >> 16) & 0xff);
            r[offset + 30] := u8((n[0] >> 8) & 0xff);
            r[offset + 31] := u8(n[0] & 0xff);
        };

        /// Convert a field element to a 32-byte big endian
        /// value. Requires the input to be normalized.
        public func b32(): [var Nat8] {
            var r = Array.tabulateVar<Nat8>(32, func i = 0);
            fill_b32(r, 0);
            r
        };

        /// Set a field element equal to the additive inverse of
        /// another. Takes a maximum magnitude of the input as an
        /// argument. The magnitude of the output is one higher.
        public func neg_in_place(other: Field, m: Nat32) {
            assert(other.magnitude <= m);
            assert(other.verify());

            let mp1t2 = 2 *% (m +% 1);

            n[0] := 0x3fffc2f *% mp1t2 -% other.n[0];
            n[1] := 0x3ffffbf *% mp1t2 -% other.n[1];
            n[2] := 0x3ffffff *% mp1t2 -% other.n[2];
            n[3] := 0x3ffffff *% mp1t2 -% other.n[3];
            n[4] := 0x3ffffff *% mp1t2 -% other.n[4];
            n[5] := 0x3ffffff *% mp1t2 -% other.n[5];
            n[6] := 0x3ffffff *% mp1t2 -% other.n[6];
            n[7] := 0x3ffffff *% mp1t2 -% other.n[7];
            n[8] := 0x3ffffff *% mp1t2 -% other.n[8];
            n[9] := 0x03fffff *% mp1t2 -% other.n[9];

            magnitude := m + 1;
            normalized := false;
            assert(verify());
        };

        /// Compute the additive inverse of this element. Takes the maximum
        /// expected magnitude of this element as an argument.
        public func neg(m: Nat32): Field {
            let ret = Field();
            let _self = clone();
            ret.neg_in_place(_self, m);
            ret
        };

        /// Multiplies the passed field element with a small integer
        /// constant. Multiplies the magnitude by that small integer.
        public func mul_int(a: Nat32) {
            n[0] *%= a;
            n[1] *%= a;
            n[2] *%= a;
            n[3] *%= a;
            n[4] *%= a;
            n[5] *%= a;
            n[6] *%= a;
            n[7] *%= a;
            n[8] *%= a;
            n[9] *%= a;

            magnitude *%= a;
            normalized := false;
            assert(verify());
        };

        /// Compare two field elements. Requires both inputs to be
        /// normalized.
        public func cmp_var(other: Field): Order.Order {
            // Variable time compare implementation.
            assert(normalized);
            assert(other.normalized);
            assert(verify());
            assert(other.verify());           

            for (ii in Iter.revRange(9, 0)) { //0..10.rev()
                let i = Int.abs(ii);
                if (n[i] > other.n[i]) {
                    return #greater;
                };
                if (n[i] < other.n[i]) {
                    return #less;
                };
            };
            #equal
        };

        public func eq_var(other: Field): Bool {
            var na = neg(1);
            na.add_assign(other);
            na.normalizes_to_zero_var()
        };

        public func mul_inner(a: Field, b: Field) {
            let M: Nat64 = 0x3ffffff;
            let R0: Nat64 = 0x3d10;
            let R1: Nat64 = 0x400;

            var c: Nat64 = 0;
            var d: Nat64 = 0;
            
            assert(a.n[0] >> 30 == 0);
            assert(a.n[1] >> 30 == 0);
            assert(a.n[2] >> 30 == 0);
            assert(a.n[3] >> 30 == 0);
            assert(a.n[4] >> 30 == 0);
            assert(a.n[5] >> 30 == 0);
            assert(a.n[6] >> 30 == 0);
            assert(a.n[7] >> 30 == 0);
            assert(a.n[8] >> 30 == 0);
            assert(a.n[9] >> 26 == 0);
            assert(b.n[0] >> 30 == 0);
            assert(b.n[1] >> 30 == 0);
            assert(b.n[2] >> 30 == 0);
            assert(b.n[3] >> 30 == 0);
            assert(b.n[4] >> 30 == 0);
            assert(b.n[5] >> 30 == 0);
            assert(b.n[6] >> 30 == 0);
            assert(b.n[7] >> 30 == 0);
            assert(b.n[8] >> 30 == 0);
            assert(b.n[9] >> 26 == 0);

            // [... a b c] is a shorthand for ... + a<<52 + b<<26 + c<<0 mod n.
            // px is a shorthand for sum(a[i]*b[x-i], i=0..x).
            // Note that [x 0 0 0 0 0 0 0 0 0 0] = [x*R1 x*R0].

            d := wrapping_add(
                    wrapping_add(
                        wrapping_add(
                            wrapping_add(
                                wrapping_add(
                                    wrapping_add(
                                        wrapping_add(
                                            wrapping_add(
                                                wrapping_add(
                                                    u64(a.n[0]) *% u64(b.n[9]), 
                                                    u64(a.n[1]) *% u64(b.n[8])
                                                ), 
                                                u64(a.n[2]) *% u64(b.n[7])
                                            ), 
                                            u64(a.n[3]) *% u64(b.n[6])
                                        ), 
                                        u64(a.n[4]) *% u64(b.n[5])
                                    ), 
                                    u64(a.n[5]) *% u64(b.n[4])
                                ), 
                                u64(a.n[6]) *% u64(b.n[3])
                            ), 
                            u64(a.n[7]) *% u64(b.n[2])
                        ), 
                        u64(a.n[8]) *% u64(b.n[1])
                    ), 
                    u64(a.n[9]) *% u64(b.n[0])
                );
            // assert(d >> 64 == 0);

            /* [d 0 0 0 0 0 0 0 0 0] = [p9 0 0 0 0 0 0 0 0 0] */
            let t9 = u64u32(d & M);
            d >>= 26;
            assert(t9 >> 26 == 0);
            assert(d >> 38 == 0);
            /* [d t9 0 0 0 0 0 0 0 0 0] = [p9 0 0 0 0 0 0 0 0 0] */

            c := u64(a.n[0]) *% u64(b.n[0]);
            assert(c >> 60 == 0);
            /* [d t9 0 0 0 0 0 0 0 0 c] = [p9 0 0 0 0 0 0 0 0 p0] */

            d := wrapping_add(
                    wrapping_add(
                        wrapping_add(
                            wrapping_add(
                                wrapping_add(
                                    wrapping_add(
                                        wrapping_add(
                                            wrapping_add(
                                                wrapping_add(
                                                    d,
                                                    u64(a.n[1]) *% u64(b.n[9])
                                                ), 
                                                u64(a.n[2]) *% u64(b.n[8])
                                            ), 
                                            u64(a.n[3]) *% u64(b.n[7])
                                        ), 
                                        u64(a.n[4]) *% u64(b.n[6])
                                    ), 
                                    u64(a.n[5]) *% u64(b.n[5])
                                ), 
                                u64(a.n[6]) *% u64(b.n[4])
                            ), 
                            u64(a.n[7]) *% u64(b.n[3])
                        ), 
                        u64(a.n[8]) *% u64(b.n[2])
                    ), 
                    u64(a.n[9]) *% u64(b.n[1])
                );
            assert(d >> 63 == 0);
            /* [d t9 0 0 0 0 0 0 0 0 c] = [p10 p9 0 0 0 0 0 0 0 0 p0] */
            let v0 = d & M;
            d >>= 26;
            c +%= v0 *% R0;
            assert(v0 >> 26 == 0);
            assert(d >> 37 == 0);
            assert(c >> 61 == 0);
            /* [d u0 t9 0 0 0 0 0 0 0 0 c-u0*R0] = [p10 p9 0 0 0 0 0 0 0 0 p0] */
            let t0 = u64u32(c & M);
            c >>= 26;
            c +%= v0 *% R1;

            assert(t0 >> 26 == 0);
            assert(c >> 37 == 0);
            /* [d u0 t9 0 0 0 0 0 0 0 c-u0*R1 t0-u0*R0] = [p10 p9 0 0 0 0 0 0 0 0 p0] */
            /* [d 0 t9 0 0 0 0 0 0 0 c t0] = [p10 p9 0 0 0 0 0 0 0 0 p0] */

            c := wrapping_add(
                    wrapping_add(
                        c, 
                        u64(a.n[0]) *% u64(b.n[1])
                    ),
                    u64(a.n[1]) *% u64(b.n[0])
                );
            assert(c >> 62 == 0);
            /* [d 0 t9 0 0 0 0 0 0 0 c t0] = [p10 p9 0 0 0 0 0 0 0 p1 p0] */

            d := wrapping_add(
                    wrapping_add(
                        wrapping_add(
                            wrapping_add(
                                wrapping_add(
                                    wrapping_add(
                                        wrapping_add(
                                            wrapping_add(
                                                d,
                                                u64(a.n[2]) *% u64(b.n[9])
                                            ), 
                                            u64(a.n[3]) *% u64(b.n[8])
                                        ), 
                                        u64(a.n[4]) *% u64(b.n[7])
                                    ), 
                                    u64(a.n[5]) *% u64(b.n[6])
                                ), 
                                u64(a.n[6]) *% u64(b.n[5])
                            ), 
                            u64(a.n[7]) *% u64(b.n[4])
                        ), 
                        u64(a.n[8]) *% u64(b.n[3])
                    ), 
                    u64(a.n[9]) *% u64(b.n[2])
                );

            assert(d >> 63 == 0);
            /* [d 0 t9 0 0 0 0 0 0 0 c t0] = [p11 p10 p9 0 0 0 0 0 0 0 p1 p0] */
            let v1 = d & M;
            d >>= 26;
            c +%= v1 *% R0;
            assert(v1 >> 26 == 0);
            assert(d >> 37 == 0);
            assert(c >> 63 == 0);
            /* [d u1 0 t9 0 0 0 0 0 0 0 c-u1*R0 t0] = [p11 p10 p9 0 0 0 0 0 0 0 p1 p0] */
            let t1 = u64u32(c & M);
            c >>= 26;
            c +%= v1 *% R1;
            assert(t1 >> 26 == 0);
            assert(c >> 38 == 0);
            /* [d u1 0 t9 0 0 0 0 0 0 c-u1*R1 t1-u1*R0 t0] = [p11 p10 p9 0 0 0 0 0 0 0 p1 p0] */
            /* [d 0 0 t9 0 0 0 0 0 0 c t1 t0] = [p11 p10 p9 0 0 0 0 0 0 0 p1 p0] */

            c := wrapping_add(
                    wrapping_add(
                        wrapping_add(
                            c, 
                            u64(a.n[0]) *% u64(b.n[2])
                        ),
                        u64(a.n[1]) *% u64(b.n[1])
                    ),
                    u64(a.n[2]) *% u64(b.n[0])
                );

            assert(c >> 62 == 0);
            /* [d 0 0 t9 0 0 0 0 0 0 c t1 t0] = [p11 p10 p9 0 0 0 0 0 0 p2 p1 p0] */

            d := wrapping_add(
                    wrapping_add(
                        wrapping_add(
                            wrapping_add(
                                wrapping_add(
                                    wrapping_add(
                                        wrapping_add(
                                            d,
                                            u64(a.n[3]) *% u64(b.n[9])
                                        ), 
                                        u64(a.n[4]) *% u64(b.n[8])
                                    ), 
                                    u64(a.n[5]) *% u64(b.n[7])
                                ), 
                                u64(a.n[6]) *% u64(b.n[6])
                            ), 
                            u64(a.n[7]) *% u64(b.n[5])
                        ), 
                        u64(a.n[8]) *% u64(b.n[4])
                    ), 
                    u64(a.n[9]) *% u64(b.n[3])
                );

            assert(d >> 63 == 0);
            /* [d 0 0 t9 0 0 0 0 0 0 c t1 t0] = [p12 p11 p10 p9 0 0 0 0 0 0 p2 p1 p0] */
            let v2 = d & M;
            d >>= 26;
            c +%= v2 *% R0;
            assert(v2 >> 26 == 0);
            assert(d >> 37 == 0);
            assert(c >> 63 == 0);
            /* [d u2 0 0 t9 0 0 0 0 0 0 c-u2*R0 t1 t0] = [p12 p11 p10 p9 0 0 0 0 0 0 p2 p1 p0] */
            let t2 = u64u32(c & M) ;
            c >>= 26;
            c +%= v2 *% R1;
            assert(t2 >> 26 == 0);
            assert(c >> 38 == 0);
            /* [d u2 0 0 t9 0 0 0 0 0 c-u2*R1 t2-u2*R0 t1 t0] = [p12 p11 p10 p9 0 0 0 0 0 0 p2 p1 p0] */
            /* [d 0 0 0 t9 0 0 0 0 0 c t2 t1 t0] = [p12 p11 p10 p9 0 0 0 0 0 0 p2 p1 p0] */

            c := wrapping_add(
                    wrapping_add(
                        wrapping_add(
                            wrapping_add(
                                c, 
                                u64(a.n[0]) *% u64(b.n[3])
                            ),
                            u64(a.n[1]) *% u64(b.n[2])
                        ),
                        u64(a.n[2]) *% u64(b.n[1])
                    ),
                    u64(a.n[3]) *% u64(b.n[0])
                );
            assert(c >> 63 == 0);
            /* [d 0 0 0 t9 0 0 0 0 0 c t2 t1 t0] = [p12 p11 p10 p9 0 0 0 0 0 p3 p2 p1 p0] */
            d := wrapping_add(
                    wrapping_add(
                        wrapping_add(
                            wrapping_add(
                                wrapping_add(
                                    wrapping_add(
                                        d,
                                        u64(a.n[4]) *% u64(b.n[9])
                                    ), 
                                    u64(a.n[5]) *% u64(b.n[8])
                                ), 
                                u64(a.n[6]) *% u64(b.n[7])
                            ), 
                            u64(a.n[7]) *% u64(b.n[6])
                        ), 
                        u64(a.n[8]) *% u64(b.n[5])
                    ), 
                    u64(a.n[9]) *% u64(b.n[4])
                );

            assert(d >> 63 == 0);
            /* [d 0 0 0 t9 0 0 0 0 0 c t2 t1 t0] = [p13 p12 p11 p10 p9 0 0 0 0 0 p3 p2 p1 p0] */
            let v3 = d & M;
            d >>= 26;
            c +%= v3 *% R0;
            assert(v3 >> 26 == 0);
            assert(d >> 37 == 0);
            // assert(c, 64);
            /* [d u3 0 0 0 t9 0 0 0 0 0 c-u3*R0 t2 t1 t0] = [p13 p12 p11 p10 p9 0 0 0 0 0 p3 p2 p1 p0] */
            let t3 = u64u32(c & M);
            c >>= 26;
            c +%= v3 *% R1;
            assert(t3 >> 26 == 0);
            assert(c >> 39 == 0);
            /* [d u3 0 0 0 t9 0 0 0 0 c-u3*R1 t3-u3*R0 t2 t1 t0] = [p13 p12 p11 p10 p9 0 0 0 0 0 p3 p2 p1 p0] */
            /* [d 0 0 0 0 t9 0 0 0 0 c t3 t2 t1 t0] = [p13 p12 p11 p10 p9 0 0 0 0 0 p3 p2 p1 p0] */

            c := wrapping_add(
                    wrapping_add(
                        wrapping_add(
                            wrapping_add(
                                wrapping_add(
                                    c, 
                                    u64(a.n[0]) *% u64(b.n[4])
                                ),
                                u64(a.n[1]) *% u64(b.n[3])
                            ),
                            u64(a.n[2]) *% u64(b.n[2])
                        ),
                        u64(a.n[3]) *% u64(b.n[1])
                    ),
                    u64(a.n[4]) *% u64(b.n[0])
                );

            assert(c >> 63 == 0);
            /* [d 0 0 0 0 t9 0 0 0 0 c t3 t2 t1 t0] = [p13 p12 p11 p10 p9 0 0 0 0 p4 p3 p2 p1 p0] */
            d := wrapping_add(
                    wrapping_add(
                        wrapping_add(
                            wrapping_add(
                                wrapping_add(
                                    d,
                                    u64(a.n[5]) *% u64(b.n[9])
                                ), 
                                u64(a.n[6]) *% u64(b.n[8])
                            ), 
                            u64(a.n[7]) *% u64(b.n[7])
                        ), 
                        u64(a.n[8]) *% u64(b.n[6])
                    ), 
                    u64(a.n[9]) *% u64(b.n[5])
                );

            assert(d >> 62 == 0);
            /* [d 0 0 0 0 t9 0 0 0 0 c t3 t2 t1 t0] = [p14 p13 p12 p11 p10 p9 0 0 0 0 p4 p3 p2 p1 p0] */
            let v4 = d & M;
            d >>= 26;
            c +%= v4 *% R0;
            assert(v4 >> 26 == 0);
            assert(d >> 36 == 0);
            // assert(c, 64);
            /* [d u4 0 0 0 0 t9 0 0 0 0 c-u4*R0 t3 t2 t1 t0] = [p14 p13 p12 p11 p10 p9 0 0 0 0 p4 p3 p2 p1 p0] */
            let t4 = u64u32(c & M);
            c >>= 26;
            c +%= v4 *% R1;
            assert(t4 >> 26 == 0);
            assert(c >> 39 == 0);
            /* [d u4 0 0 0 0 t9 0 0 0 c-u4*R1 t4-u4*R0 t3 t2 t1 t0] = [p14 p13 p12 p11 p10 p9 0 0 0 0 p4 p3 p2 p1 p0] */
            /* [d 0 0 0 0 0 t9 0 0 0 c t4 t3 t2 t1 t0] = [p14 p13 p12 p11 p10 p9 0 0 0 0 p4 p3 p2 p1 p0] */

            c := wrapping_add(
                    wrapping_add(
                        wrapping_add(
                            wrapping_add(
                                wrapping_add(
                                    wrapping_add(
                                        c, 
                                        u64(a.n[0]) *% u64(b.n[5])
                                    ),
                                    u64(a.n[1]) *% u64(b.n[4])
                                ),
                                u64(a.n[2]) *% u64(b.n[3])
                            ),
                            u64(a.n[3]) *% u64(b.n[2])
                        ),
                        u64(a.n[4]) *% u64(b.n[1])
                    ),
                    u64(a.n[5]) *% u64(b.n[0])
                );

            assert(c >> 63 == 0);
            /* [d 0 0 0 0 0 t9 0 0 0 c t4 t3 t2 t1 t0] = [p14 p13 p12 p11 p10 p9 0 0 0 p5 p4 p3 p2 p1 p0] */
            d := wrapping_add(
                    wrapping_add(
                        wrapping_add(
                            wrapping_add(
                                d,
                                u64(a.n[6]) *% u64(b.n[9])
                            ), 
                            u64(a.n[7]) *% u64(b.n[8])
                        ), 
                        u64(a.n[8]) *% u64(b.n[7])
                    ), 
                    u64(a.n[9]) *% u64(b.n[6])
                );
            assert(d >> 62 == 0);
            /* [d 0 0 0 0 0 t9 0 0 0 c t4 t3 t2 t1 t0] = [p15 p14 p13 p12 p11 p10 p9 0 0 0 p5 p4 p3 p2 p1 p0] */
            let v5 = d & M;
            d >>= 26;
            c +%= v5 *% R0;
            assert(v5 >> 26 == 0);
            assert(d >> 36 == 0);
            // assert(c, 64);
            /* [d u5 0 0 0 0 0 t9 0 0 0 c-u5*R0 t4 t3 t2 t1 t0] = [p15 p14 p13 p12 p11 p10 p9 0 0 0 p5 p4 p3 p2 p1 p0] */
            let t5 = u64u32(c & M);
            c >>= 26;
            c +%= v5 *% R1;
            assert(t5 >> 26 == 0);
            assert(c >> 39 == 0);
            /* [d u5 0 0 0 0 0 t9 0 0 c-u5*R1 t5-u5*R0 t4 t3 t2 t1 t0] = [p15 p14 p13 p12 p11 p10 p9 0 0 0 p5 p4 p3 p2 p1 p0] */
            /* [d 0 0 0 0 0 0 t9 0 0 c t5 t4 t3 t2 t1 t0] = [p15 p14 p13 p12 p11 p10 p9 0 0 0 p5 p4 p3 p2 p1 p0] */

            c := wrapping_add(
                    wrapping_add(
                        wrapping_add(
                            wrapping_add(
                                wrapping_add(
                                    wrapping_add(
                                        wrapping_add(
                                            c, 
                                            u64(a.n[0]) *% u64(b.n[6])
                                        ),
                                        u64(a.n[1]) *% u64(b.n[5])
                                    ),
                                    u64(a.n[2]) *% u64(b.n[4])
                                ),
                                u64(a.n[3]) *% u64(b.n[3])
                            ),
                            u64(a.n[4]) *% u64(b.n[2])
                        ),
                        u64(a.n[5]) *% u64(b.n[1])
                    ),
                    u64(a.n[6]) *% u64(b.n[0])
                );
            assert(c >> 63 == 0);
            /* [d 0 0 0 0 0 0 t9 0 0 c t5 t4 t3 t2 t1 t0] = [p15 p14 p13 p12 p11 p10 p9 0 0 p6 p5 p4 p3 p2 p1 p0] */
            d := wrapping_add(
                    wrapping_add(
                        wrapping_add(
                            d, 
                            u64(a.n[7]) *% u64(b.n[9])
                        ), 
                        u64(a.n[8]) *% u64(b.n[8])
                    ), 
                    u64(a.n[9]) *% u64(b.n[7])
                );
            assert(d >> 61 == 0);
            /* [d 0 0 0 0 0 0 t9 0 0 c t5 t4 t3 t2 t1 t0] = [p16 p15 p14 p13 p12 p11 p10 p9 0 0 p6 p5 p4 p3 p2 p1 p0] */
            let v6 = d & M;
            d >>= 26;
            c +%= v6 *% R0;
            assert(v6 >> 26 == 0);
            assert(d >> 35 == 0);
            // assert(c, 64);
            /* [d u6 0 0 0 0 0 0 t9 0 0 c-u6*R0 t5 t4 t3 t2 t1 t0] = [p16 p15 p14 p13 p12 p11 p10 p9 0 0 p6 p5 p4 p3 p2 p1 p0] */
            let t6 = u64u32(c & M);
            c >>= 26;
            c +%= v6 *% R1;
            assert(t6 >> 26 == 0);
            assert(c >> 39 == 0);
            /* [d u6 0 0 0 0 0 0 t9 0 c-u6*R1 t6-u6*R0 t5 t4 t3 t2 t1 t0] = [p16 p15 p14 p13 p12 p11 p10 p9 0 0 p6 p5 p4 p3 p2 p1 p0] */
            /* [d 0 0 0 0 0 0 0 t9 0 c t6 t5 t4 t3 t2 t1 t0] = [p16 p15 p14 p13 p12 p11 p10 p9 0 0 p6 p5 p4 p3 p2 p1 p0] */

            c := wrapping_add(
                    wrapping_add(
                        wrapping_add(
                            wrapping_add(
                                wrapping_add(
                                    wrapping_add(
                                        wrapping_add(
                                            wrapping_add(
                                                c, 
                                                u64(a.n[0]) *% u64(b.n[7])
                                            ),
                                            u64(a.n[1]) *% u64(b.n[6])
                                        ),
                                        u64(a.n[2]) *% u64(b.n[5])
                                    ),
                                    u64(a.n[3]) *% u64(b.n[4])
                                ),
                                u64(a.n[4]) *% u64(b.n[3])
                            ),
                            u64(a.n[5]) *% u64(b.n[2])
                        ),
                        u64(a.n[6]) *% u64(b.n[1])
                    ),
                    u64(a.n[7]) *% u64(b.n[0])
                );

            // assert(c, 64);
            assert(c <= 0x8000007c00000007);
            /* [d 0 0 0 0 0 0 0 t9 0 c t6 t5 t4 t3 t2 t1 t0] = [p16 p15 p14 p13 p12 p11 p10 p9 0 p7 p6 p5 p4 p3 p2 p1 p0] */
            d := wrapping_add(
                    wrapping_add(
                        d, 
                        u64(a.n[8]) *% u64(b.n[9])
                    ), 
                    u64(a.n[9]) *% u64(b.n[8])
                );
            assert(d >> 58 == 0);
            /* [d 0 0 0 0 0 0 0 t9 0 c t6 t5 t4 t3 t2 t1 t0] = [p17 p16 p15 p14 p13 p12 p11 p10 p9 0 p7 p6 p5 p4 p3 p2 p1 p0] */
            let v7 = d & M;
            d >>= 26;
            c +%= v7 *% R0;
            assert(v7 >> 26 == 0);
            assert(d >> 32 == 0);
            // assert(c, 64);
            assert(c <= 0x800001703fffc2f7);
            /* [d u7 0 0 0 0 0 0 0 t9 0 c-u7*R0 t6 t5 t4 t3 t2 t1 t0] = [p17 p16 p15 p14 p13 p12 p11 p10 p9 0 p7 p6 p5 p4 p3 p2 p1 p0] */
            let t7 = u64u32(c & M);
            c >>= 26;
            c +%= v7 *% R1;
            assert(t7 >> 26 == 0);
            assert(c >> 38 == 0);
            /* [d u7 0 0 0 0 0 0 0 t9 c-u7*R1 t7-u7*R0 t6 t5 t4 t3 t2 t1 t0] = [p17 p16 p15 p14 p13 p12 p11 p10 p9 0 p7 p6 p5 p4 p3 p2 p1 p0] */
            /* [d 0 0 0 0 0 0 0 0 t9 c t7 t6 t5 t4 t3 t2 t1 t0] = [p17 p16 p15 p14 p13 p12 p11 p10 p9 0 p7 p6 p5 p4 p3 p2 p1 p0] */

            c := wrapping_add(
                    wrapping_add(
                        wrapping_add(
                            wrapping_add(
                                wrapping_add(
                                    wrapping_add(
                                        wrapping_add(
                                            wrapping_add(
                                                wrapping_add(
                                                    c, 
                                                    u64(a.n[0]) *% u64(b.n[8])
                                                ),
                                                u64(a.n[1]) *% u64(b.n[7])
                                            ),
                                            u64(a.n[2]) *% u64(b.n[6])
                                        ),
                                        u64(a.n[3]) *% u64(b.n[5])
                                    ),
                                    u64(a.n[4]) *% u64(b.n[4])
                                ),
                                u64(a.n[5]) *% u64(b.n[3])
                            ),
                            u64(a.n[6]) *% u64(b.n[2])
                        ),
                        u64(a.n[7]) *% u64(b.n[1])
                    ),
                    u64(a.n[8]) *% u64(b.n[0])
                );

            // assert(c, 64);
            assert(c <= 0x9000007b80000008);
            /* [d 0 0 0 0 0 0 0 0 t9 c t7 t6 t5 t4 t3 t2 t1 t0] = [p17 p16 p15 p14 p13 p12 p11 p10 p9 p8 p7 p6 p5 p4 p3 p2 p1 p0] */
            d := wrapping_add(
                    d, 
                    u64(a.n[9]) *% u64(b.n[9])
                );
            assert(d >> 57 == 0);
            /* [d 0 0 0 0 0 0 0 0 t9 c t7 t6 t5 t4 t3 t2 t1 t0] = [p18 p17 p16 p15 p14 p13 p12 p11 p10 p9 p8 p7 p6 p5 p4 p3 p2 p1 p0] */
            let v8 = d & M;
            d >>= 26;
            c +%= v8 *% R0;
            assert(v8 >> 26 == 0);
            assert(d >> 31 == 0);
            // assert(c, 64);
            assert(c <= 0x9000016fbfffc2f8);
            /* [d u8 0 0 0 0 0 0 0 0 t9 c-u8*R0 t7 t6 t5 t4 t3 t2 t1 t0] = [p18 p17 p16 p15 p14 p13 p12 p11 p10 p9 p8 p7 p6 p5 p4 p3 p2 p1 p0] */

            n[3] := t3;
            assert(n[3] >> 26 == 0);
            /* [d u8 0 0 0 0 0 0 0 0 t9 c-u8*R0 t7 t6 t5 t4 r3 t2 t1 t0] = [p18 p17 p16 p15 p14 p13 p12 p11 p10 p9 p8 p7 p6 p5 p4 p3 p2 p1 p0] */
            n[4] := t4;
            assert(n[4] >> 26 == 0);
            /* [d u8 0 0 0 0 0 0 0 0 t9 c-u8*R0 t7 t6 t5 r4 r3 t2 t1 t0] = [p18 p17 p16 p15 p14 p13 p12 p11 p10 p9 p8 p7 p6 p5 p4 p3 p2 p1 p0] */
            n[5] := t5;
            assert(n[5] >> 26 == 0);
            /* [d u8 0 0 0 0 0 0 0 0 t9 c-u8*R0 t7 t6 r5 r4 r3 t2 t1 t0] = [p18 p17 p16 p15 p14 p13 p12 p11 p10 p9 p8 p7 p6 p5 p4 p3 p2 p1 p0] */
            n[6] := t6;
            assert(n[6] >> 26 == 0);
            /* [d u8 0 0 0 0 0 0 0 0 t9 c-u8*R0 t7 r6 r5 r4 r3 t2 t1 t0] = [p18 p17 p16 p15 p14 p13 p12 p11 p10 p9 p8 p7 p6 p5 p4 p3 p2 p1 p0] */
            n[7] := t7;
            assert(n[7] >> 26 == 0);
            /* [d u8 0 0 0 0 0 0 0 0 t9 c-u8*R0 r7 r6 r5 r4 r3 t2 t1 t0] = [p18 p17 p16 p15 p14 p13 p12 p11 p10 p9 p8 p7 p6 p5 p4 p3 p2 p1 p0] */

            n[8] := u64u32(c & M);
            c >>= 26;
            c +%= v8 *% R1;
            assert(n[8] >> 26 == 0);
            assert(c >> 39 == 0);
            /* [d u8 0 0 0 0 0 0 0 0 t9+c-u8*R1 r8-u8*R0 r7 r6 r5 r4 r3 t2 t1 t0] = [p18 p17 p16 p15 p14 p13 p12 p11 p10 p9 p8 p7 p6 p5 p4 p3 p2 p1 p0] */
            /* [d 0 0 0 0 0 0 0 0 0 t9+c r8 r7 r6 r5 r4 r3 t2 t1 t0] = [p18 p17 p16 p15 p14 p13 p12 p11 p10 p9 p8 p7 p6 p5 p4 p3 p2 p1 p0] */
            c +%= d *% R0 + u64(t9);
            assert(c >> 45 == 0);
            /* [d 0 0 0 0 0 0 0 0 0 c-d*R0 r8 r7 r6 r5 r4 r3 t2 t1 t0] = [p18 p17 p16 p15 p14 p13 p12 p11 p10 p9 p8 p7 p6 p5 p4 p3 p2 p1 p0] */
            n[9] := u64u32(c & (M >> 4));
            c >>= 22;
            c +%= d *% (R1 << 4);
            assert(n[9] >> 22 == 0);
            assert(c >> 46 == 0);
            /* [d 0 0 0 0 0 0 0 0 r9+((c-d*R1<<4)<<22)-d*R0 r8 r7 r6 r5 r4 r3 t2 t1 t0] = [p18 p17 p16 p15 p14 p13 p12 p11 p10 p9 p8 p7 p6 p5 p4 p3 p2 p1 p0] */
            /* [d 0 0 0 0 0 0 0 -d*R1 r9+(c<<22)-d*R0 r8 r7 r6 r5 r4 r3 t2 t1 t0] = [p18 p17 p16 p15 p14 p13 p12 p11 p10 p9 p8 p7 p6 p5 p4 p3 p2 p1 p0] */
            /* [r9+(c<<22) r8 r7 r6 r5 r4 r3 t2 t1 t0] = [p18 p17 p16 p15 p14 p13 p12 p11 p10 p9 p8 p7 p6 p5 p4 p3 p2 p1 p0] */

            d := c *% (R0 >> 4) + u64(t0);
            assert(d >> 56 == 0);
            /* [r9+(c<<22) r8 r7 r6 r5 r4 r3 t2 t1 d-c*R0>>4] = [p18 p17 p16 p15 p14 p13 p12 p11 p10 p9 p8 p7 p6 p5 p4 p3 p2 p1 p0] */
            n[0] := u64u32(d & M);
            d >>= 26;
            assert(n[0] >> 26 == 0);
            assert(d >> 30 == 0);
            /* [r9+(c<<22) r8 r7 r6 r5 r4 r3 t2 t1+d r0-c*R0>>4] = [p18 p17 p16 p15 p14 p13 p12 p11 p10 p9 p8 p7 p6 p5 p4 p3 p2 p1 p0] */
            d +%= c *% (R1 >> 4) + u64(t1);
            assert(d >> 53 == 0);
            assert(d <= 0x10000003ffffbf);
            /* [r9+(c<<22) r8 r7 r6 r5 r4 r3 t2 d-c*R1>>4 r0-c*R0>>4] = [p18 p17 p16 p15 p14 p13 p12 p11 p10 p9 p8 p7 p6 p5 p4 p3 p2 p1 p0] */
            /* [r9 r8 r7 r6 r5 r4 r3 t2 d r0] = [p18 p17 p16 p15 p14 p13 p12 p11 p10 p9 p8 p7 p6 p5 p4 p3 p2 p1 p0] */
            n[1] := u64u32(d & M);
            d >>= 26;
            assert(n[1] >> 26 == 0);
            assert(d >> 27 == 0);
            assert(d <= 0x4000000);
            /* [r9 r8 r7 r6 r5 r4 r3 t2+d r1 r0] = [p18 p17 p16 p15 p14 p13 p12 p11 p10 p9 p8 p7 p6 p5 p4 p3 p2 p1 p0] */
            d +%= u64(t2);
            assert(d >> 27 == 0);
            /* [r9 r8 r7 r6 r5 r4 r3 d r1 r0] = [p18 p17 p16 p15 p14 p13 p12 p11 p10 p9 p8 p7 p6 p5 p4 p3 p2 p1 p0] */
            n[2] := u64u32(d);
            assert(n[2] >> 27 == 0);
            /* [r9 r8 r7 r6 r5 r4 r3 r2 r1 r0] = [p18 p17 p16 p15 p14 p13 p12 p11 p10 p9 p8 p7 p6 p5 p4 p3 p2 p1 p0] */            
        };

        public func sqr_inner(a: Field) {
            let M: Nat64 = 0x3ffffff;
            let R0: Nat64 = 0x3d10;
            let R1: Nat64 = 0x400;

            var c: Nat64 = 0;
            var d: Nat64 = 0;

            assert(a.n[0] >> 30 == 0);
            assert(a.n[1] >> 30 == 0);
            assert(a.n[2] >> 30 == 0);
            assert(a.n[3] >> 30 == 0);
            assert(a.n[4] >> 30 == 0);
            assert(a.n[5] >> 30 == 0);
            assert(a.n[6] >> 30 == 0);
            assert(a.n[7] >> 30 == 0);
            assert(a.n[8] >> 30 == 0);
            assert(a.n[9] >> 26 == 0);

            // [... a b c] is a shorthand for ... + a<<52 + b<<26 + c<<0 mod n.
            // px is a shorthand for sum(a.n[i]*a.n[x-i], i=0..x).
            // Note that [x 0 0 0 0 0 0 0 0 0 0] = [x*R1 x*R0].

             
            d := wrapping_add(
                    wrapping_add(
                        wrapping_add(
                            wrapping_add(
                                u64(a.n[0] *% 2) *% u64(a.n[9]), 
                                u64(a.n[1] *% 2) *% u64(a.n[8])
                            ), 
                            u64(a.n[2] *% 2) *% u64(a.n[7])
                        ), 
                        u64(a.n[3] *% 2) *% u64(a.n[6])
                    ), 
                    u64(a.n[4] *% 2) *% u64(a.n[5])
                );
            // assert(d >> 64 == 0);
            /* [d 0 0 0 0 0 0 0 0 0] = [p9 0 0 0 0 0 0 0 0 0] */
            let t9 = u64u32(d & M);
            d >>= 26;
            assert(t9 >> 26 == 0);
            assert(d >> 38 == 0);
            /* [d t9 0 0 0 0 0 0 0 0 0] = [p9 0 0 0 0 0 0 0 0 0] */

            c := u64(a.n[0]) *% u64(a.n[0]);
            assert(c >> 60 == 0);
            /* [d t9 0 0 0 0 0 0 0 0 c] = [p9 0 0 0 0 0 0 0 0 p0] */
            d := wrapping_add(
                    wrapping_add(
                        wrapping_add(
                            wrapping_add(
                                wrapping_add(
                                    d,
                                    u64(a.n[1] *% 2) *% u64(a.n[9])
                                ), 
                                u64(a.n[2] *% 2) *% u64(a.n[8])
                            ), 
                            u64(a.n[3] *% 2) *% u64(a.n[7])
                        ), 
                        u64(a.n[4] *% 2) *% u64(a.n[6])
                    ),
                    u64(a.n[5]) *% u64(a.n[5])
                );

            assert(d >> 63 == 0);
            /* [d t9 0 0 0 0 0 0 0 0 c] = [p10 p9 0 0 0 0 0 0 0 0 p0] */
            let v0 = d & M;
            d >>= 26;
            c +%= v0 *% R0;
            assert(v0 >> 26 == 0);
            assert(d >> 37 == 0);
            assert(c >> 61 == 0);
            /* [d u0 t9 0 0 0 0 0 0 0 0 c-u0*R0] = [p10 p9 0 0 0 0 0 0 0 0 p0] */
            let t0 = u64u32(c & M);
            c >>= 26;
            c +%= v0 *% R1;
            assert(t0 >> 26 == 0);
            assert(c >> 37 == 0);
            /* [d u0 t9 0 0 0 0 0 0 0 c-u0*R1 t0-u0*R0] = [p10 p9 0 0 0 0 0 0 0 0 p0] */
            /* [d 0 t9 0 0 0 0 0 0 0 c t0] = [p10 p9 0 0 0 0 0 0 0 0 p0] */

            c := wrapping_add(
                    c,
                    u64(a.n[0] *% 2) *% u64(a.n[1])
                );
            assert(c >> 62 == 0);
            /* [d 0 t9 0 0 0 0 0 0 0 c t0] = [p10 p9 0 0 0 0 0 0 0 p1 p0] */

            d := wrapping_add(
                    wrapping_add(
                        wrapping_add(
                            wrapping_add(
                                d,
                                u64(a.n[2] *% 2) *% u64(a.n[9])
                            ), 
                            u64(a.n[3] *% 2) *% u64(a.n[8])
                        ), 
                        u64(a.n[4] *% 2) *% u64(a.n[7])
                    ),
                    u64(a.n[5] *% 2) *% u64(a.n[6])
                );
            
            assert(d >> 63 == 0);
            /* [d 0 t9 0 0 0 0 0 0 0 c t0] = [p11 p10 p9 0 0 0 0 0 0 0 p1 p0] */
            let v1 = d & M;
            d >>= 26;
            c +%= v1 *% R0;
            assert(v1 >> 26 == 0);
            assert(d >> 37 == 0);
            assert(c >> 63 == 0);
            /* [d u1 0 t9 0 0 0 0 0 0 0 c-u1*R0 t0] = [p11 p10 p9 0 0 0 0 0 0 0 p1 p0] */
            let t1 = u64u32(c & M);
            c >>= 26;
            c +%= v1 *% R1;
            assert(t1 >> 26 == 0);
            assert(c >> 38 == 0);
            /* [d u1 0 t9 0 0 0 0 0 0 c-u1*R1 t1-u1*R0 t0] = [p11 p10 p9 0 0 0 0 0 0 0 p1 p0] */
            /* [d 0 0 t9 0 0 0 0 0 0 c t1 t0] = [p11 p10 p9 0 0 0 0 0 0 0 p1 p0] */

            c := wrapping_add(
                    wrapping_add(
                        c,
                        u64(a.n[0] *% 2) *% u64(a.n[2])
                    ),
                    u64(a.n[1]) *% u64(a.n[1])
                );

            assert(c >> 62 == 0);
            /* [d 0 0 t9 0 0 0 0 0 0 c t1 t0] = [p11 p10 p9 0 0 0 0 0 0 p2 p1 p0] */
            d := wrapping_add(
                    wrapping_add(
                        wrapping_add(
                            wrapping_add(
                                d,
                                u64(a.n[3] *% 2) *% u64(a.n[9])
                            ), 
                            u64(a.n[4] *% 2) *% u64(a.n[8])
                        ), 
                        u64(a.n[5] *% 2) *% u64(a.n[7])
                    ),
                    u64(a.n[6]) *% u64(a.n[6])
                );
            assert(d >> 63 == 0);
            /* [d 0 0 t9 0 0 0 0 0 0 c t1 t0] = [p12 p11 p10 p9 0 0 0 0 0 0 p2 p1 p0] */
            let v2 = d & M;
            d >>= 26;
            c +%= v2 *% R0;
            assert(v2 >> 26 == 0);
            assert(d >> 37 == 0);
            assert(c >> 63 == 0);
            /* [d u2 0 0 t9 0 0 0 0 0 0 c-u2*R0 t1 t0] = [p12 p11 p10 p9 0 0 0 0 0 0 p2 p1 p0] */
            let t2 = u64u32(c & M);
            c >>= 26;
            c +%= v2 *% R1;
            assert(t2 >> 26 == 0);
            assert(c >> 38 == 0);
            /* [d u2 0 0 t9 0 0 0 0 0 c-u2*R1 t2-u2*R0 t1 t0] = [p12 p11 p10 p9 0 0 0 0 0 0 p2 p1 p0] */
            /* [d 0 0 0 t9 0 0 0 0 0 c t2 t1 t0] = [p12 p11 p10 p9 0 0 0 0 0 0 p2 p1 p0] */

            c := wrapping_add(
                    wrapping_add(
                        c,
                        u64(a.n[0] *% 2) *% u64(a.n[3])
                    ),
                    u64(a.n[1] *% 2) *% u64(a.n[2])
                );
            assert(c >> 63 == 0);
            /* [d 0 0 0 t9 0 0 0 0 0 c t2 t1 t0] = [p12 p11 p10 p9 0 0 0 0 0 p3 p2 p1 p0] */
            d := wrapping_add(
                    wrapping_add(
                        wrapping_add(
                            d, 
                            u64(a.n[4] *% 2) *% u64(a.n[9])
                        ), 
                        u64(a.n[5] *% 2) *% u64(a.n[8])
                    ),
                    u64(a.n[6] *% 2) *% u64(a.n[7])
                );
            assert(d >> 63 == 0);
            /* [d 0 0 0 t9 0 0 0 0 0 c t2 t1 t0] = [p13 p12 p11 p10 p9 0 0 0 0 0 p3 p2 p1 p0] */
            let v3 = d & M;
            d >>= 26;
            c +%= v3 *% R0;
            assert(v3 >> 26 == 0);
            assert(d >> 37 == 0);
            // debug_assert_bits!(c, 64);
            /* [d u3 0 0 0 t9 0 0 0 0 0 c-u3*R0 t2 t1 t0] = [p13 p12 p11 p10 p9 0 0 0 0 0 p3 p2 p1 p0] */
            let t3 = u64u32(c & M);
            c >>= 26;
            c +%= v3 *% R1;
            assert(t3 >> 26 == 0);
            assert(c >> 39 == 0);
            /* [d u3 0 0 0 t9 0 0 0 0 c-u3*R1 t3-u3*R0 t2 t1 t0] = [p13 p12 p11 p10 p9 0 0 0 0 0 p3 p2 p1 p0] */
            /* [d 0 0 0 0 t9 0 0 0 0 c t3 t2 t1 t0] = [p13 p12 p11 p10 p9 0 0 0 0 0 p3 p2 p1 p0] */

            c := wrapping_add(
                    wrapping_add(
                        wrapping_add(
                            c,
                            u64(a.n[0] *% 2) *% u64(a.n[4])
                        ),
                        u64(a.n[1] *% 2) *% u64(a.n[3])
                    ),
                    u64(a.n[2]) *% u64(a.n[2])
                );
            assert(c >> 63 == 0);
            /* [d 0 0 0 0 t9 0 0 0 0 c t3 t2 t1 t0] = [p13 p12 p11 p10 p9 0 0 0 0 p4 p3 p2 p1 p0] */
            d := wrapping_add(
                    wrapping_add(
                        wrapping_add(
                            d, 
                            u64(a.n[5] *% 2) *% u64(a.n[9])
                        ), 
                        u64(a.n[6] *% 2) *% u64(a.n[8])
                    ),
                    u64(a.n[7]) *% u64(a.n[7])
                );          
            assert(d >> 62 == 0);
            /* [d 0 0 0 0 t9 0 0 0 0 c t3 t2 t1 t0] = [p14 p13 p12 p11 p10 p9 0 0 0 0 p4 p3 p2 p1 p0] */
            let v4 = d & M;
            d >>= 26;
            c +%= v4 *% R0;
            assert(v4 >> 26 == 0);
            assert(d >> 36 == 0);
            // debug_assert_bits!(c, 64);
            /* [d u4 0 0 0 0 t9 0 0 0 0 c-u4*R0 t3 t2 t1 t0] = [p14 p13 p12 p11 p10 p9 0 0 0 0 p4 p3 p2 p1 p0] */
            let t4 = u64u32(c & M);
            c >>= 26;
            c +%= v4 *% R1;
            assert(t4 >> 26 == 0);
            assert(c >> 39 == 0);
            /* [d u4 0 0 0 0 t9 0 0 0 c-u4*R1 t4-u4*R0 t3 t2 t1 t0] = [p14 p13 p12 p11 p10 p9 0 0 0 0 p4 p3 p2 p1 p0] */
            /* [d 0 0 0 0 0 t9 0 0 0 c t4 t3 t2 t1 t0] = [p14 p13 p12 p11 p10 p9 0 0 0 0 p4 p3 p2 p1 p0] */

            c := wrapping_add(
                    wrapping_add(
                        wrapping_add(
                            c,
                            u64(a.n[0] *% 2) *% u64(a.n[5])
                        ),
                        u64(a.n[1] *% 2) *% u64(a.n[4])
                    ),
                    u64(a.n[2] *% 2) *% u64(a.n[3])
                );
            assert(c >> 63 == 0);
            /* [d 0 0 0 0 0 t9 0 0 0 c t4 t3 t2 t1 t0] = [p14 p13 p12 p11 p10 p9 0 0 0 p5 p4 p3 p2 p1 p0] */
            d := wrapping_add(
                    wrapping_add(
                        d, 
                        u64(a.n[6] *% 2) *% u64(a.n[9])
                    ),
                    u64(a.n[7] *% 2) *% u64(a.n[8])
                );  
            assert(d >> 62 == 0);
            /* [d 0 0 0 0 0 t9 0 0 0 c t4 t3 t2 t1 t0] = [p15 p14 p13 p12 p11 p10 p9 0 0 0 p5 p4 p3 p2 p1 p0] */
            let v5 = d & M;
            d >>= 26;
            c +%= v5 *% R0;
            assert(v5 >> 26 == 0);
            assert(d >> 36 == 0);
            // debug_assert_bits!(c, 64);
            /* [d u5 0 0 0 0 0 t9 0 0 0 c-u5*R0 t4 t3 t2 t1 t0] = [p15 p14 p13 p12 p11 p10 p9 0 0 0 p5 p4 p3 p2 p1 p0] */
            let t5 = u64u32(c & M);
            c >>= 26;
            c +%= v5 *% R1;
            assert(t5 >> 26 == 0);
            assert(c >> 39 == 0);
            /* [d u5 0 0 0 0 0 t9 0 0 c-u5*R1 t5-u5*R0 t4 t3 t2 t1 t0] = [p15 p14 p13 p12 p11 p10 p9 0 0 0 p5 p4 p3 p2 p1 p0] */
            /* [d 0 0 0 0 0 0 t9 0 0 c t5 t4 t3 t2 t1 t0] = [p15 p14 p13 p12 p11 p10 p9 0 0 0 p5 p4 p3 p2 p1 p0] */

            c := wrapping_add(
                    wrapping_add(
                        wrapping_add(
                            wrapping_add(
                                c,
                                u64(a.n[0] *% 2) *% u64(a.n[6])
                            ),
                            u64(a.n[1] *% 2) *% u64(a.n[5])
                        ),
                        u64(a.n[2] *% 2) *% u64(a.n[4])
                    ),
                    u64(a.n[3]) *% u64(a.n[3])
                );
            assert(c >> 63 == 0);
            /* [d 0 0 0 0 0 0 t9 0 0 c t5 t4 t3 t2 t1 t0] = [p15 p14 p13 p12 p11 p10 p9 0 0 p6 p5 p4 p3 p2 p1 p0] */
            d := wrapping_add(
                    wrapping_add(
                        d, 
                        u64(a.n[7] *% 2) *% u64(a.n[9])
                    ),
                    u64(a.n[8]) *% u64(a.n[8])
                );
            assert(d >> 61 == 0);
            /* [d 0 0 0 0 0 0 t9 0 0 c t5 t4 t3 t2 t1 t0] = [p16 p15 p14 p13 p12 p11 p10 p9 0 0 p6 p5 p4 p3 p2 p1 p0] */
            let v6 = d & M;
            d >>= 26;
            c +%= v6 *% R0;
            assert(v6 >> 26 == 0);
            assert(d >> 35 == 0);
            // debug_assert_bits!(c, 64);
            /* [d u6 0 0 0 0 0 0 t9 0 0 c-u6*R0 t5 t4 t3 t2 t1 t0] = [p16 p15 p14 p13 p12 p11 p10 p9 0 0 p6 p5 p4 p3 p2 p1 p0] */
            let t6 = u64u32(c & M);
            c >>= 26;
            c +%= v6 *% R1;
            assert(t6 >> 26 == 0);
            assert(c >> 39 == 0);
            /* [d u6 0 0 0 0 0 0 t9 0 c-u6*R1 t6-u6*R0 t5 t4 t3 t2 t1 t0] = [p16 p15 p14 p13 p12 p11 p10 p9 0 0 p6 p5 p4 p3 p2 p1 p0] */
            /* [d 0 0 0 0 0 0 0 t9 0 c t6 t5 t4 t3 t2 t1 t0] = [p16 p15 p14 p13 p12 p11 p10 p9 0 0 p6 p5 p4 p3 p2 p1 p0] */

            c := wrapping_add(
                    wrapping_add(
                        wrapping_add(
                            wrapping_add(
                                c,
                                u64(a.n[0] *% 2) *% u64(a.n[7])
                            ),
                            u64(a.n[1] *% 2) *% u64(a.n[6])
                        ),
                        u64(a.n[2] *% 2) *% u64(a.n[5])
                    ),
                    u64(a.n[3] *% 2) *% u64(a.n[4])
                );

            // debug_assert_bits!(c, 64);
            assert(c <= 0x8000007C00000007);
            /* [d 0 0 0 0 0 0 0 t9 0 c t6 t5 t4 t3 t2 t1 t0] = [p16 p15 p14 p13 p12 p11 p10 p9 0 p7 p6 p5 p4 p3 p2 p1 p0] */
            d := wrapping_add(d, u64(a.n[8] *% 2) *% u64(a.n[9]));
            assert(d >> 58 == 0);
            /* [d 0 0 0 0 0 0 0 t9 0 c t6 t5 t4 t3 t2 t1 t0] = [p17 p16 p15 p14 p13 p12 p11 p10 p9 0 p7 p6 p5 p4 p3 p2 p1 p0] */
            let v7 = d & M;
            d >>= 26;
            c +%= v7 *% R0;
            assert(v7 >> 26 == 0);
            assert(d >> 32 == 0);
            /* debug_assert_bits!(c, 64); */
            assert(c <= 0x800001703FFFC2F7);
            /* [d u7 0 0 0 0 0 0 0 t9 0 c-u7*R0 t6 t5 t4 t3 t2 t1 t0] = [p17 p16 p15 p14 p13 p12 p11 p10 p9 0 p7 p6 p5 p4 p3 p2 p1 p0] */
            let t7 = u64u32(c & M);
            c >>= 26;
            c +%= v7 *% R1;
            assert(t7 >> 26 == 0);
            assert(c >> 38 == 0);
            /* [d u7 0 0 0 0 0 0 0 t9 c-u7*R1 t7-u7*R0 t6 t5 t4 t3 t2 t1 t0] = [p17 p16 p15 p14 p13 p12 p11 p10 p9 0 p7 p6 p5 p4 p3 p2 p1 p0] */
            /* [d 0 0 0 0 0 0 0 0 t9 c t7 t6 t5 t4 t3 t2 t1 t0] = [p17 p16 p15 p14 p13 p12 p11 p10 p9 0 p7 p6 p5 p4 p3 p2 p1 p0] */

            c := wrapping_add(
                    wrapping_add(
                        wrapping_add(
                            wrapping_add(
                                wrapping_add(
                                    c,
                                    u64(a.n[0] *% 2) *% u64(a.n[8])
                                ),
                                u64(a.n[1] *% 2) *% u64(a.n[7])
                            ),
                            u64(a.n[2] *% 2) *% u64(a.n[6])
                        ),
                        u64(a.n[3] *% 2) *% u64(a.n[5])
                    ), 
                    u64(a.n[4]) *% u64(a.n[4])
                );
            // debug_assert_bits!(c, 64);
            assert(c <= 0x9000007B80000008);
            /* [d 0 0 0 0 0 0 0 0 t9 c t7 t6 t5 t4 t3 t2 t1 t0] = [p17 p16 p15 p14 p13 p12 p11 p10 p9 p8 p7 p6 p5 p4 p3 p2 p1 p0] */
            d := wrapping_add(d, u64(a.n[9]) *% u64(a.n[9]));
            assert(d >> 57 == 0);
            /* [d 0 0 0 0 0 0 0 0 t9 c t7 t6 t5 t4 t3 t2 t1 t0] = [p18 p17 p16 p15 p14 p13 p12 p11 p10 p9 p8 p7 p6 p5 p4 p3 p2 p1 p0] */
            let v8 = d & M;
            d >>= 26;
            c +%= v8 *% R0;
            assert(v8 >> 26 == 0);
            assert(d >> 31 == 0);
            /* debug_assert_bits!(c, 64); */
            assert(c <= 0x9000016FBFFFC2F8);
            /* [d u8 0 0 0 0 0 0 0 0 t9 c-u8*R0 t7 t6 t5 t4 t3 t2 t1 t0] = [p18 p17 p16 p15 p14 p13 p12 p11 p10 p9 p8 p7 p6 p5 p4 p3 p2 p1 p0] */

            n[3] := t3;
            assert(n[3] >> 26 == 0);
            /* [d u8 0 0 0 0 0 0 0 0 t9 c-u8*R0 t7 t6 t5 t4 r3 t2 t1 t0] = [p18 p17 p16 p15 p14 p13 p12 p11 p10 p9 p8 p7 p6 p5 p4 p3 p2 p1 p0] */
            n[4] := t4;
            assert(n[4] >> 26 == 0);
            /* [d u8 0 0 0 0 0 0 0 0 t9 c-u8*R0 t7 t6 t5 r4 r3 t2 t1 t0] = [p18 p17 p16 p15 p14 p13 p12 p11 p10 p9 p8 p7 p6 p5 p4 p3 p2 p1 p0] */
            n[5] := t5;
            assert(n[5] >> 26 == 0);
            /* [d u8 0 0 0 0 0 0 0 0 t9 c-u8*R0 t7 t6 r5 r4 r3 t2 t1 t0] = [p18 p17 p16 p15 p14 p13 p12 p11 p10 p9 p8 p7 p6 p5 p4 p3 p2 p1 p0] */
            n[6] := t6;
            assert(n[6] >> 26 == 0);
            /* [d u8 0 0 0 0 0 0 0 0 t9 c-u8*R0 t7 r6 r5 r4 r3 t2 t1 t0] = [p18 p17 p16 p15 p14 p13 p12 p11 p10 p9 p8 p7 p6 p5 p4 p3 p2 p1 p0] */
            n[7] := t7;
            assert(n[7] >> 26 == 0);
            /* [d u8 0 0 0 0 0 0 0 0 t9 c-u8*R0 r7 r6 r5 r4 r3 t2 t1 t0] = [p18 p17 p16 p15 p14 p13 p12 p11 p10 p9 p8 p7 p6 p5 p4 p3 p2 p1 p0] */

            n[8] := u64u32(c & M);
            c >>= 26;
            c +%= v8 *% R1;
            assert(n[8] >> 26 == 0);
            assert(c >> 39 == 0);
            /* [d u8 0 0 0 0 0 0 0 0 t9+c-u8*R1 r8-u8*R0 r7 r6 r5 r4 r3 t2 t1 t0] = [p18 p17 p16 p15 p14 p13 p12 p11 p10 p9 p8 p7 p6 p5 p4 p3 p2 p1 p0] */
            /* [d 0 0 0 0 0 0 0 0 0 t9+c r8 r7 r6 r5 r4 r3 t2 t1 t0] = [p18 p17 p16 p15 p14 p13 p12 p11 p10 p9 p8 p7 p6 p5 p4 p3 p2 p1 p0] */
            c +%= d *% R0 + u64(t9);
            assert(c >> 45 == 0);
            /* [d 0 0 0 0 0 0 0 0 0 c-d*R0 r8 r7 r6 r5 r4 r3 t2 t1 t0] = [p18 p17 p16 p15 p14 p13 p12 p11 p10 p9 p8 p7 p6 p5 p4 p3 p2 p1 p0] */
            n[9] := u64u32(c & (M >> 4));
            c >>= 22;
            c +%= d *% (R1 << 4);
            assert(n[9] >> 22 == 0);
            assert(c >> 46 == 0);
            /* [d 0 0 0 0 0 0 0 0 r9+((c-d*R1<<4)<<22)-d*R0 r8 r7 r6 r5 r4 r3 t2 t1 t0] = [p18 p17 p16 p15 p14 p13 p12 p11 p10 p9 p8 p7 p6 p5 p4 p3 p2 p1 p0] */
            /* [d 0 0 0 0 0 0 0 -d*R1 r9+(c<<22)-d*R0 r8 r7 r6 r5 r4 r3 t2 t1 t0] = [p18 p17 p16 p15 p14 p13 p12 p11 p10 p9 p8 p7 p6 p5 p4 p3 p2 p1 p0] */
            /* [r9+(c<<22) r8 r7 r6 r5 r4 r3 t2 t1 t0] = [p18 p17 p16 p15 p14 p13 p12 p11 p10 p9 p8 p7 p6 p5 p4 p3 p2 p1 p0] */

            d := c *% (R0 >> 4) + u64(t0);
            assert(d >> 56 == 0);
            /* [r9+(c<<22) r8 r7 r6 r5 r4 r3 t2 t1 d-c*R0>>4] = [p18 p17 p16 p15 p14 p13 p12 p11 p10 p9 p8 p7 p6 p5 p4 p3 p2 p1 p0] */
            n[0] := u64u32(d & M);
            d >>= 26;
            assert(n[0] >> 26 == 0);
            assert(d >> 30 == 0);
            /* [r9+(c<<22) r8 r7 r6 r5 r4 r3 t2 t1+d r0-c*R0>>4] = [p18 p17 p16 p15 p14 p13 p12 p11 p10 p9 p8 p7 p6 p5 p4 p3 p2 p1 p0] */
            d +%= c *% (R1 >> 4) + u64(t1);
            assert(d >> 53 == 0);
            assert(d <= 0x10000003FFFFBF);
            /* [r9+(c<<22) r8 r7 r6 r5 r4 r3 t2 d-c*R1>>4 r0-c*R0>>4] = [p18 p17 p16 p15 p14 p13 p12 p11 p10 p9 p8 p7 p6 p5 p4 p3 p2 p1 p0] */
            /* [r9 r8 r7 r6 r5 r4 r3 t2 d r0] = [p18 p17 p16 p15 p14 p13 p12 p11 p10 p9 p8 p7 p6 p5 p4 p3 p2 p1 p0] */
            n[1] := u64u32(d & M);
            d >>= 26;
            assert(n[1] >> 26 == 0);
            assert(d >> 27 == 0);
            assert(d <= 0x4000000);
            /* [r9 r8 r7 r6 r5 r4 r3 t2+d r1 r0] = [p18 p17 p16 p15 p14 p13 p12 p11 p10 p9 p8 p7 p6 p5 p4 p3 p2 p1 p0] */
            d +%= u64(t2);
            assert(d >> 27 == 0);
            /* [r9 r8 r7 r6 r5 r4 r3 d r1 r0] = [p18 p17 p16 p15 p14 p13 p12 p11 p10 p9 p8 p7 p6 p5 p4 p3 p2 p1 p0] */
            n[2] := u64u32(d);
            assert(n[2] >> 27 == 0);
            /* [r9 r8 r7 r6 r5 r4 r3 r2 r1 r0] = [p18 p17 p16 p15 p14 p13 p12 p11 p10 p9 p8 p7 p6 p5 p4 p3 p2 p1 p0] */            
        };

        /// Sets a field element to be the product of two others. Requires
        /// the inputs' magnitudes to be at most 8. The output magnitude
        /// is 1 (but not guaranteed to be normalized).
        public func mul_in_place(a: Field, b: Field) {
            assert(a.magnitude <= 8);
            assert(b.magnitude <= 8);
            assert(a.verify());
            assert(b.verify());     

            mul_inner(a, b);
            magnitude := 1;
            normalized := false;
            assert(verify());
        };

        /// Sets a field element to be the square of another. Requires the
        /// input's magnitude to be at most 8. The output magnitude is 1
        /// (but not guaranteed to be normalized).
        public func sqr_in_place(a: Field) {
            assert(a.magnitude <= 8);
            assert(a.verify());
            sqr_inner(a);
            magnitude := 1;
            normalized := false;
            assert(a.verify());            
        };

        public func sqr(): Field {
            let ret = Field();
            let _self = clone();
            ret.sqr_in_place(_self);
            ret
        };

        /// If a has a square root, it is computed in r and 1 is
        /// returned. If a does not have a square root, the root of its
        /// negation is computed and 0 is returned. The input's magnitude
        /// can be at most 8. The output magnitude is 1 (but not
        /// guaranteed to be normalized). The result in r will always be a
        /// square itself.
        public func sqrt(): (Field, Bool) {
            let _self = clone();
            var x2 = sqr();
            x2.mul_assign(_self);

            var x3 = x2.sqr();
            x3.mul_assign(_self);

            var x6 = x3;
            for (_ in (Iter.range(0, 2))) { //0..3
                x6 := x6.sqr();
            };
            x6.mul_assign(x3);

            var x9 = x6;
            for (_ in (Iter.range(0, 2))) { //0..3
                x9 := x9.sqr();
            };
            x9.mul_assign(x3);

            var x11 = x9;
            for (_ in (Iter.range(0, 1))) { //0..2
                x11 := x11.sqr();
            };
            x11.mul_assign(x2);

            var x22 = x11;
            for (_ in (Iter.range(0, 10))) { //0..11
                x22 := x22.sqr();
            };
            x22.mul_assign(x11);

            var x44 = x22;
            for (_ in (Iter.range(0, 21))) { //0..22
                x44 := x44.sqr();
            };
            x44.mul_assign(x22);

            var x88 = x44;
            for (_ in (Iter.range(0, 43))) { //0..44
                x88 := x88.sqr();
            };
            x88.mul_assign(x44);

            var x176 = x88;
            for (_ in (Iter.range(0, 87))) { //0..88
                x176 := x176.sqr();
            };
            x176.mul_assign(x88);

            var x220 = x176;
            for (_ in (Iter.range(0, 43))) { //0..44
                x220 := x220.sqr();
            };
            x220.mul_assign(x44);

            var x223 = x220;
            for (_ in (Iter.range(0, 2))) { //0..3
                x223 := x223.sqr();
            };
            x223.mul_assign(x3);

            var t1 = x223;
            for (_ in (Iter.range(0, 22))) { //0..23
                t1 := t1.sqr();
            };
            t1.mul_assign(x22);
            for (_ in (Iter.range(0, 5))) { //0..6
                t1 := t1.sqr();
            };
            t1.mul_assign(x2);
            t1 := t1.sqr();
            let r = t1.sqr();

            t1 := r.sqr();
            (r, t1.eq(_self))
        };

        /// Sets a field element to be the (modular) inverse of
        /// another. Requires the input's magnitude to be at most 8. The
        /// output magnitude is 1 (but not guaranteed to be normalized).
        public func inv(): Field {
            let _self = clone();
            var x2 = _self.sqr();
            x2 := x2.mul(_self);

            var x3 = x2.sqr();
            x3.mul_assign(_self);

            var x6 = x3;
            for (_ in (Iter.range(0, 2))) { //0..3
                x6 := x6.sqr();
            };
            x6.mul_assign(x3);

            var x9 = x6;
            for (_ in (Iter.range(0, 2))) { //0..3
                x9 := x9.sqr();
            };
            x9.mul_assign(x3);

            var x11 = x9;
            for (_ in (Iter.range(0, 1))) { //0..2
                x11 := x11.sqr();
            };
            x11.mul_assign(x2);

            var x22 = x11;
            for (_ in (Iter.range(0, 10))) { //0..11
                x22 := x22.sqr();
            };
            x22.mul_assign(x11);

            var x44 = x22;
            for (_ in (Iter.range(0, 21))) { //0..22
                x44 := x44.sqr();
            };
            x44.mul_assign(x22);

            var x88 = x44;
            for (_ in (Iter.range(0, 43))) { //0..44
                x88 := x88.sqr();
            };
            x88.mul_assign(x44);

            var x176 = x88;
            for (_ in (Iter.range(0, 87))) { //0..88
                x176 := x176.sqr();
            };
            x176.mul_assign(x88);

            var x220 = x176;
            for (_ in (Iter.range(0, 43))) { //0..44
                x220 := x220.sqr();
            };
            x220.mul_assign(x44);

            var x223 = x220;
            for (_ in (Iter.range(0, 2))) { //0..3
                x223 := x223.sqr();
            };
            x223.mul_assign(x3);

            var t1 = x223;
            for (_ in (Iter.range(0, 22))) { //0..23
                t1 := t1.sqr();
            };
            t1.mul_assign(x22);
            for (_ in (Iter.range(0, 4))) { //0..5
                t1 := t1.sqr();
            };
            t1.mul_assign(_self);
            for (_ in (Iter.range(0, 2))) { //0..3
                t1 := t1.sqr();
            };
            t1.mul_assign(x2);
            for (_ in (Iter.range(0, 1))) { //0..2
                t1 := t1.sqr();
            };
            _self.mul(t1)
        };

        /// Potentially faster version of secp256k1_fe_inv, without
        /// constant-time guarantee.
        public func inv_var(): Field {
            inv()
        };

        /// Checks whether a field element is a quadratic residue.
        public func is_quad_var(): Bool {
            let (_, ret) = sqrt();
            ret
        };

        /// If flag is true, set *r equal to *a; otherwise leave
        /// it. Constant-time.
        public func cmov(other: Field, flag: Bool) {
            if flag {
                n[0] := other.n[0];
                n[1] := other.n[1];
                n[2] := other.n[2];
                n[3] := other.n[3];
                n[4] := other.n[4];
                n[5] := other.n[5];
                n[6] := other.n[6];
                n[7] := other.n[7];
                n[8] := other.n[8];
                n[9] := other.n[9];
                magnitude := other.magnitude;
                normalized := other.normalized;
            };
        };

        // Default Field()

        // Add
        public func add(other: Field): Field {
            let ret = clone();
            ret.add_assign(other);
            ret
        };

        // AddAssign
        public func add_assign(other: Field) {
            n[0] +%= other.n[0];
            n[1] +%= other.n[1];
            n[2] +%= other.n[2];
            n[3] +%= other.n[3];
            n[4] +%= other.n[4];
            n[5] +%= other.n[5];
            n[6] +%= other.n[6];
            n[7] +%= other.n[7];
            n[8] +%= other.n[8];
            n[9] +%= other.n[9];

            magnitude +%= other.magnitude;
            normalized := false;
            assert(verify());            
        };

        // Mul
        public func mul(other: Field) : Field {
            let ret = Field();
            let _self = clone();
            ret.mul_in_place(_self, other);
            ret
        };

        // MulAssign
        public func mul_assign(other: Field) {
            let ret = Field();
            let _self = clone();
            ret.mul_in_place(_self, other);
            assign_mut(ret)
        };

        // PartialEq
        public func eq(other: Field): Bool {
            var na = neg(magnitude);
            na := na.add(other);
            na.normalizes_to_zero()
        };

        // Ord
        public func cmp(other: Field): Order.Order {
            cmp_var(other)
        };

        // PartialOrd
        public func partial_cmp(other: Field): ?Order.Order {
            ?cmp(other)
        };

        public func into(): FieldStorage {
            assert(normalized);
            let r = FieldStorage();

            r.n[0] := n[0] | n[1] << 26;
            r.n[1] := n[1] >> 6 | n[2] << 20;
            r.n[2] := n[2] >> 12 | n[3] << 14;
            r.n[3] := n[3] >> 18 | n[4] << 8;
            r.n[4] := n[4] >> 24 | n[5] << 2 | n[6] << 28;
            r.n[5] := n[6] >> 4 | n[7] << 22;
            r.n[6] := n[7] >> 10 | n[8] << 16;
            r.n[7] := n[8] >> 16 | n[9] << 10;

            r
        };

    };

    public func new_raw(
        d9: Nat32,
        d8: Nat32,
        d7: Nat32,
        d6: Nat32,
        d5: Nat32,
        d4: Nat32,
        d3: Nat32,
        d2: Nat32,
        d1: Nat32,
        d0: Nat32,
    ): Field {
        let ret = Field();
        ret.n[0] := d0;
        ret.n[1] := d1;
        ret.n[2] := d2;
        ret.n[3] := d3;
        ret.n[4] := d4;
        ret.n[5] := d5;
        ret.n[6] := d6;
        ret.n[7] := d7;
        ret.n[8] := d8;
        ret.n[9] := d9;
        ret.magnitude := 1;
        ret.normalized := false;
        ret
    };

    public func new(
        d7: Nat32,
        d6: Nat32,
        d5: Nat32,
        d4: Nat32,
        d3: Nat32,
        d2: Nat32,
        d1: Nat32,
        d0: Nat32,            
    ): Field {
        let ret = Field();
        ret.n[0] := d0 & 0x3ffffff;
        ret.n[1] := (d0 >> 26) | ((d1 & 0xfffff) << 6);
        ret.n[2] := (d1 >> 20) | ((d2 & 0x3fff) << 12);
        ret.n[3] := (d2 >> 14) | ((d3 & 0xff) << 18);
        ret.n[4] := (d3 >> 8) | ((d4 & 0x3) << 24);
        ret.n[5] := (d4 >> 2) & 0x3ffffff;
        ret.n[6] := (d4 >> 28) | ((d5 & 0x3fffff) << 4);
        ret.n[7] := (d5 >> 22) | ((d6 & 0xffff) << 10);
        ret.n[8] := (d6 >> 16) | ((d7 & 0x3ff) << 16);
        ret.n[9] := (d7 >> 10);
        ret.magnitude := 1;
        ret.normalized := true;
        ret
    };

    /// Compact field element storage.
    public class FieldStorage() {
        public var n: [var Nat32] = Array.tabulateVar<Nat32>(8, func i = 0);
        public let len: Nat = 8;

        public func clone(): FieldStorage {
            let fs = FieldStorage();
            fs.n[0] := n[0];
            fs.n[1] := n[1];
            fs.n[2] := n[2];
            fs.n[3] := n[3];
            fs.n[4] := n[4];
            fs.n[5] := n[5];
            fs.n[6] := n[6];
            fs.n[7] := n[7];
            return fs;
        };

        public func cmov(other: FieldStorage, flag: Bool) {
            n[0] := if flag { other.n[0] } else { n[0] };
            n[1] := if flag { other.n[1] } else { n[1] };
            n[2] := if flag { other.n[2] } else { n[2] };
            n[3] := if flag { other.n[3] } else { n[3] };
            n[4] := if flag { other.n[4] } else { n[4] };
            n[5] := if flag { other.n[5] } else { n[5] };
            n[6] := if flag { other.n[6] } else { n[6] };
            n[7] := if flag { other.n[7] } else { n[7] };
        };

        public func from(): Field {
            let r = Field();
            r.n[0] := n[0] & 0x3FFFFFF;
            r.n[1] := n[0] >> 26 | ((n[1] << 6) & 0x3FFFFFF);
            r.n[2] := n[1] >> 20 | ((n[2] << 12) & 0x3FFFFFF);
            r.n[3] := n[2] >> 14 | ((n[3] << 18) & 0x3FFFFFF);
            r.n[4] := n[3] >> 8 | ((n[4] << 24) & 0x3FFFFFF);
            r.n[5] := (n[4] >> 2) & 0x3FFFFFF;
            r.n[6] := n[4] >> 28 | ((n[5] << 4) & 0x3FFFFFF);
            r.n[7] := n[5] >> 22 | ((n[6] << 10) & 0x3FFFFFF);
            r.n[8] := n[6] >> 16 | ((n[7] << 16) & 0x3FFFFFF);
            r.n[9] := n[7] >> 10;

            r.magnitude := 1;
            r.normalized := true;

            r
        };
    };

    public func new_fs(
        d7: Nat32,
        d6: Nat32,
        d5: Nat32,
        d4: Nat32,
        d3: Nat32,
        d2: Nat32,
        d1: Nat32,
        d0: Nat32,
    ): FieldStorage {
        let ret = FieldStorage();
        ret.n[0] := d0;
        ret.n[1] := d1;
        ret.n[2] := d2;
        ret.n[3] := d3;
        ret.n[4] := d4;
        ret.n[5] := d5;
        ret.n[6] := d6;
        ret.n[7] := d7;
        ret
    };
};
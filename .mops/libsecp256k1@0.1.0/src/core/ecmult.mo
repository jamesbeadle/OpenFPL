import Array "mo:base/Array";
import Iter "mo:base/Iter";
import Nat32 "mo:base/Nat32";
import Nat64 "mo:base/Nat64";
import Int32 "mo:base/Int32";
import Int "mo:base/Int";
import Buffer "mo:base/Buffer";
import Field "field";
import Group "group";
import Scalar "scalar";
import Utils "utils";
import Subtle "../subtle/lib";
import Blob "mo:base/Blob";
import Nat8 "mo:base/Nat8";
import Text "mo:base/Text";
import Char "mo:base/Char";

module {
    type Field = Field.Field;
    type AffineStorage = Group.AffineStorage;
    type Affine = Group.Affine;
    type Jacobian = Group.Jacobian;
    type JacobianStatic = Group.JacobianStatic;
    type Scalar = Scalar.Scalar;
    type Choice = Subtle.Choice;

    public let WINDOW_A: Nat32 = 5;
    public let WINDOW_G: Nat32 = 16;
    public let ECMULT_TABLE_SIZE_A: Nat = 8; //  1 << (WINDOW_A - 2);
    public let ECMULT_TABLE_SIZE_G: Nat = 16384; // 1 << (WINDOW_G - 2);
    public let WNAF_BITS: Nat = 256;

    func _calcPreG(
    ): [AffineStorage] {
        let pre_g = Array.tabulateVar<AffineStorage>(ECMULT_TABLE_SIZE_G, func i = Group.AffineStorage());
        let gj = Group.Jacobian();
        gj.set_ge(Group.affineStatic(Group.AFFINE_G));
        odd_multiples_table_storage_var(pre_g, gj);
        return Array.freeze(pre_g);
    };

    public func loadPreG(
        pre_g: Blob
    ): [AffineStorage] {
        let arr = Blob.toArray(pre_g);
        assert(arr.size() == ECMULT_TABLE_SIZE_G * 2 * 8 * 4);

        let _leArrayToNat32 = func (ofs: Nat): Nat32 {
            return Nat32.fromNat(Nat8.toNat(arr[ofs+0])) 
                | Nat32.fromNat(Nat8.toNat(arr[ofs+1])) << 8 
                | Nat32.fromNat(Nat8.toNat(arr[ofs+2])) << 16
                | Nat32.fromNat(Nat8.toNat(arr[ofs+3])) << 24;
        };

        let res = Array.tabulate<AffineStorage>(ECMULT_TABLE_SIZE_G, func (i) {
            let offset = i * 2 * 8 * 4;
            let af = Group.AffineStorage();
            af.x.n := Array.tabulateVar<Nat32>(8, func (j) {
                _leArrayToNat32(offset + ((8-1) * 4) - (j * 4));
            });
            af.y.n := Array.tabulateVar<Nat32>(8, func (j) {
                _leArrayToNat32(offset + (8 * 4) + ((8-1) * 4) - (j * 4));
            });
            
            return af;
        });

        return res;
    };

    /// Context for accelerating the computation of a*P + b*G.
    public class ECMultContext(
        _pre_g: ?[AffineStorage]
    ) {
        public let pre_g: [AffineStorage] = switch(_pre_g) {
            case (null) _calcPreG(); 
            case (?tb) tb;
        };

        public func ecmult(
            r: Jacobian, 
            a: Jacobian, 
            na: Scalar.Scalar, 
            ng: Scalar.Scalar
        ) {
            let pre_a = Array.tabulateVar<Affine>(ECMULT_TABLE_SIZE_A, func i = Group.Affine());
            var z = Field.Field();
            let wnaf_na = Array.tabulateVar<Int32>(256, func i = 0: Int32);
            let wnaf_ng = Array.tabulateVar<Int32>(256, func i = 0: Int32);
            let bits_na = ecmult_wnaf(wnaf_na, na, Nat64.fromNat(Nat32.toNat(WINDOW_A)));
            var bits = bits_na;
            odd_multiples_table_globalz_windowa(pre_a, z, a);

            let bits_ng = ecmult_wnaf(wnaf_ng, ng, Nat64.fromNat(Nat32.toNat(WINDOW_G)));
            if(bits_ng > bits) {
                bits := bits_ng;
            };

            r.set_infinity();
            for(ii in Iter.revRange(Nat32.toNat(Int32.toNat32(bits))-1, 0)) {
                let i = Int.abs(ii);
                r.double_var_in_place(r.clone(), null);

                let n1 = wnaf_na[i];
                if(i < Int32.toInt(bits_na) and n1 != 0) {
                    let tmpa = table_get_ge(pre_a, n1, Int32.fromNat32(WINDOW_A));
                    r.add_ge_var_in_place(r.clone(), tmpa, null);
                };
                
                let n2 = wnaf_ng[i];
                if(i < Int32.toInt(bits_ng) and n2 != 0) {
                    let tmpa = table_get_ge_storage(pre_g, n2, Int32.fromNat32(WINDOW_G));
                    r.add_zinv_var_in_place(r.clone(), tmpa, z);
                };
            };

            if(not r.is_infinity()) {
                r.z.mul_assign(z);
            };
        };
    };

    public func ecmult_wnaf(
        wnaf: [var Int32], 
        a: Scalar.Scalar, 
        w: Nat64
    ): Int32 {
        let len = Nat64.fromNat(wnaf.size());
        let wl1 = Int32.fromNat32(Nat32.fromNat(Nat64.toNat(w -% 1)));
        var s = a.clone();
        var last_set_bit = -1: Int32;
        var bit = 0: Nat64;
        var sign = 1: Int32;
        var carry = 0: Int32;

        assert(len <= 256);
        assert(w >= 2 and w <= 31);

        for(i in Iter.range(0, wnaf.size()-1)) {
            wnaf[i] := 0;
        };

        if(s.bits(255, 1) > 0) {
            s.neg_mut();
            sign := -1;
        };

        label L while(bit < len) {
            if(s.bits(bit, 1) == Int32.toNat32(carry)) {
                bit +%= 1;
                continue L;
            };

            var now = w;
            if(now > len -% bit) {
                now := len -% bit;
            };

            var word = Int32.fromNat32(s.bits_var(bit, now)) +% carry;

            carry := (word >> wl1) & 1;
            word -%= carry << Int32.fromNat32(Nat32.fromNat(Nat64.toNat(w)));

            wnaf[Nat64.toNat(bit)] := sign *% word;
            last_set_bit := Int32.fromNat32(Nat32.fromNat(Nat64.toNat(bit)));

            bit +%= now;
        };
        assert(carry == 0);
        assert(do {
            var t = true;
            while(bit < 256) {
                t := t and (s.bits(bit, 1) == 0);
                bit +%= 1;
            };
            t
        });
        
        return last_set_bit +% 1;
    };

    /// Set a batch of group elements equal to the inputs given in jacobian
    /// coordinates. Not constant time.
    public func set_all_gej_var(
        a: [Jacobian]
    ): [var Affine] {
        let az_buf = Buffer.Buffer<Field>(a.size());
        for (point in Array.vals(a)) {
            if (not point.is_infinity()) {
                az_buf.add(point.z.clone());
            };
        };
        let az = Buffer.toVarArray(az_buf);
        let azi = inv_all_var(az);

        let ret = Array.tabulateVar<Affine>(a.size(), func i = Group.Affine());

        var count = 0;
        for (i in Iter.range(0, a.size()-1)) {
            ret[i].infinity := a[i].infinity;
            if (not a[i].is_infinity()) {
                ret[i].set_gej_zinv(a[i], azi[count]);
                count += 1;
            };
        };
        ret
    };

    /// Calculate the (modular) inverses of a batch of field
    /// elements. Requires the inputs' magnitudes to be at most 8. The
    /// output magnitudes are 1 (but not guaranteed to be
    /// normalized).
    public func inv_all_var(
        fields: [var Field]
    ): [var Field] {
        if (fields.size() == 0) {
            return [var];
        };

        let ret_buf = Buffer.Buffer<Field>(fields.size());
        ret_buf.add(fields[0]);

        for (i in Iter.range(1, fields.size()-1)) {
            ret_buf.add(ret_buf.get(i-1).mul(fields[i]));
        };
        let ret = Buffer.toVarArray(ret_buf);

        var u = ret[fields.size() - 1].inv_var();

        for (i in Iter.revRange(fields.size()-1, 1)) {
            let j: Nat = Int.abs(i);
            let x: Nat = j - 1;
            ret[j] := ret[x].mul(u);
            u.mul_assign(fields[j]);
        };

        ret[0] := u;
        ret
    };

    // Scalar.n = GEN_BLIND
    let GEN_BLIND: [Nat32] = [
        2217680822, 850875797, 1046150361, 1330484644, 4015777837, 2466086288, 2052467175, 2084507480,
    ];
    // Field::new_raw
    let GEN_INITIAL: JacobianStatic = {
        x = [
            586608, 43357028, 207667908, 262670128, 142222828, 38529388, 267186148, 45417712,
            115291924, 13447464,
        ];
        y = [
            12696548, 208302564, 112025180, 191752716, 143238548, 145482948, 228906000, 69755164,
            243572800, 210897016,
        ];
        z = [
            3685368, 75404844, 20246216, 5748944, 73206666, 107661790, 110806176, 73488774, 5707384,
            104448710,
        ];
        infinity = false;
    };

    func _calcPreC(
    ): [[AffineStorage]] {
        let affine_g = Group.affineStatic(Group.AFFINE_G);
        
        let gj = Group.Jacobian();
        gj.set_ge(affine_g);

        // Construct a group element with no known corresponding scalar (nothing up my sleeve).
        let nums_32: [Nat8] = Array.map<Char, Nat8>(
            Iter.toArray(Text.toIter("The scalar for this x is unknown")), 
            func c = Nat8.fromNat(Nat32.toNat(Char.toNat32(c)))
        );
        let nums_x = Field.Field();
        assert(nums_x.set_b32(nums_32, 0));
        let nums_ge = Group.Affine();
        assert(nums_ge.set_xo_var(nums_x, false));
        var nums_gej = Group.Jacobian();
        nums_gej.set_ge(nums_ge);
        nums_gej := nums_gej.add_ge_var(affine_g, null);

        // Compute prec.
        let precj = Array.tabulateVar<Group.Jacobian>(1024, func i = Group.Jacobian());
        var gbase = gj.clone();
        var numsbase = nums_gej.clone();
        for(j in Iter.range(0, 63)) { // 0..64
            precj[j * 16].assign_mut(numsbase);
            for(i in Iter.range(1, 15)) { // 1..16
                precj[j * 16 + i] := precj[j * 16 + i - 1].add_var(gbase, null);
            };
            for(_ in Iter.range(0, 3)) { // 0..4
                gbase := gbase.double_var(null);
            };
            numsbase := numsbase.double_var(null);
            if(j == 62) {
                numsbase := numsbase.neg();
                numsbase := numsbase.add_var(nums_gej, null);
            };
        };

        let prec = Array.tabulate<[var AffineStorage]>(
            64, func i = Array.tabulateVar<AffineStorage>(
                16, func i = Group.AffineStorage()));
        
        let prec_ = set_all_gej_var(Array.freeze(precj));

        for(j in Iter.range(0, 63)) { // 0..64
            for(i in Iter.range(0, 15)) { // 0..16
                let pg = Group.into_as(prec_[j * 16 + i]);
                prec[j][i] := pg;
            };
        };

        return Array.map<[var AffineStorage], [AffineStorage]>(prec, func e = Array.freeze(e));
    };

    public func loadPrec(
        prec: Blob
    ): [[AffineStorage]] {
        let arr = Blob.toArray(prec);
        assert(arr.size() == (64*16) * 2 * 8 * 4);

        let _leArrayToNat32 = func (ofs: Nat): Nat32 {
            return Nat32.fromNat(Nat8.toNat(arr[ofs+0])) 
                | Nat32.fromNat(Nat8.toNat(arr[ofs+1])) << 8 
                | Nat32.fromNat(Nat8.toNat(arr[ofs+2])) << 16
                | Nat32.fromNat(Nat8.toNat(arr[ofs+3])) << 24;
        };

        let res = Array.tabulate<[AffineStorage]>(64, func (j) {
            let rowofs = j * 16 * 2 * 8 * 4;
            let res = Array.tabulate<AffineStorage>(16, func (i) {
                let offset = rowofs + i * 2 * 8 * 4;
                let af = Group.AffineStorage();
                af.x.n := Array.tabulateVar<Nat32>(8, func (j) {
                    _leArrayToNat32(offset + ((8-1) * 4) - (j * 4));
                });
                af.y.n := Array.tabulateVar<Nat32>(8, func (j) {
                    _leArrayToNat32(offset + (8 * 4) + ((8-1) * 4) - (j * 4));
                });
                
                return af;
            });
        });

        return res;
    };

    /// Context for accelerating the computation of a*G.
    public class ECMultGenContext(
        _prec: ?[[AffineStorage]]
    ) {
        public let blind = Scalar.Scalar();
        blind.set(GEN_BLIND);
        public let initial = Group.jacobianStatic(GEN_INITIAL);

        public let prec: [[AffineStorage]] = switch(_prec) {
            case (null) _calcPreC(); 
            case (?tb) tb;
        };

        public func ecmult_gen(
            r: Jacobian, 
            gn: Scalar
        ) {
            let adds = Group.AffineStorage();
            r.assign_mut(initial);
            let gnb = gn.add(blind);

            for(j in Iter.range(0, 63)) { // 0..64
                let bits = gnb.bits(Nat64.fromNat(j * 4), 4);
                for(i in Iter.range(0, 15)) { // 0..16
                    adds.cmov(prec[j][i], Nat32.fromNat(i) == bits);
                };
                let add = Group.from_as(adds);
                r.assign_mut(r.add_ge(add));
            };
        };
    };

    func odd_multiples_table_globalz_windowa(
        pre: [var Group.Affine],
        globalz: Field.Field,
        a: Jacobian,
    ) {
        let prej = Array.tabulateVar<Jacobian>(ECMULT_TABLE_SIZE_A, func i = Group.Jacobian());
        let zr = Array.tabulateVar<Field.Field>(ECMULT_TABLE_SIZE_A, func i = Field.Field());

        odd_multiples_table(prej, zr, a);
        Group.globalz_set_table_gej(pre, globalz, prej, zr);
    };

    func table_get_ge(
        pre: [var Group.Affine], 
        n: Int32, 
        w: Int32
    ): Group.Affine {
        assert(n & 1 == 1);
        assert(n >= -((1 << (w -% 1)) -% 1));
        assert(n <= ((1 << (w -% 1)) -% 1));
        let r = if(n > 0) {
            pre[Int.abs(Int32.toInt((n -% 1) >> 1))].clone();
        } else {
            pre[Int.abs(Int32.toInt((-n -% 1) >> 1))].neg();
        };

        return r;
    };

    func table_get_ge_storage(
        pre: [Group.AffineStorage], 
        n: Int32, 
        w: Int32
    ): Group.Affine {
        assert(n & 1 == 1);
        assert(n >= -((1 << (w -% 1)) -% 1));
        assert(n <= ((1 << (w -% 1)) -% 1));
        let r = if(n > 0) {
            Group.from_as(pre[Int.abs(Int32.toInt((n -% 1) >> 1))]);
        } else {
            let r = Group.from_as(pre[Int.abs(Int32.toInt((-n -% 1) >> 1))]);
            r.neg();
        };
        return r;
    };

    public func odd_multiples_table(
        prej: [var Jacobian], 
        zr: [var Field], 
        a: Jacobian
    ) {
        let len = prej.size();
        assert(prej.size() == zr.size());
        assert(not (len == 0));
        assert(not a.is_infinity());

        let d = a.double_var(null);
        let d_ge = Group.new_af(d.x, d.y);

        let a_ge = Group.Affine();
        a_ge.set_gej_zinv(a, d.z);
        prej[0].x := a_ge.x.clone();
        prej[0].y := a_ge.y.clone();
        prej[0].z := a.z.clone();
        prej[0].infinity := false;

        zr[0] := d.z.clone();
        for (i in Iter.range(1, len-1)) {
            prej[i] := prej[i-1].add_ge_var(d_ge, ?zr[i]);
        };

        let l = prej[len-1].z.mul(d.z);
        prej[len-1].z := l;
    };

    func odd_multiples_table_storage_var(
        pre: [var AffineStorage], 
        a: Jacobian
    ) {
        let prej = Array.tabulateVar<Jacobian>(pre.size(), func i = Group.Jacobian());
        let prea = Array.tabulateVar<Affine>(pre.size(), func i = Group.Affine());
        let zr = Array.tabulateVar<Field>(pre.size(), func i = Field.Field());

        odd_multiples_table(prej, zr, a);
        Group.set_table_gej_var(prea, prej, zr);

        for (i in Iter.range(0, pre.size()-1)) {
            pre[i] := Group.into_as(prea[i]);
        };
    };
};
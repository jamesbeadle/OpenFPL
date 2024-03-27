import Result "mo:base/Result";
import Array "mo:base/Array";
import Field "field";
import Group "group";
import Scalar "scalar";
import Ecmult "ecmult";
import Error "error";
import Choice "../subtle";

module {
    let P_MINUS_ORDER = func (): Field.Field = 
        Field.new(0, 0, 0, 1, 0x45512319, 0x50B75FC4, 0x402DA172, 0x2FC9BAEE);

    let ORDER_AS_FE = func (): Field.Field = 
        Field.new(
            0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFE, 0xBAAEDCE6, 0xAF48A03B, 0xBFD25E8C, 0xD0364141,
        );

    public func recover_raw(
        self: Ecmult.ECMultContext,
        sigr: Scalar.Scalar,
        sigs: Scalar.Scalar,
        rec_id: Nat8,
        message: Scalar.Scalar,
    ): Result.Result<Group.Affine, Error.Error> {
        assert(rec_id < 4);

        if(sigr.is_zero() or sigs.is_zero()) {
            return #err(#InvalidSignature);
        };

        let brx = Array.freeze(sigr.b32());
        let fx = Field.Field();
        let overflow = fx.set_b32(brx, 0);
        assert(overflow);

        if(rec_id & 2 > 0) {
            switch(fx.cmp(P_MINUS_ORDER()) ) {
                case (#greater or #equal) {
                    return #err(#InvalidSignature);
                };
                case _ {};
            };
            fx.add_assign(ORDER_AS_FE());
        };
        let x = Group.Affine();
        if(not x.set_xo_var(fx, rec_id & 1 > 0)) {
            return #err(#InvalidSignature);
        };
        let xj = Group.Jacobian();
        xj.set_ge(x);
        let rn = sigr.inv();
        let u1 = rn.mul(message);
        u1.neg_mut();
        let u2 = rn.mul(sigs);
        var qj = Group.Jacobian();
        self.ecmult(qj, xj, u2, u1);

        let pubkey = Group.Affine();
        pubkey.set_gej_var(qj);

        if(pubkey.is_infinity()) {
            #err(#InvalidSignature)
        } else {
            #ok(pubkey)
        };
    };

    public func sign_raw(
        self: Ecmult.ECMultGenContext,
        seckey: Scalar.Scalar,
        message: Scalar.Scalar,
        nonce: Scalar.Scalar
    ): Result.Result<(Scalar.Scalar, Scalar.Scalar, Nat8), Error.Error> {
        let rp = Group.Jacobian();
        self.ecmult_gen(rp, nonce);
        let r = Group.Affine();
        r.set_gej(rp);
        r.x.normalize();
        r.y.normalize();
        let b = Array.freeze(r.x.b32());
        let sigr = Scalar.Scalar();
        let overflow = Choice.from(sigr.set_b32(b, 0));
        assert(not sigr.is_zero());
        assert(not overflow);

        var recid = (if(overflow) 2: Nat8 else 0: Nat8) | (if(r.y.is_odd()) 1: Nat8 else 0: Nat8);
        let n = sigr.mul(seckey);
        n.add_assign(message);
        let sigs = nonce.inv();
        sigs.mul_assign(n);
        n.clear();
        rp.clear();
        r.clear();
        if(sigs.is_zero()) {
            return #err(#InvalidMessage);
        };
        if(sigs.is_high()) {
            sigs.neg_mut();
            recid ^= 1;
        };
        return #ok((sigr, sigs, recid));
    }
};
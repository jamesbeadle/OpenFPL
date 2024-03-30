import Array "mo:base/Array";
import E "mo:base/Error";
import Result "mo:base/Result";
import Utils "core/utils";
import Field "core/field";
import Error "core/error";
import Group "core/group";
import Ecmult "core/ecmult";
import SecretKey "SecretKey";

module {
    public class PublicKey(
        affine_: Group.Affine
    ) {
        public let affine = affine_;

        public func serialize(
        ): [Nat8] {
            let ret = Array.tabulateVar<Nat8>(65, func i = 0);
            let elem = affine.clone();

            elem.x.normalize_var();
            elem.y.normalize_var();
            elem.x.fill_b32(ret, 1);
            elem.y.fill_b32(ret, 33);
            ret[0] := Utils.TAG_PUBKEY_FULL;

            return Array.freeze(ret);
        };

        public func serialize_compressed(
        ): [Nat8] {
            let ret = Array.tabulateVar<Nat8>(33, func i = 0);
            let elem = affine.clone();

            elem.x.normalize_var();
            elem.y.normalize_var();
            elem.x.fill_b32(ret, 1);
            ret[0] := if(elem.y.is_odd()) {
                Utils.TAG_PUBKEY_ODD
            } else {
                Utils.TAG_PUBKEY_EVEN
            };

            return Array.freeze(ret);
        }
    };

    public func from_secret_key_with_context(
        seckey: SecretKey.SecretKey,
        context: Ecmult.ECMultGenContext,
    ): PublicKey {
        let pj = Group.Jacobian();
        context.ecmult_gen(pj, seckey.scalar);
        let p = Group.Affine();
        p.set_gej(pj);
        return PublicKey(p);
    };

    public func parse(
        p: [Nat8]
    ): Result.Result<PublicKey, Error.Error> {
        if(not (p[0] == Utils.TAG_PUBKEY_FULL
            or p[0] == Utils.TAG_PUBKEY_HYBRID_EVEN
            or p[0] == Utils.TAG_PUBKEY_HYBRID_ODD)) {
            return #err(#InvalidPublicKey);
        };
        let x = Field.Field();
        let y = Field.Field();
        if(not x.set_b32(p, 1)) {
            return #err(#InvalidPublicKey);
        };
        if(not y.set_b32(p, 33)) {
            return #err(#InvalidPublicKey);
        };
        let elem = Group.Affine();
        elem.set_xy(x, y);
        if((p[0] == Utils.TAG_PUBKEY_HYBRID_EVEN or p[0] == Utils.TAG_PUBKEY_HYBRID_ODD)
            and (y.is_odd() != (p[0] == Utils.TAG_PUBKEY_HYBRID_ODD))) {
            return #err(#InvalidPublicKey);
        };
        if(elem.is_infinity()) {
            return #err(#InvalidPublicKey);
        };
        if(elem.is_valid_var()) {
            #ok(PublicKey(elem))
        } else {
            #err(#InvalidPublicKey)
        };
    };

    public func parse_compressed(
        p: [Nat8],
    ): Result.Result<PublicKey, Error.Error> {
        if(not (p[0] == Utils.TAG_PUBKEY_EVEN or p[0] == Utils.TAG_PUBKEY_ODD)) {
            return #err(#InvalidPublicKey);
        };
        let x = Field.Field();
        if(not x.set_b32(p, 1)) {
            return #err(#InvalidPublicKey);
        };
        let elem = Group.Affine();
        ignore elem.set_xo_var(x, p[0] == Utils.TAG_PUBKEY_ODD);
        if(elem.is_infinity()) {
            return #err(#InvalidPublicKey);
        };
        if(elem.is_valid_var()) {
            #ok(PublicKey(elem))
        } else {
            #err(#InvalidPublicKey)
        };
    };

    
};
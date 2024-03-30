import Array "mo:base/Array";
import E "mo:base/Error";
import Result "mo:base/Result";
import Error "core/error";
import Scalar "core/scalar";
import Choice "subtle";

module {
    public class Signature(
        r_: Scalar.Scalar,
        s_: Scalar.Scalar
    ) {
        public let r = r_;
        public let s = s_;

        public func serialize(
        ): [Nat8] {
            let ret = Array.tabulateVar<Nat8>(64, func i = 0: Nat8);
            r.fill_b32(ret, 0);
            s.fill_b32(ret, 32);
            return Array.freeze(ret);
        };
    };

    /// Parse an possibly overflowing signature.
    ///
    /// A SECP256K1 signature is usually required to be within 0 and curve
    /// order. This function, however, allows signatures larger than curve order
    /// by taking the signature and minus curve order.
    ///
    /// Note that while this function is technically safe, it is non-standard,
    /// meaning you will have compatibility issues if you also use other
    /// SECP256K1 libraries. It's not recommended to use this function. Please
    /// use `parse_standard` instead.
    public func parse_overflowing(
        p: [Nat8]
    ): Signature {
        let r = Scalar.Scalar();
        let s = Scalar.Scalar();

        // Okay for signature to overflow
        ignore r.set_b32(p, 0);
        ignore s.set_b32(p, 32);

        return Signature(r, s);
    };

    /// Parse a standard SECP256K1 signature. The signature is required to be
    /// within 0 and curve order. Returns error if it overflows.
    public func parse_standard(
        p: [Nat8]
    ): Result.Result<Signature, Error.Error> {
        let r = Scalar.Scalar();
        let s = Scalar.Scalar();

        // It's okay for the signature to overflow here, it's checked below.
        let overflowed_r = r.set_b32(p, 0);
        let overflowed_s = s.set_b32(p, 32);

        if(Choice.from(overflowed_r.bitor(overflowed_s))) {
            return #err(#InvalidSignature);
        };

        return #ok(Signature(r, s));
    };
}
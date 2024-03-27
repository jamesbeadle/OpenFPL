import Array "mo:base/Array";
import E "mo:base/Error";
import Result "mo:base/Result";
import Utils "core/utils";
import Field "core/field";
import Error "core/error";
import Group "core/group";
import Scalar "core/scalar";
import Choice "subtle";

module {
    public class SecretKey(
        scalar_: Scalar.Scalar
    ) {
        public let scalar = scalar_;
    };

    public func parse(
        p: [Nat8]
    ): Result.Result<SecretKey, Error.Error> {
        if(p.size() != Utils.SECRET_KEY_SIZE) {
            return #err(#InvalidInputLength);
        };
        let elem = Scalar.Scalar();
        if(not Choice.from(elem.set_b32(p, 0))) {
            return #ok(SecretKey(elem));
        } else {
            return #err(#InvalidSecretKey);
        };
    };
};
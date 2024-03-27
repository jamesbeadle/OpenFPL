import Array "mo:base/Array";
import E "mo:base/Error";
import Result "mo:base/Result";
import Utils "core/utils";
import Error "core/error";
import Scalar "core/scalar";

module {
    public class Message(
        value_: Scalar.Scalar
    ) {
        public let value = value_;

        public func serialize(
        ): [Nat8] {
            return Array.freeze(value.b32());
        };
    };

    public func parse(
        p: [Nat8]
    ): Message {
        let m = Scalar.Scalar();

        // Okay for message to overflow.
        ignore m.set_b32(p, 0);

        return Message(m);
    };

    public func parse_slice(
        p: [Nat8]
    ): Result.Result<Message, Error.Error> {
        if(p.size() != Utils.MESSAGE_SIZE) {
            return #err(#InvalidInputLength);
        };

        let a = Array.tabulate<Nat8>(Utils.MESSAGE_SIZE, func i = if(i < p.size()) p[i] else 0);
        return #ok(parse(a));
    };

};
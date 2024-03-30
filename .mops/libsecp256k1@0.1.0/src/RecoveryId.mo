import Array "mo:base/Array";
import E "mo:base/Error";
import Result "mo:base/Result";
import Error "core/error";

module {
    public class RecoveryId(
        value_: Nat8
    ) {
        public let value = value_;
        
        public func serialize(
        ): Nat8 {
            return value;
        }
    };

    /// Parse recovery ID starting with 0.
    public func parse(
        p: Nat8
    ): Result.Result<RecoveryId, Error.Error> {
        if(p < 4) {
            return #ok(RecoveryId(p));
        } else {
            return #err(#InvalidRecoveryId);
        };
    };

    /// Parse recovery ID as Ethereum RPC format, starting with 27.
    public func parse_rpc(
        p: Nat8
    ): Result.Result<RecoveryId, Error.Error> {
        if(p >= 27 and p < 27 + 4) {
            return parse(p - 27);
        } else {
            return #err(#InvalidRecoveryId);
        };
    };

    
};
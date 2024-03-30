import Array "mo:base/Array";
import E "mo:base/Error";
import Result "mo:base/Result";
import Error "core/error";
import Message "Message";
import Signature "Signature";
import RecoveryId "RecoveryId";
import PublicKey "PublicKey";
import SecretKey "SecretKey";
import ECMult "core/ecmult";
import Ecdsa "core/ecdsa";
import Scalar "core/scalar";
import Choice "subtle";
import Random "interfaces/Random";

module {
    /// Recover public key from a signed message, using the given context.
    public func recover_with_context(
        message: Message.Message,
        signature: Signature.Signature,
        recovery_id: RecoveryId.RecoveryId,
        context: ECMult.ECMultContext
    ): Result.Result<PublicKey.PublicKey, Error.Error> {
        switch(Ecdsa
            .recover_raw(context, signature.r, signature.s, recovery_id.value, message.value)) {
            case(#err(msg)) {
                return #err(msg);
            };
            case (#ok(af)) {
                return #ok(PublicKey.PublicKey(af));
            };
        };
    };

    public func sign_with_context(
        message: Message.Message,
        seckey: SecretKey.SecretKey,
        context: ECMult.ECMultGenContext,
        random: Random.Random
    ): Result.Result<(Signature.Signature, RecoveryId.RecoveryId), Error.Error> {
        var attempts = 0;
        loop {
            let nonce = Scalar.Scalar();
            let overflow = Choice.from(nonce.set_b32(random.next(), 0));

            if(not overflow and not nonce.is_zero()) {
                switch(Ecdsa.sign_raw(context, seckey.scalar, message.value, nonce)) {
                    case (#ok(val)) {
                        return #ok((Signature.Signature(val.0, val.1), RecoveryId.RecoveryId(val.2)));
                    };
                    case (#err(_)) {
                        attempts += 1;
                        if(attempts > 10) {
                            return #err(#NotFound);
                        };
                    };
                };
            };
        };
    };
};
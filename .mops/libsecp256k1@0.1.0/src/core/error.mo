module {
    public type Error = {
        #InvalidSignature;
        #InvalidPublicKey;
        #InvalidSecretKey;
        #InvalidRecoveryId;
        #InvalidMessage;
        #InvalidInputLength;
        #TweakOutOfRange;
        #InvalidAffine;
        #NotFound;
    };
};
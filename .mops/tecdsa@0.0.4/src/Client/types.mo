import { Fees } "mo:utilities";

module {

  public type Fee = Fees.Fee;

  public type Message = Blob;

  public type Signature = Blob;

  public type PublicKey = [Nat8];

  public type Tag = (Nat8, Nat8);

  public type Curve = { #secp256k1 };

  public type KeyId = {curve: Curve; name : Text};

  public type Params = {key_id: KeyId; derivation_path: [Blob]; canister_id: ?Principal};

  public type AsyncReturn<T> = { #ok: T; #err: AsyncError };

  public type AsyncError = {
    #fee_not_defined: Text;
    #trapped: Text;
    #other: Text;
  };

  public type ReturnFee = Fees.Return;

  public type IC = actor {
    ecdsa_public_key : ({
      canister_id : ?Principal;
      derivation_path : [Blob];
      key_id : { curve: { #secp256k1; } ; name: Text };
    }) -> async ({ public_key : Blob; chain_code : Blob; });
    sign_with_ecdsa : ({
      message_hash : Blob;
      derivation_path : [Blob];
      key_id : { curve: { #secp256k1; } ; name: Text };
    }) -> async ({ signature : Blob });
  };

}
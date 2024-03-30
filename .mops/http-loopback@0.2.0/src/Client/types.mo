import { Fees } "mo:utilities";
import Cbor "../Cbor";

module {

  public type URL = Text;

  public type ContentMap = Cbor.ContentMap; 

  public type Response = { #ok: ResponseType; #err: Error };

  public type ResponseType = { #unknown; #replied : Bytearray; #rejected : Bytearray };

  public type ReturnFee = Fees.Return;

  public type Bytearray = [Nat8];

  public type Error = {
    #fee_not_defined: Text;
    #rejected: Text;
    #missing: Text;
    #invalid: Text;
    #trapped: Text;
    #expired;
    #fatal: Text;
    #other: Text;
  };

  public type Request = {
    envelope: Bytearray;
    canister_id: Text;
    max_response_bytes: ?Nat64;
  };
  
};
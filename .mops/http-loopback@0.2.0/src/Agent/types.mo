import Client "../Client";
import ECDSA "mo:tecdsa";
import Cbor "../Cbor";
import State "state";
import Text "mo:base/Text";
import Hash "mo:rep-indy-hash";

module {

  public type Client = Client.Client;

  public type Identity = ECDSA.Identity;

  public type Bytearray = [Nat8];
  
  public type RequestId = Blob;

  public type State = State.State;

  public type Candid = Blob;

  public type CborArray = { #majorType4: [Cbor.CborValue] };

  public type CborBytes = { #majorType2 : [Nat8] };

  public type HashTree = Cbor.HashTree;

  public type ContentMap = Cbor.ContentMap;

  public type Certificate = ContentMap;

  public type Signature = Blob;

  public type Paths = [[Blob]];

  public type Response = { #ok: Candid; #err: Client.Error };

  public type SignResponse = { #ok: (RequestId, Bytearray); #err : Client.Error };

  public type SignAndSendResponse = { #ok: (RequestId, Client.ResponseType); #err : Client.Error };

  public type Status = { #ok : Client.ResponseType; #err : Client.Error };

  public type ReadResponse = { #ok : Bytearray; #err : Client.Error };

  public type ReadRequest = {
    max_response_bytes: ?Nat64;
    canister_id: Text;
    paths : Paths
  };

  public type CallRequest = {
    max_response_bytes: ?Nat64;
    canister_id: Text;
    method_name: Text;
    arg: Blob
  };

  public type RequestType = {
    #read_state: ReadRequest;
    #query_method: CallRequest;
    #update_method: CallRequest;
  };

  public type Request = {
    request: RequestType;
    ingress_expiry: Nat;
    sender: Blob;
    nonce: ?Blob;
  };

};
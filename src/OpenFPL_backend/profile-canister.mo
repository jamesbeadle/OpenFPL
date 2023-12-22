import T "types";
import List "mo:base/List";
import HashMap "mo:base/HashMap";
import Text "mo:base/Text";
import Iter "mo:base/Iter";

actor class ProfileCanister() {
  private var profilePictures : HashMap.HashMap<T.PrincipalId, Blob> = HashMap.HashMap<T.PrincipalId, Blob>(100, Text.equal, Text.hash);   

  public shared func addProfilePicture(principalId: Text, profilePicture: Blob){
    profilePictures.put(principalId, profilePicture);
  };

  public shared func hasSpaceAvailable() : async Bool {
    profilePictures.size() < 4000;
  };

  system func preupgrade() { };

  system func postupgrade() {};
};

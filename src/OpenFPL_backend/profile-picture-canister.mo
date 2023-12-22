import T "types";
import List "mo:base/List";
import HashMap "mo:base/HashMap";
import Text "mo:base/Text";
import Iter "mo:base/Iter";

actor class ProfilePictureCanister() {  
  private stable var bucket1 : [(T.PrincipalId, Blob)] = [];
  private stable var bucket2 : [(T.PrincipalId, Blob)] = [];
  private stable var bucket3 : [(T.PrincipalId, Blob)] = [];
  private stable var bucket4 : [(T.PrincipalId, Blob)] = [];
  private stable var bucket5 : [(T.PrincipalId, Blob)] = [];
  private stable var bucket6 : [(T.PrincipalId, Blob)] = [];
  private stable var bucket7 : [(T.PrincipalId, Blob)] = [];
  private stable var bucket8 : [(T.PrincipalId, Blob)] = [];
  private stable var bucket9 : [(T.PrincipalId, Blob)] = [];
  private stable var bucket10 : [(T.PrincipalId, Blob)] = [];
  private stable var bucket11 : [(T.PrincipalId, Blob)] = [];
  private stable var bucket12 : [(T.PrincipalId, Blob)] = [];

  private var currentBucketIndex = 0;
  private var maxPicturesPerBucket = 15000;
  
  public shared func addProfilePicture(principalId: T.PrincipalId, profilePicture: Blob) : async () {
    switch (currentBucketIndex) {
      case 0 {
        if (bucket1.size() < maxPicturesPerBucket) {
          bucket1 := bucket1 + [(principalId, profilePicture)];
        }
      };
      case 1 {
        if (bucket2.size() < maxPicturesPerBucket) {
          bucket2 := bucket2 + [(principalId, profilePicture)];
        }
      };
      case _ { /* Handle an unexpected case, possibly an error */ };
    };

    // Update currentBucketIndex if the current bucket is full
    if (getBucketSize(currentBucketIndex) >= maxPicturesPerBucket) {
      currentBucketIndex := (currentBucketIndex + 1) % totalBuckets;
    }
  };

  public shared func hasSpaceAvailable() : async Bool {
    // Check if the current bucket still has space
    return getBucketSize(currentBucketIndex) < maxPicturesPerBucket;
  };

  private func getBucketSize(index : Nat) : Nat {
    // Logic to return the size of the bucket based on index
    switch (index) {
      case 0 { bucket1.size() };
      case 1 { bucket2.size() };
      // ... Repeat for all buckets

      case _ { 0 }; // Default case, should not happen
    };
  };


  system func preupgrade() { };

  system func postupgrade() {};
};

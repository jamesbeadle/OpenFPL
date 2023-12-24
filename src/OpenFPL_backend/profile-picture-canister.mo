import T "types";
import List "mo:base/List";
import HashMap "mo:base/HashMap";
import Text "mo:base/Text";
import Iter "mo:base/Iter";
import Buffer "mo:base/Buffer";
import Cycles "mo:base/ExperimentalCycles";

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
  private let totalBuckets : Nat = 12;
  
  public shared func addProfilePicture(principalId: T.PrincipalId, profilePicture: Blob) : async () {
    switch (currentBucketIndex) {
      case 0 {
        if (bucket1.size() < maxPicturesPerBucket) {
          let bucketBuffer = Buffer.fromArray<(T.PrincipalId, Blob)>(bucket1);
          bucketBuffer.add((principalId, profilePicture));
          bucket1 := Buffer.toArray(bucketBuffer);
        }
      };
      case 1 {
        if (bucket2.size() < maxPicturesPerBucket) {
          let bucketBuffer = Buffer.fromArray<(T.PrincipalId, Blob)>(bucket2);
          bucketBuffer.add((principalId, profilePicture));
          bucket2 := Buffer.toArray(bucketBuffer);
        }
      };
      case 2 {
        if (bucket3.size() < maxPicturesPerBucket) {
          let bucketBuffer = Buffer.fromArray<(T.PrincipalId, Blob)>(bucket3);
          bucketBuffer.add((principalId, profilePicture));
          bucket3 := Buffer.toArray(bucketBuffer);
        }
      };
      case 3 {
        if (bucket4.size() < maxPicturesPerBucket) {
          let bucketBuffer = Buffer.fromArray<(T.PrincipalId, Blob)>(bucket4);
          bucketBuffer.add((principalId, profilePicture));
          bucket4 := Buffer.toArray(bucketBuffer);
        }
      };
      case 4 {
        if (bucket5.size() < maxPicturesPerBucket) {
          let bucketBuffer = Buffer.fromArray<(T.PrincipalId, Blob)>(bucket5);
          bucketBuffer.add((principalId, profilePicture));
          bucket5 := Buffer.toArray(bucketBuffer);
        }
      };
      case 5 {
        if (bucket6.size() < maxPicturesPerBucket) {
          let bucketBuffer = Buffer.fromArray<(T.PrincipalId, Blob)>(bucket6);
          bucketBuffer.add((principalId, profilePicture));
          bucket6 := Buffer.toArray(bucketBuffer);
        }
      };
      case 6 {
        if (bucket7.size() < maxPicturesPerBucket) {
          let bucketBuffer = Buffer.fromArray<(T.PrincipalId, Blob)>(bucket7);
          bucketBuffer.add((principalId, profilePicture));
          bucket7 := Buffer.toArray(bucketBuffer);
        }
      };
      case 7 {
        if (bucket8.size() < maxPicturesPerBucket) {
          let bucketBuffer = Buffer.fromArray<(T.PrincipalId, Blob)>(bucket8);
          bucketBuffer.add((principalId, profilePicture));
          bucket8 := Buffer.toArray(bucketBuffer);
        }
      };
      case 8 {
        if (bucket9.size() < maxPicturesPerBucket) {
          let bucketBuffer = Buffer.fromArray<(T.PrincipalId, Blob)>(bucket9);
          bucketBuffer.add((principalId, profilePicture));
          bucket9 := Buffer.toArray(bucketBuffer);
        }
      };
      case 9 {
        if (bucket10.size() < maxPicturesPerBucket) {
          let bucketBuffer = Buffer.fromArray<(T.PrincipalId, Blob)>(bucket10);
          bucketBuffer.add((principalId, profilePicture));
          bucket10 := Buffer.toArray(bucketBuffer);
        }
      };
      case 10 {
        if (bucket11.size() < maxPicturesPerBucket) {
          let bucketBuffer = Buffer.fromArray<(T.PrincipalId, Blob)>(bucket11);
          bucketBuffer.add((principalId, profilePicture));
          bucket11 := Buffer.toArray(bucketBuffer);
        }
      };
      case 11 {
        if (bucket12.size() < maxPicturesPerBucket) {
          let bucketBuffer = Buffer.fromArray<(T.PrincipalId, Blob)>(bucket12);
          bucketBuffer.add((principalId, profilePicture));
          bucket12 := Buffer.toArray(bucketBuffer);
        }
      };
      case _ {  };
    };

    if (getBucketSize(currentBucketIndex) >= maxPicturesPerBucket) {
      currentBucketIndex := (currentBucketIndex + 1) % totalBuckets;
    }
  };

  public shared func hasSpaceAvailable() : async Bool {
    let spaceInBucket1 = bucket1.size() < maxPicturesPerBucket;
    let spaceInBucket2 = bucket2.size() < maxPicturesPerBucket;
    let spaceInBucket3 = bucket3.size() < maxPicturesPerBucket;
    let spaceInBucket4 = bucket4.size() < maxPicturesPerBucket;
    let spaceInBucket5 = bucket5.size() < maxPicturesPerBucket;
    let spaceInBucket6 = bucket6.size() < maxPicturesPerBucket;
    let spaceInBucket7 = bucket7.size() < maxPicturesPerBucket;
    let spaceInBucket8 = bucket8.size() < maxPicturesPerBucket;
    let spaceInBucket9 = bucket9.size() < maxPicturesPerBucket;
    let spaceInBucket10 = bucket10.size() < maxPicturesPerBucket;
    let spaceInBucket11 = bucket11.size() < maxPicturesPerBucket;
    let spaceInBucket12 = bucket12.size() < maxPicturesPerBucket;

    return spaceInBucket1 or spaceInBucket2 or spaceInBucket3 or
      spaceInBucket4 or spaceInBucket5 or spaceInBucket6 or spaceInBucket7 or
      spaceInBucket8 or spaceInBucket9 or spaceInBucket10 or spaceInBucket11 or
      spaceInBucket12;
  };


  private func getBucketSize(index : Nat) : Nat {
    switch (index) {
      case 0 { bucket1.size() };
      case 1 { bucket2.size() };
      case 2 { bucket3.size() };
      case 3 { bucket4.size() };
      case 4 { bucket5.size() };
      case 5 { bucket6.size() };
      case 6 { bucket7.size() };
      case 7 { bucket8.size() };
      case 8 { bucket9.size() };
      case 9 { bucket10.size() };
      case 10 { bucket11.size() };
      case 11 { bucket12.size() };
      case _ { 0 };
    };
  };


  system func preupgrade() { };

  system func postupgrade() {};

  public func checkCanisterCycles() : () {
    let amount = Cycles.available();
    let limit : Nat = 0;//capacity - 20; //TODO: AGAIN WHAT IS THIS?
    let acceptable =
      if (amount <= limit) amount
      else limit;
    let accepted = Cycles.accept(acceptable);
    assert (accepted == acceptable);
  };
};

import T "types";
import List "mo:base/List";
import TrieMap "mo:base/TrieMap";
import Text "mo:base/Text";
import Iter "mo:base/Iter";
import Buffer "mo:base/Buffer";
import Cycles "mo:base/ExperimentalCycles";
import Timer "mo:base/Timer";
import Principal "mo:base/Principal";
import Debug "mo:base/Debug";
import CanisterIds "CanisterIds";
import Utilities "utilities";
import Environment "Environment";

actor class ProfilePictureCanister() {
  private stable var bucket1 : [(T.PrincipalId, Blob)] = [];
  private stable var bucket2 : [(T.PrincipalId, Blob)] = [];
  private stable var bucket3 : [(T.PrincipalId, Blob)] = [];
  private stable var bucket4 : [(T.PrincipalId, Blob)] = [];
  private stable var bucket5 : [(T.PrincipalId, Blob)] = [];
  private stable var bucket6 : [(T.PrincipalId, Blob)] = [];
  private stable var stable_bucket_map : [(T.PrincipalId, Nat8)] = [];

  let network = Environment.DFX_NETWORK;
  var main_canister_id = CanisterIds.MAIN_CANISTER_IC_ID;
  if (network == "local") {
    main_canister_id := CanisterIds.MAIN_CANISTER_LOCAL_ID;
  };

  private var currentBucketIndex = 0;
  private var maxPicturesPerBucket = 5000;
  private let totalBuckets : Nat = 12;
  private let cyclesCheckInterval : Nat = Utilities.getHour() * 24;
  private var cyclesCheckTimerId : ?Timer.TimerId = null;

  private var bucketMap : TrieMap.TrieMap<T.PrincipalId, Nat8> = TrieMap.TrieMap<T.PrincipalId, Nat8>(Text.equal, Text.hash);

  public shared ({ caller }) func addProfilePicture(principalId : T.PrincipalId, profilePicture : Blob) : async () {
    assert not Principal.isAnonymous(caller);
    let callerPrincipalId = Principal.toText(caller);
    assert callerPrincipalId == main_canister_id;

    switch (currentBucketIndex) {
      case 0 {
        if (bucket1.size() < maxPicturesPerBucket) {
          let bucketBuffer = Buffer.fromArray<(T.PrincipalId, Blob)>(bucket1);
          bucketBuffer.add((principalId, profilePicture));
          bucket1 := Buffer.toArray(bucketBuffer);
          bucketMap.put(principalId, 0);
        };
      };
      case 1 {
        if (bucket2.size() < maxPicturesPerBucket) {
          let bucketBuffer = Buffer.fromArray<(T.PrincipalId, Blob)>(bucket2);
          bucketBuffer.add((principalId, profilePicture));
          bucket2 := Buffer.toArray(bucketBuffer);
          bucketMap.put(principalId, 1);
        };
      };
      case 2 {
        if (bucket3.size() < maxPicturesPerBucket) {
          let bucketBuffer = Buffer.fromArray<(T.PrincipalId, Blob)>(bucket3);
          bucketBuffer.add((principalId, profilePicture));
          bucket3 := Buffer.toArray(bucketBuffer);
          bucketMap.put(principalId, 2);
        };
      };
      case 3 {
        if (bucket4.size() < maxPicturesPerBucket) {
          let bucketBuffer = Buffer.fromArray<(T.PrincipalId, Blob)>(bucket4);
          bucketBuffer.add((principalId, profilePicture));
          bucket4 := Buffer.toArray(bucketBuffer);
          bucketMap.put(principalId, 3);
        };
      };
      case 4 {
        if (bucket5.size() < maxPicturesPerBucket) {
          let bucketBuffer = Buffer.fromArray<(T.PrincipalId, Blob)>(bucket5);
          bucketBuffer.add((principalId, profilePicture));
          bucket5 := Buffer.toArray(bucketBuffer);
          bucketMap.put(principalId, 4);
        };
      };
      case 5 {
        if (bucket6.size() < maxPicturesPerBucket) {
          let bucketBuffer = Buffer.fromArray<(T.PrincipalId, Blob)>(bucket6);
          bucketBuffer.add((principalId, profilePicture));
          bucket6 := Buffer.toArray(bucketBuffer);
          bucketMap.put(principalId, 5);
        };
      };
      case _ {};
    };

    if (getBucketSize(currentBucketIndex) >= maxPicturesPerBucket) {
      currentBucketIndex := (currentBucketIndex + 1) % totalBuckets;
    };
  };

  public shared query ({ caller }) func hasSpaceAvailable() : async Bool {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == main_canister_id;

    let spaceInBucket1 = bucket1.size() < maxPicturesPerBucket;
    let spaceInBucket2 = bucket2.size() < maxPicturesPerBucket;
    let spaceInBucket3 = bucket3.size() < maxPicturesPerBucket;
    let spaceInBucket4 = bucket4.size() < maxPicturesPerBucket;
    let spaceInBucket5 = bucket5.size() < maxPicturesPerBucket;
    let spaceInBucket6 = bucket6.size() < maxPicturesPerBucket;

    return spaceInBucket1 or spaceInBucket2 or spaceInBucket3 or spaceInBucket4 or spaceInBucket5 or spaceInBucket6;
  };

  public shared query ({ caller }) func getProfilePicture(userPrincipal : T.PrincipalId) : async ?Blob {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == main_canister_id;

    let bucketIndex = bucketMap.get(userPrincipal);
    switch (bucketIndex) {
      case (null) {
        return null;
      };
      case (?index) {
        switch (index) {
          case 0 {
            let profilePictures = TrieMap.fromEntries<T.PrincipalId, Blob>(
              Iter.fromArray(bucket1),
              Text.equal,
              Text.hash,
            );
            return profilePictures.get(userPrincipal);
          };
          case 1 {
            let profilePictures = TrieMap.fromEntries<T.PrincipalId, Blob>(
              Iter.fromArray(bucket2),
              Text.equal,
              Text.hash,
            );
            return profilePictures.get(userPrincipal);
          };
          case 2 {
            let profilePictures = TrieMap.fromEntries<T.PrincipalId, Blob>(
              Iter.fromArray(bucket3),
              Text.equal,
              Text.hash,
            );
            return profilePictures.get(userPrincipal);
          };
          case 3 {
            let profilePictures = TrieMap.fromEntries<T.PrincipalId, Blob>(
              Iter.fromArray(bucket4),
              Text.equal,
              Text.hash,
            );
            return profilePictures.get(userPrincipal);
          };
          case 4 {
            let profilePictures = TrieMap.fromEntries<T.PrincipalId, Blob>(
              Iter.fromArray(bucket5),
              Text.equal,
              Text.hash,
            );
            return profilePictures.get(userPrincipal);
          };
          case 5 {
            let profilePictures = TrieMap.fromEntries<T.PrincipalId, Blob>(
              Iter.fromArray(bucket6),
              Text.equal,
              Text.hash,
            );
            return profilePictures.get(userPrincipal);
          };
          case _ {
            return null;
          };
        };
      };
    };

  };

  private func getBucketSize(index : Nat) : Nat {
    switch (index) {
      case 0 { bucket1.size() };
      case 1 { bucket2.size() };
      case 2 { bucket3.size() };
      case 3 { bucket4.size() };
      case 4 { bucket5.size() };
      case 5 { bucket6.size() };
      case _ { 0 };
    };
  };

  private func checkCanisterCycles() : async () {

    let balance = Cycles.balance();

    if (balance < 500000000000) {
      let openfpl_backend_canister = actor (main_canister_id) : actor {
        requestCanisterTopup : () -> async ();
      };
      await openfpl_backend_canister.requestCanisterTopup();
    };
    setCheckCyclesTimer();
  };

  private func setCheckCyclesTimer() {
    switch (cyclesCheckTimerId) {
      case (null) {};
      case (?id) {
        Timer.cancelTimer(id);
        cyclesCheckTimerId := null;
      };
    };
    cyclesCheckTimerId := ?Timer.setTimer(#nanoseconds(cyclesCheckInterval), checkCanisterCycles);
  };

  system func preupgrade() {
    stable_bucket_map := Iter.toArray(bucketMap.entries());
  };

  system func postupgrade() {
    bucketMap := TrieMap.fromEntries<T.PrincipalId, Nat8>(
      Iter.fromArray(stable_bucket_map),
      Text.equal,
      Text.hash,
    );
    setCheckCyclesTimer();
  };

  public func getCyclesBalance() : async Nat {
    return Cycles.balance();
  };

  public func topupCanister() : async () {
    let amount = Cycles.available();
    let accepted = Cycles.accept(amount);
  };

  setCheckCyclesTimer();

};

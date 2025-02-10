import Array "mo:base/Array";
import Hash "mo:base/Hash";
import Iter "mo:base/Iter";
import Nat8 "mo:base/Nat8";
import Nat16 "mo:base/Nat16";
import Nat32 "mo:base/Nat32";

import FootballTypes "mo:waterway-mops/FootballTypes";

module {

  public let eqNat8 = func(a : Nat8, b : Nat8) : Bool {
    a == b;
  };

  public let hashNat8 = func(key : Nat8) : Hash.Hash {
    Nat32.fromNat(Nat8.toNat(key) % (2 ** 32 - 1));
  };

  public let eqNat16 = func(a : Nat16, b : Nat16) : Bool {
    a == b;
  };

  public let hashNat16 = func(key : Nat16) : Hash.Hash {
    Nat32.fromNat(Nat16.toNat(key) % (2 ** 32 - 1));
  };

  public let eqNat32 = func(a : Nat32, b : Nat32) : Bool {
    a == b;
  };

  public let hashNat32 = func(key : Nat32) : Hash.Hash {
    Nat32.fromNat(Nat32.toNat(key) % (2 ** 32 - 1));
  };

  public func eqPlayerEventData(event1 : FootballTypes.PlayerEventData, event2 : FootballTypes.PlayerEventData) : Bool {
    event1.fixtureId == event2.fixtureId and event1.playerId == event2.playerId and event1.eventType == event2.eventType and event1.eventStartMinute == event2.eventStartMinute and event1.eventEndMinute == event2.eventEndMinute
  };

  public func eqPlayerEventDataArray(array1 : [FootballTypes.PlayerEventData], array2 : [FootballTypes.PlayerEventData]) : Bool {
    if (Array.size(array1) != Array.size(array2)) {
      return false;
    };

    for (i in Iter.range(0, Array.size(array1) -1)) {
      if (not eqPlayerEventData(array1[i], array2[i])) {
        return false;
      };
    };

    return true;
  };

};

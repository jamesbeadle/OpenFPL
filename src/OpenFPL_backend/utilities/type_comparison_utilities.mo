import Array "mo:base/Array";
import Iter "mo:base/Iter";
import FootballTypes "mo:waterway-mops/football/FootballTypes";

module {

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

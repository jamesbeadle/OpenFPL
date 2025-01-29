import Int "mo:base/Int";
import Int16 "mo:base/Int16";
import List "mo:base/List";
import T "../types/app_types";

module {

  public func assignPositionText(sortedEntries : List.List<T.LeaderboardEntry>) : List.List<T.LeaderboardEntry> {
    var position = 1;
    var previousScore : ?Int16 = null;
    var currentPosition = 1;

    func updatePosition(entry : T.LeaderboardEntry) : T.LeaderboardEntry {
      if (previousScore == null) {
        previousScore := ?entry.points;
        let updatedEntry = {
          entry with position = position;
          positionText = Int.toText(position);
        };
        currentPosition += 1;
        return updatedEntry;
      } else if (previousScore == ?entry.points) {
        currentPosition += 1;
        return { entry with position = position; positionText = "-" };
      } else {
        position := currentPosition;
        previousScore := ?entry.points;
        let updatedEntry = {
          entry with position = position;
          positionText = Int.toText(position);
        };
        currentPosition += 1;
        return updatedEntry;
      };
    };

    return List.map(sortedEntries, updatePosition);
  };  
  
};

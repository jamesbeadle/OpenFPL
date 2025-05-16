import FootballDefinitions "mo:waterway-mops/domain/football/definitions";
import AppTypes "../types/app_types";

module {


  public func calculateAggregatePlayerEvents(events : [AppTypes.PlayerEventData], playerPosition : FootballEnums.PlayerPosition) : Int16 {
    var totalScore : Int16 = 0;

    if (playerPosition == #Goalkeeper or playerPosition == #Defender) {
      let goalsConcededCount = Array.filter<FootballTypes.PlayerEventData>(
        events,
        func(event : FootballTypes.PlayerEventData) : Bool {
          event.eventType == #GoalConceded;
        },
      ).size();

      if (goalsConcededCount >= 2) {

        totalScore += (Int16.fromNat16(Nat16.fromNat(goalsConcededCount)) / 2) * -15;
      };
    };

    if (playerPosition == #Goalkeeper) {
      let savesCount = Array.filter<FootballTypes.PlayerEventData>(
        events,
        func(event : FootballTypes.PlayerEventData) : Bool {
          event.eventType == #KeeperSave;
        },
      ).size();

      totalScore += (Int16.fromNat16(Nat16.fromNat(savesCount)) / 3) * 5;
    };

    return totalScore;
  };

  public func calculateIndividualScoreForEvent(event : FootballTypes.PlayerEventData, playerPosition : FootballEnums.PlayerPosition) : Int16 {
    switch (event.eventType) {
      case (#Appearance) { return 5 };
      case (#Goal) {
        switch (playerPosition) {
          case (#Forward) { return 10 };
          case (#Midfielder) { return 15 };
          case _ { return 20 };
        };
      };
      case (#GoalAssisted) {
        switch (playerPosition) {
          case (#Forward) { return 10 };
          case (#Midfielder) { return 10 };
          case _ { return 15 };
        };
      };
      case (#KeeperSave) { return 0 };
      case (#CleanSheet) {
        switch (playerPosition) {
          case (#Goalkeeper) { return 10 };
          case (#Defender) { return 10 };
          case _ { return 0 };
        };
      };
      case (#PenaltySaved) { return 20 };
      case (#PenaltyMissed) { return -15 };
      case (#YellowCard) { return -5 };
      case (#RedCard) { return -20 };
      case (#OwnGoal) { return -10 };
      case (#HighestScoringPlayer) { return 25 };
      case _ { return 0 };
    };
  };

}
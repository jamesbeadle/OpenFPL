import Hash "mo:base/Hash";
import Nat32 "mo:base/Nat32";
import Nat16 "mo:base/Nat16";
import Nat8 "mo:base/Nat8";
import T "./types";
import Iter "mo:base/Iter";
import Array "mo:base/Array";
import List "mo:base/List";
import Time "mo:base/Time";
import Nat "mo:base/Nat";
import Nat64 "mo:base/Nat64";
import Int64 "mo:base/Int64";
import Text "mo:base/Text";
import Int16 "mo:base/Int16";
import Float "mo:base/Float";

module {
  
  public let getHour = func()  : Int { return 1_000_000_000 * 60 * 60 };

  public let eqNat8 = func(a : Nat8, b : Nat8) : Bool {
    a == b;
  };

  public let hashNat8 = func(key : Nat8) : Hash.Hash {
    Nat32.fromNat(Nat8.toNat(key) % (2 ** 32 -1));
  };

  public let eqNat16 = func(a : Nat16, b : Nat16) : Bool {
    a == b;
  };

  public let hashNat16 = func(key : Nat16) : Hash.Hash {
    Nat32.fromNat(Nat16.toNat(key) % (2 ** 32 -1));
  };

  public let eqNat32 = func(a : Nat32, b : Nat32) : Bool {
    a == b;
  };

  public let hashNat32 = func(key : Nat32) : Hash.Hash {
    Nat32.fromNat(Nat32.toNat(key) % (2 ** 32 -1));
  };

  public let eqWeeklyKey = func(a : T.WeeklyLeaderboardKey, b : T.WeeklyLeaderboardKey) : Bool {
    a.0 == b.0 and a.1 == b.1;
  };

  public let hashWeeklyKey = func(key : T.WeeklyLeaderboardKey) : Hash.Hash {
    combineHashes(hashNat32(Nat32.fromNat(Nat16.toNat(key.0))), hashNat32(Nat32.fromNat(Nat8.toNat(key.1))));
  };

  public let combineHashes = func(hash1 : Hash.Hash, hash2 : Hash.Hash) : Hash.Hash {
    (hash1 + hash2) % (2 ** 32);
  };

  public let eqMonthlyKey = func(a : T.MonthlyLeaderboardKey, b : T.MonthlyLeaderboardKey) : Bool {
    a.0 == b.0 and a.1 == b.1 and a.2 == b.2;
  };

  public let hashMonthlyKey = func(key : T.MonthlyLeaderboardKey) : Hash.Hash {
    combineHashes(hashNat32(Nat32.fromNat(Nat16.toNat(key.0))), combineHashes(hashNat32(Nat32.fromNat(Nat8.toNat(key.1))), hashNat32(Nat32.fromNat(Nat16.toNat(key.2)))));
  };

  public let hashNat = func(key : Nat) : Hash.Hash {
    Nat32.fromNat(key % (2 ** 32 -1));
  };

  public func eqPlayerEventData(event1 : T.PlayerEventData, event2 : T.PlayerEventData) : Bool {
    event1.fixtureId == event2.fixtureId and event1.playerId == event2.playerId and event1.eventType == event2.eventType and event1.eventStartMinute == event2.eventStartMinute and event1.eventEndMinute == event2.eventEndMinute
  };

  public func eqPlayerEventDataArray(array1 : [T.PlayerEventData], array2 : [T.PlayerEventData]) : Bool {
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

  public func unixTimeToMonth(unixTime : Int) : Nat8 {

    let secondsInADay = 86400;
    let seconds = unixTime / 1000000000;
    var days = seconds / secondsInADay;

    var years = 1970;
    var dayCounter = days;
    label leapLoop while (dayCounter > 365) {
      if (years % 4 == 0 and (years % 100 != 0 or years % 400 == 0) and dayCounter > 366) {
        dayCounter -= 366;
      } else {
        dayCounter -= 365;
      };
      years += 1;
    };

    var dayOfYear : Int = dayCounter + 1;
    if (dayOfYear == 366) {
      dayOfYear := 1;
    };

    var isLeapYear = false;
    if (years % 4 == 0) {
      if (years % 100 != 0) {
        isLeapYear := true;
      } else if (years % 400 == 0) {
        isLeapYear := true;
      };
    };

    var monthEnds : [Nat] = [];

    if (isLeapYear) {
      monthEnds := [31, 60, 91, 121, 152, 182, 213, 244, 274, 305, 335, 366];
    } else {
      monthEnds := [31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334, 365];
    };

    var month = 0;
    label monthLoop for (m in Iter.range(0, 11)) {
      month += 1;
      if (dayOfYear <= monthEnds[m]) {
        break monthLoop;
      };
    };

    return Nat8.fromNat(month);
  };

  public func calculateAgeFromUnix(dobUnix : Int) : Nat {
    let secondsInADay : Int = 86_400;
    let currentUnixTime : Int = Time.now();

    let currentDays : Int = currentUnixTime / (1_000_000_000 * secondsInADay);
    let dobDays : Int = dobUnix / (1_000_000_000 * secondsInADay);

    let currentYear : Int = getYear(currentDays);
    let dobYear : Int = getYear(dobDays);

    let currentDayOfYear : Int = getDayOfYear(currentDays, currentYear);
    let dobDayOfYear : Int = getDayOfYear(dobDays, dobYear);

    var age : Int = currentYear - dobYear;
    if (currentDayOfYear < dobDayOfYear) {
      age := age - 1;
    };

    return Nat64.toNat(Int64.toNat64(Int64.fromInt(age)));

  };

  private func getYear(days : Int) : Int {
    var years = 1970;
    var dayCounter = days;
    label leapLoop while (dayCounter > 365) {
      if (years % 4 == 0 and (years % 100 != 0 or years % 400 == 0) and dayCounter > 366) {
        dayCounter -= 366;
      } else {
        dayCounter -= 365;
      };
      years += 1;
    };
    return years;
  };

  private func getDayOfYear(days : Int, year : Int) : Int {
    var dayCounter = days;
    for (y in Iter.range(1970, year - 1)) {
      if (y % 4 == 0 and (y % 100 != 0 or y % 400 == 0)) {
        dayCounter -= 366; // Leap year
      } else {
        dayCounter -= 365; // Non-leap year
      };
    };
    return dayCounter;
  };

  public func nextUnixTimeForDayOfYear(dayOfYear: Int) : Int {
    let currentUnixTime : Int = Time.now();
    let secondsInADay = 86400;
    let seconds = currentUnixTime / 1000000000;
    var days = seconds / secondsInADay;

    var years = 1970;
    var dayCounter = days;
    while (dayCounter > 365) {
      if (years % 4 == 0 and (years % 100 != 0 or years % 400 == 0) and dayCounter >= 366) {
        dayCounter -= 366;
      } else {
        dayCounter -= 365;
      };
      years += 1;
    };

    var currentDayOfYear : Int = dayCounter + 1;

    var isCurrentYearLeap = false;
    if (years % 4 == 0) {
      if (years % 100 != 0) {
        isCurrentYearLeap := true;
      } else if (years % 400 == 0) {
        isCurrentYearLeap := true;
      };
    };

    var daysTillNextInstance : Int = 0;

    if (currentDayOfYear == dayOfYear) {
        if (isCurrentYearLeap) {
          daysTillNextInstance := 366;
        } else {
          daysTillNextInstance := 365;
        }
    } else if (currentDayOfYear > dayOfYear) {
        let nextYear : Int = years + 1;
        var isNextYearLeap = false;
        if (nextYear % 4 == 0) {
          if (nextYear % 100 != 0) {
            isNextYearLeap := true;
          } else if (nextYear % 400 == 0) {
            isNextYearLeap := true;
          };
        };
        if (isNextYearLeap) {
          daysTillNextInstance := 366 - currentDayOfYear + dayOfYear;
        } else {
          daysTillNextInstance := 365 - currentDayOfYear + dayOfYear;
        };
    } else {
        daysTillNextInstance := dayOfYear - currentDayOfYear;
    };

    let nextInstanceUnixTime : Int = currentUnixTime + daysTillNextInstance * 1_000_000_000 * secondsInADay;
    return nextInstanceUnixTime;
  };



  public func validateHexColor(hex : Text) : Bool {

    if (Text.size(hex) != 7 or not Text.startsWith(hex, #text "#")) {
      return false;
    };

    let hexChars = "0123456789abcdefABCDEF";
    let strippedHex = switch (Text.stripStart(hex, #text "#")) {
      case (?h) h;
      case null hex;
    };

    for (char in Text.toIter(strippedHex)) {
      if (not Text.contains(hexChars, #char char)) {
        return false;
      };
    };

    return true;
  };

  
  public func calculateAggregatePlayerEvents(events : [T.PlayerEventData], playerPosition : T.PlayerPosition) : Int16 {
    var totalScore : Int16 = 0;

    if (playerPosition == #Goalkeeper or playerPosition == #Defender) {
      let goalsConcededCount = Array.filter<T.PlayerEventData>(
        events,
        func(event : T.PlayerEventData) : Bool { event.eventType == #GoalConceded },
      ).size();

      if (goalsConcededCount >= 2) {

        totalScore += (Int16.fromNat16(Nat16.fromNat(goalsConcededCount)) / 2) * -15;
      };
    };

    if (playerPosition == #Goalkeeper) {
      let savesCount = Array.filter<T.PlayerEventData>(
        events,
        func(event : T.PlayerEventData) : Bool { event.eventType == #KeeperSave },
      ).size();

      totalScore += (Int16.fromNat16(Nat16.fromNat(savesCount)) / 3) * 5;
    };

    return totalScore;
  };

  public func calculateIndividualScoreForEvent(event : T.PlayerEventData, playerPosition : T.PlayerPosition) : Int16 {
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

  public func nat64Percentage(amount: Nat64, percentage: Float) : Nat64 {
    return Int64.toNat64(Float.toInt64(Float.fromInt64(Int64.fromNat64(amount)) * percentage));
  };

};

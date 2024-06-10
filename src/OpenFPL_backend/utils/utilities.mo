import Hash "mo:base/Hash";
import Nat32 "mo:base/Nat32";
import Nat16 "mo:base/Nat16";
import Nat8 "mo:base/Nat8";
import T "../types";
import DTOs "../DTOs";
import Iter "mo:base/Iter";
import Array "mo:base/Array";
import Time "mo:base/Time";
import Nat "mo:base/Nat";
import Nat64 "mo:base/Nat64";
import Int64 "mo:base/Int64";
import Text "mo:base/Text";
import Int16 "mo:base/Int16";
import Float "mo:base/Float";
import Principal "mo:base/Principal";
import List "mo:base/List";
import Int "mo:base/Int";
import Option "mo:base/Option";
import Management "../modules/Management";
import Cycles "mo:base/ExperimentalCycles";
import Char "mo:base/Char";

module {

  public let getHour = func() : Nat { return 1_000_000_000 * 60 * 60 };

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

  public func nextUnixTimeForDayOfYear(dayOfYear : Int) : Int {
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
      };
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

  public func getReadableDate(date : Int) : Text {
      let secondsInADay : Int = 86_400;
      let days = date / (1_000_000_000 * secondsInADay);

      let year = getYear(days);
      let dayOfYear = getDayOfYear(days, year);

      let isLeapYear = if (year % 4 == 0 and (year % 100 != 0 or year % 400 == 0)) {
        true
      } else {
        false
      };

      let monthEnds = if (isLeapYear) {
        [31, 60, 91, 121, 152, 182, 213, 244, 274, 305, 335, 366];
      } else {
        [31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334, 365];
      };

      var month = 0;
      var day = dayOfYear;

      label monthLoop for (m in Iter.range(0, 11)) {
        if (day <= monthEnds[m]) {
          month := m + 1;
          if (m > 0) {
            day := day - monthEnds[m-1];
          };
          break monthLoop;
        };
      };

      let monthNames = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
      return Text.concat(Text.concat(Text.concat(Int.toText(day), " "), monthNames[month - 1]), Text.concat(" ", Int.toText(year)));
  };

  public func getNext6AM() : Int {
    let secondsInADay : Int = 86400;
    let secondsInAnHour : Int = 3600;
    let currentUnixTime : Int = Time.now();
    let currentSeconds : Int = currentUnixTime / 1000000000;
    
    let currentDaySeconds : Int = currentSeconds % secondsInADay;

    var secondsToNext6AM : Int = 0;
    if (currentDaySeconds < 6 * secondsInAnHour) {
        secondsToNext6AM := 6 * secondsInAnHour - currentDaySeconds;
    } else {
        secondsToNext6AM := (24 * secondsInAnHour - currentDaySeconds) + 6 * secondsInAnHour;
    };

    let next6AMUnixTime : Int = currentUnixTime + secondsToNext6AM * 1000000000;
    return next6AMUnixTime;
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
        func(event : T.PlayerEventData) : Bool {
          event.eventType == #GoalConceded;
        },
      ).size();

      if (goalsConcededCount >= 2) {

        totalScore += (Int16.fromNat16(Nat16.fromNat(goalsConcededCount)) / 2) * -15;
      };
    };

    if (playerPosition == #Goalkeeper) {
      let savesCount = Array.filter<T.PlayerEventData>(
        events,
        func(event : T.PlayerEventData) : Bool {
          event.eventType == #KeeperSave;
        },
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

  public func nat64Percentage(amount : Nat64, percentage : Float) : Nat64 {
    return Int64.toNat64(Float.toInt64(Float.fromInt64(Int64.fromNat64(amount)) * percentage));
  };

  public func updateCanister_(a : actor {}, backendCanisterController : ?Principal, IC : Management.Management) : async () {
    let cid = { canister_id = Principal.fromActor(a) };
    switch (backendCanisterController) {
      case (null) {};
      case (?controller) {
        await (
          IC.update_settings({
            canister_id = cid.canister_id;
            settings = {
              controllers = ?[controller];
              compute_allocation = null;
              memory_allocation = null;
              freezing_threshold = ?31_540_000;
              reserved_cycles_limit = null
            };
            sender_canister_version = null
          }),
        );
      };
    };
  };

  public func topup_canister_(a : actor {}, backendCanisterController : ?Principal, IC : Management.Management, cycles: Nat) : async () {
    let cid = { canister_id = Principal.fromActor(a) };
    switch (backendCanisterController) {
      case (null) {};
      case (?controller) {
        Cycles.add<system>(cycles);
        await (
          IC.deposit_cycles({
            canister_id = cid.canister_id;
          }),
        );
      };
    };
  };

  public func getLatestFixtureTime(fixtures : [T.Fixture]) : Int {
    return Array.foldLeft(
      fixtures,
      fixtures[0].kickOff,
      func(acc : Int, fixture : T.Fixture) : Int {
        if (fixture.kickOff > acc) {
          return fixture.kickOff;
        } else {
          return acc;
        };
      },
    );
  };

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

  public func mergeSortLeaderboard(entries : List.List<T.LeaderboardEntry>) : List.List<T.LeaderboardEntry> {
    let len = List.size(entries);
    if (len <= 1) {
      return entries;
    } else {
      let (firstHalf, secondHalf) = List.split(len / 2, entries);
      return List.merge(mergeSortLeaderboard(firstHalf), mergeSortLeaderboard(secondHalf), compareLeaderboardEntry);
    };
  };

  private func compareLeaderboardEntry(entry1 : T.LeaderboardEntry, entry2 : T.LeaderboardEntry) : Bool {
    return entry1.points <= entry2.points;
  };

  public func scalePercentages(percentages : [Float], actualWinners : Nat) : [Float] {
    let length: Int = Array.size(percentages);
    
    if (actualWinners == length) {
        return percentages;
    } else if (actualWinners < length) {
        let truncated = Array.subArray(percentages, 0, actualWinners);
        let sum = Array.foldLeft<Float, Float>(truncated, 0.0, func(x, y) { x + y });
        return Array.map<Float, Float>(truncated, func(p) { (p / sum) * 100.0 });
    } else {
        let lengthNat: Nat = Nat64.toNat(Nat64.fromIntWrap(length) - 1);
        let lastPercentage = percentages[lengthNat];
        let extraWinners: Nat = actualWinners - lengthNat;
        let tieShare = lastPercentage / Float.fromInt(extraWinners + 1);

        let extended = Array.tabulate<Float>(actualWinners, func(i: Nat) : Float {
            if (i < length - 1) {
                return percentages[i];
            } else {
                return tieShare;
            }
        });
        return extended;
    };
  };

  public func findTiedEntries(entries : List.List<T.LeaderboardEntry>, points : Int16) : List.List<T.LeaderboardEntry> {
    var tiedEntries = List.nil<T.LeaderboardEntry>();
    var currentEntries = entries;

    label currentLoop while (not List.isNil(currentEntries)) {
      let (currentEntry, rest) = List.pop(currentEntries);
      currentEntries := rest;

      switch (currentEntry) {
        case (null) {};
        case (?entry) {
          if (entry.points == points) {
            tiedEntries := List.push(entry, tiedEntries);
          } else {
            break currentLoop;
          };
        };
      };
    };

    return List.reverse(tiedEntries);
  };

  public func calculateTiePayouts(tiedEntries : List.List<T.LeaderboardEntry>, scaledPercentages : [Float], startPosition : Nat) : List.List<Float> {
    let numTiedEntries = List.size(tiedEntries);
    var totalPayout : Float = 0.0;
    let endPosition : Int = startPosition + numTiedEntries - 1;

    label posLoop for (i in Iter.range(startPosition, endPosition)) {
      if (i > 100) {
        break posLoop;
      };
      totalPayout += scaledPercentages[i - 1];
    };

    let equalPayout = totalPayout / Float.fromInt(numTiedEntries);
    let payouts = List.replicate<Float>(numTiedEntries, equalPayout);

    return payouts;
  };

  public func getTeamValue(playerIds: [T.PlayerId], allPlayers: [DTOs.PlayerDTO]) : Nat16 {
      let updatedPlayers = Array.filter<DTOs.PlayerDTO>(
        allPlayers,
        func(player : DTOs.PlayerDTO) : Bool {
          let playerId = player.id;
          let isPlayerIdInNewTeam = Array.find(
            playerIds,
            func(id : Nat16) : Bool {
              return id == playerId;
            },
          );
          return Option.isSome(isPlayerIdInNewTeam);
        },
      );

      return Array.foldLeft<DTOs.PlayerDTO, Nat16>(updatedPlayers, 0, func(sumSoFar, x) = sumSoFar + x.valueQuarterMillions);
  };


  public func toLowercase(t: Text.Text): Text.Text {
    func charToLower(c: Char): Char {
      if (Char.isUppercase(c)) {
        Char.fromNat32(Char.toNat32(c) + 32)
      } else {
        c
      }
    };
    Text.map(t, charToLower)
  };

};

import Iter "mo:base/Iter";
import Int "mo:base/Int";
import Int64 "mo:base/Int64";
import Nat "mo:base/Nat";
import Nat8 "mo:base/Nat8";
import Nat64 "mo:base/Nat64";
import Text "mo:base/Text";
import Time "mo:base/Time";

module {

  public let getHour = func() : Nat { return 1_000_000_000 * 60 * 60 };

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
        dayCounter -= 366; 
      } else {
        dayCounter -= 365;
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

};

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

module {
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

    let days = seconds / secondsInADay;

    let years = (1970 + days / 365);
    let leapYears : Int = (years - 1969) / 4 - (years - 1901) / 100 + (years - 1600) / 400;
    let dayOfYear : Int = days - (years - 1970) * 365 - leapYears;
    let isLeapYear = (years % 4 == 0 and (years % 100 != 0 or years % 400 == 0));
    var monthEnds = [0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334];
    if (isLeapYear) {
      monthEnds := [0, 31, 60, 91, 121, 152, 182, 213, 244, 274, 305, 335];
    };

    var month = 0;

    label check for (m in Iter.range(0, 10)) {
      if (dayOfYear < monthEnds[m +1]) {
        month := m;
        break check;
      };
    };

    return Nat8.fromNat(month + 1); // To make it 1-based
  };

  public func isNationalityValid(checkNationality : Text) : Bool {
    let nationalities = List.fromArray<Text>([
      "Albania",
      "Algeria",
      "Argentina",
      "Australia",
      "Austria",
      "Belgium",
      "Bosnia and Herzegovina",
      "Brazil",
      "Burkina Faso",
      "Cameroon",
      "Canada",
      "Colombia",
      "Costa Rica",
      "Ivory Coast",
      "Croatia",
      "Czech Republic",
      "Denmark",
      "DR Congo",
      "Ecuador",
      "Egypt",
      "England",
      "Estonia",
      "Finland",
      "France",
      "Gabon",
      "Germany",
      "Ghana",
      "Greece",
      "Grenada",
      "Guinea",
      "Iceland",
      "Iran",
      "Ireland",
      "Israel",
      "Italy",
      "Ivory Coast",
      "Jamaica",
      "Japan",
      "Macedonia",
      "Mali",
      "Mexico",
      "Montserrat",
      "Morocco",
      "Netherlands",
      "Nigeria",
      "Northern Ireland",
      "Norway",
      "Paraguay",
      "Poland",
      "Portugal",
      "Scotland",
      "Senegal",
      "Serbia",
      "Slovakia",
      "South Africa",
      "South Korea",
      "Spain",
      "Sweden",
      "Switzerland",
      "Tunisia",
      "Turkey",
      "Ukraine",
      "United States",
      "Uruguay",
      "Wales",
      "Zimbabwe",
    ]);

    for (nationality in Iter.fromList(nationalities)) {
      if (nationality == checkNationality) {
        return true;
      };
    };

    return false;
  };

  public func calculateAgeFromUnix(dobUnix : Int) : Nat {
    let secondsInADay : Int = 86400;
    let currentUnixTime : Int = Time.now();

    let currentDays : Int = currentUnixTime / secondsInADay;
    let dobDays : Int = dobUnix / secondsInADay;

    let currentYear : Int = 1970 + currentDays / 365;
    let dobYear : Int = 1970 + dobDays / 365;

    let currentLeapYears : Int = (currentYear - 1969) / 4 - (currentYear - 1901) / 100 + (currentYear - 1600) / 400;
    let dobLeapYears : Int = (dobYear - 1969) / 4 - (dobYear - 1901) / 100 + (dobYear - 1600) / 400;

    let currentDayOfYear : Int = currentDays - (currentYear - 1970) * 365 - currentLeapYears;
    let dobDayOfYear : Int = dobDays - (dobYear - 1970) * 365 - dobLeapYears;

    var age : Int = currentYear - dobYear;
    if (currentDayOfYear < dobDayOfYear) {
      age := age - 1;
    };

    return Nat64.toNat(Int64.toNat64(Int64.fromInt(age)));
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

};

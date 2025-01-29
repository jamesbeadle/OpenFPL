import Char "mo:base/Char";
import Float "mo:base/Float";
import Int "mo:base/Int";
import Int64 "mo:base/Int64";
import Nat "mo:base/Nat";
import Nat64 "mo:base/Nat64";
import Text "mo:base/Text";
import Array "mo:base/Array";
import FootballTypes "../types/football_types";


module {


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

  public func nat64Percentage(amount : Nat64, percentage : Float) : Nat64 {
    return Int64.toNat64(Float.toInt64(Float.fromInt64(Int64.fromNat64(amount)) * percentage));
  };

  public func intToNat(input: Int) : Nat {
    return Nat64.toNat(Int64.toNat64(Int64.fromInt(input)))
  };

  public func natToInt(input: Nat) : Int {
    return Int64.toInt(Int64.fromNat64(Nat64.fromNat(input)));
  };

  public func natToFloat(input: Nat) : Float {
    return Float.fromInt(Int64.toInt(Int64.fromNat64(Nat64.fromNat(input))));
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

  public func getLatestFixtureTime(fixtures : [FootballTypes.Fixture]) : Int {
    return Array.foldLeft(
      fixtures,
      fixtures[0].kickOff,
      func(acc : Int, fixture : FootballTypes.Fixture) : Int {
        if (fixture.kickOff > acc) {
          return fixture.kickOff;
        } else {
          return acc;
        };
      },
    );
  };

};

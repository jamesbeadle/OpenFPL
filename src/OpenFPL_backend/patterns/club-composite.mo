import T "../types";
import DTOs "../DTOs";
import List "mo:base/List";
import Result "mo:base/Result";
import Array "mo:base/Array";
import Order "mo:base/Order";
import Text "mo:base/Text";
import Utilities "../utilities";

module {

  public class ClubComposite() {
    private var nextClubId : T.ClubId = 1;
    private var clubs = List.fromArray<T.Club>([]);
    private var relegatedClubs = List.fromArray<T.Club>([]);

    public func setStableData(
      stable_next_club_id : T.ClubId,
      stable_clubs : [T.Club],
    ) {

      nextClubId := stable_next_club_id;
      clubs := List.fromArray(stable_clubs);
    };

    public func getClubs() : [T.Club] {
      let clubsArray = List.toArray(clubs);
      let sortedArray = Array.sort(
        clubsArray,
        func(a : T.Club, b : T.Club) : Order.Order {
          if (a.name < b.name) { return #less };
          if (a.name == b.name) { return #equal };
          return #greater;
        },
      );
      let sortedClubs = List.fromArray(sortedArray);
      return sortedArray;
    };

    public func validatePromoteFormerClub(promoteFormerClubDTO : DTOs.PromoteFormerClubDTO) : async Result.Result<Text, Text> {
      if (List.size(clubs) >= 20) {
        return #err("Invalid: League cannot contain more than 20 teams.");
      };

      let clubToPromote = List.find<T.Club>(relegatedClubs, func(c : T.Club) { c.id == promoteFormerClubDTO.clubId });
      switch (clubToPromote) {
        case (null) {
          return #err("Invalid: Cannot find relegated club.");
        };
        case (?foundClub) {};
      };

      return #ok("Valid");
    };

    public func executePromoteFormerClub(promoteFormerClubDTO : DTOs.PromoteFormerClubDTO) : async () {
      let clubToPromote = List.find<T.Club>(relegatedClubs, func(c : T.Club) { c.id == promoteFormerClubDTO.clubId });
      switch (clubToPromote) {
        case (null) {};
        case (?club) {
          clubs := List.push(club, clubs);
          relegatedClubs := List.filter<T.Club>(
            relegatedClubs,
            func(currentClub : T.Club) : Bool {
              return currentClub.id != promoteFormerClubDTO.clubId;
            },
          );
        };
      };
    };

    public func validatePromoteNewClub(promoteNewClubDTO : DTOs.PromoteNewClubDTO) : async Result.Result<Text, Text> {

      if (List.size(clubs) >= 20) {
        return #err("Invalid: League cannot contain more than 20 teams.");
      };

      if (Text.size(promoteNewClubDTO.name) > 100) {
        return #err("Invalid: Club name cannot be greater than 100 characters.");
      };

      if (Text.size(promoteNewClubDTO.friendlyName) > 50) {
        return #err("Invalid: Club friendly name cannot be greater than 50 characters.");
      };

      if (Text.size(promoteNewClubDTO.abbreviatedName) != 3) {
        return #err("Invalid: Club abbreviated name must be 3 characters.");
      };

      if (not Utilities.validateHexColor(promoteNewClubDTO.primaryColourHex)) {
        return #err("Invalid: Invalid primary hex colour.");
      };

      if (not Utilities.validateHexColor(promoteNewClubDTO.secondaryColourHex)) {
        return #err("Invalid: Invalid secondary hex colour.");
      };

      if (not Utilities.validateHexColor(promoteNewClubDTO.thirdColourHex)) {
        return #err("Invalid: Invalid third hex colour.");
      };

      return #ok("Valid");
    };

    public func executePromoteNewClub(promoteNewClubDTO : DTOs.PromoteNewClubDTO) : async () {
      let newClub : T.Club = {
        id = nextClubId;
        name = promoteNewClubDTO.name;
        friendlyName = promoteNewClubDTO.friendlyName;
        abbreviatedName = promoteNewClubDTO.abbreviatedName;
        primaryColourHex = promoteNewClubDTO.primaryColourHex;
        secondaryColourHex = promoteNewClubDTO.secondaryColourHex;
        thirdColourHex = promoteNewClubDTO.thirdColourHex;
        shirtType = promoteNewClubDTO.shirtType;
      };
      clubs := List.push(newClub, clubs);
      nextClubId += 1;
    };

    public func validateUpdateClub(updateClubDTO : DTOs.UpdateClubDTO) : async Result.Result<Text, Text> {
      let club = List.find(
        clubs,
        func(c : T.Club) : Bool {
          return c.id == updateClubDTO.clubId;
        },
      );

      switch (club) {
        case (null) {
          return #err("Invalid: No club found to update.");
        };
        case (?foundTeam) {

          if (Text.size(foundTeam.name) > 100) {
            return #err("Invalid: Club name must be less than 100 characters.");
          };

          if (Text.size(foundTeam.friendlyName) > 50) {
            return #err("Invalid: Club friendly name must be less than 50 characters.");
          };

          if (Text.size(foundTeam.abbreviatedName) != 3) {
            return #err("Invalid: Club abbreviated name must be 3 characters.");
          };

          if (not Utilities.validateHexColor(foundTeam.primaryColourHex)) {
            return #err("Invalid: Primary hex colour invalid.");
          };

          if (not Utilities.validateHexColor(foundTeam.secondaryColourHex)) {
            return #err("Invalid: Secondary hex colour invalid.");
          };

          if (not Utilities.validateHexColor(foundTeam.thirdColourHex)) {
            return #err("Invalid: Third hex colour invalid.");
          };
        };
      };

      return #ok("Valid");
    };

    public func executeUpdateClub(updateClubDTO : DTOs.UpdateClubDTO) : async () {
      clubs := List.map<T.Club, T.Club>(
        clubs,
        func(currentClub : T.Club) : T.Club {
          if (currentClub.id == updateClubDTO.clubId) {
            return {
              id = currentClub.id;
              name = updateClubDTO.name;
              friendlyName = updateClubDTO.friendlyName;
              primaryColourHex = updateClubDTO.primaryColourHex;
              secondaryColourHex = updateClubDTO.secondaryColourHex;
              thirdColourHex = updateClubDTO.thirdColourHex;
              abbreviatedName = updateClubDTO.abbreviatedName;
              shirtType = updateClubDTO.shirtType;
            };
          } else {
            return currentClub;
          };
        },
      );
    };

    public func getStableClubs() : [T.Club] {
      return List.toArray(clubs);
    };

    public func setStableClubs(stable_clubs : [T.Club]) {
      clubs := List.fromArray(stable_clubs);
    };

    public func getStableRelegatedClubs() : [T.Club] {
      return List.toArray(relegatedClubs);
    };

    public func setStableRelegatedClubs(stable_relegated_clubs : [T.Club]) {
      relegatedClubs := List.fromArray(stable_relegated_clubs);
    };

    public func getStableNextClubId() : T.ClubId {
      return nextClubId;
    };

    public func setStableNextClubId(stable_next_club_id : T.ClubId) {
      nextClubId := stable_next_club_id;
    };
  };
};

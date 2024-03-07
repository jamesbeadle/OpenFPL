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

    public func getFormerClubs() : [T.Club] {
      let clubsArray = List.toArray(relegatedClubs);
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

    public func init() {
      if (List.size(clubs) == 0) {
        clubs := List.fromArray<T.Club>([
          {
            id = 1;
            secondaryColourHex = "#FFFFFF";
            name = "Arsenal";
            friendlyName = "Arsenal";
            thirdColourHex = "#F0DCBA";
            abbreviatedName = "ARS";
            shirtType = #Filled;
            primaryColourHex = "#D3121A";
          },
          {
            id = 3;
            secondaryColourHex = "#262729";
            name = "AFC Bournemouth";
            friendlyName = "Bournemouth";
            thirdColourHex = "#262729";
            abbreviatedName = "BOU";
            shirtType = #Striped;
            primaryColourHex = "#CA2D26";
          },
          {
            id = 2;
            secondaryColourHex = "#B7D7FE";
            name = "Aston Villa";
            friendlyName = "Aston Villa";
            thirdColourHex = "#FFFFFF";
            abbreviatedName = "AVL";
            shirtType = #Filled;
            primaryColourHex = "#CA3E69";
          },
          {
            id = 4;
            secondaryColourHex = "#FFFFFF";
            name = "Brentford";
            friendlyName = "Brentford";
            thirdColourHex = "#090F14";
            abbreviatedName = "BRE";
            shirtType = #Striped;
            primaryColourHex = "#CF2E26";
          },
          {
            id = 5;
            secondaryColourHex = "#124098";
            name = "Brighton & Hove Albion";
            friendlyName = "Brighton";
            thirdColourHex = "#124098";
            abbreviatedName = "BRI";
            shirtType = #Striped;
            primaryColourHex = "#FFFFFF";
          },
          {
            id = 6;
            secondaryColourHex = "#A5D9F7";
            name = "Burnley";
            friendlyName = "Burnley";
            thirdColourHex = "#FFFFFF";
            abbreviatedName = "BUR";
            shirtType = #Filled;
            primaryColourHex = "#781932";
          },
          {
            id = 7;
            secondaryColourHex = "#FFFFFF";
            name = "Chelsea";
            friendlyName = "Chelsea";
            thirdColourHex = "#020514";
            abbreviatedName = "CHE";
            shirtType = #Filled;
            primaryColourHex = "#2D57C7";
          },
          {
            id = 8;
            secondaryColourHex = "#E12F44";
            name = "Crystal Palace";
            friendlyName = "Crystal Palace";
            thirdColourHex = "#FFFFFF";
            abbreviatedName = "CRY";
            shirtType = #Striped;
            primaryColourHex = "#1A47A0";
          },
          {
            id = 9;
            secondaryColourHex = "#FFFFFF";
            name = "Everton";
            friendlyName = "Everton";
            thirdColourHex = "#13356D";
            abbreviatedName = "EVE";
            shirtType = #Filled;
            primaryColourHex = "#0F3DD1";
          },
          {
            id = 10;
            secondaryColourHex = "#B14C5C";
            name = "Fulham";
            friendlyName = "Fulham";
            thirdColourHex = "#000000";
            abbreviatedName = "FUL";
            shirtType = #Filled;
            primaryColourHex = "#FFFFFF";
          },
          {
            id = 11;
            secondaryColourHex = "#FFFFFF";
            name = "Liverpool";
            friendlyName = "Liverpool";
            thirdColourHex = "#2CC4B9";
            abbreviatedName = "LIV";
            shirtType = #Filled;
            primaryColourHex = "#E50113";
          },
          {
            id = 12;
            secondaryColourHex = "#FFFFFF";
            name = "Luton Town";
            friendlyName = "Luton";
            thirdColourHex = "#524360";
            abbreviatedName = "LUT";
            shirtType = #Filled;
            primaryColourHex = "#F46038";
          },
          {
            id = 13;
            secondaryColourHex = "#FFFFFF";
            name = "Manchester City";
            friendlyName = "Man City";
            thirdColourHex = "#A3E1FE";
            abbreviatedName = "MCI";
            shirtType = #Filled;
            primaryColourHex = "#569ECD";
          },
          {
            id = 14;
            secondaryColourHex = "#FFFFFF";
            name = "Manchester United";
            friendlyName = "Man United";
            thirdColourHex = "#FEF104";
            abbreviatedName = "MUN";
            shirtType = #Filled;
            primaryColourHex = "#C00814";
          },
          {
            id = 15;
            secondaryColourHex = "#1A1A1A";
            name = "Newcastle United";
            friendlyName = "Newcastle";
            thirdColourHex = "#1A1A1A";
            abbreviatedName = "NEW";
            shirtType = #Striped;
            primaryColourHex = "#FFFFFF";
          },
          {
            id = 16;
            secondaryColourHex = "#FFFFFF";
            name = "Nottingham Forest";
            friendlyName = "Nottingham Forest";
            thirdColourHex = "#FFFFFF";
            abbreviatedName = "NFO";
            shirtType = #Filled;
            primaryColourHex = "#BB212A";
          },
          {
            id = 17;
            secondaryColourHex = "#CF1E25";
            name = "Sheffield United";
            friendlyName = "Sheffield United";
            thirdColourHex = "#000000";
            abbreviatedName = "SHE";
            shirtType = #Striped;
            primaryColourHex = "#FFFFFF";
          },
          {
            id = 18;
            secondaryColourHex = "#001952";
            name = "Tottenham Hotspur";
            friendlyName = "Tottenham";
            thirdColourHex = "#001952";
            abbreviatedName = "TOT";
            shirtType = #Filled;
            primaryColourHex = "#FFFFFF";
          },
          {
            id = 19;
            secondaryColourHex = "#A7DAF9";
            name = "West Ham United";
            friendlyName = "West Ham";
            thirdColourHex = "#F1D655";
            abbreviatedName = "WHU";
            shirtType = #Filled;
            primaryColourHex = "#6D202A";
          },
          {
            id = 20;
            secondaryColourHex = "#2D2D23";
            name = "Wolverhampton Wanderers";
            friendlyName = "Wolves";
            thirdColourHex = "#2D2D23";
            abbreviatedName = "WOL";
            shirtType = #Filled;
            primaryColourHex = "#F7CA3B";
          },
        ]);
      };
    };
  };
};
